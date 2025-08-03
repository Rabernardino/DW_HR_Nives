from airflow.decorators import dag, task
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from airflow.exceptions import AirflowException

from datetime import datetime, timedelta
import logging


log = logging.getLogger(__name__)


default_args = {
    'owner':'airflow',
    'start_date':datetime(2025,7,13),
    'email_on_failure':False,
    'email_on_retry':False,
    'retries':0,
    'retry_delay':timedelta(minutes=10)    
}


@dag(
    dag_id='data_extraction_to_snowflake',
    default_args=default_args,
    description='Data extraction from local database to Snowflake',
    schedule_interval=timedelta(days=1),
    catchup=False
)



def etl_postgres_to_snowflake():


    @task(task_id='collecting_table_names')
    def collecting_table_name_postgres():
        log.info("Attempting to collect table names from the Postgres database")
        try:        
            with PostgresHook(postgres_conn_id='postgres').get_conn() as post_conn:
                with post_conn.cursor() as cursor:
                    cursor.execute(
                        "SELECT table_name FROM information_schema.tables WHERE table_schema = 'HR_NIVES'"
                    )

                    tables = [row[0] for row in cursor.fetchall()]
                    return tables
        except Exception as e:
            log.error(f"Error collecting the table names from Postgres database", exc_info=True)
            raise AirflowException(f"Failed to collect the table names: {e}")
            


    @task(task_id='processing_tables')
    def processing_each_table(table_name: str):
        log.info(f"Starting transfer data from table {table_name}")

        try:
            with SnowflakeHook(snowflake_conn_id='snowflake').get_conn() as snow_conn:
                with snow_conn.cursor() as cursor:
                    cursor.execute(
                        f"SELECT MAX(ID) FROM {table_name}"
                    )

                    max_id = cursor.fetchone()[0] or 0


    # @task(task_id='processing_tables')
    # def processing_each_table(table_name: str):
    #     log.info(f"Starting transfer data from table {table_name}")
    #     try:
    #         with PostgresHook(postgres_conn_id='postgres').get_conn() as post_conn:
    #             with post_conn.cursor() as cursor:
    #                 full_table_name_raw = f'"HR_NIVES".{table_name}'
    #                 cursor.execute(
    #                     f"SELECT MAX(ID) FROM {full_table_name_raw}"
    #                 )

    #                 max_id = cursor.fetchone()[0] or 0
        except Exception as e:
            raise AirflowException(f"Failed on collecting the max_id from table {table_name}: {e}")
    
        try:
            with PostgresHook(postgres_conn_id='postgres').get_conn() as post_conn:
                with post_conn.cursor() as cursor:
                    full_table_name_raw = f'"HR_NIVES".{table_name}'

                    """Creating the insert structure""" 
                    cursor.execute(
                        f"SELECT column_name FROM information_schema.columns WHERE table_schema = 'HR_NIVES' and table_name = '{table_name}'"
                    )
                    
                    columns = [row[0] for row in cursor.fetchall()]
                    columns_on_string = ', '.join(columns)
                    placeholders = ', '.join(['%s'] * len(columns))

                    # cursor.execute(
                    #     f"SELECT * FROM {full_table_name_raw} WHERE ID > {max_id}"
                    # )

                    cursor.execute(
                        f"SELECT * FROM {full_table_name_raw}"
                    )

                    data_for_ingestion = cursor.fetchall()
        except Exception as e:
            raise AirflowException(f"Failed to extract data from Postgres table {table_name}")

        # with SnowflakeHook(snowflake_conn_id='snowflake').get_conn() as snow_conn:
        #     with snow_conn.cursor() as cursor:
        #         insert_query = f"INSERT INTO {table_name} {columns_on_string} VALUES {placeholders}"
        #         for row in data_for_ingestion:
        #             cursor.execute(insert_query, row)

        log.info(f"Ingesting {len(data_for_ingestion)} rows into Postgres DW")
        try:
            with PostgresHook(postgres_conn_id='postgres').get_conn() as post_conn:
                with post_conn.cursor() as cursor:
                    full_table_name_dw = f'"DW_HR_NIVES".{table_name}'
                    insert_query = f"INSERT INTO {full_table_name_dw} ({columns_on_string}) VALUES ({placeholders})" 

                    for row in data_for_ingestion:
                        # logger.info(f"Inserting row into {full_table_name_dw}: {row}")
                        cursor.execute(insert_query,row)
        except Exception as e:
            raise AirflowException(f"Failed to transfer data to Postgres DW on table:{full_table_name_dw}")



    tables = collecting_table_name_postgres()
    processing_each_table.expand(table_name=tables)

etl_postgres_to_snowflake_dag = etl_postgres_to_snowflake()