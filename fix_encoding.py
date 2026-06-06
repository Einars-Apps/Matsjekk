"""Fix mojibake (double-encoded UTF-8 via cp1252) in docs/ HTML files.

Strategy: scan the text for sequences of cp1252-encodable characters that,
when encoded back to cp1252 bytes and decoded as UTF-8, yield valid Unicode
characters outside the ASCII+Latin-1 basic range. Replace those sequences.

Handles cp1252 undefined bytes (0x81,0x8D,0x8F,0x90,0x9D) which Python
maps to their C1 control char equivalents (U+0081 etc.) on decode.
"""
import os

DOCS = r'C:\Users\ebors\mat_sjekk\docs'

def char_to_cp1252_byte(ch: str) -> int | None:
    """Return the cp1252 byte for a character, including c1-control fallback."""
    cp = ord(ch)
    if cp < 0x80:
        return cp
    if 0x80 <= cp <= 0x9F:
        # C1 control chars: cp1252 undefined bytes that Python maps back here
        try:
            return ch.encode('cp1252')[0]
        except UnicodeEncodeError:
            return cp  # raw byte value for undefined cp1252 positions
    if cp <= 0xFF:
        return cp  # direct latin-1 byte
    # Higher: try cp1252 encoding for special chars (€, Ž, etc.)
    try:
        b = ch.encode('cp1252')
        return b[0] if len(b) == 1 else None
    except UnicodeEncodeError:
        return None


def fix_mojibake(text: str) -> str:
    """Reverse cp1252-mojibake: re-encode cp1252-values back to UTF-8 bytes."""
    result = []
    i = 0
    while i < len(text):
        found = False
        for length in (4, 3, 2):
            chunk = text[i:i+length]
            if len(chunk) < length:
                continue
            bytes_list = [char_to_cp1252_byte(c) for c in chunk]
            if None in bytes_list:
                continue
            raw = bytes(bytes_list)
            try:
                decoded = raw.decode('utf-8')
                # Only replace if it compresses to fewer chars and contains
                # non-trivial Unicode (outside plain ASCII)
                if (len(decoded) < len(chunk) and
                        any(ord(c) > 127 for c in decoded)):
                    result.append(decoded)
                    i += length
                    found = True
                    break
            except UnicodeDecodeError:
                pass
        if not found:
            result.append(text[i])
            i += 1
    return ''.join(result)


html_files = [f for f in os.listdir(DOCS) if f.endswith('.html')]

for fname in sorted(html_files):
    path = os.path.join(DOCS, fname)
    with open(path, 'rb') as f:
        raw = f.read()
    has_bom = raw.startswith(b'\xef\xbb\xbf')
    if has_bom:
        raw = raw[3:]
    try:
        text = raw.decode('utf-8')
    except UnicodeDecodeError:
        print(f'SKIP (not valid UTF-8): {fname}')
        continue

    fixed = fix_mojibake(text)
    if fixed != text:
        with open(path, 'w', encoding='utf-8', newline='') as f:
            f.write(fixed)
        orig_bad = [w for w in text.split() if any(ord(c) > 200 for c in w)][:3]
        fix_good = [w for w in fixed.split() if any(ord(c) > 127 for c in w)][:3]
        print(f'FIXED: {fname}')
        print(f'  before: {orig_bad}')
        print(f'  after:  {fix_good}')
    else:
        print(f'OK (no changes): {fname}')
