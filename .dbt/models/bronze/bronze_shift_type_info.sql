{{ config(materialized='view' )}}


WITH source AS (
    SELECT
        id,
        shift_type_id,
        shift_type
    FROM
        {{ source('sources','raw_shift_type_info') }}
)

SELECT
    *
FROM
    source