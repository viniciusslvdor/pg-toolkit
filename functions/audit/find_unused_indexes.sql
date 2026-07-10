CREATE OR REPLACE FUNCTION public.find_unused_indexes()
RETURNS TABLE (
    schema_name text,
    table_name  text,
    index_name  text,
    index_size  text,
    index_scans bigint
)
LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
    SELECT
        schemaname::text,
        relname::text,
        indexrelname::text,
        pg_size_pretty(pg_relation_size(indexrelid))::text,
        idx_scan
    FROM pg_stat_user_indexes
    WHERE idx_scan = 0
    ORDER BY
        pg_relation_size(indexrelid) DESC,
        schemaname,
        relname;
END;
$$;