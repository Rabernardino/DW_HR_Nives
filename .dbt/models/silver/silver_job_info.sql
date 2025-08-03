{{ config(materialized='table') }}

SELECT
    id,
    job_title_id as id_job_title,
    job_title
FROM
    {{ ref('bronze_job_info') }}