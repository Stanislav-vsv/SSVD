/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_ETL  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.API_ETL AS

  PROCEDURE INIT_JOB(
    /*
    ����������:
      ��������� ������������� ��� ����������� ���������� ������� ETL � ������� ������
        �������������� ������� � ������������ � ��������� ���������� ���������.
      � ���������� ����������� ����������� ���� ������ � ������� ������ �������������� �������  �
        ������������ ID ���������� �������.
    ��� ���������:
      API
     */
    p_folder_name    IN VARCHAR2, /* �������� ��������� �������� ����� IPC, � ������� �������� ����� ����������� ������� IPC */
    p_workflow_name  IN VARCHAR2, /* �������� ��������� �������� ������ IPC, ������� ��������� ������� ETL*/
    p_workflowrun_id IN NUMBER, /* �������� ��������� �������� �������������� ������� ������, ������� ��������� � ������ ���������� ��������� IPC */
    p_loading_id     IN NUMBER DEFAULT NULL /* �������� ��������� �������� �������������� ������������ ������, � ������ �������� ����������� */
  );

  PROCEDURE COMPLETE_JOB(
    /*
    ����������:
      ��������� ������������� ��� ����������� ���������� ���������� ������� ETL  � ������� ������
        ������������� ������� � ������������ � ��������� ���������� ���������.
      � ���������� ����������� ����������� ������ � ������� ������
     */
  p_job_id      IN NUMBER,  /* �������� ��������� �������� �������������� ���������� ������� ETL */
  p_status_code IN VARCHAR2 /* �������� ��������� �������� ������� ����������, ������� ��������� � ������ ����������� ��������� iPC */
  );

  PROCEDURE INIT_CTL(
    /*
    ����������:
      ��������� ������������� ��� ����������� ������ ������ ������������ ��������
    ��� ���������:
      API
    */
    p_folder_name    IN VARCHAR2, /* �������� ��������� �������� ����� IPC, � ������� �������� ����������� ����� ������ ETL*/
    p_workflow_name  IN VARCHAR, /* �������� ��������� �������� ������������ ������ ������ ETL */
    p_workflowrun_id IN NUMBER, /* �������� ��������� �������� �������������� ������� ������, ������� �������� � ������ ����������� ��������� iPC */
    p_reg_loading_id IN NUMBER DEFAULT NULL /* �������� ��������� �������� �������������� ������������� ������, � ������ �������� �����������  */
  );

  PROCEDURE COMPLETE_CTL(
    /*
    ����������:
      ��������� ������������� ��� ����������� ���������� ���������� ������������ ������ ������ ETL � ������� ������
        ����������� � ������������ ������� � ������������ � ��������� ���������� ���������.
      � ���������� ����������� ����������� ������ � ������� ������ ����������� � ������������ �������
        ��� ��������� ID ���������� ������������ ������.
    ��� ���������:
      ETL
     */
    p_loading_id  IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������������ ������ ������ ETL */
    p_status_code IN VARCHAR2 /* �������� ��������� �������� ������� ����������, ������� ��������� � ������ ���������� ��������� IPC */
  );


  PROCEDURE INIT_REG(
    /*
    ����������:
      ��������� ������������� ��� ����������� ������ ������ ������������� ������ ETL
    ��� ���������:
      API
     */
    p_folder_name    IN VARCHAR2, /* �������� ��������� �������� ����� IPC, � ������� �������� ������������ ����� ETL */
    p_workflow_name  IN VARCHAR2, /* �������� ��������� �������� ������������� ������ ETL */
    p_workflowrun_id IN NUMBER /* �������� ��������� �������� �������������� ������� ������, ������� ��������� � ������� ���������� ��������� IPC */
  );



  PROCEDURE COMPLETE_REG(
    /*
    ����������:
      ��������� ������������� ��� ����������� ���������� ���������� ������������� ������ ETL � �������
        ������ ����������� � ������������ ������� � ������������ � ��������� ���������� ���������.
      � ���������� ����������� ����������� ������ � ������� ������ ����������� � ������������ �������
        ��� ��������� ID ���������� ������������� ������
     */
    p_reg_loading_id IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������������� ������ ETL */
    p_status_code    IN VARCHAR2 /* �������� ��������� �������� ������� ����������, ������� ��������� � ������ ���������� ��������� ETL */
  );

  PROCEDURE GET_PARAM_VALUE(input_value IN VARCHAR2, output_value OUT VARCHAR2);

