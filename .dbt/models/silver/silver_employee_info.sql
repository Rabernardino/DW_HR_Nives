{{ config(materialized='table') }}

SELECT 
    id,
    employee_id as id_employee,
    name,
    gender_id as id_gender,
    ethnicity_id as id_ethnicity,
    pwd_id as id_pwd
FROM
    {{ ref('bronze_employee_info') }}
