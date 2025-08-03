{{ config(materialized='view') }}

WITH source AS (
    SELECT
        id,
        pwd_id,
        pwd
    FROM
        {{ source('sources','raw_pwd_info')}}
)

SELECT
    *
FROM
    source