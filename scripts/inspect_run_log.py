import zipfile
import sys

def inspect(zip_path, term_filter=None):
    with zipfile.ZipFile(zip_path) as z:
        for name in z.namelist():
            if term_filter and term_filter.lower() not in name.lower():
                continue
            try:
                text = z.read(name).decode('utf-8', errors='ignore')
            except Exception:
                continue
            lines = text.splitlines()
            for i, l in enumerate(lines):
                if 'upload-artifact' in l or 'deprecated version' in l or 'This request has been automatically failed' in l:
                    start = max(0, i-5)
                    end = min(len(lines), i+6)
                    print('===', name)
                    print('\n--- Context around line', i+1, '---')
                    for j in range(start, end):
                        print(f"{j+1:5d}: {lines[j]}")
                    print('\n')

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('usage: python scripts/inspect_run_log.py run-XXXXX-logs.zip [filter]')
        sys.exit(1)
    zip_path = sys.argv[1]
    filt = sys.argv[2] if len(sys.argv) > 2 else None
    inspect(zip_path, filt)
