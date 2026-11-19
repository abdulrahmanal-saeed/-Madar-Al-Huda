#!/usr/bin/env python3
"""Static RLS design-contract guard. NOT a replacement for database security tests."""
from pathlib import Path
import re
source = (Path(__file__).resolve().parent / 'SCHEMA_BLUEPRINT.sql').read_text().lower()
tables = set(re.findall(r'create table\s+(mh_private|public)\.(mh_[a-z0-9_]+|[a-z0-9_]+)\s*\(', source))
rls = set(re.findall(r'alter table\s+(mh_private|public)\.(mh_[a-z0-9_]+|[a-z0-9_]+)\s+enable row level security\s*;', source))
assert tables and tables == rls, f'Every declared table must enable RLS: missing={tables-rls}, extra={rls-tables}'
assert ('public','mh_published_items') in tables
assert 'rights_expires_at > now()' in source
assert 'withdrawn_at is null' in source
assert 'rights_verified and editorial_approved' in source
for name in ('mh_user_bookmarks','mh_user_positions','mh_lesson_progress'):
    assert ('public', name) in tables
    for operation in ('select','insert','update','delete'):
        pattern = r'create policy\s+"?[a-z0-9_]+"?\s+on public\.'+name+r'\s+for '+operation+r' to authenticated'
        assert re.search(pattern, source), (name, operation)
    assert source.count('((select auth.uid()) = user_id)') >= 3
assert not re.search(r'create policy\s+.*?\s+on public\.mh_published_items\s+for\s+(insert|update|delete)',source,re.S)
assert 'grant select on public.mh_published_items to anon, authenticated;' in source
print(f'Schema blueprint static checks passed: {len(tables)} RLS-enabled tables; owner CRUD and publication gates.')
