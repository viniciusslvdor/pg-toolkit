CREATE OR REPLACE FUNCTION public.find_duplicate_indexes()
RETURNS TABLE (
    schema_name text,
    table_name  text,
    index_name  text,
    duplicate_of text
)
LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
    WITH indexes AS
    (
        SELECT
            ns.nspname AS schema_name,
            tbl.relname AS table_name,
            idx.relname AS index_name,
            pg_get_indexdef(idx.oid) AS definition
        FROM pg_index i
        JOIN pg_class idx
            ON idx.oid = i.indexrelid
        JOIN pg_class tbl
            ON tbl.oid = i.indrelid
        JOIN pg_namespace ns
            ON ns.oid = tbl.relnamespace
        WHERE ns.nspname NOT IN (
            'pg_catalog',
            'information_schema'
        )
    )
    SELECT
        i1.schema_name::text,
        i1.table_name::text,
        i1.index_name::text,
        i2.index_name::text
    FROM indexes i1
    JOIN indexes i2
      ON i1.schema_name = i2.schema_name
     AND i1.table_name = i2.table_name
     AND i1.definition = i2.definition
     AND i1.index_name < i2.index_name
    ORDER BY
        i1.schema_name,
        i1.table_name,
        i1.index_name;
END;
$$;