import zipfile, sys
p='run-21970390398-logs.zip'
with zipfile.ZipFile(p) as z:
    for name in z.namelist():
        if name.endswith('1_deploy.txt'):
            print('Found', name)
            with z.open(name) as f:
                text=f.read().decode('utf-8',errors='ignore')
                lines=text.splitlines()
                for i,line in enumerate(lines,1):
                    if 'upload-artifact' in line or 'deprecated' in line or 'automatically failed' in line or '##[error]' in line:
                        start=max(0,i-10)
                        end=min(len(lines), i+2)
                        print('\n--- context around line', i, '---')
                        for j in range(start, end):
                            print(j+1, lines[j])
                break
    else:
        print('deploy file not found')
