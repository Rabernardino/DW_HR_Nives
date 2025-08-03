{{ config(materialized='table') }}

SELECT
    id,
    hiring_id as id_hiring_event,
    employee_id as id_employee,
    hiring_date,
    job_title_id as id_job_title,
    shift_id as id_shift,
    contract_id as id_contract
FROM
    {{ ref('bronze_hiring_events') }}