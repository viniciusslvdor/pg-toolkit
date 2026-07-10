CREATE OR REPLACE FUNCTION public.table_row_count()
RETURNS TABLE (
    schema_name text,
    table_name  text,
    row_count   bigint
)
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
	    ORDER BY
	        t.table_schema,
	        t.table_name
	LOOP

        RETURN QUERY EXECUTE format(
            '
            SELECT
                %L::text,
                %L::text,
                COUNT(*)::bigint
            FROM %I.%I
            ',
            r_table.table_schema,
            r_table.table_name,
            r_table.table_schema,
            r_table.table_name
        );

    END LOOP;
END;
$$;