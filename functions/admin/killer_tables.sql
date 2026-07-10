CREATE OR REPLACE FUNCTION public.killer_tables()
RETURNS void
LANGUAGE plpgsql
AS
$$
DECLARE
    r_table    record;
    r_sequence record;
BEGIN
    FOR r_table IN
        SELECT
            table_schema,
            table_name
        FROM information_schema.tables
        WHERE table_type = 'BASE TABLE'
          AND table_schema NOT IN ('pg_catalog', 'information_schema')
        ORDER BY
            table_schema,
            table_name
    LOOP

        RAISE NOTICE 'Truncating %.%', r_table.table_schema, r_table.table_name;

        EXECUTE format(
            'TRUNCATE TABLE %I.%I CASCADE',
            r_table.table_schema,
            r_table.table_name
        );

    END LOOP;

    -- Restart all sequences
    FOR r_sequence IN
        SELECT
            sequence_schema,
            sequence_name
        FROM information_schema.sequences
        WHERE sequence_schema NOT IN ('pg_catalog', 'information_schema')
        ORDER BY
            sequence_schema,
            sequence_name
    LOOP

        PERFORM pg_catalog.setval(
            format(
                '%I.%I',
                r_sequence.sequence_schema,
                r_sequence.sequence_name
            ),
            1,
            false
        );

    END LOOP;
END;
$$;