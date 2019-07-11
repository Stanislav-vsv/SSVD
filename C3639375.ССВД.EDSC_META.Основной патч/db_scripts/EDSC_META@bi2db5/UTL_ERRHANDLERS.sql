/* This object may not be sorted properly in the script due to cirular references. */
--
-- UTL_ERRHANDLERS  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.UTL_ERRHANDLERS AS

   k_crlf CONSTANT VARCHAR2(2) := CHR(13) || CHR(10);
  /*
    RAISE_ERROR - ��������� ��������� ����������� ����������
    ����������: ��������� ������������� ��� ��������������� ��������� ����������
    ��� ���������: UTL
  */
  PROCEDURE RAISE_ERROR(
    p_exception_name IN VARCHAR2, /* �������� ��������� �������� ���� ������������ ���������� */
    p_errmsg_text    IN VARCHAR2,  /* �������� ��������� ��������  ��������� �� ������ */
    p_plsqlunit_name IN VARCHAR2, /* �������� ��������� �������� ����� ������������ �����, � ������� ��������� ������ */
    p_severity_code  IN VARCHAR2 DEFAULT 'E', /* �������� ��������� �������� ������ ����������� ('E' - ������, 'W' - ��������������) */
    p_sqlerrm_text   IN VARCHAR2 DEFAULT NULL); /* �������� ��������� �������� ���������� ��������� �� ������ */



  /*
    LOG_ERROR - ��������� ������������ ������
    ����������:
    ��������� ������������� ��� ����������� ������ ��� ��������������.
    �������� ������������ � ������ ����������� ����������.
    � ���������� ������ ��������� ����������� ���� ������ � ������� ������������ ������
    ��� ���������: UTL
  */
  PROCEDURE LOG_ERROR(
    p_exception_code IN NUMBER, /* �������� ��������� �������� ���� ������������ ���������� */
    p_exception_name IN VARCHAR2, /* �������� ��������� �������� ���� ������������ ���������� */
    p_errmsg_text    IN VARCHAR2, /* �������� ��������� �������� ��������� �� ������ */
    p_plsqlunit_name IN VARCHAR2, /* �������� ��������� �������� ����� ������������ �����, � ������� ��������� ������ */
    p_severity_code  IN VARCHAR2, /* �������� ��������� �������� ������ ����������� ('E' - ������, 'W' - ��������������) */
    p_sqlerrm_text   IN VARCHAR2 DEFAULT NULL); /* �������� ��������� �������� ���������� ��������� �� ������ */

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
    RAISE_ERROR - ��������� ��������� ����������� ����������
    ����������: ��������� ������������� ��� ��������������� ��������� ����������
    ��� ���������: UTL
  */
  PROCEDURE RAISE_ERROR(
    p_exception_name IN VARCHAR2, /* �������� ��������� �������� ���� ������������ ���������� */
    p_errmsg_text    IN VARCHAR2,  /* �������� ��������� ��������  ��������� �� ������ */
    p_plsqlunit_name IN VARCHAR2, /* �������� ��������� �������� ����� ������������ �����, � ������� ��������� ������ */
    p_severity_code  IN VARCHAR2 DEFAULT 'E', /* �������� ��������� �������� ������ ����������� ('E' - ������, 'W' - ��������������) */
    p_sqlerrm_text   IN VARCHAR2 DEFAULT NULL) /* �������� ��������� �������� ���������� ��������� �� ������ */
  IS
    v_exception_code NUMBER;
    v_exception_name VARCHAR2(255);
    v_severity_code  VARCHAR2(1);
    v_errmsg_text    VARCHAR2(4000);
  BEGIN
    /*
    TODO: ��������� ��������� ������ RAISE_ERROR
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
        v_errmsg_text    := '�������� ���������: '||NVL(p_errmsg_text, '')||k_crlf||
                            '�������������� ���������: �������� �������� ��������� P_SEVERITY_CODE.';
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
    LOG_ERROR - ��������� ������������ ������
    ����������:
    ��������� ������������� ��� ����������� ������ ��� ��������������.
    �������� ������������ � ������ ����������� ����������.
    � ���������� ������ ��������� ����������� ���� ������ � ������� ������������ ������
    ��� ���������: UTL
  */
  PROCEDURE LOG_ERROR(
    p_exception_code IN NUMBER, /* �������� ��������� �������� ���� ������������ ���������� */
    p_exception_name IN VARCHAR2, /* �������� ��������� �������� ���� ������������ ���������� */
    p_errmsg_text    IN VARCHAR2, /* �������� ��������� �������� ��������� �� ������ */
    p_plsqlunit_name IN VARCHAR2, /* �������� ��������� �������� ����� ������������ �����, � ������� ��������� ������ */
    p_severity_code  IN VARCHAR2, /* �������� ��������� �������� ������ ����������� ('E' - ������, 'W' - ��������������) */
    p_sqlerrm_text   IN VARCHAR2 DEFAULT NULL)  /* �������� ��������� �������� ���������� ��������� �� ������ */
  IS
  v_exception_code NUMBER;

  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    /* TODO: �������� ������� ���������� */

      v_exception_code := TO_NUMBER(p_exception_code);

    INSERT INTO LOG_ERRORS(EXCEPTION_CODE, EXCEPTION_NAME, ERRMSG_TEXT, PLSQLUNIT_NAME, SEVERITY_CODE, SQLERRM_TEXT)
      VALUES(v_exception_code, p_exception_name, p_errmsg_text, p_plsqlunit_name, p_severity_code, p_sqlerrm_text);

    COMMIT;

  END;

END UTL_ERRHANDLERS;
/