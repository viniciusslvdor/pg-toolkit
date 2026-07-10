CREATE OR REPLACE FUNCTION public.tables_without_index_fk()
RETURNS TABLE (
    schema_name text,
    table_name text,
    foreign_key text,
    column_name text
)
LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN QUERY
    SELECT
        ns.nspname::text,
        tbl.relname::text,
        con.conname::text,
        att.attname::text
    FROM pg_constraint AS con

    JOIN pg_class AS tbl
        ON tbl.oid = con.conrelid

    JOIN pg_namespace AS ns
        ON ns.oid = tbl.relnamespace

    JOIN pg_attribute AS att
        ON att.attrelid = tbl.oid
       AND att.attnum = ANY(con.conkey)

    WHERE con.contype = 'f'

      AND ns.nspname NOT IN (
            'pg_catalog',
            'information_schema'
      )

      AND NOT EXISTS (

            SELECT 1
            FROM pg_index idx
            WHERE idx.indrelid = tbl.oid
              AND idx.indkey[0] = att.attnum

      )

    ORDER BY
        ns.nspname,
        tbl.relname,
        con.conname;

END;
$$;