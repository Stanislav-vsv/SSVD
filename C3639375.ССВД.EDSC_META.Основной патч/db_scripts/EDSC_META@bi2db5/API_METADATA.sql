/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_METADATA  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.API_METADATA  AS

  PROCEDURE UPSERT_MD_IPCOBJECTS(
    /*
    Ќазначение:
      ѕроцедура предназначена дл€ изменени€ регистрации потоков IPC в метаданных ѕродукта
      ¬ результате изменени€ добавл€етс€ или обновл€етс€ одна запись в таблице объектов IPC
    “ип процедуры:
      API
    */
    p_folder_name      IN VARCHAR2, /* ѕараметр принимает значение имени папки IPC, в которой размещаетс€ объект IPC*/
    p_workflow_name    IN VARCHAR2, /* ѕараметр принимает значение имени потока IPC */
    p_purposetype_code IN VARCHAR2, /* ѕараметр принимает значение типа функционального назначени€ потока IPC*/
    p_ipcobject_desc   IN VARCHAR2 DEFAULT NULL, /* «начением параметра может быть определено описание потока IPC*/
    p_patch_code       IN VARCHAR2 DEFAULT NULL  /* «начением параметра определ€етс€ номер патча, в котором внос€тс€ изменени€. */
   );

  PROCEDURE DEL_MD_IPCOBJECTS(
    /*
    Ќазначение:
      ѕроцедура предназначена дл€ выполнени€ логического удалени€ потоков IPC в метаданных ѕродукта.
      Ћогически удаленный поток не может использоватьс€ дл€ запуска в рамках потоков WF_RUN_ANY_ETL,
      ƒл€ него не могут быть определены пользовательские значени€ параметров.
      ¬ результате логического обновлени€ обновл€етс€ атрибут ACTIVE_FLAG дл€ записи в таблице объектов IPC
      по ключу
    “ип процедуры:
      API
    */
    p_folder_name   IN VARCHAR2, /* ѕараметр принимает значение папки IPC, в которой размещаетс€ объект IPC */
    p_workflow_name IN VARCHAR2, /* ѕараметр принимает значение имени потока IPC */
    p_patch_code    IN VARCHAR2 DEFAULT NULL  /* «начением параметра определ€етс€ номер патча, в котором внос€тс€ изменени€. */
  );

  PROCEDURE UPSERT_MD_PARAMETERS(
    /*
    Ќазначение:
        ѕроцедура предназначена дл€ изменени€ (добавлени€ или обновлени€) регистрации параметра в метаданных ѕродукта.
        ¬ результате изменени€ добавл€етс€ или обновл€етс€ одна запись в таблице параметров.

    “ип процедуры:
        API
    */
    p_param_name    IN VARCHAR2, /* ѕараметр принимает  значение имени параметра в метаданных продукта */
    p_param_desc    IN VARCHAR2, /* ѕараметр принимает значение описани€ параметра */
    p_datatype_code IN VARCHAR2, /* ѕараметр принимает значение типа данных параметра */
    p_patch_code    IN VARCHAR2 DEFAULT NULL  /* Ќомер патча */
  );

  PROCEDURE DEL_MD_PARAMETERS(
    /*
        Ќазначение:
            ѕроцедура предназначена дл€ выполнени€ логического удалени€ параметров в метаданных ѕродукта. Ћогически удаленный параметр не может использоватьс€ при генерации значений параметров и дл€ него не могут быть определены пользовательские значени€ параметров.
            ¬ результате логического удалени€ обновл€етс€ атрибут ACTIVE_FLAG дл€ записи в таблице параметров по ключу.

        “ип процедуры:
            API
    */
    p_param_name IN VARCHAR2, /* ѕараметр принимает значение имени параметра, используемого в потоках IPC */
    p_patch_code IN VARCHAR2 DEFAULT NULL   /* Ќомер патча */
  );

  /*
    Ќазначение:
      ѕроцедура предназначена дл€ изменени€ (добавлени€ или обновлени€) назначени€ параметров oбъектам IPC и правила вычислени€ его значени€ в зависимости от режима и регламента загрузки данных.
      ¬ результате исполнени€ регистрации формируетс€ одна запись в таблице параметров.
    “ип процедуры:
      API
  */
  PROCEDURE UPSERT_MD_IPCOBJPARAMS (
      p_folder_name         IN VARCHAR2 /* ѕараметр принимает значение имени параметра, используемого в потоках IPC. */
    , p_workflow_name       IN VARCHAR2 /* ѕараметр принимает значение описание параметра. */
    , p_ipcobjtype_code     IN VARCHAR2 DEFAULT 'WORKFLOW' /* ѕараметр принимает значение тип объекта IPC, на основании которого формируетс€ секци€ файла параметров.*/
    , p_ipcobject_name      IN VARCHAR2 DEFAULT NULL /* ѕараметр принимает значение физическое им€ объекта IPC, дл€ которого определ€етс€ правила формировани€ значени€ параметра.*/
    , p_param_name          IN VARCHAR2 /* ”казываетс€ им€ параметра, дл€ которого определ€етс€ правило вычислени€ значени€.*/
    , p_loadingmode_code    IN VARCHAR2 DEFAULT 'INCREMENT' /* ѕараметр принимает значение режима загрузки, дл€ которого определ€етс€ правило вычислени€ значени€. */
    , p_reglamenttype_code  IN VARCHAR2 DEFAULT 'REGULAR_D' /* ѕараметр принимает значение типа регламента загрузки, дл€ которого определ€етс€ правило вычислени€ значени€.*/
    , p_paramvaluetype_code IN VARCHAR2 /* ”казываетс€ тип значени€ параметра в соответствии с системным словарем DCT_PARAMVALUETYPES. */
    , p_param_value         IN VARCHAR2 /* ”казываетс€ значение параметра или правило его вычислени€ в зависимости от указанного типа значени€.*/
    , p_logging_flag        IN VARCHAR2 DEFAULT 'Y' /* ”казываетс€ логический признак (Y|N), который определ€ет необходимость логировани€ вычисленного значени€ в журнале LOG_PARAMPREVVALUE. */
    , p_patch_code          IN VARCHAR2 DEFAULT NULL /* «начением параметра определ€етс€ номер патча, в котором внос€тс€ изменени€.*/
  );


  PROCEDURE UPSERT_MD_TABLES(
    /*
    ѕроцедура изменени€ метаданных дл€ таблиц ¬итрины
    Ќазначение:
      ѕроцедура предназначена дл€ изменени€ (добавлени€ или обновлени€) регистрации таблиц ¬итрин в метаданных ѕродукта
      ¬ результате изменени€ добавл€етс€ или обновл€етс€ одна запись в регистрации таблиц ¬итрины.
    “ип процедуры: API
    */

    p_schema_name IN VARCHAR2, /* ѕараметр принимает значение имени схемы ¬итрины, в которой размещена таблица*/
    p_table_name IN VARCHAR2, /* ѕараметр принимает значение SQL-имени таблицы ¬итрины */
    p_table_desc IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение описани€ таблицы ¬итрины */
    p_patch_code IN VARCHAR2 DEFAULT NULL /* «начением параметра определ€етс€ номер патча, в котором внос€тс€ изменени€.*/
  );

  PROCEDURE REMOVE_MD_TABLES(
    /*
    ѕроцедура физического удалени€ метаданных дл€ таблицы ¬итрины
    Ќазначение:
      ѕроцедура предназначена дл€ удалени€ регистрации таблиц ¬итрин в метаданных продукта
      ¬ результате изменени€ добавл€етс€ или обновл€етс€ одна запись в реестре атрибутов таблиц ¬итрины
    “ип процедуры:
      API
    */
    p_schema_name IN VARCHAR2, /* ѕараметр принимает значение имени схемы ¬итрины, в которой размешена таблица */
    p_table_name  IN VARCHAR2 /* ѕараметр принимает значение SQL-имени таблицы ¬итрины */
  );

  PROCEDURE UPSERT_MD_COLUMNS(
    /*
    ѕроцедура изменений метаданных дл€ атрибута таблиц ¬итрины
    Ќазначение:
      ѕроцедура предназначена дл€ изменени€(добавлени€ или обновлени€) регистрации атрибута таблиц ¬итрины в метаданных ѕродукта
      ¬ результате изменени€ добавл€етс€ или обновл€етс€ запись в јтрибутах таблиц ¬итрины
    */
    p_schema_name        IN VARCHAR2, /* ѕараметр принимает значение SQL-имени схемы ¬итрины, в которой размещена таблица */
    p_table_name         IN VARCHAR2,  /* ѕараметр принимает значение SQL-имени таблицы ¬итрины. */
    p_column_name        IN VARCHAR2, /* ѕараметр принимает значение SQL-имени добавл€емого/измен€емого пол€ таблицы. */
    p_deletedkey_flag    IN VARCHAR2, /* ѕараметр принимает значение дл€ определени€ флага пол€ дл€ определени€ ключа дл€ удалени€ */
    p_nvl_flag           IN VARCHAR2, /* ѕараметр принимает значение дл€ определени€ флага пол€ дл€ определени€ обработки необ€зательных полей функции NVL */
    p_columntype_code    IN VARCHAR2,
    p_default_value      IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение по умолчанию, определенное дл€ атрибута таблицы, которое используетс€ при обработке NVL*/
    p_ref_scheme_name    IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение SQL-имени схемы, в которой размешена таблица, на которую ссылаетс€ атрибут */
    p_ref_table_name     IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение SQL-имени таблицы, на которую ссылаетс€ атрибут */
    p_ref_expression_sql IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение SQL-выражение, значени€ которого €вд€ютс€ исходными натуральными ключами дл€ заполнени€ пол€ DM*_STG.KEYBRIDGE.CODE */
    p_insnewkey_flag     IN VARCHAR2 DEFAULT NULL, /* ‘лаг, который определ€ет, что по значени€м натурального ключа ссылочного атрибута требуетс€ генераци€ суррогатных ключей DK */
    p_patch_code         IN NUMBER DEFAULT NULL /* ѕараметр принимает значение идентификатора ”правл€ющего потока, в рамках которого исполн€етс€. */
  );

