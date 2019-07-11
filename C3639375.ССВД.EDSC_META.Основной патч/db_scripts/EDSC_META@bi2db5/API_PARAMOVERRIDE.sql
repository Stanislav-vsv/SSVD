/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_PARAMOVERRIDE  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.API_PARAMOVERRIDE
IS

  PROCEDURE INS_USR_PARAMOVERRIDES(
    p_reg_folder_name IN VARCHAR2,
    p_reg_workflow_name IN VARCHAR2,
    p_folder_name IN VARCHAR2,
    p_workflow_name IN VARCHAR2,
    p_param_name IN VARCHAR2,
    p_param_value IN VARCHAR2,
    p_ipcobjtype_code IN VARCHAR2,
    p_ipcobject_name IN VARCHAR2 DEFAULT NULL,
    p_cycle_order_no IN NUMBER DEFAULT 0,
    p_cycle_status IN VARCHAR2 DEFAULT 'N/A',
    p_cycle_loading_id IN NUMBER DEFAULT NULL,
    p_reg_loading_id IN NUMBER DEFAULT NULL,
    p_loading_id IN NUMBER DEFAULT NULL,
    p_job_id IN NUMBER DEFAULT NULL
    );

  PROCEDURE UPD_USR_PARAMOVERRIDES(
    p_reg_folder_name IN VARCHAR2,
    p_reg_workflow_name IN VARCHAR2,
    p_folder_name IN VARCHAR2,
    p_workflow_name IN VARCHAR2,
    p_reg_loading_id IN NUMBER DEFAULT NULL,
    p_loading_ind IN NUMBER DEFAULT NULL,
    p_job_id IN NUMBER DEFAULT NULL,
    p_cycle_loading_id IN NUMBER DEFAULT NULL
  );

END API_PARAMOVERRIDE;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_PARAMOVERRIDE  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.API_PARAMOVERRIDE
IS

  PROCEDURE INS_USR_PARAMOVERRIDES(
    p_reg_folder_name IN VARCHAR2,
    p_reg_workflow_name IN VARCHAR2,
    p_folder_name IN VARCHAR2,
    p_workflow_name IN VARCHAR2,
    p_param_name IN VARCHAR2,
    p_param_value IN VARCHAR2,
    p_ipcobjtype_code IN VARCHAR2,
    p_ipcobject_name IN VARCHAR2 DEFAULT NULL,
    p_cycle_order_no IN NUMBER DEFAULT 0,
    p_cycle_status IN VARCHAR2 DEFAULT 'N/A',
    p_cycle_loading_id IN NUMBER DEFAULT NULL,
    p_reg_loading_id IN NUMBER DEFAULT NULL,
    p_loading_id IN NUMBER DEFAULT NULL,
    p_job_id IN NUMBER DEFAULT NULL
    )
  IS
  BEGIN

    /* 1.  онтроль параметров */

    IF p_folder_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT => '«начение параметра p_folder_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_PARAMOVERRIDE.INS_USR_PARAMOVERRIDES',
        P_SEVERITY_CODE => 'E',
        P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT => '«начение параметра p_workflow_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_PARAMOVERRIDE.INS_USR_PARAMOVERRIDES',
        P_SEVERITY_CODE => 'E',
        P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_param_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT => '«начение параметра p_param_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_PARAMOVERRIDE.INS_USR_PARAMOVERRIDES',
        P_SEVERITY_CODE => 'E',
        P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_ipcobjtype_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT => '«начение параметра p_ipcobjtype_code не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_PARAMOVERRIDE.INS_USR_PARAMOVERRIDES',
        P_SEVERITY_CODE => 'E',
        P_SQLERRM_TEXT => NULL
      );
    END IF;


    INSERT INTO USR_PARAMOVERRIDES(REG_LOADING_ID, LOADING_ID, JOB_ID, IPCOBJTYPE_CODE, IPCOBJECT_NAME,
                                   REG_FOLDER_NAME, REG_WORKFLOW_NAME, FOLDER_NAME, WORKFLOW_NAME, PARAM_NAME,
                                   PARAM_VALUE, CYCLE_LOADING_ID, CYCLE_ORDER_NO, CYCLE_STATUS)
      VALUES (p_reg_loading_id, p_loading_id, p_job_id, p_ipcobjtype_code, p_ipcobject_name,
              p_reg_folder_name, p_reg_workflow_name, p_folder_name, p_workflow_name, p_param_name,
              p_param_value, p_cycle_loading_id, p_cycle_order_no, p_cycle_status);

    COMMIT;
  END;




  PROCEDURE UPD_USR_PARAMOVERRIDES(
    p_reg_folder_name IN VARCHAR2,
    p_reg_workflow_name IN VARCHAR2,
    p_folder_name IN VARCHAR2,
    p_workflow_name IN VARCHAR2,
    p_reg_loading_id IN NUMBER DEFAULT NULL,
    p_loading_ind IN NUMBER DEFAULT NULL,
    p_job_id IN NUMBER DEFAULT NULL,
    p_cycle_loading_id IN NUMBER DEFAULT NULL
  )
  IS
  BEGIN
    NULL;
  END;

END API_PARAMOVERRIDE;
/