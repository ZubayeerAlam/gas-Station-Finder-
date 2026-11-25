#!/usr/bin/env python3
"""Line coverage of the domain layer (pure business logic) from lcov.info.

Usage: python3 tool/domain_coverage.py coverage/lcov.info [min_percent]
Counts lib/features/*/domain/** and lib/core/utils/**, excluding generated
*.freezed.dart / *.g.dart files. Exits 1 when below min_percent.
"""
import re
import sys

path = sys.argv[1] if len(sys.argv) > 1 else 'coverage/lcov.info'
minimum = float(sys.argv[2]) if len(sys.argv) > 2 else 70.0
include = re.compile(r'^lib/(features/[^/]+/domain/|core/utils/)')
generated = re.compile(r'\.(freezed|g)\.dart$')

files = {}
current = None
with open(path) as f:
    for line in f:
        line = line.strip()
        if line.startswith('SF:'):
            name = line[3:]
            current = name if include.search(name) and not generated.search(name) else None
            if current:
                files[current] = [0, 0]
        elif current and line.startswith('DA:'):
            hits = int(line.split(',')[1])
            files[current][1] += 1
            files[current][0] += 1 if hits > 0 else 0

hit = sum(h for h, _ in files.values())
total = sum(t for _, t in files.values())
pct = 100.0 * hit / total if total else 0.0
for name, (h, t) in sorted(files.items(), key=lambda kv: kv[1][0] / max(kv[1][1], 1)):
    print(f'{100.0 * h / t if t else 100:6.1f}%  {h:4}/{t:<4} {name}')
print(f'\nDomain-layer line coverage: {pct:.1f}% ({hit}/{total} lines, {len(files)} files); minimum {minimum:.0f}%')
sys.exit(0 if pct >= minimum else 1)
