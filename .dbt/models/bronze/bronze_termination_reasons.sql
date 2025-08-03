{{ config(materialized='view') }}


WITH source AS (
    SELECT
        id,
        termination_reason_id,
        termination_reason
    FROM
        {{ source('sources','raw_termination_reasons_info') }}
)


SELECT
    *
FROM
    source