# PostgreSQL Functions

A collection of useful PL/pgSQL functions for PostgreSQL 16.14.

These are functions I've developed and used many times throughout my professional career. Most of them solve recurring administrative tasks, data maintenance, troubleshooting, and database inspection, making them useful for both DBAs and PL developers.

> Obs: Last tested on PostgreSQL 16.14.

---

## Functions

### Database Maintenance

#### `killer_tables()`

Truncates all user tables and restarts all sequences.

```sql
SELECT public.killer_tables();
```

---

#### `disable_all_triggers()`

Disables triggers for all user tables.

```sql
SELECT public.disable_all_triggers();
```

---

#### `enable_all_triggers()`

Enables triggers for all user tables.

```sql
SELECT public.enable_all_triggers();
```

---

#### `rebuild_all_sequences()`

Synchronizes all sequences with the highest value found in their respective tables.

```sql
SELECT public.rebuild_all_sequences();
```

---

### Search Utilities

#### `search_in_tables(search_value, schema_name)`

Searches a value in all searchable columns within a schema.

```sql
SELECT *
FROM public.search_in_tables('%john%', 'public');
```

---

#### `search_all_database(search_value)`

Searches a value across all user schemas.

```sql
SELECT *
FROM public.search_all_database('%john%');
```

---

#### `find_column(column_name)`

Finds columns matching a given name.

```sql
SELECT *
FROM public.find_column('%customer%');
```

---

### Reports

#### `table_row_count()`

Returns the exact number of rows for every user table.

```sql
SELECT *
FROM public.table_row_count();
```

---

#### `generate_database_report()`

Generates a summary report of the current database.

```sql
SELECT *
FROM public.generate_database_report();
```

---

### Database Audit

#### `find_unused_indexes()`

Lists indexes that have never been used.

```sql
SELECT *
FROM public.find_unused_indexes();
```

---

#### `find_duplicate_indexes()`

Finds duplicate indexes.

```sql
SELECT *
FROM public.find_duplicate_indexes();
```

---

#### `tables_without_primary_key()`

Lists tables that do not have a primary key.

```sql
SELECT *
FROM public.tables_without_primary_key();
```

---

#### `tables_without_index_fk()`

Lists foreign keys that do not have a supporting index.

```sql
SELECT *
FROM public.tables_without_index_fk();
```

---

### Maintenance Procedures

#### `vacuum_database()`

Runs `VACUUM` (or `VACUUM ANALYZE`) for every user table.

```sql
CALL public.vacuum_database();
```

## Compatibility

- PostgreSQL 16.14
