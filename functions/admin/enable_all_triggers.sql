CREATE OR REPLACE FUNCTION public.enable_all_triggers(
    p_schema_name text DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
AS
$$
DECLARE
    r_table record;
BEGIN
    FOR r_table IN
        SELECT
            t.table_schema,
            t.table_name
        FROM information_schema.tables AS t
        WHERE t.table_type = 'BASE TABLE'
          AND t.table_schema NOT IN (
                'pg_catalog',
                'information_schema'
          )
          AND (
                p_schema_name IS NULL
                OR t.table_schema = p_schema_name
          )
        ORDER BY
            t.table_schema,
            t.table_name
    LOOP

        RAISE NOTICE 'Enabling triggers on %.%',
            r_table.table_schema,
            r_table.table_name;

        EXECUTE format(
            'ALTER TABLE %I.%I ENABLE TRIGGER ALL',
            r_table.table_schema,
            r_table.table_name
        );

    END LOOP;
END;
$$;