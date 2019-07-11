/* This object may not be sorted properly in the script due to cirular references. */
--
-- UTL_HELPERS  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.UTL_HELPERS AS

--  FUNCTION CHECK_PURPOSETYPE_BY_CODE(
--    p_purpose_type_code VARCHAR2) RETURN NUMBER;





  FUNCTION GET_EXCEPTION_CODE_BY_NAME(
    p_exception_name VARCHAR2
  )
    RETURN NUMBER;

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

  FUNCTION GET_PURPOSETYPE_CODE(
    p_folder_name   VARCHAR2,
    p_workflow_name VARCHAR2
  )
    RETURN VARCHAR2;


  FUNCTION GET_REGLAMENTTYPE_CODE(
    p_folder_name    VARCHAR2,
    p_workflow_name  VARCHAR2,
    p_workflowrun_id NUMBER
  )
    RETURN VARCHAR2;

/*
  FUNCTION CheckParameterIsNotNULL(p_param_value VARCHAR2)
    RETURN NUMBER;


  FUNCTION CheckParameterIsNotNULL(p_param_value NUMBER)
    RETURN NUMBER;


  FUNCTION CheckParameterIsNotNULL(p_param_value DATE)
    RETURN NUMBER;
*/

END UTL_HELPERS;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- UTL_HELPERS  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.UTL_HELPERS IS

--  FUNCTION CHECK_PURPOSETYPE_BY_CODE(p_purpose_type_code VARCHAR2)
--  RETURN NUMBER
--  IS
--    v_purpose_type_existence integer ;
--  BEGIN
--    SELECT CASE WHEN count(*) >= 1 THEN 1 ELSE 0 END AS p
--      INTO v_purpose_type_existence
--    FROM DCT_PURPOSETYPES d
--    where D.PURPOSETYPE_CODE = p_purpose_type_CODE;
--
--    RETURN v_purpose_type_existence;
--
--  END;

/*
  FUNCTION check_parameter_is_not_NULL(p_param_value VARCHAR2)
    RETURN BOOLEAN
  IS
  BEGIN
    IF p_param_value IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END;

  FUNCTION check_parameter_is_not_NULL(p_param_value NUMBER)
    RETURN BOOLEAN
  IS
  BEGIN
    IF p_param_value IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END;


  FUNCTION check_parameter_is_not_NULL(p_param_value DATE)
    RETURN BOOLEAN
  IS
  BEGIN
    IF p_param_value IS NULL THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
  END;


  FUNCTION check_parameter_is_NULL(p_param_value VARCHAR2)
    RETURN BOOLEAN
  IS
  BEGIN
    IF p_param_value IS NULL THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;

  FUNCTION check_parameter_is_NULL(p_param_value NUMBER)
    RETURN BOOLEAN
  IS
  BEGIN
    IF p_param_value IS NULL THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;


  FUNCTION check_parameter_is_NULL(p_param_value DATE)
    RETURN BOOLEAN
  IS
  BEGIN
    IF p_param_value IS NULL THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;
*/




  FUNCTION GET_EXCEPTION_CODE_BY_NAME(
    p_exception_name VARCHAR2
  )
    RETURN NUMBER
  IS
    v_exception_code NUMBER;
  BEGIN
    SELECT exception_code
      INTO v_exception_code
      FROM dct_exceptions
     WHERE exception_name = p_exception_name;

    RETURN v_exception_code;
  EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN -20999; -- e_complex_error
        WHEN TOO_MANY_ROWS THEN
            RETURN -20999; -- e_complex_error
  END;

  FUNCTION GET_JOB_ID(
    p_folder_name    VARCHAR2,
    p_workflow_name  VARCHAR2,
    p_workflowrun_id NUMBER
  )
    RETURN NUMBER
  IS
    v_job_id NUMBER;
  BEGIN
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

    RETURN v_job_id;

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT    => 'Системная ошибка',
           P_PLSQLUNIT_NAME => 'UTL_HELPERS.GET_JOB_ID',
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
    SELECT GET_PURPOSETYPE_CODE(P_FOLDER_NAME => p_folder_name, P_WORKFLOW_NAME => p_workflow_name)
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
          P_PLSQLUNIT_NAME => 'UTL_HELPERS.GET_LOADING_ID',
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
           P_PLSQLUNIT_NAME => 'UTL_HELPERS.GET_LOADING_ID',
           P_SEVERITY_CODE  => 'S',
           P_SQLERRM_TEXT   => SQLERRM
         );
      END IF;
      RAISE;
    
  END;




  FUNCTION GET_PURPOSETYPE_CODE(
    p_folder_name   VARCHAR2,
    p_workflow_name VARCHAR2
  )
    RETURN VARCHAR2
  IS
    v_purposetype_code VARCHAR2(255);
  BEGIN
  

        SELECT PURPOSETYPE_CODE
          INTO v_purposetype_code
          FROM MD_IPCOBJECTS
         WHERE FOLDER_NAME   = p_folder_name
           AND WORKFLOW_NAME = p_workflow_name;
   
 
    
    
    RETURN v_purposetype_code;
    
    EXCEPTION
    
    WHEN NO_DATA_FOUND
        THEN 
         UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_metadata_not_found',
          P_ERRMSG_TEXT => 'Таблица MD_IPCOBJECTS не заполнена для ' || p_workflow_name,
          P_PLSQLUNIT_NAME => 'UTL_HELPERS.GET_PURPOSETYPE_CODE',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => SQLERRM
        );
        RAISE;
    
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT    => 'Системная ошибка',
           P_PLSQLUNIT_NAME => 'UTL_HELPERS.GET_PURPOSETYPE_CODE',
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
    v_purposetype_code VARCHAR2(255);
  BEGIN
    SELECT GET_PURPOSETYPE_CODE(P_FOLDER_NAME => p_folder_name, P_WORKFLOW_NAME => p_workflow_name)
      INTO v_purposetype_code
      FROM DUAL;

    CASE
      WHEN v_purposetype_code = 'ETL'
      THEN NULL;

    END CASE;

  END;




END UTL_HELPERS;
/