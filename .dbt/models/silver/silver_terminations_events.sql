{{ config(materialized='table') }}


SELECT
    id,
    employee_id as id_employee,
    termination_date,
    termination_reason_id as id_termination_reason
FROM
    {{ ref('bronze_terminations_events') }}

