{{ config(materialized='table' )}}

SELECT
    id,
    ethnicity_id as id_ethnicity,
    ethnicity
FROM
    {{ ref('bronze_ethnicity_info') }}