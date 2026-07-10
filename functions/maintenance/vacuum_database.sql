CREATE OR REPLACE PROCEDURE public.vacuum_database(
    p_analyze boolean DEFAULT true
)
LANGUAGE plpgsql
AS
$$
DECLARE
    r_table record;
BEGIN

    FOR r_table IN

        SELECT
            table_schema,
            table_name
        FROM information_schema.tables
        WHERE table_type = 'BASE TABLE'
          AND table_schema NOT IN (
                'pg_catalog',
                'information_schema'
          )
        ORDER BY
            table_schema,
            table_name

    LOOP

        RAISE NOTICE 'Vacuuming %.%',
            r_table.table_schema,
            r_table.table_name;

        IF p_analyze THEN

            EXECUTE format(
                'VACUUM ANALYZE %I.%I',
                r_table.table_schema,
                r_table.table_name
            );

        ELSE

            EXECUTE format(
                'VACUUM %I.%I',
                r_table.table_schema,
                r_table.table_name
            );

        END IF;

    END LOOP;

END;
$$;