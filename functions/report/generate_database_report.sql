CREATE OR REPLACE FUNCTION public.generate_database_report()
RETURNS TABLE (
    metric text,
    value text
)
LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY

    SELECT
        'Database'::text,
        current_database()::text

    UNION ALL

    SELECT
        'Database Size',
        pg_size_pretty(pg_database_size(current_database()))

    UNION ALL

    SELECT
        'Schemas',
        COUNT(*)::text
    FROM information_schema.schemata
    WHERE schema_name NOT LIKE 'pg_%'
      AND schema_name <> 'information_schema'

    UNION ALL

    SELECT
        'Tables',
        COUNT(*)::text
    FROM information_schema.tables
    WHERE table_type = 'BASE TABLE'
      AND table_schema NOT IN ('pg_catalog', 'information_schema')

    UNION ALL

    SELECT
        'Views',
        COUNT(*)::text
    FROM information_schema.views
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema')

    UNION ALL

    SELECT
        'Sequences',
        COUNT(*)::text
    FROM information_schema.sequences
    WHERE sequence_schema NOT IN ('pg_catalog', 'information_schema')

    UNION ALL

    SELECT
        'Indexes',
        COUNT(*)::text
    FROM pg_indexes
    WHERE schemaname NOT IN ('pg_catalog', 'information_schema')

    UNION ALL

    SELECT
        'Functions',
        COUNT(*)::text
    FROM pg_proc p
    JOIN pg_namespace n
      ON n.oid = p.pronamespace
    WHERE n.nspname NOT IN ('pg_catalog', 'information_schema');

END;
$$;