{{ config(materialized='table') }}


SELECT
    id,
    gender_id as id_gender,
    gender
FROM
    {{ ref('bronze_gender_info')}}