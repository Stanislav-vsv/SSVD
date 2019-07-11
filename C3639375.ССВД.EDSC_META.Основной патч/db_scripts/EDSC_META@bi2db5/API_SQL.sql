/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_SQL  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.API_SQL  AS

  PROCEDURE LOG_SQL (
      p_folder_name       IN VARCHAR2 /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
    , p_workflow_name     IN VARCHAR2 /* �������� ��������� �������� ����� ������ IPC */
    , p_proc_name         IN VARCHAR2 /* �������� ��������� �������� ����� ���������, � ������� ����������� ������������ SQL-������ */
    , p_targettable_name  IN VARCHAR2 DEFAULT NULL /* �������� ��������� �������� ����� ������� �������, ��� ������� ����������� ������������ SQL-������. */
    , p_sourcetable_name  IN VARCHAR2 DEFAULT NULL /* �������� ��������� ������������� �������� �������, ����������� � ������������ SQL-�������. */
    , p_source_code       IN VARCHAR2 DEFAULT NULL /* �������� ��������� �������� ����� �������� �������, ������� ������� ��������� � ������������ SQL-�������. */
    , p_sqlerrm_text      IN VARCHAR2 DEFAULT NULL /* �������� ��������� �������� ���������� ��������� �� ������ ��� ������������� ����������, ����� ����������� ������������ SQL-������. */
    , p_job_id            IN NUMBER   /* �������� ��������� �������� �������������� ���������� ������� ETL-��������, � ������� ������� ��������� ����������� � ����������� Dynamic SQL. */
    , p_start_dttm        IN DATE     /* �������� ��������� �������� ���� � ������� ������ ���������� Dynamic SQL. */
    , p_end_dttm          IN DATE DEFAULT NULL     /* �������� ��������� �������� ���� � ������� ���������� ���������� Dynamic SQL. */
    , p_rows_cnt          IN NUMBER DEFAULT NULL   /* �������� ��������� ���������� �������, ������� ���� ���������� � Dynamic SQL. */
    , p_message_text      IN VARCHAR2 /* �������� ��������� ������� ���������, ��������������� ���� ���������� ���������, ������� ��������� Dynamic SQL. */
    , p_sql_text          IN CLOB DEFAULT NULL     /* �������� ��������� ����� ������������� SQL-�������, ������� ����������� � ������ ���� ��� ����� ����� ���������. */
  );

END;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_SQL  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.API_SQL AS

  PROCEDURE LOG_SQL (
      p_folder_name       IN VARCHAR2  /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
    , p_workflow_name     IN VARCHAR2  /* �������� ��������� �������� ����� ������ IPC */
    , p_proc_name         IN VARCHAR2  /* �������� ��������� �������� ����� ���������, � ������� ����������� ������������ SQL-������ */
    , p_targettable_name  IN VARCHAR2 DEFAULT NULL /* �������� ��������� �������� ����� ������� �������, ��� ������� ����������� ������������ SQL-������. */
    , p_sourcetable_name  IN VARCHAR2 DEFAULT NULL /* �������� ��������� ������������� �������� �������, ����������� � ������������ SQL-�������. */
    , p_source_code       IN VARCHAR2 DEFAULT NULL /* �������� ��������� �������� ����� �������� �������, ������� ������� ��������� � ������������ SQL-�������. */
    , p_sqlerrm_text      IN VARCHAR2 DEFAULT NULL /* �������� ��������� �������� ���������� ��������� �� ������ ��� ������������� ����������, ����� ����������� ������������ SQL-������. */
    , p_job_id            IN NUMBER   /* �������� ��������� �������� �������������� ���������� ������� ETL-��������, � ������� ������� ��������� ����������� � ����������� Dynamic SQL. */
    , p_start_dttm        IN DATE     /* �������� ��������� �������� ���� � ������� ������ ���������� Dynamic SQL. */
    , p_end_dttm          IN DATE DEFAULT NULL    /* �������� ��������� �������� ���� � ������� ���������� ���������� Dynamic SQL. */
    , p_rows_cnt          IN NUMBER DEFAULT NULL  /* �������� ��������� ���������� �������, ������� ���� ���������� � Dynamic SQL. */
    , p_message_text      IN VARCHAR2 /* �������� ��������� ������� ���������, ��������������� ���� ���������� ���������, ������� ��������� Dynamic SQL. */
    , p_sql_text          IN CLOB DEFAULT NULL    /* �������� ��������� ����� ������������� SQL-�������, ������� ����������� � ������ ���� ��� ����� ����� ���������. */
  )
  IS
  BEGIN
    /* 1. �������� ���������� */
    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );

    END IF;

    IF p_proc_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� P_PROC_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    IF p_job_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� P_JOB_ID �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    IF p_start_dttm IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� P_START_DTTM �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    IF p_targettable_name IS NULL AND p_sourcetable_name IS NULL AND p_source_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '���� �� ���� �� ���������� [P_TARGETTABLE_NAME, P_SOURCETABLE_NAME, P_SOURCE_CODE] ������ ����� �������� NOT NULL.',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /* 2. ���������� ������ � LOG_SQL */
    INSERT INTO LOG_SQL (
              FOLDER_NAME
            , WORKFLOW_NAME
            , PROC_NAME
            , TARGETTABLE_NAME
            , SOURCETABLE_NAME
            , SOURCE_CODE
            , JOB_ID
            , START_DTTM
            , END_DTTM
            , ROWS_CNT
            , SQLERRM_TEXT
            , SYSTIME_TMST
            , OSUSER_CODE
            , SESSIONUSER_CODE
            , MESSAGE_TEXT
            , SQL_TEXT
          )
      VALUES (
            p_folder_name
          , p_workflow_name
          , p_proc_name
          , p_targettable_name
          , p_sourcetable_name
          , p_source_code
          , p_job_id
          , p_start_dttm
          , p_end_dttm
          , p_rows_cnt
          , p_sqlerrm_text
          , SYSTIMESTAMP
          , SYS_CONTEXT('USERENV','OS_USER')
          , SYS_CONTEXT('USERENV','SESSION_USER')
          , p_message_text
          , p_sql_text
      );

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT    => '��������� ������',
           P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
           P_SEVERITY_CODE  => 'S',
           P_SQLERRM_TEXT   => SQLERRM
         );
      END IF;
      RAISE;

  END;


END;
/