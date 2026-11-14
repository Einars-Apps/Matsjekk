import importlib.util
from pathlib import Path

import pytest
import requests


def load_module():
    path = Path(__file__).resolve().parents[1] / 'fetch_farmshops.py'
    spec = importlib.util.spec_from_file_location('fetch_farmshops_under_test', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    module._reset_fetch_runtime_state()
    return module


def test_rate_limit_skips_endpoint_instead_of_retrying_it(monkeypatch):
    module = load_module()
    calls = []

    def post(endpoint, query):
        calls.append(endpoint)
        if endpoint == module.OVERPASS_ENDPOINTS[0]:
            raise module.OverpassUnavailable('429 from first', module.RATE_LIMIT_COOLDOWN_SECONDS)
        return [{
            'id': 1,
            'lat': 60.0,
            'lon': 10.0,
            'tags': {'name': 'Gårdsbutikk'},
        }]

    monkeypatch.setattr(module, '_post_overpass', post)
    monkeypatch.setattr(module.time, 'sleep', lambda *_args, **_kwargs: None)

    items = module._fetch_overpass_filtered('[out:json];', 'NO')

    assert items[0]['name'] == 'Gårdsbutikk'
    assert calls == module.OVERPASS_ENDPOINTS[:2]
    assert module._endpoint_available(module.OVERPASS_ENDPOINTS[0]) is False


def test_unreachable_endpoint_is_not_called_again(monkeypatch):
    module = load_module()
    calls = []

    def post(endpoint, query):
        calls.append(endpoint)
        raise module.OverpassUnavailable(
            'network unreachable',
            module.CONNECT_FAILURE_COOLDOWN_SECONDS,
        )

    monkeypatch.setattr(module, '_post_overpass', post)
    monkeypatch.setattr(module.time, 'sleep', lambda *_args, **_kwargs: None)

    with pytest.raises(RuntimeError, match='All endpoints failed'):
        module._fetch_overpass_filtered('[out:json];', 'ES')

    assert calls == list(module.OVERPASS_ENDPOINTS)


def test_connection_error_fails_fast_with_cooldown(monkeypatch):
    module = load_module()
    captured = {}

    def boom(*_args, **kwargs):
        captured['timeout'] = kwargs.get('timeout')
        raise requests.ConnectionError('Network is unreachable')

    monkeypatch.setattr(module.SESSION, 'post', boom)

    with pytest.raises(module.OverpassUnavailable) as exc:
        module._post_overpass('https://lz4.overpass-api.de/api/interpreter', 'q')

    assert captured['timeout'] == (
        module.CONNECT_TIMEOUT_SECONDS,
        module.READ_TIMEOUT_SECONDS,
    )
    assert exc.value.cooldown_seconds == module.CONNECT_FAILURE_COOLDOWN_SECONDS


def test_http_429_uses_retry_after_as_minimum_cooldown(monkeypatch):
    module = load_module()

    class Response:
        status_code = 429
        headers = {'Retry-After': '30'}

    monkeypatch.setattr(module.SESSION, 'post', lambda *_args, **_kwargs: Response())

    with pytest.raises(module.OverpassUnavailable) as exc:
        module._post_overpass('https://overpass.kumi.systems/api/interpreter', 'q')

    assert exc.value.cooldown_seconds == module.RATE_LIMIT_COOLDOWN_SECONDS


def test_pagination_stops_when_a_page_repeats(monkeypatch):
    module = load_module()
    monkeypatch.setattr(module.time, 'sleep', lambda *_args, **_kwargs: None)
    pages = [
        ([{'id': 'a'}], 500),
        ([{'id': 'a'}], 500),
        ([{'id': 'b'}], 500),
    ]

    records = module._collect_paged_records(lambda page: pages[page], max_pages=10)

    assert records == [{'id': 'a'}]


def test_pagination_stops_at_max_pages(monkeypatch):
    module = load_module()
    monkeypatch.setattr(module.time, 'sleep', lambda *_args, **_kwargs: None)

    records = module._collect_paged_records(
        lambda page: ([{'id': page}], 10000),
        max_pages=3,
    )

    assert [row['id'] for row in records] == [0, 1, 2]


def test_deadline_does_not_call_overpass(monkeypatch):
    module = load_module()
    module._fetch_deadline_at = module.time.monotonic() - 1
    calls = []
    monkeypatch.setattr(module, '_post_overpass', lambda *_args, **_kwargs: calls.append(1))

    with pytest.raises(module.FetchDeadlineReached):
        module._fetch_overpass_filtered('[out:json];', 'FR')

    assert calls == []
