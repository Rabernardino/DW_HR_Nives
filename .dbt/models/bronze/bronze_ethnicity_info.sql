{{ config(materialized='view') }}

WITH source AS (
    SELECT
        id,
        ethnicity_id,
        ethnicity
    FROM
        {{ source('sources','raw_ethnicity_info')}}
)

SELECT
    *
FROM
    source