/* This object may not be sorted properly in the script due to cirular references. */
--
-- UTL_ERRHANDLERS  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.UTL_ERRHANDLERS AS

   k_crlf CONSTANT VARCHAR2(2) := CHR(13) || CHR(10);
  /*
    RAISE_ERROR - процедура обработки программных исключений
    Назначение: Процедура предназначена для унифицированных обработки исключений
    Тип процедуры: UTL
  */
  PROCEDURE RAISE_ERROR(
    p_exception_name IN VARCHAR2, /* Параметр принимает значение кода программного исключения */
    p_errmsg_text    IN VARCHAR2,  /* Параметр принимает значение  сообщения об ошибке */
    p_plsqlunit_name IN VARCHAR2, /* Параметр принимает значение имени программного блока, в котором произошла ошибка */
    p_severity_code  IN VARCHAR2 DEFAULT 'E', /* Параметр принимает значение уровня критичности ('E' - ошибка, 'W' - предупреждение) */
    p_sqlerrm_text   IN VARCHAR2 DEFAULT NULL); /* Параметр принимает значение системного сообщения об ошибке */



  /*
    LOG_ERROR - процедура логгирования ошибок
    Назначение:
    Процедура предназначена для логирования ошибок или предупреждений.
    Процедра испольняется в рамках автономоной транзакции.
    В результате работы процедуры формируется одна запись в журнале регистрациии ошибок
    Тип процедуры: UTL
  */
  PROCEDURE LOG_ERROR(
    p_exception_code IN NUMBER, /* Параметр принимает значение кода программного исключения */
    p_exception_name IN VARCHAR2, /* Параметр принимает значение кода программного исключения */
    p_errmsg_text    IN VARCHAR2, /* Параметр принимает значение сообщения об ошибки */
    p_plsqlunit_name IN VARCHAR2, /* Параметр принимает значение имени программного блока, в котором произошла ошибка */
    p_severity_code  IN VARCHAR2, /* Параметр принимает значение уровня критичности ('E' - ошибка, 'W' - предупреждение) */
    p_sqlerrm_text   IN VARCHAR2 DEFAULT NULL); /* Параметр принимает значение системного сообщения об ошибки */

--   FUNCTION CHECK_SEVERITY_CODE(p_severity_code VARCHAR2)
--     RETURN BOOLEAN;
--
--
--   FUNCTION GET_EXCEPTION_CODE_BY_NAME(p_exception_name VARCHAR2) RETURN NUMBER;

END UTL_ERRHANDLERS;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- UTL_ERRHANDLERS  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.UTL_ERRHANDLERS AS

  /*
    RAISE_ERROR - процедура обработки программных исключений
    Назначение: Процедура предназначена для унифицированных обработки исключений
    Тип процедуры: UTL
  */
  PROCEDURE RAISE_ERROR(
    p_exception_name IN VARCHAR2, /* Параметр принимает значение кода программного исключения */
    p_errmsg_text    IN VARCHAR2,  /* Параметр принимает значение  сообщения об ошибке */
    p_plsqlunit_name IN VARCHAR2, /* Параметр принимает значение имени программного блока, в котором произошла ошибка */
    p_severity_code  IN VARCHAR2 DEFAULT 'E', /* Параметр принимает значение уровня критичности ('E' - ошибка, 'W' - предупреждение) */
    p_sqlerrm_text   IN VARCHAR2 DEFAULT NULL) /* Параметр принимает значение системного сообщения об ошибке */
  IS
    v_exception_code NUMBER;
    v_exception_name VARCHAR2(255);
    v_severity_code  VARCHAR2(1);
    v_errmsg_text    VARCHAR2(4000);
  BEGIN
    /*
    TODO: Обработка неверного вызова RAISE_ERROR
    */
    /*
    select UTL_ERRHANDLERS.GET_EXCEPTION_CODE_BY_NAME(p_exception_name)
    into v_exception_code
    from dual;
    */
    IF p_severity_code NOT IN ('S','E','W') THEN
--        dbms_output.put_line('p_severity_code NOT IN (S,E,W)');
        v_exception_name := 'e_complex_error';
        v_exception_code := UTL_HELPERS.GET_EXCEPTION_CODE_BY_NAME(v_exception_name);
        v_severity_code  := 'E';
        v_errmsg_text    := 'Исходное сообщение: '||NVL(p_errmsg_text, '')||k_crlf||
                            'Дополнительное сообщение: Неверное значение параметра P_SEVERITY_CODE.';
    ELSIF p_severity_code = 'S' THEN
--        dbms_output.put_line(p_exception_name);
        v_exception_code := TO_NUMBER(p_exception_name);
        v_exception_name := 'e_system_error';
        v_severity_code  := p_severity_code;
        v_errmsg_text    := p_errmsg_text;
    ELSE
--        dbms_output.put_line('else');
        v_exception_code := UTL_HELPERS.GET_EXCEPTION_CODE_BY_NAME(p_exception_name);
        v_exception_name := p_exception_name;
        v_severity_code  := p_severity_code;
        v_errmsg_text    := p_errmsg_text;
    END IF;

    LOG_ERROR(v_exception_code, v_exception_name, v_errmsg_text, p_plsqlunit_name, v_severity_code, p_sqlerrm_text);

    CASE
        WHEN p_severity_code = 'E' THEN
          ROLLBACK;
          RAISE_APPLICATION_ERROR(v_exception_code, p_errmsg_text || CASE WHEN p_sqlerrm_text is not null then  k_crlf ||  p_sqlerrm_text else '' end, FALSE);
        WHEN p_severity_code = 'S' THEN
          ROLLBACK;
        ELSE
          NULL;
    END CASE;
END;


  /*
    LOG_ERROR - процедура логгирования ошибок
    Назначение:
    Процедура предназначена для логирования ошибок или предупреждений.
    Процедра испольняется в рамках автономоной транзакции.
    В результате работы процедуры формируется одна запись в журнале регистрациии ошибок
    Тип процедуры: UTL
  */
  PROCEDURE LOG_ERROR(
    p_exception_code IN NUMBER, /* Параметр принимает значение кода программного исключения */
    p_exception_name IN VARCHAR2, /* Параметр принимает значение кода программного исключения */
    p_errmsg_text    IN VARCHAR2, /* Параметр принимает значение сообщения об ошибки */
    p_plsqlunit_name IN VARCHAR2, /* Параметр принимает значение имени программного блока, в котором произошла ошибка */
    p_severity_code  IN VARCHAR2, /* Параметр принимает значение уровня критичности ('E' - ошибка, 'W' - предупреждение) */
    p_sqlerrm_text   IN VARCHAR2 DEFAULT NULL)  /* Параметр принимает значение системного сообщения об ошибки */
  IS
  v_exception_code NUMBER;

  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    /* TODO: проверка входных параметров */

      v_exception_code := TO_NUMBER(p_exception_code);

    INSERT INTO LOG_ERRORS(EXCEPTION_CODE, EXCEPTION_NAME, ERRMSG_TEXT, PLSQLUNIT_NAME, SEVERITY_CODE, SQLERRM_TEXT)
      VALUES(v_exception_code, p_exception_name, p_errmsg_text, p_plsqlunit_name, p_severity_code, p_sqlerrm_text);

    COMMIT;

  END;

END UTL_ERRHANDLERS;
/