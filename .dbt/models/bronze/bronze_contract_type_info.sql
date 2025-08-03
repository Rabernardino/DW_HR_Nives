{{ config(materialized='view' )}}


WITH source AS (
    SELECT
        id,
        contract_type_id,
        contract_type
    FROM
        {{ source('sources','raw_contract_type_info') }}
)

SELECT
    *
FROM
    source