import importlib.util
import json
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[2]


def load_module():
    path = ROOT / 'scripts' / 'weekly_risk_review.py'
    spec = importlib.util.spec_from_file_location('weekly_risk_review', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sample_review():
    return {
        'summary_nb': 'Forslag som krever menneskelig vurdering.',
        'limitations_nb': 'Begrenset kildegrunnlag.',
        'findings': [{
            'country': 'NO', 'level': 'yellow', 'brand': 'example',
            'summary_nb': 'Kilden beskriver en leveranse.',
            'proposed_change_nb': 'Vurder dokumentasjonen manuelt.',
            'source_ids': ['source-1'],
            'evidence_quote': 'The documented supply relationship is confirmed.',
        }],
    }


def sample_sources():
    return [{
        'id': 'source-1', 'url': 'https://food.ec.europa.eu/example',
        'title': 'Example', 'date': '2026-10-01',
        'text': 'The documented supply relationship is confirmed.',
    }]


def test_valid_review_and_no_findings():
    module = load_module()
    review = sample_review()
    module.validate_review(review, sample_sources(), ['NO'])
    review['findings'] = []
    module.validate_review(review, sample_sources(), ['NO'])


@pytest.mark.parametrize('field,value', [
    ('country', 'FAKE'), ('level', 'safe'), ('source_ids', []),
    ('source_ids', ['invented']), ('evidence_quote', 'too short'),
    ('evidence_quote', 'A fabricated quote that is not in the actual source.'),
    ('brand', ''), ('proposed_change_nb', ''),
])
def test_reject_unsupported_evidence(field, value):
    module = load_module()
    review = sample_review()
    review['findings'][0][field] = value
    with pytest.raises(ValueError):
        module.validate_review(review, sample_sources(), ['NO'])


@pytest.mark.parametrize('url,allowed', [
    ('https://food.ec.europa.eu/example', True),
    ('https://www.arla.com/example', True),
    ('https://www.tine.no/example', True),
    ('http://www.tine.no/example', False),
    ('https://tine.no.attacker.example', False),
    ('https://user@www.tine.no/example', False),
    ('http://127.0.0.1', False),
])
def test_source_allowlist(url, allowed):
    assert load_module().allowed_url(url) is allowed


def test_unapproved_redirect_is_rejected(monkeypatch):
    module = load_module()

    class Response:
        is_redirect = True
        headers = {'Location': 'https://attacker.example/private'}

    calls = []

    def get(url, **kwargs):
        calls.append(url)
        return Response()

    monkeypatch.setattr(module.requests, 'get', get)
    with pytest.raises(ValueError, match='Unapproved source'):
        module.fetch_source('https://www.tine.no/example')
    assert len(calls) == 1


def test_missing_api_key_does_not_write_report(monkeypatch, tmp_path):
    module = load_module()
    monkeypatch.delenv('OPENAI_API_KEY', raising=False)
    out = tmp_path / 'report.json'
    monkeypatch.setattr('sys.argv', ['weekly_risk_review.py', '--out', str(out)])
    with pytest.raises(RuntimeError, match='OPENAI_API_KEY'):
        module.main()
    assert not out.exists()


def test_all_topics_levels_and_countries_are_reported_without_publishing(monkeypatch, tmp_path):
    module = load_module()
    monkeypatch.setenv('OPENAI_API_KEY', 'test-only')
    sources = {topic: sample_sources() for topic in module.TOPICS}
    monkeypatch.setattr(module, 'collect_sources', lambda: (sources, ['Partial collection warning']))
    monkeypatch.setattr(module, 'analyze_topic', lambda *args: sample_review())
    published_paths = [
        ROOT / 'docs' / 'supplier_rules_v2.json',
        ROOT / 'docs' / 'data' / 'ngt_suppliers.json',
    ]
    before = [path.read_bytes() for path in published_paths]
    out = tmp_path / 'report.json'
    monkeypatch.setattr('sys.argv', ['weekly_risk_review.py', '--out', str(out)])
    module.main()
    report = json.loads(out.read_text(encoding='utf-8'))
    assert set(report['topics']) == {'bovaer', 'gmo_feed', 'insect', 'ngt'}
    assert report['status'] == 'needs_human_review'
    for topic in report['topics'].values():
        assert set(topic['coverage']) == set(report['scope']['countries'])
        assert set(topic['coverage']['NO']) == {'red', 'yellow', 'green', 'unknown'}
        assert topic['coverage']['NO']['yellow'] == 'proposal_present'
        assert topic['coverage']['NO']['green'] == 'no_supported_proposal'
        assert all('text' not in source for source in topic['sources'])
    assert [path.read_bytes() for path in published_paths] == before


def test_missing_topic_sources_fails_explicitly(monkeypatch, tmp_path):
    module = load_module()
    monkeypatch.setenv('OPENAI_API_KEY', 'test-only')
    monkeypatch.setattr(module, 'collect_sources', lambda: ({topic: [] for topic in module.TOPICS}, []))
    out = tmp_path / 'report.json'
    monkeypatch.setattr('sys.argv', ['weekly_risk_review.py', '--out', str(out)])
    with pytest.raises(RuntimeError, match='No usable primary sources'):
        module.main()
    assert not out.exists()


def test_pr_body_uses_repository_template(tmp_path):
    module = load_module()
    out = tmp_path / 'pr-body.md'
    module.write_pr_body({'collection_errors': []}, out)
    body = out.read_text(encoding='utf-8')
    template = (ROOT / '.github' / 'PULL_REQUEST_TEMPLATE.md').read_text(encoding='utf-8')
    assert [line for line in body.splitlines() if line.startswith('### ')] == [
        line for line in template.splitlines() if line.startswith('### ')
    ]
    for line in template.splitlines():
        if line.startswith('- [ ]'):
            assert line in body
    assert 'passed in this workflow' in body
    assert 'Merging an unchanged report does not update app warnings' in body
