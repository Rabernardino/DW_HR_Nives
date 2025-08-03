{{ config(materialized='table') }}


SELECT
    id,
    shift_type_id as id_shift_type,
    shift_type
FROM
    {{ ref('bronze_shift_type_info') }}