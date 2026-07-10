CREATE OR REPLACE FUNCTION public.search_in_tables(
    p_search_value text,
    p_schema_name  text
)
RETURNS TABLE (
    column_value text,
    table_name   text
)
LANGUAGE plpgsql
AS
$$
DECLARE
    r_column record;
    v_sql    text := '';
BEGIN
    FOR r_column IN
        SELECT
            c.table_name,
            c.column_name
        FROM information_schema.columns c
        WHERE c.table_schema = p_schema_name
          AND c.is_updatable = 'YES'
        ORDER BY
            c.table_name,
            c.ordinal_position
    LOOP

        v_sql := v_sql ||
            format(
                'SELECT %1$I::text AS column_value,
                        %2$L::text AS table_name
                   FROM %3$I.%4$I
                  WHERE %1$I::text ILIKE %5$L
                UNION ALL ',
                r_column.column_name,
                r_column.table_name,
                p_schema_name,
                r_column.table_name,
                p_search_value
            );

    END LOOP;

    IF v_sql = '' THEN
        RETURN;
    END IF;

    v_sql := left(v_sql, length(v_sql) - length('UNION ALL '));

    RETURN QUERY EXECUTE v_sql;

END;
$$;