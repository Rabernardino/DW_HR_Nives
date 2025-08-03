{{ config(materialized='view' )}}


WITH source AS (
    SELECT
        id,
        employee_id,
        termination_date,
        termination_reason_id
    FROM
        {{ source('sources','raw_terminations_events') }}
)


SELECT
    *
FROM
    source