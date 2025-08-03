{{ config(materialized='view') }}


WITH source AS (
    SELECT
        id,
        job_title_id,
        job_title
    FROM
        {{ source('sources','raw_job_info') }}
)


SELECT
    *
FROM
    source