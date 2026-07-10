CREATE OR REPLACE FUNCTION public.rebuild_all_sequences()
RETURNS void
LANGUAGE plpgsql
AS
$$
DECLARE
    r_column record;
    v_sql text;
BEGIN
    FOR r_column IN
        SELECT
            c.table_schema,
            c.table_name,
            c.column_name,
            pg_get_serial_sequence(
                format('%I.%I', c.table_schema, c.table_name),
                c.column_name
            ) AS sequence_name
        FROM information_schema.columns AS c
        WHERE c.table_schema NOT IN (
            'pg_catalog',
            'information_schema'
        )
    LOOP

        IF r_column.sequence_name IS NOT NULL THEN

            RAISE NOTICE 'Rebuilding sequence %', r_column.sequence_name;

            v_sql := format(
                'SELECT setval(%L,
                               COALESCE((SELECT MAX(%I) FROM %I.%I), 1),
                               true)',
                r_column.sequence_name,
                r_column.column_name,
                r_column.table_schema,
                r_column.table_name
            );

            EXECUTE v_sql;

        END IF;

    END LOOP;
END;
$$;