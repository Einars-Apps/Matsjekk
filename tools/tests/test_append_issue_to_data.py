import importlib.util
from pathlib import Path
import json


def load_module():
    tools_dir = Path(__file__).resolve().parents[1]
    mod_path = tools_dir / 'append_issue_to_data.py'
    spec = importlib.util.spec_from_file_location('append_issue_to_data', str(mod_path))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_extract_yaml_block():
    mod = load_module()
    body = "Intro\n```yaml\nname: Farm A\nlat: 59.0\nlon: 10.0\n```"
    yaml_text = mod.extract_yaml_block(body)
    assert 'name: Farm A' in yaml_text


def test_main_writes_submission(tmp_path, monkeypatch):
    mod = load_module()
    # Run in isolated tmp directory
    monkeypatch.chdir(tmp_path)
    monkeypatch.setenv('ISSUE_BODY', '```yaml\nname: Test Farm\nlat: 59\nlon: 10\n```')
    monkeypatch.setenv('ISSUE_NUMBER', '42')
    monkeypatch.setenv('ISSUE_TITLE', 'Test Farm Submission')
    monkeypatch.setenv('ISSUE_AUTHOR', 'tester')
    rc = mod.main()
    assert rc == 0
    out = tmp_path / 'docs' / 'data' / 'submissions' / 'farmshop_issue_42.json'
    assert out.exists()
    data = json.loads(out.read_text(encoding='utf-8'))
    assert data['id'] == 'issue-42'
    assert data.get('name') == 'Test Farm' or 'name' in data
