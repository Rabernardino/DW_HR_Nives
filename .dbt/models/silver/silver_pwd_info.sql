{{ config(materialized='table') }}


SELECT
    id,
    pwd_id as id_pwd,
    pwd
FROM
    {{ ref('bronze_pwd_info') }}