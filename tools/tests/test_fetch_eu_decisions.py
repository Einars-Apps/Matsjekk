import importlib.util
from pathlib import Path

import pytest


def load_module():
    path = Path(__file__).resolve().parents[1] / 'fetch_eu_decisions.py'
    spec = importlib.util.spec_from_file_location('fetch_eu_decisions', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


@pytest.mark.parametrize('url,expected', [
    ('https://food.ec.europa.eu/article', True),
    ('https://www.europarl.europa.eu/news/en/article', True),
    ('https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:123', True),
    ('https://news.google.com/rss/articles/id', False),
    ('https://europa.eu.attacker.example/article', False),
    ('http://food.ec.europa.eu/article', False),
    ('https://user:password@food.ec.europa.eu/article', False),
    ('', False),
])
def test_publisher_url(url, expected):
    assert load_module().is_publisher_url(url) is expected


def test_resolve_and_cache_source_urls(monkeypatch):
    module = load_module()
    news_url = 'https://news.google.com/rss/articles/test-id'
    publisher_url = 'https://food.ec.europa.eu/article'
    calls = []

    class Decoder:
        def __init__(self, timeout):
            assert timeout == 15

        def __enter__(self):
            return self

        def __exit__(self, *args):
            pass

        def decode_google_news_urls(self, urls, interval):
            calls.append(urls)
            assert interval == 1
            return [{'success': True, 'decoded_url': publisher_url}]

    monkeypatch.setattr(module, 'GoogleDecoder', Decoder)
    items = [{'url': news_url}, {'url': news_url}, {'url': publisher_url}]
    module.resolve_source_urls(items, [])
    assert calls == [[news_url]]
    assert items[0] == {'url': publisher_url, 'google_news_url': news_url}
    assert items[1] == items[0]
    assert items[2] == {'url': publisher_url}
    new_items = [{'url': news_url}]
    module.resolve_source_urls(new_items, items)
    assert new_items[0] == items[0]
    assert len(calls) == 1


@pytest.mark.parametrize('result', [
    {'success': False, 'message': 'HTTP 429'},
    {'success': True, 'decoded_url': 'https://news.google.com/articles/another-id'},
    {'success': True, 'decoded_url': 'https://attacker.example/article'},
])
def test_resolution_failure_keeps_news_link_and_warns(monkeypatch, caplog, result):
    module = load_module()
    news_url = 'https://news.google.com/rss/articles/test-id'

    class Decoder:
        def __init__(self, **kwargs):
            pass

        def __enter__(self):
            return self

        def __exit__(self, *args):
            pass

        def decode_google_news_urls(self, *args, **kwargs):
            return [result]

    monkeypatch.setattr(module, 'GoogleDecoder', Decoder)
    items = [{'url': news_url}]
    module.resolve_source_urls(items, [])
    assert items[0]['url'] == news_url
    assert 'Could not resolve EU source URL' in caplog.text
