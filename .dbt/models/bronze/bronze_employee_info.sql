{{ config(materialized='view') }}

WITH source AS (
    SELECT
        id,
        employee_id,
        name,
        gender_id,
        ethnicity_id,
        pwd_id
    FROM
        {{ source('sources','raw_employee_info') }}
)

SELECT
    *
FROM
    source