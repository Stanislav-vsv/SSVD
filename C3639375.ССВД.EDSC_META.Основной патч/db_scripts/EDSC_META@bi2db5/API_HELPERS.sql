/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_HELPERS  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.API_HELPERS AS

  FUNCTION GET_JOB_ID(
    p_folder_name    VARCHAR2,
    p_workflow_name  VARCHAR2,
    p_workflowrun_id NUMBER
  )
    RETURN NUMBER;

  FUNCTION GET_LOADING_ID(
    p_folder_name    VARCHAR2,
    p_workflow_name  VARCHAR2,
    p_workflowrun_id NUMBER
  )
    RETURN NUMBER;


  FUNCTION GET_REGLAMENTTYPE_CODE(
    p_folder_name    VARCHAR2,
    p_workflow_name  VARCHAR2,
    p_workflowrun_id NUMBER
  )
    RETURN VARCHAR2;


  function CLOBREPLACE(
    p_INPUT      CLOB,
    p_PATTERN    VARCHAR2,
    p_SUBSTITUTE CLOB
  )
    return CLOB;

END API_HELPERS;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_HELPERS  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.API_HELPERS IS

  FUNCTION GET_JOB_ID(
    p_folder_name    VARCHAR2,
    p_workflow_name  VARCHAR2,
    p_workflowrun_id NUMBER
  )
    RETURN NUMBER
  IS
    v_job_id NUMBER;
    v_purposetype_code VARCHAR2(255);
  BEGIN

    SELECT UTL_HELPERS.GET_PURPOSETYPE_CODE(P_FOLDER_NAME => p_folder_name, P_WORKFLOW_NAME => p_workflow_name)
      INTO v_purposetype_code
      FROM DUAL;

    IF v_purposetype_code = 'ETL'
      THEN
      BEGIN
        SELECT MAX(JOB_ID)
          INTO v_job_id
          FROM LOG_JOB
         WHERE WORKFLOW_NAME  = p_workflow_name
           AND FOLDER_NAME    = p_folder_name
           AND WORKFLOWRUN_ID = p_workflowrun_id;

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_job_id := NULL;
      END;
    ELSE
      v_job_id := NULL;
    END IF;

    RETURN v_job_id;

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT    => 'Системная ошибка',
           P_PLSQLUNIT_NAME => 'API_HELPERS.GET_JOB_ID',
           P_SEVERITY_CODE  => 'S',
           P_SQLERRM_TEXT   => SQLERRM
         );
      END IF;
      RAISE;

  END;

  FUNCTION GET_LOADING_ID(
    p_folder_name    VARCHAR2,
    p_workflow_name  VARCHAR2,
    p_workflowrun_id NUMBER
  )
    RETURN NUMBER
  IS
    v_purposetype_code VARCHAR2(255);
    v_loading_id NUMBER;
  BEGIN
    SELECT UTL_HELPERS.GET_PURPOSETYPE_CODE(P_FOLDER_NAME => p_folder_name, P_WORKFLOW_NAME => p_workflow_name)
      INTO v_purposetype_code
      FROM DUAL;

    CASE
      WHEN v_purposetype_code = 'ETL' THEN
        SELECT j.LOADING_ID
        INTO v_loading_id
        FROM LOG_JOB j
       WHERE JOB_ID = (
                      SELECT MAX(JOB_ID)
                        FROM LOG_JOB j_in
                       WHERE j_in.FOLDER_NAME    = p_folder_name
                         AND j_in.WORKFLOW_NAME  = p_workflow_name
                         AND j_in.WORKFLOWRUN_ID = p_workflowrun_id
                      );

      WHEN v_purposetype_code in ('CTL', 'REG') THEN
        SELECT MAX(LOADING_ID)
          INTO v_loading_id
          FROM LOG_LOADING
         WHERE FOLDER_NAME    = p_folder_name
           AND WORKFLOW_NAME  = p_workflow_name
           AND WORKFLOWRUN_ID = p_workflowrun_id;

      ELSE
        UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_bad',
          P_ERRMSG_TEXT => 'Неверное значение параметра PURPOSETYPE_CODE: ' || v_purposetype_code,
          P_PLSQLUNIT_NAME => 'API_HELPERS.GET_LOADING_ID',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => SQLERRM
        );
    END CASE;

    RETURN v_loading_id;

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT    => 'Системная ошибка',
           P_PLSQLUNIT_NAME => 'API_HELPERS.GET_LOADING_ID',
           P_SEVERITY_CODE  => 'S',
           P_SQLERRM_TEXT   => SQLERRM
         );
      END IF;
      RAISE;

  END;

  FUNCTION GET_REGLAMENTTYPE_CODE(
    p_folder_name VARCHAR2,
    p_workflow_name VARCHAR2,
    p_workflowrun_id NUMBER
  )
    RETURN VARCHAR2
  IS
    /*v_purposetype_code VARCHAR2(255);
  BEGIN
    SELECT UTL_HELPERS.GET_PURPOSETYPE_CODE(P_FOLDER_NAME => p_folder_name, P_WORKFLOW_NAME => p_workflow_name)
      INTO v_purposetype_code
      FROM DUAL;

    CASE
      WHEN v_purposetype_code = 'ETL'
      THEN NULL;

    END CASE;
    */
    BEGIN
        RETURN 'REGULAR_D';
  END;

    function CLOBREPLACE(
    p_INPUT      CLOB,
    p_PATTERN    VARCHAR2,
    p_SUBSTITUTE CLOB
  )
    return CLOB
   is
    FCLOB   CLOB := p_INPUT;
    FOFFSET INTEGER;
    FCHUNK  CLOB;
    begin
      if length(p_SUBSTITUTE) > 32000 then
        FOFFSET := 1;
        FCLOB := replace(FCLOB, p_PATTERN, '###CLOBREPLACE###');
        while FOFFSET <= length(p_SUBSTITUTE) loop
          FCHUNK := substr(p_SUBSTITUTE, FOFFSET, 32000) || '###CLOBREPLACE###';
          FCLOB := regexp_replace(FCLOB, '###CLOBREPLACE###', FCHUNK);
          FOFFSET := FOFFSET + 32000;
        end loop;
        FCLOB := regexp_replace(FCLOB, '###CLOBREPLACE###', '');
      else
        FCLOB := replace(FCLOB, p_PATTERN, p_SUBSTITUTE);
      end if;
      return FCLOB;
    end;




END API_HELPERS;
/