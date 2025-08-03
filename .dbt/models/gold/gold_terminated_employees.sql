{{ config(materialized='table') }}


SELECT
    EMPLOYEE.ID_EMPLOYEE,
    EMPLOYEE.NAME,
    GENDERS.GENDER,
    ETHNICITY.ETHNICITY,
    PWDS.PWD,
    TERM_EVENTS.TERMINATION_DATE,
    TERM_INFO.TERMINATION_REASON
FROM
    {{ ref('silver_terminations_events')}} TERM_EVENTS

JOIN {{ ref('silver_employee_info') }} EMPLOYEE
    ON EMPLOYEE.ID_EMPLOYEE = TERM_EVENTS.ID_EMPLOYEE

JOIN {{ ref('silver_termination_reasons_info')}} TERM_INFO
    ON TERM_EVENTS.ID_TERMINATION_REASON = TERM_INFO.ID_TERMINATION_REASON

JOIN {{ ref('silver_gender_info')}} GENDERS
    ON EMPLOYEE.ID_GENDER = GENDERS.ID_GENDER

JOIN {{ ref('silver_pwd_info')}} PWDS
    ON PWDS.ID_PWD = EMPLOYEE.ID_PWD

JOIN {{ ref('silver_ethnicity_info') }} ETHNICITY
    ON EMPLOYEE.ID_ETHNICITY = ETHNICITY.ID_ETHNICITY