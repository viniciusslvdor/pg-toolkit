CREATE OR REPLACE FUNCTION public.find_column(
    p_column_name text
)
RETURNS TABLE (
    schema_name text,
    table_name  text,
    column_name text,
    data_type   text,
    nullable    boolean
)
LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN QUERY
    SELECT
        c.table_schema::text,
        c.table_name::text,
        c.column_name::text,
        c.data_type::text,
        c.is_nullable = 'YES'
    FROM information_schema.columns AS c
    WHERE c.table_schema NOT IN (
            'pg_catalog',
            'information_schema'
          )
      AND c.column_name ILIKE p_column_name
    ORDER BY
        c.table_schema,
        c.table_name,
        c.ordinal_position;

END;
$$;