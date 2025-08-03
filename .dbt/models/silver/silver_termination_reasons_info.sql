{{ config(materialized='table') }}


SELECT
    id,
    termination_reason_id as id_termination_reason,
    termination_reason
FROM
    {{ ref('bronze_termination_reasons_info') }}