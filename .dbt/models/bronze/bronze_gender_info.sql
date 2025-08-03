{{ config(materialized='view') }}


WITH source AS (
    SELECT
        id,
        gender_id,
        gender
    FROM
        {{ source('sources','raw_gender_info') }}
)


SELECT
    *
FROM
    source