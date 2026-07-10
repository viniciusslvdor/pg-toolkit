CREATE OR REPLACE FUNCTION public.search_all_database(
    p_search_value text
)
RETURNS TABLE (
    schema_name  text,
    table_name   text,
    column_name  text,
    column_value text
)
LANGUAGE plpgsql
AS
$$
DECLARE
    r_column record;
BEGIN
    FOR r_column IN
        SELECT
            c.table_schema,
            c.table_name,
            c.column_name
        FROM information_schema.columns c
        JOIN information_schema.tables t
          ON t.table_schema = c.table_schema
         AND t.table_name = c.table_name
        WHERE t.table_type = 'BASE TABLE'
          AND c.table_schema NOT IN ('pg_catalog', 'information_schema')
          AND c.data_type IN (
                'character varying',
                'character',
                'text'
          )
        ORDER BY
            c.table_schema,
            c.table_name,
            c.ordinal_position
    LOOP

        RETURN QUERY EXECUTE format(
            '
            SELECT
                %L::text,
                %L::text,
                %L::text,
                %I::text
            FROM %I.%I
            WHERE %I ILIKE %L
            ',
            r_column.table_schema,
            r_column.table_name,
            r_column.column_name,
            r_column.column_name,
            r_column.table_schema,
            r_column.table_name,
            r_column.column_name,
            p_search_value
        );

    END LOOP;
END;
$$;