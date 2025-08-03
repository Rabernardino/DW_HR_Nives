{{ config(materialized='view')}}

WITH source AS (
    SELECT
        id,
        hiring_id,
        employee_id,
        hiring_date,
        job_title_id,
        shift_id,
        contract_id
    FROM
        {{ source('sources','raw_hiring_events')}}
)

SELECT
    *
FROM
    source