END API_METADATA;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_METADATA  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.API_METADATA  AS

    /* ѕроцедуры управлени€ метаданными объектов IPC */

  PROCEDURE UPSERT_MD_IPCOBJECTS(
    p_folder_name       IN VARCHAR2, /* ѕараметр принимает значение имени папки IPC, в которой размещаетс€ объект IPC*/
    p_workflow_name     IN VARCHAR2, /* ѕараметр принимает значение имени потока IPC */
    p_purposetype_code  IN VARCHAR2, /* ѕараметр принимает значение типа функционального назначени€ потока IPC*/
    p_ipcobject_desc    IN VARCHAR2 DEFAULT NULL, /* «начением параметра может быть определено описание потока IPC*/
    p_patch_code        IN VARCHAR2
)
  IS
    v_check_flag NUMBER;
  BEGIN

    /*
    1.	 онтроль параметров:
      a.	≈сли p_folder_name равен NULL,
        то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_FOLDER_NAME не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_IPCOBJECTSТ
        Х	p_severity_code  = СEТ
    */
    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра P_FOLDER_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	≈сли p_workflow_name равен NULL,
        то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_WORKFLOW_NAME не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_IPCOBJECTSТ
        Х	p_severity_code  = СEТ
    */

    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра P_WORKFLOW_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;


    /*
      c.	≈сли p_purposetype_code равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_PURPOSETYPE_CODE не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_IPCOBJECTSТ
        Х	p_severity_code  = СEТ
    */

    IF p_purposetype_code IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '«начение параметра P_PURPOSETYPE_CODE не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
        P_SEVERITY_CODE  => 'E'
      );
    END IF;


    /*
    2.	≈сли найдена запись в таблице MD_IPCOBJECTS, у которой:
      Х	FOLDER_NAME   = p_folder_name
      Х	WORKFLOW_NAME = p_workflow_name
        то обновл€етс€ найденна€ запись в таблице MD_IPCOBJECTS с установкой значений полей:
        Х	PURPOSETYPE_CODE = p_purposetype_code
        Х	IPCOBJECT_DESC   = p_ipcobject_desc
        Х	CHANGE_DATE      = SYSDATE
        Х	PATCH_CODE       = p_patch_code
      иначе добавл€етс€ запись в таблицу MD_IPCOBJECTS со значени€ми полей:
        Х	FOLDER_NAME      = p_folder_name
        Х	WORKFLOW_NAME    = p_workflow_name
        Х	PURPOSETYPE_CODE = p_purposetype_code
        Х	IPCOBJECT_DESC   = p_ipcobject_desc
        Х	ACTIVE_FLAG      = СYТ
        Х	CHANGE_DATE      = SYSDATE
        Х	PATCH_CODE       = p_patch_code
    */
    BEGIN
      SELECT 1
        INTO v_check_flag
        FROM MD_IPCOBJECTS
       WHERE FOLDER_NAME   = p_folder_name
         AND WORKFLOW_NAME = p_workflow_name;
      EXCEPTION
        WHEN NO_DATA_FOUND
        THEN v_check_flag := 0;
    END;

    v_check_flag := nvl(v_check_flag, 0);

    IF v_check_flag = 1 THEN
      UPDATE MD_IPCOBJECTS
         SET PURPOSETYPE_CODE = nvl(p_purposetype_code, PURPOSETYPE_CODE),
             IPCOBJECT_DESC   = nvl(p_ipcobject_desc, IPCOBJECT_DESC),
             CHANGE_DATE      = SYSDATE,
             PATCH_CODE       = nvl(p_patch_code, PATCH_CODE)
       WHERE FOLDER_NAME    = p_folder_name
         AND WORKFLOW_NAME  = p_workflow_name;

    ELSIF v_check_flag = 0 THEN

      INSERT INTO md_ipcobjects (
               FOLDER_NAME, WORKFLOW_NAME, PURPOSETYPE_CODE, IPCOBJECT_DESC,
               ACTIVE_FLAG, CHANGE_DATE, PATCH_CODE
               )
        VALUES (
               p_folder_name, p_workflow_name, p_purposetype_code, p_ipcobject_desc,
               'Y', SYSDATE, p_patch_code
               );
    END IF;

    /*
    3. ¬ыполн€етс€ подтверждение транзакции Ѕƒ
    */
    COMMIT;

    /*
    4.	≈сли при исполнении процедуры возникли исключени€,
      то:
      a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_IPCOBJECTSТ
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
         P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;

  PROCEDURE DEL_MD_IPCOBJECTS (
    p_folder_name   IN VARCHAR2, /* ѕараметр принимает значение папки IPC, в которой размещаетс€ объект IPC */
    p_workflow_name IN VARCHAR2, /* ѕараметр принимает значение имени потока IPC */
    p_patch_code    IN VARCHAR2 DEFAULT NULL /* «начением параметра определ€етс€ номер патча, в котором внос€тс€ изменени€ */
    )
  IS
    v_check_flag NUMBER;
  BEGIN

    /*
    1.	 онтроль параметров:
      a.	≈сли P_FOLDER_NAME равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_FOLDER_NAME не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.DEL_MD_IPCOBJECTSТ
        Х	p_severity_code  = СEТ
    */

    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра P_FOLDER_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	≈сли P_WORKFLOW_NAME равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_WORKFLOW_NAME не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA. DEL_MD_IPCOBJECTSТ
        Х	p_severity_code  = СEТ
    */
    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра P_WORKFLOW_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	≈сли найдена запись в таблице MD_IPCOBJECTS, у которой:
      Х	FOLDER_NAME = p_folder_name
      Х	WORKFLOW_NAME = p_workflow_name
      то дл€ нее обновл€ютс€ значени€ полей:
        Х	ACTIVE_FLAG = СNТ
        Х	CHANGE_DATE = SYSDATE
      иначе вызываетс€ процедура UTL_ERRHANDLERS.RAISE_ERROR с параметрами:
        Х	p_exception_name = Сe_metadata_not_foundТ
        Х	p_errmsg_text    = СЌе найден объект IPC в таблице MD_IPCOBJECTS дл€ значений параметров: P_FOLDER_NAME = [ Т+P_FOLDER_NAME+Т], P_WORKFLOW_NAME = [Т+P_WORKFLOW_NAME+Т].Т
        Х	p_plsqlunit_name = СAPI_METADATA. DEL_MD_IPCOBJECTSТ
        Х	p_severity_code  = СWТ
    */

    BEGIN
      SELECT 1
        INTO v_check_flag
        FROM MD_IPCOBJECTS
       WHERE FOLDER_NAME   = p_folder_name
         AND WORKFLOW_NAME = p_workflow_name;
      EXCEPTION
        WHEN NO_DATA_FOUND
        THEN v_check_flag := 0;
    END;

    v_check_flag := nvl(v_check_flag, 0);

    CASE WHEN v_check_flag = 1
      THEN
      UPDATE MD_IPCOBJECTS
         SET ACTIVE_FLAG = 'N',
             CHANGE_DATE = SYSDATE,
             PATCH_CODE  = NVL(p_patch_code, PATCH_CODE)
       WHERE FOLDER_NAME   = p_folder_name
         AND WORKFLOW_NAME = p_workflow_name;

      WHEN v_check_flag = 0
      THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_metadata_not_found',
          P_ERRMSG_TEXT    => 'Ќе найден объект IPC в таблице MD_IPCOBJECTS дл€ значений параметров: P_FOLDER_NAME = [' ||
                               p_folder_name || '],P_WORKFLOW_NAME=' || p_workflow_name || '].',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'W',
          P_SQLERRM_TEXT   => NULL
        );

    END CASE;

    /*
    3. ¬ыполн€етс€ подтверждение транзакции Ѕƒ
    */

    COMMIT;

    /*
    4.	≈сли при исполнении процедуры возникли исключени€,
      то:
      a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_METADATA.DEL_MD_IPCOBJECTSТ
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
         P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;


    /* ѕроцедуры управлени€ метаданными параметров */

  PROCEDURE UPSERT_MD_PARAMETERS(
    p_param_name    IN VARCHAR2, /* ѕараметр принимает  значение имени параметра в метаданных продукта */
    p_param_desc    IN VARCHAR2, /* ѕараметр принимает значение описани€ параметра */
    p_datatype_code IN VARCHAR2, /* ѕараметр принимает значение типа данных параметра */
    p_patch_code    IN VARCHAR2 DEFAULT NULL  /* Ќомер патча */
  )
  IS
    v_check_flag NUMBER;
  BEGIN
    /*
    1.     онтроль параметров:
      a.    ≈сли P_PARAM_NAME равен NULL,
        то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        -    P_EXCEPTION_CODE = -20101
        -    P_ERRMSG_TEXT = С«начение параметра P_PARAM_NAME не может принимать значение NULLТ
        -    P_PLSQLUNIT_NAME = СAPI_METADATA. UPSERT_MD_PARAMETERSТ
        -    P_SEVERITY_CODE = СEТ
    2.    ≈сли найдена запись в таблице MD_PARAMETERS, у которой:
      -    PARAM_NAME = P_PARAM_NAME
       то выполн€етс€ процедура UPD_MD_PARAMETERS с параметрами:
      -    P_PARAM_NAME = P_PARAM_NAME
      -    P_PARAM_DESC = P_PARAM_DESC
      -    P_DATATYPE_CODE = P_DATATYPE_CODE
        иначе выполн€етс€ процедура INS_MD_PARAMETERS с параметрами:
      -    P_PARAM_NAME = P_PARAM_NAME
      -    P_PARAM_DESC = P_PARAM_DESC
      -    P_DATATYPE_CODE = P_DATATYPE_CODE

    3.    ¬ыполн€етс€ подтверждение транзакции Ѕƒ
    4.    ≈сли при исполнении процедуры возникли исключени€,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
      -    P_EXCEPTION_CODE = SQLCODE
      -    P_ERRMSG_TEXT = С—истемна€ ошибкаТ
      -    P_PLSQLUNIT_NAME = СAPI_METADATA. UPSERT_MD_PARAMETERSТ
      -    P_SEVERITY_CODE = СEТ
      -    P_SQLERRM_TEXT = SQLERRM
    */


    /*
    1.	 онтроль параметров:
      a.	≈сли p_param_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_PARAM_NAME не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_PARAMETERSТ
        Х	p_severity_code  = СEТ
    */

    IF p_param_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_param_name не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_PARAMETERS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
     2.	≈сли найдена запись в таблице MD_PARAMETERS, у которой PARAM_NAME = p_param_name
      то обновл€етс€ найденна€ запись в таблице MD_PARAMETERS с установкой значений полей:
        Х	PARAM_DESC    = p_param_desc
        Х	DATATYPE_CODE = p_datatype_code
        Х	CHANGE_DATE   = SYSDATE
        Х	PATCH_CODE    = p_patch_code
      иначе добавл€етс€ записи в таблицу MD_PARAMETERS со значени€ми полей:
        Х	PARAM_NAME    = p_param_name
        Х	PARAM_NAME    = p_param_desc
        Х	DATATYPE_CODE = p_datatype_code
        Х	ACTIVE_FLAG   = СYТ
        Х	CHANGE_DATE   = SYSDATE
        Х	P_PATCH_CODE  = p_patch_code
     */
    BEGIN
      SELECT 1
        INTO v_check_flag
        FROM MD_PARAMETERS
       WHERE PARAM_NAME = p_param_name;
    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN v_check_flag := 0;
    END;

    v_check_flag := NVL(v_check_flag, 0);

    IF v_check_flag = 0 THEN
        /* 1.2 ƒобавл€етс€ запись в таблицу MD_PARAMETERS */
        INSERT INTO MD_PARAMETERS
                   (PARAM_NAME, PARAM_DESC, DATATYPE_CODE, ACTIVE_FLAG, CHANGE_DATE, PATCH_CODE)
            VALUES (p_param_name, p_param_desc, p_datatype_code, 'Y', SYSDATE, p_patch_code);

    ELSIF v_check_flag = 1 THEN
        /* 2. ќбновл€етс€ запись в таблице MD_PARAMETERS */
          UPDATE MD_PARAMETERS
             SET PARAM_DESC     = nvl(p_param_desc, PARAM_DESC),
                 DATATYPE_CODE  = nvl(p_datatype_code, DATATYPE_CODE),
                 CHANGE_DATE    = SYSDATE,
                 PATCH_CODE     = nvl(p_patch_code, PATCH_CODE)
           WHERE PARAM_NAME     = p_param_name;
    END IF;

    /*
    3.	¬ыполн€етс€ подтверждение транзакции Ѕƒ
    */

    COMMIT;


    /*
    4.	≈сли при исполнении процедуры возникли исключени€,
      то:
      a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_PARAMETERSТ
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
         P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_PARAMETERS',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;

  END;

  PROCEDURE DEL_MD_PARAMETERS(
    p_param_name IN VARCHAR2, /* ѕараметр принимает значение имени параметра, используемого в потоках IPC */
    p_patch_code IN VARCHAR2 DEFAULT NULL   /* Ќомер патча */
  )
  IS
  BEGIN
    /*
    1.	 онтроль параметров:
      a.	≈сли P_PARAM_NAME равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        -	P_EXCEPTION_CODE = -20101
        -	P_ERRMSG_TEXT = С«начение параметра P_PARAM_NAME не может принимать значение NULLТ
        -	P_PLSQLUNIT_NAME = СAPI_METADATA.DEL_MD_PARAMETERSТ
        -	P_SEVERITY_CODE = СEТ

    2.	¬ыполн€етс€ обновление записи в таблице MD_PARAMETERS, у которой:
      -	PARAM_NAME = P_PARAM_NAME
       и устанавливаютс€ значени€ полей:
      -	ACTIVE_FLAG = СNТ
      -	CHANGE_DATE = SYSDATE
    3.	¬ыполн€етс€ подтверждение транзакции Ѕƒ
    4.	≈сли при исполнении процедуры возникли исключени€,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
      -	P_EXCEPTION_CODE = SQLCODE
      -	P_ERRMSG_TEXT = С—истемна€ ошибкаТ
      -	P_PLSQLUNIT_NAME = СAPI_METADATA. DEL_MD_PARAMETERSТ
      -	P_SEVERITY_CODE = СEТ
      -	P_SQLERRM_TEXT = SQLERRM
    */


    /*
    1.	 онтроль параметров:
      a.	≈сли p_param_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра P_PARAM_NAME не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.DEL_MD_PARAMETERSТ
        Х	p_severity_code  = СEТ
    */

    IF p_param_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра p_param_name не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    /*
    2.	ƒл€ записи в таблице MD_PARAMETERS, у которой PARAM_NAME = p_param_name обновл€ютс€ значени€ полей:
      Х	ACTIVE_FLAG = СNТ
      Х	CHANGE_DATE = SYSDATE
      Х	PATCH_CODE = p_patch_code
    */

      UPDATE MD_PARAMETERS
         SET ACTIVE_FLAG = 'N',
             CHANGE_DATE = SYSDATE,
             PATCH_CODE = nvl(p_patch_code, PATCH_CODE)
       WHERE PARAM_NAME = p_param_name;

      /* 3. ѕодтверждение транзакции */

      COMMIT;


  /* 4. Ѕлок ислкючений */

  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT => '—истемна€ ошибка',
         P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
         P_SEVERITY_CODE => 'S',
         P_SQLERRM_TEXT => SQLERRM
       );
    END IF;
    RAISE;

  END;

  PROCEDURE UPSERT_MD_IPCOBJPARAMS (
      p_folder_name         IN VARCHAR2 /* ѕараметр принимает значение имени параметра, используемого в потоках IPC. */
    , p_workflow_name       IN VARCHAR2 /* ѕараметр принимает значение описание параметра. */
    , p_ipcobjtype_code     IN VARCHAR2 DEFAULT 'WORKFLOW' /* ѕараметр принимает значение тип объекта IPC, на основании которого формируетс€ секци€ файла параметров.*/
    , p_ipcobject_name      IN VARCHAR2 DEFAULT NULL /* ѕараметр принимает значение физическое им€ объекта IPC, дл€ которого определ€етс€ правила формировани€ значени€ параметра.*/
    , p_param_name          IN VARCHAR2 /* ”казываетс€ им€ параметра, дл€ которого определ€етс€ правило вычислени€ значени€.*/
    , p_loadingmode_code    IN VARCHAR2 DEFAULT 'INCREMENT' /* ѕараметр принимает значение режима загрузки, дл€ которого определ€етс€ правило вычислени€ значени€. */
    , p_reglamenttype_code  IN VARCHAR2 DEFAULT 'REGULAR_D' /* ѕараметр принимает значение типа регламента загрузки, дл€ которого определ€етс€ правило вычислени€ значени€.*/
    , p_paramvaluetype_code IN VARCHAR2 /* ”казываетс€ тип значени€ параметра в соответствии с системным словарем DCT_PARAMVALUETYPES. */
    , p_param_value         IN VARCHAR2 /* ”казываетс€ значение параметра или правило его вычислени€ в зависимости от указанного типа значени€.*/
    , p_logging_flag        IN VARCHAR2 DEFAULT 'Y' /* ”казываетс€ логический признак (Y|N), который определ€ет необходимость логировани€ вычисленного значени€ в журнале LOG_PARAMPREVVALUE. */
    , p_patch_code          IN VARCHAR2 DEFAULT NULL /* «начением параметра определ€етс€ номер патча, в котором внос€тс€ изменени€.*/

  )
  IS
    v_check_flag NUMBER;
  BEGIN
  /*
      1.   онтроль параметров:
        a.  ≈сли p_folder_name равен NULL,
            то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
            Х  P_EXCEPTION_NAME = Тe_paramvalue_emptyТ
            Х  P_ERRMSG_TEXT = С«начение параметра P_FOLDER_NAME не может принимать значение NULLТ
            Х  P_PLSQLUNIT_NAME = СAPI_METADATA.UPSERT_MD_IPCOBJPARAMSТ
            Х  P_SEVERITY_CODE = СEТ
        b.  ≈сли p_workflow_name равен NULL,
            то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
            Х  P_EXCEPTION_NAME = Тe_paramvalue_emptyТ
            Х  P_ERRMSG_TEXT = С«начение параметра P_WORKFLOW_NAME не может принимать значение NULLТ
            Х  P_PLSQLUNIT_NAME = СAPI_METADATA.UPSERT_MD_IPCOBJPARAMSТ
            Х  P_SEVERITY_CODE = СEТ
        c.  ≈сли p_param_name равен NULL,
            то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
            Х  P_EXCEPTION_NAME = Тe_paramvalue_emptyТ
            Х  P_ERRMSG_TEXT = С«начение параметра P_PARAM_NAME не может принимать значение NULLТ
            Х  P_PLSQLUNIT_NAME = СAPI_METADATA.UPSERT_MD_IPCOBJPARAMSТ
            Х  P_SEVERITY_CODE = СEТ
        d.  ≈сли p_paramvaluetype_code равен NULL,
            то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
            Х  P_EXCEPTION_NAME = Тe_paramvalue_emptyТ
            Х  P_ERRMSG_TEXT = С«начение параметра P_PARAMVALUETYPE_CODE не может принимать значение NULLТ
            Х  P_PLSQLUNIT_NAME = СAPI_METADATA.UPSERT_MD_IPCOBJPARAMSТ
            Х  P_SEVERITY_CODE = СEТ

      2.  ≈сли найдена запись в таблице MD_IPCOBJECTS, у которой:
            ?  FOLDER_NAME         = p_folder_name
            ?  WORKFLOW_NAME       = p_workflow_name
            ?  IPCOBJTYPE_CODE     = p_ipcobjtype_code
            ?  IPCOBJECT_NAME      = p_ipcobject_name
            ?  PARAM_NAME          = p_param_name
            ?  LOADINGMODE_CODE    = p_loadingmode_code
            ?  REGLAMENTTYPE_CODE  = p_reglamenttype_code
          то обновл€етс€ найденна€ запись в таблице MD_IPCOBJPARAMS с установкой значений полей:
            ?  PARAMVALUETYPE_CODE = p_paramvaluetype_code
            ?  PARAM_VALUE         = p_param_value
            ?  LOGGING_FLAG        = p_logging_flag
            ?  CHANGE_DATE         = SYSDATE
            ?  PATCH_CODE          = p_patch_code
          иначе добавл€етс€ нова€ запись в таблицу MD_IPCOBJPARAMS со значени€ми полей:
            ?  FOLDER_NAME         = p_folder_name
            ?  WORKFLOW_NAME       = p_workflow_name
            ?  IPCOBJTYPE_CODE     = p_ipcobjtype_code
            ?  IPCOBJECT_NAME      = p_ipcobject_name
            ?  PARAM_NAME          = p_param_name
            ?  LOADINGMODE_CODE    = p_loadingmode_code
            ?  REGLAMENTTYPE_CODE  = p_reglamenttype_code
            ?  PARAMVALUETYPE_CODE = p_paramvaluetype_code
            ?  PARAM_VALUE         = p_param_value
            ?  LOGGING_FLAG        = p_logging_flag
            ?  CHANGE_DATE         = SYSDATE
            ?  PATCH_CODE          = p_patch_code

      3.  ¬ыполн€етс€ подтверждение транзакции Ѕƒ
      4.  ≈сли при исполнении процедуры возникли исключени€,
          то:
          a.  ≈сли SQLCODE не входит в диапазон [-20999;-20000],
              то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
                ?  P_EXCEPTION_NAME = SQLCODE
                ?  P_ERRMSG_TEXT = С—истемна€ ошибкаТ
                ?  P_PLSQLUNIT_NAME = СAPI_METADATA.UPSERT_MD_IPCOBJPARAMSТ
                ?  P_SEVERITY_CODE = СSТ
                ?  P_SQLERRM_TEXT = SQLERRM
          b.  ¬ызываетс€ системное исключение.*/

  /* 1.  онтроль параметров */
    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра P_FOLDER_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра P_WORKFLOW_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );

    END IF;

    IF p_param_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра P_PARAM_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

  /* 2. ѕроверка наличи€ записи и выполнени€ INSERT или UPDATE */
    BEGIN
      SELECT 1
        INTO v_check_flag
        FROM MD_IPCOBJPARAMS
       WHERE
            FOLDER_NAME         = p_folder_name
        AND WORKFLOW_NAME       = p_workflow_name
        AND IPCOBJTYPE_CODE     = p_ipcobjtype_code
        AND (IPCOBJECT_NAME      = p_ipcobject_name
            OR (p_ipcobject_name IS NULL AND IPCOBJECT_NAME IS NULL))
        AND PARAM_NAME          = p_param_name
        AND LOADINGMODE_CODE    = p_loadingmode_code
        AND REGLAMENTTYPE_CODE  = p_reglamenttype_code;
    EXCEPTION
      WHEN NO_DATA_FOUND
        THEN v_check_flag := 0;
    END;

    v_check_flag := NVL(v_check_flag, 0);

    IF v_check_flag = 0 THEN
        /* 1.1 ƒополнительный контроль параметров при добавлении*/
        IF p_paramvaluetype_code IS NULL THEN
          UTL_ERRHANDLERS.RAISE_ERROR(
              P_EXCEPTION_NAME => 'e_paramvalue_empty',
              P_ERRMSG_TEXT => '«начение параметра P_PARAMVALUETYPE_CODE не может принимать значение NULL',
              P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
              P_SEVERITY_CODE => 'E',
              P_SQLERRM_TEXT => NULL
          );
        END IF;

        IF p_param_value IS NULL THEN
          UTL_ERRHANDLERS.RAISE_ERROR(
              P_EXCEPTION_NAME => 'e_paramvalue_empty',
              P_ERRMSG_TEXT => '«начение параметра P_PARAM_VALUE не может принимать значение NULL',
              P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
              P_SEVERITY_CODE => 'E',
              P_SQLERRM_TEXT => NULL
          );
        END IF;

        /* 1.2 ƒобавл€етс€ запись в таблицу MD_IPCOBJPARAMS */
        INSERT INTO MD_IPCOBJPARAMS(
                FOLDER_NAME, WORKFLOW_NAME, IPCOBJTYPE_CODE, IPCOBJECT_NAME, PARAM_NAME, LOADINGMODE_CODE, REGLAMENTTYPE_CODE, PARAMVALUETYPE_CODE, PARAM_VALUE, LOGGING_FLAG, CHANGE_DATE, PATCH_CODE
                )
            VALUES (
                p_folder_name, p_workflow_name, p_ipcobjtype_code, p_ipcobject_name, p_param_name, p_loadingmode_code, p_reglamenttype_code, p_paramvaluetype_code, p_param_value, p_logging_flag, SYSDATE, p_patch_code
                );

    ELSIF v_check_flag = 1 THEN
        /* 2. ќбновл€етс€ запись в таблице MD_IPCOBJPARAMS */
          UPDATE MD_IPCOBJPARAMS SET
                PARAMVALUETYPE_CODE = NVL(p_paramvaluetype_code, PARAMVALUETYPE_CODE)
              , PARAM_VALUE         = NVL(p_param_value, PARAM_VALUE)
              , LOGGING_FLAG        = NVL(p_logging_flag, LOGGING_FLAG)
              , CHANGE_DATE         = SYSDATE
              , PATCH_CODE          = NVL(p_patch_code, PATCH_CODE)
           WHERE
                FOLDER_NAME         = p_folder_name
            AND WORKFLOW_NAME       = p_workflow_name
            AND IPCOBJTYPE_CODE     = p_ipcobjtype_code
            AND (IPCOBJECT_NAME     = p_ipcobject_name
                OR (p_ipcobject_name IS NULL AND IPCOBJECT_NAME IS NULL))
            AND PARAM_NAME          = p_param_name
            AND LOADINGMODE_CODE    = p_loadingmode_code
            AND REGLAMENTTYPE_CODE  = p_reglamenttype_code;
    END IF;

  /* 3. ѕодтверждение транзакции */
    COMMIT;

  /* 4. Ѕлок ислкючений */

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '—истемна€ ошибка',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;
  END;

  PROCEDURE DEL_MD_IPCOBJPARAMS(
        p_folder_name         IN VARCHAR2 /* ѕараметр принимает значение имени параметра, используемого в потоках IPC. */
      , p_workflow_name       IN VARCHAR2 /* ѕараметр принимает значение описание параметра. */
      , p_ipcobjtype_code     IN VARCHAR2 /* ѕараметр принимает значение тип объекта IPC, на основании которого формируетс€ секци€ файла параметров. */
      , p_ipcobject_name      IN VARCHAR2 /* ѕараметр принимает значение физическое им€ объекта IPC, дл€ которого определ€етс€ правила формировани€ значени€ параметра. */
      , p_param_name          IN VARCHAR2 /* ”казываетс€ им€ параметра, дл€ которого определ€етс€ правило вычислени€ значени€. */
      , p_loadingmode_code    IN VARCHAR2 /* ѕараметр принимает значение режима загрузки, дл€ которого определ€етс€ правило вычислени€ значени€.  */
      , p_reglamenttype_code  IN VARCHAR2 /* ѕараметр принимает значение типа регламента загрузки, дл€ которого определ€етс€ правило вычислени€ значени€. */
    )
  IS
  BEGIN

  /* 1.  онтроль параметров */
    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра P_FOLDER_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра P_WORKFLOW_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );

    END IF;
    IF p_ipcobjtype_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра P_IPCOBJTYPE_CODE не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_param_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра P_PARAM_NAME не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_loadingmode_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра P_LOADINGMODE_CODE не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_reglamenttype_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '«начение параметра P_REGLAMENTTYPE_CODE не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

  /* 2. ”даление назначени€ параметра */
    DELETE FROM MD_IPCOBJPARAMS
      WHERE
            FOLDER_NAME         = p_folder_name
        AND WORKFLOW_NAME       = p_workflow_name
        AND IPCOBJTYPE_CODE     = p_ipcobjtype_code
        AND (IPCOBJECT_NAME     = p_ipcobject_name
            OR (p_ipcobject_name IS NULL AND IPCOBJECT_NAME IS NULL))
        AND PARAM_NAME          = p_param_name
        AND LOADINGMODE_CODE    = p_loadingmode_code
        AND REGLAMENTTYPE_CODE  = p_reglamenttype_code;

  /* 3. ѕодтверждение транзакции */
    COMMIT;

  /* 4. Ѕлок ислкючений */
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '—истемна€ ошибка',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;
  END;



    PROCEDURE UPSERT_MD_TABLES(
    /*
    ѕроцедура изменени€ метаданных дл€ таблиц ¬итрины
    Ќазначение:
      ѕроцедура предназначена дл€ изменени€ (добавлени€ или обновлени€) регистрации таблиц ¬итрин в метаданных ѕродукта
      ¬ результате изменени€ добавл€етс€ или обновл€етс€ одна запись в регистрации таблиц ¬итрины.
    “ип процедуры: API
    */

    p_schema_name IN VARCHAR2, /* ѕараметр принимает значение имени схемы ¬итрины, в которой размещена таблица*/
    p_table_name IN VARCHAR2, /* ѕараметр принимает значение SQL-имени таблицы ¬итрины */
    p_table_desc IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение описани€ таблицы ¬итрины */
    p_patch_code          IN VARCHAR2 DEFAULT NULL /* «начением параметра определ€етс€ номер патча, в котором внос€тс€ изменени€.*/
  )
  IS

      v_check_flag INTEGER;

  BEGIN
    /*
    1.	 онтроль параметров:
      a.	≈сли p_schema_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра p_schema_name не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_TABLESТ
        Х	p_severity_code  = СEТ
    */
    IF p_schema_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT => '«начение параметра p_schema_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_TABLES',
        P_SEVERITY_CODE => 'E'
      );
    END IF;

    /*
      b.	≈сли p_table_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра p_table_name не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_TABLESТ
        Х	p_severity_code  = СEТ
    */

    IF p_table_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT => '«начение параметра p_table_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_TABLES',
        P_SEVERITY_CODE => 'E'
      );

      /*
      2.	≈сли найдена запись в таблице MD_TABLES, у которой:
      Х SCHEMA_NAME   = p_schema_name
      Х TABLE_NAME    = p_table_name
        то обновл€етс€ найденна€ запись в таблице MD_TABLES с установкой значений полей:
        Х TABLE_DESC       = p_table_desc
        Х CHANGE_DATE      = SYSDATE
        Х PATCH_CODE       = p_patch_code
      иначе добавл€етс€ запись в таблицу MD_TABLES со значени€ми полей:
      Х SCHEMA_NAME      = p_schema_name
      Х TABLE_NAME       = p_table_name
      Х TABLE_DESC       = p_table_desc
      Х CHANGE_DATE      = SYSDATE
      */
    END IF;

    BEGIN
      SELECT 1
        INTO v_check_flag
        FROM MD_TABLES
       WHERE SCHEMA_NAME = p_schema_name
         AND TABLE_NAME = p_table_name;

    EXCEPTION
      WHEN NO_DATA_FOUND
        THEN v_check_flag := 0;
    END;

    v_check_flag := NVL(v_check_flag, 0);

    CASE WHEN v_check_flag = 1
      THEN
      UPDATE MD_TABLES
         SET TABLE_DESC = p_table_desc,
             CHANGE_DATE = SYSDATE,
             PATCH_CODE = p_patch_code
       WHERE SCHEMA_NAME = p_schema_name
         AND TABLE_NAME = p_table_name;
    WHEN v_check_flag = 0
      THEN
      INSERT INTO MD_TABLES
               (SCHEMA_NAME, TABLE_NAME, TABLE_DESC, CHANGE_DATE, PATCH_CODE)
        VALUES (p_schema_name, p_table_name, p_table_desc, SYSDATE, p_patch_code);
    END CASE;

    /*
    3.	¬ыполн€етс€ подтверждение транзакции Ѕƒ
    */
    COMMIT;

    /*
    4.	≈сли при исполнении процедуры возникли исключени€,
    то:
      a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_TABLESТ
        Х	p_severity_code  = СSТ
        Х	p_sqlerrm_text   = SQLERRM
      b.	¬ызываетс€ системное исключение
    */

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '—истемна€ ошибка',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;
  END;


  PROCEDURE REMOVE_MD_TABLES(
    /*
    ѕроцедура физического удалени€ метаданных дл€ таблицы ¬итрины
    Ќазначение:
      ѕроцедура предназначена дл€ удалени€ регистрации таблиц ¬итрин в метаданных продукта
      ¬ результате изменени€ добавл€етс€ или обновл€етс€ одна запись в реестре атрибутов таблиц ¬итрины
    “ип процедуры:
      API
    */
    p_schema_name IN VARCHAR2, /* ѕараметр принимает значение имени схемы ¬итрины, в которой размешена таблица */
    p_table_name IN VARCHAR2 /* ѕараметр принимает значение SQL-имени таблицы ¬итрины */
  )
  IS
  BEGIN
    /*
    1.	 онтроль параметров:
      a.	≈сли p_schema_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра p_schema_name не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.REMOVE_MD_TABLESТ
        Х	p_severity_code  = СEТ
    */

    IF p_schema_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '«начение параметра p_schema_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.REMOVE_MD_TABLES',
        P_SEVERITY_CODE  => 'E'
      );
    END IF;
    /*
      b.	≈сли p_table_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра p_table_name не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.REMOVE_MD_TABLESТ
        Х	p_severity_code  = СEТ
    */

    IF p_table_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '«начение параметра p_table_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.REMOVE_MD_TABLES',
        P_SEVERITY_CODE  => 'E'
      );
    END IF;

    /*
    2.	”дал€ютс€ записи из таблицы MD_COLUMNS, у которой:
      Х	SCHEMA_NAME   = p_schema_name
      Х	TABLE_NAME    = p_table_name
    */

    DELETE
      FROM MD_COLUMNS
     WHERE SCHEMA_NAME = p_schema_name
       AND TABLE_NAME  = p_table_name;

    /*
    3.	”дал€етс€ запись из таблицы MD_TABLES, у которой:
      Х	SCHEMA_NAME   = p_schema_name
      Х	TABLE_NAME    = p_table_name
    */

    DELETE
      FROM MD_TABLES
     WHERE SCHEMA_NAME = p_schema_name
       AND TABLE_NAME  = p_table_name;

    /*
    4.	¬ыполн€етс€ подтверждение транзакции Ѕƒ
    */

    COMMIT;

    /*
    5.	≈сли при исполнении процедуры возникли исключени€,
    то:
    a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
    то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
      Х	p_exception_name = SQLCODE
      Х	p_errmsg_text    = С—истемна€ ошибкаТ
      Х	p_plsqlunit_name = СAPI_METADATA.REMOVE_MD_TABLESТ
      Х	p_severity_code  = СSТ
      Х	p_sqlerrm_text   = SQLERRM
    b.	¬ызываетс€ системное исключение.
    */

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '—истемна€ ошибка',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;

  END;


  PROCEDURE UPSERT_MD_COLUMNS(
    /*
    ѕроцедура изменений метаданных дл€ атрибута таблиц ¬итрины
    Ќазначение:
      ѕроцедура предназначена дл€ изменени€(добавлени€ или обновлени€) регистрации атрибута таблиц ¬итрины в метаданных ѕродукта
      ¬ результате изменени€ добавл€етс€ или обновл€етс€ запись в јтрибутах таблиц ¬итрины
    */
    p_schema_name        IN VARCHAR2, /* ѕараметр принимает значение SQL-имени схемы ¬итрины, в которой размещена таблица */
    p_table_name         IN VARCHAR2, /* ѕараметр принимает значение SQL-имени таблицы ¬итрины. */
    p_column_name        IN VARCHAR2, /* ѕараметр принимает значение SQL-имени добавл€емого/измен€емого пол€ таблицы. */
    p_deletedkey_flag    IN VARCHAR2, /* ѕараметр принимает значение дл€ определени€ флага пол€ дл€ определени€ ключа дл€ удалени€ */
    p_nvl_flag           IN VARCHAR2, /* ѕараметр принимает значение дл€ определени€ флага пол€ дл€ определени€ обработки необ€зательных полей функции NVL */
    p_columntype_code    IN VARCHAR2,
    p_default_value      IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение по умолчанию, определенное дл€ атрибута таблицы, которое используетс€ при обработке NVL*/
    p_ref_scheme_name    IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение SQL-имени схемы, в которой размешена таблица, на которую ссылаетс€ атрибут */
    p_ref_table_name     IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение SQL-имени таблицы, на которую ссылаетс€ атрибут */
    p_ref_expression_sql IN VARCHAR2 DEFAULT NULL, /* ѕараметр принимает значение SQL-выражение, значени€ которого €вд€ютс€ исходными натуральными ключами дл€ заполнени€ пол€ DM*_STG.KEYBRIDGE.CODE */
    p_insnewkey_flag     IN VARCHAR2 DEFAULT NULL, /* ‘лаг, который определ€ет, что по значени€м натурального ключа ссылочного атрибута требуетс€ генераци€ суррогатных ключей DK */
    p_patch_code         IN NUMBER DEFAULT NULL    /* ѕараметр принимает значение идентификатора ”правл€ющего потока, в рамках которого исполн€етс€. */
  )
  IS
    v_check_flag NUMBER;
  BEGIN
    /*
    1.	 онтроль параметров:
      a.	≈сли p_schema_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра p_schema_name не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_COLUMNSТ
        Х	p_severity_code  = СEТ
    */
    IF p_schema_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '«начение параметра p_schema_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	≈сли p_table_name равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = Тe_paramvalue_emptyТ
        Х	p_errmsg_text    = С«начение параметра p_table_name не может принимать значение NULLТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_COLUMNSТ
        Х	p_severity_code  = СEТ
    */

    IF p_table_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '«начение параметра p_table_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
        c.	≈сли p_column_name равен NULL,
          то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
          Х p_exception_name = Тe_paramvalue_emptyТ
          Х p_errmsg_text    = С«начение параметра p_column_name не может принимать значение NULLТ
          Х p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_COLUMNSТ
          Х p_severity_code  = СEТ
    */

    IF p_column_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '«начение параметра p_column_name не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      e.	≈сли p_deletedkey_flag равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х p_exception_name = Тe_paramvalue_emptyТ
        Х p_errmsg_text    = С«начение параметра p_deletedkey_flag не может принимать значение NULLТ
        Х p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_COLUMNSТ
        Х p_severity_code  = СEТ
    */

    IF p_deletedkey_flag IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '«начение параметра p_deletedkey_flag не может принимать значение NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      f. ≈сли p_nvl_flag равен NULL,
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х p_exception_name = Тe_paramvalue_emptyТ
        Х p_errmsg_text    = С«начение параметра p_nvl_flag не может принимать значение NULLТ
        Х p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_COLUMNSТ
        Х p_severity_code  = СEТ
    */

    IF p_nvl_flag IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '«начение параметра p_nvl_flag не может принимать значение NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
        g.	≈сли p_nvl_flag = ТYТ » p_default_value равен NULL,
          то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
          Х p_exception_name = Тe_paramvalue_emptyТ
          Х p_errmsg_text    = С«начение параметра p_default_value не может принимать значение NULL, так как дл€ атрибута определена обработка NULL значений (P_NVL_FLAG = [Y])Т
          Х p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_COLUMNSТ
          Х p_severity_code  = СEТ

    */

    IF p_nvl_flag = 'Y' and p_default_value IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '«начение параметра p_default_value не может принимать значение NULL, так как дл€ атрибута определена обработка NULL значений (P_NVL_FLAG = [Y])',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	≈сли найдена запись в таблице MD_COLUMNS, у которой:
      Х SCHEMA_NAME   = p_schema_name
      Х TABLE_NAME    = p_table_name
      Х COLUMN_NAME   = p_column_name
        то обновл€етс€ найденна€ запись в таблице MD_COLUMNS с установкой значений полей:
        Х COLUMNTYPE_CODE    = p_columntype_code
        Х DELETEDKEY_FLAG    = p_deletedkey_flag
        Х NVL_FLAG           = p_nvl_flag
        Х DEFAULT_VALUE      = p_default_value
        Х REF_SCHEME_NAME    = p_ref_scheme_name
        Х REF_TABLE_NAME     = p_ref_table_name
        Х REF_EXPRESSION_SQL = p_ref_expression_sql
        Х INSNEWKEY_FLAG     = p_insnewkey_flag
        Х CHANGE_DATE        = SYSDATE
        Х PATCH_CODE         = p_patch_code
    иначе добавл€етс€ запись в таблицу MD_TABLES со значени€ми полей:
      Х SCHEMA_NAME        = p_schema_name
      Х TABLE_NAME         = p_table_name
      Х COLUMN_NAME        = p_column_name
      Х COLUMNTYPE_CODE    = p_columntype_code
      Х DELETEDKEY_FLAG    = p_deletedkey_flag
      Х NVL_FLAG           = p_nvl_flag
      Х DEFAULT_VALUE      = p_default_value
      Х REF_SCHEME_NAME    = p_ref_scheme_name
      Х REF_TABLE_NAME     = p_ref_table_name
      Х REF_EXPRESSION_SQL = p_ref_expression_sql
      Х INSNEWKEY_FLAG     = p_insnewkey_flag
      Х CHANGE_DATE        = SYSDATE
      Х PATCH_CODE         = p_patch_code
    */

    BEGIN
      SELECT 1
        INTO v_check_flag
        FROM MD_COLUMNS
       WHERE SCHEMA_NAME = p_schema_name
         AND TABLE_NAME  = p_table_name
         AND COLUMN_NAME = p_column_name;

    EXCEPTION
      WHEN NO_DATA_FOUND
        THEN v_check_flag := 0;
    END;

    v_check_flag := NVL(v_check_flag, 0);

    CASE WHEN v_check_flag = 1
      THEN
      UPDATE MD_COLUMNS
        SET COLUMNTYPE_CODE  = NVL(p_columntype_code, COLUMNTYPE_CODE )
        , DELETEDKEY_FLAG    = NVL(p_deletedkey_flag, DELETEDKEY_FLAG)
        , NVL_FLAG           = NVL(p_nvl_flag, NVL_FLAG)
        , DEFAULT_VALUE      = NVL(p_default_value, DEFAULT_VALUE)
        , REF_SCHEME_NAME    = NVL(p_ref_scheme_name, REF_SCHEME_NAME)
        , REF_TABLE_NAME     = NVL(p_ref_table_name, REF_TABLE_NAME)
        , REF_EXPRESSION_SQL = NVL(p_ref_expression_sql, REF_EXPRESSION_SQL)
        , INSNEWKEY_FLAG     = NVL(p_insnewkey_flag, INSNEWKEY_FLAG)
        , CHANGE_DATE        = SYSDATE
        , PATCH_CODE         = NVL(p_patch_code, PATCH_CODE)
      WHERE SCHEMA_NAME = p_schema_name
        AND TABLE_NAME  = p_table_name
        AND COLUMN_NAME = p_column_name;
      WHEN v_check_flag = 0
      THEN
      INSERT INTO MD_COLUMNS
                (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, COLUMNTYPE_CODE, DELETEDKEY_FLAG,
                 NVL_FLAG, DEFAULT_VALUE, REF_SCHEME_NAME, REF_TABLE_NAME, REF_EXPRESSION_SQL,
                 INSNEWKEY_FLAG, CHANGE_DATE, PATCH_CODE)
        VALUES  (p_schema_name, p_table_name, p_column_name, p_columntype_code, p_deletedkey_flag,
                 p_nvl_flag, p_default_value, p_ref_scheme_name, p_ref_table_name, p_ref_expression_sql,
                 p_insnewkey_flag, SYSDATE, p_patch_code);
    END CASE ;

    /*
    3.	¬ыполн€етс€ подтверждение транзакции Ѕƒ
    */

    COMMIT;

    /*
    4.	≈сли при исполнении процедуры возникли исключени€,
      то:
      a.	≈сли SQLCODE не входит в диапазон [-20999;-20000],
      то вызываетс€ UTL_ERRHANDLERS.RAISE_ERROR  с параметрами:
        Х	p_exception_name = SQLCODE
        Х	p_errmsg_text    = С—истемна€ ошибкаТ
        Х	p_plsqlunit_name = СAPI_METADATA.UPSERT_MD_COLUMNSТ
        Х	p_severity_code  = СSТ
        Х	p_sqlerrm_text   = SQLERRM
      b.	¬ызываетс€ системное исключение.
    */

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '—истемна€ ошибка',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;

  END;

END API_METADATA;
/