END API_ETL;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_ETL  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.API_ETL AS
  PROCEDURE INIT_JOB(
  p_folder_name    IN VARCHAR2,
  p_workflow_name  IN VARCHAR2,
  p_workflowrun_id IN NUMBER,
  p_loading_id     IN NUMBER DEFAULT NULL
  )
  IS
    v_job_id NUMBER;
    v_RunningJobFlag NUMBER;
  BEGIN
    /*
    1. �������� ����������:
      a. ���� p_folder_name ����� NULL,
    �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
      �	p_exception_name = �e_paramvalue_empty�
      �	p_errmsg_text    = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
      �	p_plsqlunit_name = �API_ETL.INIT_JOB�
      �	p_severity_code  = �E�
    */

    IF p_folder_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_folder_name �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.init_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.INIT_JOB�
        �	p_severity_code  = �E�
    */
    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_workflow_name �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.init_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      c.	���� p_workflowrun_id ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_WORKFLOWRUN_ID �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.INIT_JOB�
        �	p_severity_code  = �E�
    */

    IF p_workflowrun_id IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_workflowrun_id �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.init_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
     2.	������������ �������� <job_id> �� ��������� ���������� �������� �������� SEQ_JOB.
     */

    SELECT SEQ_JOB.nextval INTO v_job_id FROM DUAL;

    /*
     3.	����������� ������ � ������� LOG_JOB � ���������� �������� �����:
      �	JOB_ID         = <job_id>
      �	FOLDER_NAME    = p_folder_name
      �	WORKFLOW_NAME  = p_workflow_name
      �	WORKFLOWRUN_ID = p_workflowrun_id
      �	LOADING_ID     = p_loading_id
      �	START_DTTM     = SYSDATE
      �	END_DTTM       = NULL
      �	STATUS_CODE    = �RUNNING�
    */

    SELECT COUNT(*)
      INTO v_RunningJobFlag 
      FROM LOG_JOB 
     WHERE WORKFLOW_NAME = p_workflow_name 
       AND FOLDER_NAME = p_folder_name 
       AND end_dttm IS NULL;
       
    IF v_RunningJobFlag > 0 
    THEN 
      UPDATE LOG_JOB 
         SET status_code = 'FAILED', 
             end_dttm    = SYSDATE
       WHERE WORKFLOW_NAME = p_workflow_name 
         AND FOLDER_NAME = p_folder_name 
         AND end_dttm IS NULL;
    ELSE
      NULL;
    END IF;


    INSERT INTO LOG_JOB(JOB_ID, FOLDER_NAME, WORKFLOW_NAME, WORKFLOWRUN_ID,
                        LOADING_ID, START_DTTM, END_DTTM, STATUS_CODE)
      VALUES (v_job_id, p_folder_name, p_workflow_name, p_workflowrun_id,
              p_loading_id, SYSDATE, NULL, 'RUNNING');

    COMMIT;

    /*
    4.	���� ��� ���������� ��������� �������� ����������,
      ��:
      a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_ETL.INIT_JOB�
        �	p_severity_code  = �S�
        �	p_sqlerrm_text   = SQLERRM
      b.	���������� ��������� ����������.
    */

  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '��������� ������',
         P_PLSQLUNIT_NAME => 'API_ETL.INIT_JOB',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;


  PROCEDURE COMPLETE_JOB(
    p_job_id      IN NUMBER,
    p_status_code IN VARCHAR2
  )
  IS
  BEGIN
    /*
    1.	�������� ����������:
      a.	���� P_JOB_ID ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	P_EXCEPTION_NAME = �e_paramvalue_empty�
        �	P_ERRMSG_TEXT    = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
        �	P_PLSQLUNIT_NAME = �API_ETL.COMPLETE_JOB�
        �	P_SEVERITY_CODE = �E�
    */

    IF p_job_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_job_id �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	���� P_STATUS ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_STATUS �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.COMPLETE_JOB�
        �	p_severity_code  = �E�
    */

    IF p_status_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_status_code �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;


    /*
    2.	����������� ������ � ������� LOG_JOB ��� JOB_ID = P_JOB_ID � ���������� �������� �����:
      �	END_DTTM    = SYSDATE
      �	STATUS_CODE = p_status_code
    */

    UPDATE LOG_JOB
      SET END_DTTM    = SYSDATE,
          STATUS_CODE = p_status_code
    WHERE JOB_ID = p_job_id;

    COMMIT;

    /*
    3.	���� ��� ���������� ��������� �������� ����������,
      a.	��: ���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_ETL.COMPLETE_JOB�
        �	p_severity_code  = �S�
        �	p_sqlerrm_text   = SQLERRM
      b.	���������� ��������� ����������.
     */

  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '��������� ������',
         P_PLSQLUNIT_NAME => 'API_ETL.COMPLETE_JOB',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;




  PROCEDURE INIT_CTL(
    p_folder_name    IN VARCHAR2, /* �������� ��������� �������� ����� IPC, � ������� �������� ����������� ����� ������ ETL*/
    p_workflow_name  IN VARCHAR,  /* �������� ��������� �������� ������������ ������ ������ ETL */
    p_workflowrun_id IN NUMBER,   /* �������� ��������� �������� �������������� ������� ������, ������� ��������� � ������ ����������� ��������� iPC */
    p_reg_loading_id IN NUMBER DEFAULT NULL /* �������� ��������� �������� �������������� ������������� ������, � ������ �������� �����������  */
   )
  IS
    v_loading_id NUMBER;
  BEGIN
    /*
    1. �������� ����������:
      a.	���� p_folder_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        �	P_PLSQLUNIT_NAME = �API_ETL.INIT_CTL�
        �	P_SEVERITY_CODE  = �E�
     */
    IF p_folder_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_folder_name �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_CTL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
        b. ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
          �	p_exception_name = �e_paramvalue_empty�
          �	p_errmsg_text    = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
          �	p_plsqlunit_name = �API_ETL.INIT_CTL�
          �	p_severity_code  = �E�
    */
    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_workflow_name �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_CTL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
        c.	���� p_workflowrun_id ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
          �	p_exception_name = �e_paramvalue_empty�
          �	p_errmsg_text    = ��������� ��������� P_WORKFLOWRUN_ID �� ����� ��������� �������� NULL�
          �	p_plsqlunit_name = �API_ETL.INIT_CTL�
          �	p_severity_code  = �E�
    */
    IF p_workflowrun_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_workflowrun_id �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_CTL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	������������ �������� <loading_id> �� ��������� ���������� �������� �������� SEQ_JOB.
    */
    SELECT SEQ_JOB.nextval INTO v_loading_id FROM dual;

    /*
    3.	����������� ������ � ������� LOG_LOADING � ���������� �������� �����:
      �	LOADING_ID     = <loading_id>
      �	FOLDER_NAME    = p_folder_name
      �	WORKFLOW_NAME  = p_workflow_name
      �	WORKFLOWRUN_ID = p_workflowrun_id
      �	REG_LOADING_ID = p_reg_loading_id
      �	START_DTTM     = SYSDATE
      �	END_DTTM       = NULL
      �	STATUS_CODE    = �RUNNING�
    */
    INSERT INTO LOG_LOADING(LOADING_ID, FOLDER_NAME, WORKFLOW_NAME, WORKFLOWRUN_ID,
                            START_DTTM, END_DTTM, REG_LOADING_ID, STATUS_CODE)
      VALUES (v_loading_id, p_folder_name, p_workflow_name, p_workflowrun_id,
              SYSDATE, NULL, p_reg_loading_id, 'RUNNING');

    COMMIT;

   /*
    4. ���� ��� ���������� ��������� �������� ����������,
    ��:
      a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_ETL.INIT_CTL�
        �	p_severity_code  = �S�
        �	p_sqlerrm_text   = SQLERRM
      b.	���������� ��������� ����������.
    */
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '��������� ������',
         P_PLSQLUNIT_NAME => 'API_ETL.INIT_CTL',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;

  PROCEDURE COMPLETE_CTL(
    p_loading_id  IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������������ ������ ������ ETL */
    p_status_code IN VARCHAR2 /* �������� ��������� �������� ������� ����������, ������� ��������� � ������ ���������� ��������� IPC */
  )
  IS
  BEGIN
    /*
    1.	�������� ����������:
      a.	���� P_LOADING_ID ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_LOADING_ID �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.COMPLETE_CTL�
        �	p_severity_code  = �E�
    */

    IF p_loading_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_loading_id �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_ctl',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	���� P_STATUS ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_STATUS �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.COMPLETE_CTL�
        �	p_severity_code  = �E�
    */

    IF p_status_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_status_code �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_ctl',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	����������� ������ � ������� LOG_LOADING ��� LOADING_ID = P_LOADING_ID � ���������� �������� �����:
      �	END_DTTM    = SYSDATE
      �	STATUS_CODE = p_status_code
    */

    UPDATE LOG_LOADING
       SET STATUS_CODE = p_status_code,
           END_DTTM    = SYSDATE
     WHERE LOADING_ID = p_loading_id;

    COMMIT;


    /*
    3. ���� ��� ���������� ���������  �������� ����������,
    ��:
      a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_ETL.COMPLETE_CTL�
        �	p_severity_code  = �S�
        �	p_sqlerrm_text   = SQLERRM
      b.	���������� ��������� ����������.
    */
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '��������� ������',
         P_PLSQLUNIT_NAME => 'API_ETL.COMPLETE_CTL',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;


  PROCEDURE INIT_REG(
    p_folder_name    IN VARCHAR2, /* �������� ��������� �������� ����� IPC, � ������� �������� ������������ ����� ETL */
    p_workflow_name  IN VARCHAR2, /* �������� ��������� �������� ������������� ������ ETL */
    p_workflowrun_id IN NUMBER /* �������� ��������� �������� �������������� ������� ������, ������� ��������� � ������� ���������� ��������� IPC */
  )
  IS
    v_reg_loading_id NUMBER;
  BEGIN
    /*
    1.	�������� ����������:
      a.	���� p_folder_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.INIT_REG�
        �	p_severity_code  = �E�
    */
    IF p_folder_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_folder_name �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_REG',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	���� p_workflow_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.INIT_REG�
        �	p_severity_code  = �E�
    */
    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_workflow_name �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_REG',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      c.	���� p_workflowrun_id ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_WORKFLOWRUN_ID �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.INIT_REG�
        �	p_severity_code  = �E�
    */
    IF p_workflowrun_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_workflowrun_id �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_REG',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	������������ �������� <loading_id> �� ��������� ���������� �������� �������� SEQ_JOB.
    */
    SELECT SEQ_JOB.nextval INTO v_reg_loading_id FROM dual;

    /*
    3.	����������� ������ � ������� LOG_LOADING � ���������� �������� �����:
      �	LOADING_ID     = <loading_id>
      �	FOLDER_NAME    = p_folder_name
      �	WORKFLOW_NAME  = p_workflow_name
      �	WORKFLOWRUN_ID = p_workflowrun_id
      �	REG_LOADING_ID = NULL
      �	START_DTTM     = SYSDATE
      �	END_DTTM       = NULL
      �	STATUS_CODE    = �RUNNING�
    */
    INSERT INTO LOG_LOADING(LOADING_ID, FOLDER_NAME, WORKFLOW_NAME, WORKFLOWRUN_ID,
                            START_DTTM, END_DTTM, REG_LOADING_ID, STATUS_CODE)
      VALUES (v_reg_loading_id, p_folder_name, p_workflow_name, p_workflowrun_id,
              SYSDATE, NULL, NULL, 'RUNNING');

    COMMIT;

  /*
  4. ���� ��� ���������� ��������� �������� ����������,
  ��:
    a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
    �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
      �	p_exception_name = SQLCODE
      �	p_errmsg_text    = ���������� �������
      �	p_plsqlunit_name = �API_ETL.INIT_REG�
      �	p_severity_code  = �S�
      �	p_sqlerrm_text   = SQLERRM
    b.	���������� ��������� ����������.
  */
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '��������� ������',
         P_PLSQLUNIT_NAME => 'API_ETL.INIT_REG',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;

  PROCEDURE COMPLETE_REG(
    p_reg_loading_id IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������������� ������ ETL */
    p_status_code IN VARCHAR2/* �������� ��������� �������� ������� ����������, ������� ��������� � ������ ���������� ��������� ETL */
  )
  IS
  BEGIN
    /*
    1.	�������� ����������:
      a.	���� P_REG_LOADING_ID ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        -	P_EXCEPTION_CODE = -20101
        -	P_ERRMSG_TEXT = ��������� ��������� P_REG_LOADING_ID �� ����� ��������� �������� NULL�
        -	P_PLSQLUNIT_NAME = �API_ETL. COMPLETE_REG�
        -	P_SEVERITY_CODE = �E�
      b.	���� p_status_code ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        -	P_EXCEPTION_CODE = -20101
        -	P_ERRMSG_TEXT = ��������� ��������� p_status_code �� ����� ��������� �������� NULL�
        -	P_PLSQLUNIT_NAME = �API_ETL. COMPLETE_REG�
        -	P_SEVERITY_CODE = �E�

    2.	����������� ������ � ������� LOG_LOADING ��� LOADING_ID = P_REG_LOADING_ID � ���������� �������� �����:
      -	END_DTTM = SYSDATE
      -	STATUS = p_status_code
    3.	���� ��� ���������� ��������� �� �������� ����������,
      �� ������������ O_RES = 0
      �����:
      -	���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
      -	P_EXCEPTION_CODE = SQLCODE
      -	P_ERRMSG_TEXT = ���������� �������
      -	P_PLSQLUNIT_NAME = �API_ETL. COMPLETE_REG�
      -	P_SEVERITY_CODE = �W�
      -	P_SQLERRM_TEXT = SQLERRM
      -	������������ O_RES = SQLCODE
    */

    /*
    1.	�������� ����������:
      a.	���� P_REG_LOADING_ID ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_REG_LOADING_ID �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.COMPLETE_REG�
        �	p_severity_code  = �E�
    */

    IF p_reg_loading_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_reg_loading_id �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_reg',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b. ���� P_STATUS ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_STATUS �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_ETL.COMPLETE_REG�
        �	p_severity_code  = �E�
    */
    IF p_status_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_status_code �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_reg',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2. ����������� ������ � ������� LOG_LOADING ��� LOADING_ID = P_REG_LOADING_ID � ���������� �������� �����:
      �	END_DTTM    = SYSDATE
      �	STATUS_CODE = p_status_code
    */

    UPDATE LOG_LOADING
       SET STATUS_CODE = p_status_code,
           END_DTTM    = SYSDATE
     WHERE LOADING_ID = p_reg_loading_id;

    COMMIT;

    /*
    3. ���� ��� ���������� ��������� �������� ����������,
      ��:
      a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_METADATA.INS_MD_IPCOBJECTS�
        �	p_severity_code  = �S�
        �	p_sqlerrm_text   = SQLERRM
      b.	���������� ��������� ����������.
    */
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '��������� ������',
         P_PLSQLUNIT_NAME => 'API_ETL.complete_reg',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;

  PROCEDURE GET_PARAM_VALUE(input_value IN VARCHAR2, output_value OUT VARCHAR2)
  IS
    v_output VARCHAR2(4000);
    v_sql VARCHAR2(4000);
    BEGIN
      v_sql := 'select (' ||input_value ||') as a  from dual';
      --dbms_output.put_line(v_sql);
      EXECUTE IMMEDIATE v_sql into v_output;
      output_value := v_output;

  END;

END API_ETL;
/