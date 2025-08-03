{{ config(materialized='table') }}


SELECT
    id,
    contract_type_id as id_contract_type,
    contract_type
FROM
    {{ ref('bronze_contract_type_info') }}


