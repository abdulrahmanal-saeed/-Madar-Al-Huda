#!/usr/bin/env python3
"""Zero-dependency brand CI check. Run from project root."""
from pathlib import Path
import json, re, struct, xml.etree.ElementTree as ET
root = Path(__file__).resolve().parents[2]
d = root / 'design/brand'
res = root / 'apps/mobile/android/app/src/main/res'
colors = (root / 'apps/mobile/lib/core/theme/brand_colors.dart').read_text()
values = json.loads((d / 'tokens.json').read_text())['colors']
for key in ('primaryGreen', 'mutedGold', 'ivory', 'darkInk'):
    assert re.search(r'\b'+key+r'\s*=\s*Color\('+values[key].replace('#','0xFF')+r'\)', colors), key
for path in ('icon-master.svg','icon-monochrome.svg','wordmark-ar.svg','wordmark-en.svg'):
    e = ET.parse(d / path).getroot()
    assert e.tag.endswith('svg') and e.attrib.get('viewBox'), path
for name in ('ic_launcher_foreground.xml','ic_launcher_monochrome.xml'):
    ET.parse(res / 'drawable' / name)
ET.parse(res / 'mipmap-anydpi-v26/ic_launcher.xml')
license_text=(root/'apps/mobile/assets/fonts/ibm_plex_sans_arabic/OFL.txt').read_text().upper()
assert 'SIL OPEN FONT LICENSE' in license_text
for density,size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    data=(res / ('mipmap-'+density) / 'ic_launcher.png').read_bytes()
    assert data[:8] == b'\x89PNG\r\n\x1a\n'
    assert struct.unpack('>II',data[16:24]) == (size,size)
print('Brand palette, vectors, font license and five legacy icon densities verified.')
