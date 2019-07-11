/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_SQL  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.API_SQL  AS

  PROCEDURE LOG_SQL (
      p_folder_name       IN VARCHAR2 /* Параметр принимает значение имени папки IPC, в которой размещается объект IPC */
    , p_workflow_name     IN VARCHAR2 /* Параметр принимает значение имени потока IPC */
    , p_proc_name         IN VARCHAR2 /* Параметр принимает значение имени процедуры, в которой выполняется динамический SQL-запрос */
    , p_targettable_name  IN VARCHAR2 DEFAULT NULL /* Параметр принимает значение имени целевой таблицы, для которой сформирован динамический SQL-запрос. */
    , p_sourcetable_name  IN VARCHAR2 DEFAULT NULL /* Параметр принимает значениеимени исходной таблицы, участвующей в динамическом SQL-запросе. */
    , p_source_code       IN VARCHAR2 DEFAULT NULL /* Параметр принимает значение имени исходной системы, таблица которой участвует в динамическом SQL-запросе. */
    , p_sqlerrm_text      IN VARCHAR2 DEFAULT NULL /* Параметр принимает значение системного сообщения об ошибке при возникновении исключения, когда исполняется динамический SQL-запрос. */
    , p_job_id            IN NUMBER   /* Параметр принимает значение идентификатора исполнения функции ETL-процесса, в котором вызвана процедура формирующая и исполняющая Dynamic SQL. */
    , p_start_dttm        IN DATE     /* Параметр принимает значение даты и времени начала исполнения Dynamic SQL. */
    , p_end_dttm          IN DATE DEFAULT NULL     /* Параметр принимает значение даты и времени завершения исполнения Dynamic SQL. */
    , p_rows_cnt          IN NUMBER DEFAULT NULL   /* Параметр принимает количество записей, которые были обработаны в Dynamic SQL. */
    , p_message_text      IN VARCHAR2 /* Параметр принимает краткое сообщение, характеризующее этап исполнения процудеры, которая исполняет Dynamic SQL. */
    , p_sql_text          IN CLOB DEFAULT NULL     /* Параметр принимает текст динамического SQL-запроса, который выполняется в рамках того или иного этапа процедуры. */
  );

END;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_SQL  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.API_SQL AS

  PROCEDURE LOG_SQL (
      p_folder_name       IN VARCHAR2  /* Параметр принимает значение имени папки IPC, в которой размещается объект IPC */
    , p_workflow_name     IN VARCHAR2  /* Параметр принимает значение имени потока IPC */
    , p_proc_name         IN VARCHAR2  /* Параметр принимает значение имени процедуры, в которой выполняется динамический SQL-запрос */
    , p_targettable_name  IN VARCHAR2 DEFAULT NULL /* Параметр принимает значение имени целевой таблицы, для которой сформирован динамический SQL-запрос. */
    , p_sourcetable_name  IN VARCHAR2 DEFAULT NULL /* Параметр принимает значениеимени исходной таблицы, участвующей в динамическом SQL-запросе. */
    , p_source_code       IN VARCHAR2 DEFAULT NULL /* Параметр принимает значение имени исходной системы, таблица которой участвует в динамическом SQL-запросе. */
    , p_sqlerrm_text      IN VARCHAR2 DEFAULT NULL /* Параметр принимает значение системного сообщения об ошибке при возникновении исключения, когда исполняется динамический SQL-запрос. */
    , p_job_id            IN NUMBER   /* Параметр принимает значение идентификатора исполнения функции ETL-процесса, в котором вызвана процедура формирующая и исполняющая Dynamic SQL. */
    , p_start_dttm        IN DATE     /* Параметр принимает значение даты и времени начала исполнения Dynamic SQL. */
    , p_end_dttm          IN DATE DEFAULT NULL    /* Параметр принимает значение даты и времени завершения исполнения Dynamic SQL. */
    , p_rows_cnt          IN NUMBER DEFAULT NULL  /* Параметр принимает количество записей, которые были обработаны в Dynamic SQL. */
    , p_message_text      IN VARCHAR2 /* Параметр принимает краткое сообщение, характеризующее этап исполнения процудеры, которая исполняет Dynamic SQL. */
    , p_sql_text          IN CLOB DEFAULT NULL    /* Параметр принимает текст динамического SQL-запроса, который выполняется в рамках того или иного этапа процедуры. */
  )
  IS
  BEGIN
    /* 1. Контроль параметров */
    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => 'Значение параметра P_FOLDER_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => 'Значение параметра P_WORKFLOW_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );

    END IF;

    IF p_proc_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => 'Значение параметра P_PROC_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    IF p_job_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => 'Значение параметра P_JOB_ID не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    IF p_start_dttm IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => 'Значение параметра P_START_DTTM не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    IF p_targettable_name IS NULL AND p_sourcetable_name IS NULL AND p_source_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => 'Хотя бы один из параметров [P_TARGETTABLE_NAME, P_SOURCETABLE_NAME, P_SOURCE_CODE] должен иметь значение NOT NULL.',
          P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /* 2. Добавление записи в LOG_SQL */
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
           P_ERRMSG_TEXT    => 'Системная ошибка',
           P_PLSQLUNIT_NAME => 'API_LOG.LOG_SQL',
           P_SEVERITY_CODE  => 'S',
           P_SQLERRM_TEXT   => SQLERRM
         );
      END IF;
      RAISE;

  END;


END;
/