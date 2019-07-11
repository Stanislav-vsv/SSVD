/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_ETL  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.API_ETL AS

  PROCEDURE INIT_JOB(
    /*
    Ќазначение:
      ѕроцедура предназначена дл€ регистрации исполнени€ функции ETL в журнале работы
        функциональных потоков в соответствии с правилами заполнени€ атрибутов.
      ¬ результате регистрации формируетс€ одна запись в журнале работы функциональных потоков  и
        генерируетс€ ID исполнени€ функции.
    “ип процедуры:
      API
     */
    p_folder_name    IN VARCHAR2, /* ѕараметр принимает значение папки IPC, в котором размещен поток реализующий функцию IPC */
    p_workflow_name  IN VARCHAR2, /* ѕараметр принимает значение потока IPC, который реализует функцию ETL*/
    p_workflowrun_id IN NUMBER, /* ѕараметр принимает значение идентификатора запуска потока, который определен в рамках исполнени€ процессов IPC */
    p_loading_id     IN NUMBER DEFAULT NULL /* ѕараметр принимает значение идентификатора ”правл€ющего потока, в рамках которого исполн€етс€ */
  );

  PROCEDURE COMPLETE_JOB(
    /*
    Ќазначение:
      ѕроцедура предназначена дл€ регистрации завершени€ исполнени€ функции ETL  в журнале работы
        фунциональных потоков в соответствии с правилами заполнени€ атрибутов.
      ¬ результате регистрации обновл€етс€ запись в журнале работы
     */
  p_job_id      IN NUMBER,  /* ѕараметр принимает значение идентификатора исполнени€ функции ETL */
  p_status_code IN VARCHAR2 /* ѕараметр принимает значение статуса завершени€, который определен в рамках испольнени€ процессов iPC */
  );

  PROCEDURE INIT_CTL(
    /*
    Ќазначение:
      ѕроцедура предназначена дл€ регистрации начала работы ”правл€ющего пототока
    “ип процедуры:
      API
    */
    p_folder_name    IN VARCHAR2, /* ѕараметр принимает значение папки IPC, в которой размещен ”правл€юший поток модул€ ETL*/
    p_workflow_name  IN VARCHAR, /* ѕараметр принимает значение ”правл€ющего потока модул€ ETL */
    p_workflowrun_id IN NUMBER, /* ѕараметр принимает значение идентификатора запуска потока, который определн в рамках испролнени€ процессов iPC */
    p_reg_loading_id IN NUMBER DEFAULT NULL /* ѕараметр принимает значение идентификатора –егламентного потока, в рамках которого исполн€етс€  */
  );

  PROCEDURE COMPLETE_CTL(
    /*
    Ќазначение:
      ѕроцедура предназначена дл€ регистрации завершени€ исполнени€ ”правл€ющего ѕотока модул€ ETL в журнале работы
        ”правл€ющих и регламентных потоков в соответствии с правилами заполнени€ атрибутов.
      ¬ результате регистрации обновл€етс€ запись в журнале работы управл€ющих и регламентных потоков
        дл€ заданного ID исполнени€ ”правл€ющего потока.
    “ип процедуры:
      ETL
     */
    p_loading_id  IN NUMBER, /* ѕараметр принимает значение идентификатора исполнени€ ”правл€ющего потока модул€ ETL */
    p_status_code IN VARCHAR2 /* ѕараметр принимает значение статуса завершени€, который определен в рамках исполнени€ процессов IPC */
  );


  PROCEDURE INIT_REG(
    /*
    Ќазначение:
      ѕроцедура предназначена дл€ регистрации начала работы –егламентного потока ETL
    “ип процедуры:
      API
     */
    p_folder_name    IN VARCHAR2, /* ѕараметр принимает значение папки IPC, в которой размещен –егламентный поток ETL */
    p_workflow_name  IN VARCHAR2, /* ѕараметр принимает значение –егламентного потока ETL */
    p_workflowrun_id IN NUMBER /* ѕараметр принимает значение идентификатора запуска потока, который определен в рамкхах исполнени€ процессов IPC */
  );



  PROCEDURE COMPLETE_REG(
    /*
    Ќазначение:
      ѕроцедура предназначена дл€ регистрации завершени€ исполнени€ –егламентного потока ETL в журнале
        работы управл€ющих и регламентных потоков в соответствии с правилами заполнени€ атрибутов.
      ¬ результате регистрации обновл€етс€ запись в журнале работы управл€ющих и регламентных потоков
        дл€ заданного ID исполнени€ –егламентного потока
     */
    p_reg_loading_id IN NUMBER, /* ѕараметр принимает значение идентификатора исполнени€ –егламентного потока ETL */
    p_status_code    IN VARCHAR2 /* ѕараметр принимает значение статуса завершени€, который определен в рамках исполнени€ процессов ETL */
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
    1.  онтроль параметров:
      a. ≈сли p_folder_name равен NULL,
    то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
      Х	p_exception_name = Тe_paramvalue_emptyТ
      Х	p_errmsg_text    = С«начение параметра P_FOLDER_NAME не может принимать значение NULLТ
      Х	p_plsqlunit_name = СAPI_ETL.INIT_JOBТ
      Х	p_severity_code  = СEТ
    */

    IF p_folder_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_folder_name не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.init_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	≈сли p_workflow_name равен NULL,
        то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_WORKFLOW_NAME не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.INIT_JOBТ
        Х	p_severity_code  = СEТ
    */
    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_workflow_name не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.init_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      c.	≈сли p_workflowrun_id равен NULL,
        то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_WORKFLOWRUN_ID не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.INIT_JOBТ
        Х	p_severity_code  = СEТ
    */

    IF p_workflowrun_id IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_workflowrun_id не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.init_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
     2.	ќпредел€етс€ значени€ <job_id> на основании следующего значени€ счетчика SEQ_JOB.
     */

    SELECT SEQ_JOB.nextval INTO v_job_id FROM DUAL;

    /*
     3.	ƒобавл€етс€ запись в таблицу LOG_JOB с установкой значений полей:
      Х	JOB_ID         = <job_id>
      Х	FOLDER_NAME    = p_folder_name
      Х	WORKFLOW_NAME  = p_workflow_name
      Х	WORKFLOWRUN_ID = p_workflowrun_id
      Х	LOADING_ID     = p_loading_id
      Х	START_DTTM     = SYSDATE
      Х	END_DTTM       = NULL
      Х	STATUS_CODE    = СRUNNINGТ
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
    4.	≈сли при исполнении процедуры возникли исключени€,
      то:
      a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_ETL.INIT_JOBТ
        Х	p_severity_code  = СSТ
        Х	p_sqlerrm_text   = SQLERRM
      b.	¬ызываетс€ системное исключение.
    */

  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '—истемна€ ошибка',
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
    1.	 онтроль параметров:
      a.	≈сли P_JOB_ID равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	P_EXCEPTION_NAME = Тe_paramvalue_emptyТ
        Х	P_ERRMSG_TEXT    = С«начение параметра P_JOB_ID не может принимать значение NULLТ
        Х	P_PLSQLUNIT_NAME = СAPI_ETL.COMPLETE_JOBТ
        Х	P_SEVERITY_CODE = СEТ
    */

    IF p_job_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_job_id не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	≈сли P_STATUS равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_STATUS не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.COMPLETE_JOBТ
        Х	p_severity_code  = СEТ
    */

    IF p_status_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_status_code не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_job',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;


    /*
    2.	ќбновл€етс€ запись в таблице LOG_JOB дл€ JOB_ID = P_JOB_ID с установкой значений полей:
      Х	END_DTTM    = SYSDATE
      Х	STATUS_CODE = p_status_code
    */

    UPDATE LOG_JOB
      SET END_DTTM    = SYSDATE,
          STATUS_CODE = p_status_code
    WHERE JOB_ID = p_job_id;

    COMMIT;

    /*
    3.	≈сли при исполнении процедуры возникли исключени€,
      a.	то: ≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_ETL.COMPLETE_JOBТ
        Х	p_severity_code  = СSТ
        Х	p_sqlerrm_text   = SQLERRM
      b.	¬ызываетс€ системное исключение.
     */

  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '—истемна€ ошибка',
         P_PLSQLUNIT_NAME => 'API_ETL.COMPLETE_JOB',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;




  PROCEDURE INIT_CTL(
    p_folder_name    IN VARCHAR2, /* ѕараметр принимает значение папки IPC, в которой размещен ”правл€юший поток модул€ ETL*/
    p_workflow_name  IN VARCHAR,  /* ѕараметр принимает значение ”правл€ющего потока модул€ ETL */
    p_workflowrun_id IN NUMBER,   /* ѕараметр принимает значение идентификатора запуска потока, который определен в рамках испролнени€ процессов iPC */
    p_reg_loading_id IN NUMBER DEFAULT NULL /* ѕараметр принимает значение идентификатора –егламентного потока, в рамках которого исполн€етс€  */
   )
  IS
    v_loading_id NUMBER;
  BEGIN
    /*
    1.  онтроль параметров:
      a.	≈сли p_folder_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_FOLDER_NAME не может принимать значение NULLТ
        Х	P_PLSQLUNIT_NAME = СAPI_ETL.INIT_CTLТ
        Х	P_SEVERITY_CODE  = СEТ
     */
    IF p_folder_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_folder_name не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_CTL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
        b. ≈сли p_workflow_name равен NULL,
        то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
          Х	p_exception_name = Тe_paramvalue_emptyТ
          Х	p_errmsg_text    = С«начение параметра P_WORKFLOW_NAME не может принимать значение NULLТ
          Х	p_plsqlunit_name = СAPI_ETL.INIT_CTLТ
          Х	p_severity_code  = СEТ
    */
    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_workflow_name не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_CTL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
        c.	≈сли p_workflowrun_id равен NULL,
        то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
          Х	p_exception_name = Тe_paramvalue_emptyТ
          Х	p_errmsg_text    = С«начение параметра P_WORKFLOWRUN_ID не может принимать значение NULLТ
          Х	p_plsqlunit_name = СAPI_ETL.INIT_CTLТ
          Х	p_severity_code  = СEТ
    */
    IF p_workflowrun_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_workflowrun_id не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_CTL',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	ќпредел€етс€ значени€ <loading_id> на основании следующего значени€ счетчика SEQ_JOB.
    */
    SELECT SEQ_JOB.nextval INTO v_loading_id FROM dual;

    /*
    3.	ƒобавл€етс€ запись в таблицу LOG_LOADING с установкой значений полей:
      Х	LOADING_ID     = <loading_id>
      Х	FOLDER_NAME    = p_folder_name
      Х	WORKFLOW_NAME  = p_workflow_name
      Х	WORKFLOWRUN_ID = p_workflowrun_id
      Х	REG_LOADING_ID = p_reg_loading_id
      Х	START_DTTM     = SYSDATE
      Х	END_DTTM       = NULL
      Х	STATUS_CODE    = СRUNNINGТ
    */
    INSERT INTO LOG_LOADING(LOADING_ID, FOLDER_NAME, WORKFLOW_NAME, WORKFLOWRUN_ID,
                            START_DTTM, END_DTTM, REG_LOADING_ID, STATUS_CODE)
      VALUES (v_loading_id, p_folder_name, p_workflow_name, p_workflowrun_id,
              SYSDATE, NULL, p_reg_loading_id, 'RUNNING');

    COMMIT;

   /*
    4. ≈сли при исполнении процедуры возникли исключени€,
    то:
      a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_ETL.INIT_CTLТ
        Х	p_severity_code  = СSТ
        Х	p_sqlerrm_text   = SQLERRM
      b.	¬ызываетс€ системное исключение.
    */
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '—истемна€ ошибка',
         P_PLSQLUNIT_NAME => 'API_ETL.INIT_CTL',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;

  PROCEDURE COMPLETE_CTL(
    p_loading_id  IN NUMBER, /* ѕараметр принимает значение идентификатора исполнени€ ”правл€ющего потока модул€ ETL */
    p_status_code IN VARCHAR2 /* ѕараметр принимает значение статуса завершени€, который определен в рамках исполнени€ процессов IPC */
  )
  IS
  BEGIN
    /*
    1.	 онтроль параметров:
      a.	≈сли P_LOADING_ID равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_LOADING_ID не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.COMPLETE_CTLТ
        Х	p_severity_code  = СEТ
    */

    IF p_loading_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_loading_id не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_ctl',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	≈сли P_STATUS равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_STATUS не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.COMPLETE_CTLТ
        Х	p_severity_code  = СEТ
    */

    IF p_status_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_status_code не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_ctl',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	ќбновл€етс€ запись в таблице LOG_LOADING дл€ LOADING_ID = P_LOADING_ID с установкой значений полей:
      Х	END_DTTM    = SYSDATE
      Х	STATUS_CODE = p_status_code
    */

    UPDATE LOG_LOADING
       SET STATUS_CODE = p_status_code,
           END_DTTM    = SYSDATE
     WHERE LOADING_ID = p_loading_id;

    COMMIT;


    /*
    3. ≈сли при исполнении процедуры  возникло исключение,
    то:
      a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_ETL.COMPLETE_CTLТ
        Х	p_severity_code  = СSТ
        Х	p_sqlerrm_text   = SQLERRM
      b.	¬ызываетс€ системное исключение.
    */
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '—истемна€ ошибка',
         P_PLSQLUNIT_NAME => 'API_ETL.COMPLETE_CTL',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;


  PROCEDURE INIT_REG(
    p_folder_name    IN VARCHAR2, /* ѕараметр принимает значение папки IPC, в которой размещен –егламентный поток ETL */
    p_workflow_name  IN VARCHAR2, /* ѕараметр принимает значение –егламентного потока ETL */
    p_workflowrun_id IN NUMBER /* ѕараметр принимает значение идентификатора запуска потока, который определен в рамкхах исполнени€ процессов IPC */
  )
  IS
    v_reg_loading_id NUMBER;
  BEGIN
    /*
    1.	 онтроль параметров:
      a.	≈сли p_folder_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_FOLDER_NAME не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.INIT_REGТ
        Х	p_severity_code  = СEТ
    */
    IF p_folder_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_folder_name не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_REG',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	≈сли p_workflow_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_WORKFLOW_NAME не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.INIT_REGТ
        Х	p_severity_code  = СEТ
    */
    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_workflow_name не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_REG',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      c.	≈сли p_workflowrun_id равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_WORKFLOWRUN_ID не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.INIT_REGТ
        Х	p_severity_code  = СEТ
    */
    IF p_workflowrun_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_workflowrun_id не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.INIT_REG',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	ќпредел€етс€ значени€ <loading_id> на основании следующего значени€ счетчика SEQ_JOB.
    */
    SELECT SEQ_JOB.nextval INTO v_reg_loading_id FROM dual;

    /*
    3.	ƒобавл€етс€ запись в таблицу LOG_LOADING с установкой значений полей:
      Х	LOADING_ID     = <loading_id>
      Х	FOLDER_NAME    = p_folder_name
      Х	WORKFLOW_NAME  = p_workflow_name
      Х	WORKFLOWRUN_ID = p_workflowrun_id
      Х	REG_LOADING_ID = NULL
      Х	START_DTTM     = SYSDATE
      Х	END_DTTM       = NULL
      Х	STATUS_CODE    = СRUNNINGТ
    */
    INSERT INTO LOG_LOADING(LOADING_ID, FOLDER_NAME, WORKFLOW_NAME, WORKFLOWRUN_ID,
                            START_DTTM, END_DTTM, REG_LOADING_ID, STATUS_CODE)
      VALUES (v_reg_loading_id, p_folder_name, p_workflow_name, p_workflowrun_id,
              SYSDATE, NULL, NULL, 'RUNNING');

    COMMIT;

  /*
  4. ≈сли при исполнении процедуры возникли исключени€,
  то:
    a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
    то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
      Х	p_exception_name = SQLCODE
      Х	p_errmsg_text    = С—истемна€ ошибкаТ
      Х	p_plsqlunit_name = СAPI_ETL.INIT_REGТ
      Х	p_severity_code  = СSТ
      Х	p_sqlerrm_text   = SQLERRM
    b.	¬ызываетс€ системное исключение.
  */
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '—истемна€ ошибка',
         P_PLSQLUNIT_NAME => 'API_ETL.INIT_REG',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;

  PROCEDURE COMPLETE_REG(
    p_reg_loading_id IN NUMBER, /* ѕараметр принимает значение идентификатора исполнени€ –егламентного потока ETL */
    p_status_code IN VARCHAR2/* ѕараметр принимает значение статуса завершени€, который определен в рамках исполнени€ процессов ETL */
  )
  IS
  BEGIN
    /*
    1.	 онтроль параметров:
      a.	≈сли P_REG_LOADING_ID равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        -	P_EXCEPTION_CODE = -20101
        -	P_ERRMSG_TEXT = С«начение параметра P_REG_LOADING_ID не может принимать значение NULLТ
        -	P_PLSQLUNIT_NAME = СAPI_ETL. COMPLETE_REGТ
        -	P_SEVERITY_CODE = СEТ
      b.	≈сли p_status_code равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        -	P_EXCEPTION_CODE = -20101
        -	P_ERRMSG_TEXT = С«начение параметра p_status_code не может принимать значение NULLТ
        -	P_PLSQLUNIT_NAME = СAPI_ETL. COMPLETE_REGТ
        -	P_SEVERITY_CODE = СEТ

    2.	ќбновл€етс€ запись в таблице LOG_LOADING дл€ LOADING_ID = P_REG_LOADING_ID с установкой значений полей:
      -	END_DTTM = SYSDATE
      -	STATUS = p_status_code
    3.	≈сли при исполнении процедуры не возникло исключений,
      то возвращаетс€ O_RES = 0
      иначе:
      -	вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
      -	P_EXCEPTION_CODE = SQLCODE
      -	P_ERRMSG_TEXT = С—истемна€ ошибкаТ
      -	P_PLSQLUNIT_NAME = СAPI_ETL. COMPLETE_REGТ
      -	P_SEVERITY_CODE = СWТ
      -	P_SQLERRM_TEXT = SQLERRM
      -	возвращаетс€ O_RES = SQLCODE
    */

    /*
    1.	 онтроль параметров:
      a.	≈сли P_REG_LOADING_ID равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_REG_LOADING_ID не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.COMPLETE_REGТ
        Х	p_severity_code  = СEТ
    */

    IF p_reg_loading_id IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_reg_loading_id не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_reg',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b. ≈сли P_STATUS равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_STATUS не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_ETL.COMPLETE_REGТ
        Х	p_severity_code  = СEТ
    */
    IF p_status_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_status_code не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_ETL.complete_reg',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2. ќбновл€етс€ запись в таблице LOG_LOADING дл€ LOADING_ID = P_REG_LOADING_ID с установкой значений полей:
      Х	END_DTTM    = SYSDATE
      Х	STATUS_CODE = p_status_code
    */

    UPDATE LOG_LOADING
       SET STATUS_CODE = p_status_code,
           END_DTTM    = SYSDATE
     WHERE LOADING_ID = p_reg_loading_id;

    COMMIT;

    /*
    3. ≈сли при исполнении процедуры возникли исключени€,
      то:
      a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_METADATA.INS_MD_IPCOBJECTSТ
        Х	p_severity_code  = СSТ
        Х	p_sqlerrm_text   = SQLERRM
      b.	¬ызываетс€ системное исключение.
    */
  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT    => '—истемна€ ошибка',
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