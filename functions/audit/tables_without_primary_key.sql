CREATE OR REPLACE FUNCTION public.tables_without_primary_key()
RETURNS TABLE (
    schema_name text,
    table_name text
)
LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN QUERY
    SELECT
        n.nspname::text,
        c.relname::text
    FROM pg_class AS c
    JOIN pg_namespace AS n
        ON n.oid = c.relnamespace
    LEFT JOIN pg_constraint AS pk
        ON pk.conrelid = c.oid
       AND pk.contype = 'p'
    WHERE c.relkind = 'r'
      AND n.nspname NOT IN (
            'pg_catalog',
            'information_schema'
      )
      AND pk.oid IS NULL
    ORDER BY
        n.nspname,
        c.relname;

END;
$$;