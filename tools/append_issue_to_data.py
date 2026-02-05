#!/usr/bin/env python3
import os
import sys
import json
import re
from pathlib import Path

try:
    import yaml  # type: ignore
except Exception:
    yaml = None


def _simple_yaml_load(text: str):
    """
    Very small YAML-ish parser for simple key: value pairs.
    Falls back to this when PyYAML is not available so tests and CI
    can run without a compiled dependency.
    """
    out = {}
    for line in text.splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        if ':' in line:
            key, val = line.split(':', 1)
            key = key.strip()
            val = val.strip()
            # unquote simple quoted values
            if (val.startswith('"') and val.endswith('"')) or (val.startswith("'") and val.endswith("'")):
                val = val[1:-1]
            out[key] = val
    return out


def extract_yaml_block(body: str) -> str:
    if not body:
        return ""
    m = re.search(r"```yaml\s*(.*?)\s*```", body, re.S)
    if m:
        return m.group(1)
    m = re.search(r"---\s*(.*?)\s*---", body, re.S)
    if m:
        return m.group(1)
    return body


def main():
    body = os.environ.get('ISSUE_BODY', '')
    number = os.environ.get('ISSUE_NUMBER', '0')
    title = os.environ.get('ISSUE_TITLE', '')
    author = os.environ.get('ISSUE_AUTHOR', '')

    yaml_text = extract_yaml_block(body)
    if not yaml_text.strip():
        print('No YAML content found in issue body.')
        return 2

    try:
        if yaml is not None:
            data = yaml.safe_load(yaml_text)
        else:
            data = _simple_yaml_load(yaml_text)
    except Exception as e:
        print('Failed to parse YAML from issue body:', e)
        return 3

    if not isinstance(data, dict):
        print('Parsed YAML is not a mapping/object.')
        return 4

    entry = {}
    entry['id'] = f"issue-{number}"
    entry['title'] = title
    entry['submitted_by'] = author
    entry.update(data)

    # Ensure lat/lon are floats when present
    for k in ('lat', 'lon'):
        if k in entry:
            try:
                entry[k] = float(entry[k])
            except Exception:
                pass

    outdir = Path('docs') / 'data' / 'submissions'
    outdir.mkdir(parents=True, exist_ok=True)
    outpath = outdir / f"farmshop_issue_{number}.json"
    with outpath.open('w', encoding='utf-8') as f:
        json.dump(entry, f, ensure_ascii=False, indent=2)

    print('Wrote submission to', outpath)
    return 0


if __name__ == '__main__':
    sys.exit(main())
