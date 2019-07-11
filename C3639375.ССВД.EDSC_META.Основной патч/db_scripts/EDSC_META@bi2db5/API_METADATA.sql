/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_METADATA  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.API_METADATA  AS

  PROCEDURE UPSERT_MD_IPCOBJECTS(
    /*
    ����������:
      ��������� ������������� ��� ��������� ����������� ������� IPC � ���������� ��������
      � ���������� ��������� ����������� ��� ����������� ���� ������ � ������� �������� IPC
    ��� ���������:
      API
    */
    p_folder_name      IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC*/
    p_workflow_name    IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
    p_purposetype_code IN VARCHAR2, /* �������� ��������� �������� ���� ��������������� ���������� ������ IPC*/
    p_ipcobject_desc   IN VARCHAR2 DEFAULT NULL, /* ��������� ��������� ����� ���� ���������� �������� ������ IPC*/
    p_patch_code       IN VARCHAR2 DEFAULT NULL  /* ��������� ��������� ������������ ����� �����, � ������� �������� ���������. */
   );

  PROCEDURE DEL_MD_IPCOBJECTS(
    /*
    ����������:
      ��������� ������������� ��� ���������� ����������� �������� ������� IPC � ���������� ��������.
      ��������� ��������� ����� �� ����� �������������� ��� ������� � ������ ������� WF_RUN_ANY_ETL,
      ��� ���� �� ����� ���� ���������� ���������������� �������� ����������.
      � ���������� ����������� ���������� ����������� ������� ACTIVE_FLAG ��� ������ � ������� �������� IPC
      �� �����
    ��� ���������:
      API
    */
    p_folder_name   IN VARCHAR2, /* �������� ��������� �������� ����� IPC, � ������� ����������� ������ IPC */
    p_workflow_name IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
    p_patch_code    IN VARCHAR2 DEFAULT NULL  /* ��������� ��������� ������������ ����� �����, � ������� �������� ���������. */
  );

  PROCEDURE UPSERT_MD_PARAMETERS(
    /*
    ����������:
        ��������� ������������� ��� ��������� (���������� ��� ����������) ����������� ��������� � ���������� ��������.
        � ���������� ��������� ����������� ��� ����������� ���� ������ � ������� ����������.

    ��� ���������:
        API
    */
    p_param_name    IN VARCHAR2, /* �������� ���������  �������� ����� ��������� � ���������� �������� */
    p_param_desc    IN VARCHAR2, /* �������� ��������� �������� �������� ��������� */
    p_datatype_code IN VARCHAR2, /* �������� ��������� �������� ���� ������ ��������� */
    p_patch_code    IN VARCHAR2 DEFAULT NULL  /* ����� ����� */
  );

  PROCEDURE DEL_MD_PARAMETERS(
    /*
        ����������:
            ��������� ������������� ��� ���������� ����������� �������� ���������� � ���������� ��������. ��������� ��������� �������� �� ����� �������������� ��� ��������� �������� ���������� � ��� ���� �� ����� ���� ���������� ���������������� �������� ����������.
            � ���������� ����������� �������� ����������� ������� ACTIVE_FLAG ��� ������ � ������� ���������� �� �����.

        ��� ���������:
            API
    */
    p_param_name IN VARCHAR2, /* �������� ��������� �������� ����� ���������, ������������� � ������� IPC */
    p_patch_code IN VARCHAR2 DEFAULT NULL   /* ����� ����� */
  );

  /*
    ����������:
      ��������� ������������� ��� ��������� (���������� ��� ����������) ���������� ���������� o������� IPC � ������� ���������� ��� �������� � ����������� �� ������ � ���������� �������� ������.
      � ���������� ���������� ����������� ����������� ���� ������ � ������� ����������.
    ��� ���������:
      API
  */
  PROCEDURE UPSERT_MD_IPCOBJPARAMS (
      p_folder_name         IN VARCHAR2 /* �������� ��������� �������� ����� ���������, ������������� � ������� IPC. */
    , p_workflow_name       IN VARCHAR2 /* �������� ��������� �������� �������� ���������. */
    , p_ipcobjtype_code     IN VARCHAR2 DEFAULT 'WORKFLOW' /* �������� ��������� �������� ��� ������� IPC, �� ��������� �������� ����������� ������ ����� ����������.*/
    , p_ipcobject_name      IN VARCHAR2 DEFAULT NULL /* �������� ��������� �������� ���������� ��� ������� IPC, ��� �������� ������������ ������� ������������ �������� ���������.*/
    , p_param_name          IN VARCHAR2 /* ����������� ��� ���������, ��� �������� ������������ ������� ���������� ��������.*/
    , p_loadingmode_code    IN VARCHAR2 DEFAULT 'INCREMENT' /* �������� ��������� �������� ������ ��������, ��� �������� ������������ ������� ���������� ��������. */
    , p_reglamenttype_code  IN VARCHAR2 DEFAULT 'REGULAR_D' /* �������� ��������� �������� ���� ���������� ��������, ��� �������� ������������ ������� ���������� ��������.*/
    , p_paramvaluetype_code IN VARCHAR2 /* ����������� ��� �������� ��������� � ������������ � ��������� �������� DCT_PARAMVALUETYPES. */
    , p_param_value         IN VARCHAR2 /* ����������� �������� ��������� ��� ������� ��� ���������� � ����������� �� ���������� ���� ��������.*/
    , p_logging_flag        IN VARCHAR2 DEFAULT 'Y' /* ����������� ���������� ������� (Y|N), ������� ���������� ������������� ����������� ������������ �������� � ������� LOG_PARAMPREVVALUE. */
    , p_patch_code          IN VARCHAR2 DEFAULT NULL /* ��������� ��������� ������������ ����� �����, � ������� �������� ���������.*/
  );


  PROCEDURE UPSERT_MD_TABLES(
    /*
    ��������� ��������� ���������� ��� ������ �������
    ����������:
      ��������� ������������� ��� ��������� (���������� ��� ����������) ����������� ������ ������ � ���������� ��������
      � ���������� ��������� ����������� ��� ����������� ���� ������ � ����������� ������ �������.
    ��� ���������: API
    */

    p_schema_name IN VARCHAR2, /* �������� ��������� �������� ����� ����� �������, � ������� ��������� �������*/
    p_table_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
    p_table_desc IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� �������� ������� ������� */
    p_patch_code IN VARCHAR2 DEFAULT NULL /* ��������� ��������� ������������ ����� �����, � ������� �������� ���������.*/
  );

  PROCEDURE REMOVE_MD_TABLES(
    /*
    ��������� ����������� �������� ���������� ��� ������� �������
    ����������:
      ��������� ������������� ��� �������� ����������� ������ ������ � ���������� ��������
      � ���������� ��������� ����������� ��� ����������� ���� ������ � ������� ��������� ������ �������
    ��� ���������:
      API
    */
    p_schema_name IN VARCHAR2, /* �������� ��������� �������� ����� ����� �������, � ������� ��������� ������� */
    p_table_name  IN VARCHAR2 /* �������� ��������� �������� SQL-����� ������� ������� */
  );

  PROCEDURE UPSERT_MD_COLUMNS(
    /*
    ��������� ��������� ���������� ��� �������� ������ �������
    ����������:
      ��������� ������������� ��� ���������(���������� ��� ����������) ����������� �������� ������ ������� � ���������� ��������
      � ���������� ��������� ����������� ��� ����������� ������ � ��������� ������ �������
    */
    p_schema_name        IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������, � ������� ��������� ������� */
    p_table_name         IN VARCHAR2,  /* �������� ��������� �������� SQL-����� ������� �������. */
    p_column_name        IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������������/����������� ���� �������. */
    p_deletedkey_flag    IN VARCHAR2, /* �������� ��������� �������� ��� ����������� ����� ���� ��� ����������� ����� ��� �������� */
    p_nvl_flag           IN VARCHAR2, /* �������� ��������� �������� ��� ����������� ����� ���� ��� ����������� ��������� �������������� ����� ������� NVL */
    p_columntype_code    IN VARCHAR2,
    p_default_value      IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� �� ���������, ������������ ��� �������� �������, ������� ������������ ��� ��������� NVL*/
    p_ref_scheme_name    IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� SQL-����� �����, � ������� ��������� �������, �� ������� ��������� ������� */
    p_ref_table_name     IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� SQL-����� �������, �� ������� ��������� ������� */
    p_ref_expression_sql IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� SQL-���������, �������� �������� �������� ��������� ������������ ������� ��� ���������� ���� DM*_STG.KEYBRIDGE.CODE */
    p_insnewkey_flag     IN VARCHAR2 DEFAULT NULL, /* ����, ������� ����������, ��� �� ��������� ������������ ����� ���������� �������� ��������� ��������� ����������� ������ DK */
    p_patch_code         IN NUMBER DEFAULT NULL /* �������� ��������� �������� �������������� ������������ ������, � ������ �������� �����������. */
  );

END API_METADATA;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_METADATA  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.API_METADATA  AS

    /* ��������� ���������� ����������� �������� IPC */

  PROCEDURE UPSERT_MD_IPCOBJECTS(
    p_folder_name       IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC*/
    p_workflow_name     IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
    p_purposetype_code  IN VARCHAR2, /* �������� ��������� �������� ���� ��������������� ���������� ������ IPC*/
    p_ipcobject_desc    IN VARCHAR2 DEFAULT NULL, /* ��������� ��������� ����� ���� ���������� �������� ������ IPC*/
    p_patch_code        IN VARCHAR2
)
  IS
    v_check_flag NUMBER;
  BEGIN

    /*
    1.	�������� ����������:
      a.	���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_IPCOBJECTS�
        �	p_severity_code  = �E�
    */
    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_IPCOBJECTS�
        �	p_severity_code  = �E�
    */

    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;


    /*
      c.	���� p_purposetype_code ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_PURPOSETYPE_CODE �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_IPCOBJECTS�
        �	p_severity_code  = �E�
    */

    IF p_purposetype_code IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '�������� ��������� P_PURPOSETYPE_CODE �� ����� ��������� �������� NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
        P_SEVERITY_CODE  => 'E'
      );
    END IF;


    /*
    2.	���� ������� ������ � ������� MD_IPCOBJECTS, � �������:
      �	FOLDER_NAME   = p_folder_name
      �	WORKFLOW_NAME = p_workflow_name
        �� ����������� ��������� ������ � ������� MD_IPCOBJECTS � ���������� �������� �����:
        �	PURPOSETYPE_CODE = p_purposetype_code
        �	IPCOBJECT_DESC   = p_ipcobject_desc
        �	CHANGE_DATE      = SYSDATE
        �	PATCH_CODE       = p_patch_code
      ����� ����������� ������ � ������� MD_IPCOBJECTS �� ���������� �����:
        �	FOLDER_NAME      = p_folder_name
        �	WORKFLOW_NAME    = p_workflow_name
        �	PURPOSETYPE_CODE = p_purposetype_code
        �	IPCOBJECT_DESC   = p_ipcobject_desc
        �	ACTIVE_FLAG      = �Y�
        �	CHANGE_DATE      = SYSDATE
        �	PATCH_CODE       = p_patch_code
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
    3. ����������� ������������� ���������� ��
    */
    COMMIT;

    /*
    4.	���� ��� ���������� ��������� �������� ����������,
      ��:
      a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_IPCOBJECTS�
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
         P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;

  PROCEDURE DEL_MD_IPCOBJECTS (
    p_folder_name   IN VARCHAR2, /* �������� ��������� �������� ����� IPC, � ������� ����������� ������ IPC */
    p_workflow_name IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
    p_patch_code    IN VARCHAR2 DEFAULT NULL /* ��������� ��������� ������������ ����� �����, � ������� �������� ��������� */
    )
  IS
    v_check_flag NUMBER;
  BEGIN

    /*
    1.	�������� ����������:
      a.	���� P_FOLDER_NAME ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.DEL_MD_IPCOBJECTS�
        �	p_severity_code  = �E�
    */

    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	���� P_WORKFLOW_NAME ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA. DEL_MD_IPCOBJECTS�
        �	p_severity_code  = �E�
    */
    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	���� ������� ������ � ������� MD_IPCOBJECTS, � �������:
      �	FOLDER_NAME = p_folder_name
      �	WORKFLOW_NAME = p_workflow_name
      �� ��� ��� ����������� �������� �����:
        �	ACTIVE_FLAG = �N�
        �	CHANGE_DATE = SYSDATE
      ����� ���������� ��������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �	p_exception_name = �e_metadata_not_found�
        �	p_errmsg_text    = ��� ������ ������ IPC � ������� MD_IPCOBJECTS ��� �������� ����������: P_FOLDER_NAME = [ �+P_FOLDER_NAME+�], P_WORKFLOW_NAME = [�+P_WORKFLOW_NAME+�].�
        �	p_plsqlunit_name = �API_METADATA. DEL_MD_IPCOBJECTS�
        �	p_severity_code  = �W�
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
          P_ERRMSG_TEXT    => '�� ������ ������ IPC � ������� MD_IPCOBJECTS ��� �������� ����������: P_FOLDER_NAME = [' ||
                               p_folder_name || '],P_WORKFLOW_NAME=' || p_workflow_name || '].',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJECTS',
          P_SEVERITY_CODE  => 'W',
          P_SQLERRM_TEXT   => NULL
        );

    END CASE;

    /*
    3. ����������� ������������� ���������� ��
    */

    COMMIT;

    /*
    4.	���� ��� ���������� ��������� �������� ����������,
      ��:
      a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_METADATA.DEL_MD_IPCOBJECTS�
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
         P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJECTS',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;
  END;


    /* ��������� ���������� ����������� ���������� */

  PROCEDURE UPSERT_MD_PARAMETERS(
    p_param_name    IN VARCHAR2, /* �������� ���������  �������� ����� ��������� � ���������� �������� */
    p_param_desc    IN VARCHAR2, /* �������� ��������� �������� �������� ��������� */
    p_datatype_code IN VARCHAR2, /* �������� ��������� �������� ���� ������ ��������� */
    p_patch_code    IN VARCHAR2 DEFAULT NULL  /* ����� ����� */
  )
  IS
    v_check_flag NUMBER;
  BEGIN
    /*
    1.    �������� ����������:
      a.    ���� P_PARAM_NAME ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        -    P_EXCEPTION_CODE = -20101
        -    P_ERRMSG_TEXT = ��������� ��������� P_PARAM_NAME �� ����� ��������� �������� NULL�
        -    P_PLSQLUNIT_NAME = �API_METADATA. UPSERT_MD_PARAMETERS�
        -    P_SEVERITY_CODE = �E�
    2.    ���� ������� ������ � ������� MD_PARAMETERS, � �������:
      -    PARAM_NAME = P_PARAM_NAME
       �� ����������� ��������� UPD_MD_PARAMETERS � �����������:
      -    P_PARAM_NAME = P_PARAM_NAME
      -    P_PARAM_DESC = P_PARAM_DESC
      -    P_DATATYPE_CODE = P_DATATYPE_CODE
        ����� ����������� ��������� INS_MD_PARAMETERS � �����������:
      -    P_PARAM_NAME = P_PARAM_NAME
      -    P_PARAM_DESC = P_PARAM_DESC
      -    P_DATATYPE_CODE = P_DATATYPE_CODE

    3.    ����������� ������������� ���������� ��
    4.    ���� ��� ���������� ��������� �������� ����������,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
      -    P_EXCEPTION_CODE = SQLCODE
      -    P_ERRMSG_TEXT = ���������� �������
      -    P_PLSQLUNIT_NAME = �API_METADATA. UPSERT_MD_PARAMETERS�
      -    P_SEVERITY_CODE = �E�
      -    P_SQLERRM_TEXT = SQLERRM
    */


    /*
    1.	�������� ����������:
      a.	���� p_param_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_PARAM_NAME �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_PARAMETERS�
        �	p_severity_code  = �E�
    */

    IF p_param_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_param_name �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_PARAMETERS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
     2.	���� ������� ������ � ������� MD_PARAMETERS, � ������� PARAM_NAME = p_param_name
      �� ����������� ��������� ������ � ������� MD_PARAMETERS � ���������� �������� �����:
        �	PARAM_DESC    = p_param_desc
        �	DATATYPE_CODE = p_datatype_code
        �	CHANGE_DATE   = SYSDATE
        �	PATCH_CODE    = p_patch_code
      ����� ����������� ������ � ������� MD_PARAMETERS �� ���������� �����:
        �	PARAM_NAME    = p_param_name
        �	PARAM_NAME    = p_param_desc
        �	DATATYPE_CODE = p_datatype_code
        �	ACTIVE_FLAG   = �Y�
        �	CHANGE_DATE   = SYSDATE
        �	P_PATCH_CODE  = p_patch_code
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
        /* 1.2 ����������� ������ � ������� MD_PARAMETERS */
        INSERT INTO MD_PARAMETERS
                   (PARAM_NAME, PARAM_DESC, DATATYPE_CODE, ACTIVE_FLAG, CHANGE_DATE, PATCH_CODE)
            VALUES (p_param_name, p_param_desc, p_datatype_code, 'Y', SYSDATE, p_patch_code);

    ELSIF v_check_flag = 1 THEN
        /* 2. ����������� ������ � ������� MD_PARAMETERS */
          UPDATE MD_PARAMETERS
             SET PARAM_DESC     = nvl(p_param_desc, PARAM_DESC),
                 DATATYPE_CODE  = nvl(p_datatype_code, DATATYPE_CODE),
                 CHANGE_DATE    = SYSDATE,
                 PATCH_CODE     = nvl(p_patch_code, PATCH_CODE)
           WHERE PARAM_NAME     = p_param_name;
    END IF;

    /*
    3.	����������� ������������� ���������� ��
    */

    COMMIT;


    /*
    4.	���� ��� ���������� ��������� �������� ����������,
      ��:
      a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_PARAMETERS�
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
         P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_PARAMETERS',
         P_SEVERITY_CODE  => 'S',
         P_SQLERRM_TEXT   => SQLERRM
       );
    END IF;
    RAISE;

  END;

  PROCEDURE DEL_MD_PARAMETERS(
    p_param_name IN VARCHAR2, /* �������� ��������� �������� ����� ���������, ������������� � ������� IPC */
    p_patch_code IN VARCHAR2 DEFAULT NULL   /* ����� ����� */
  )
  IS
  BEGIN
    /*
    1.	�������� ����������:
      a.	���� P_PARAM_NAME ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        -	P_EXCEPTION_CODE = -20101
        -	P_ERRMSG_TEXT = ��������� ��������� P_PARAM_NAME �� ����� ��������� �������� NULL�
        -	P_PLSQLUNIT_NAME = �API_METADATA.DEL_MD_PARAMETERS�
        -	P_SEVERITY_CODE = �E�

    2.	����������� ���������� ������ � ������� MD_PARAMETERS, � �������:
      -	PARAM_NAME = P_PARAM_NAME
       � ��������������� �������� �����:
      -	ACTIVE_FLAG = �N�
      -	CHANGE_DATE = SYSDATE
    3.	����������� ������������� ���������� ��
    4.	���� ��� ���������� ��������� �������� ����������,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
      -	P_EXCEPTION_CODE = SQLCODE
      -	P_ERRMSG_TEXT = ���������� �������
      -	P_PLSQLUNIT_NAME = �API_METADATA. DEL_MD_PARAMETERS�
      -	P_SEVERITY_CODE = �E�
      -	P_SQLERRM_TEXT = SQLERRM
    */


    /*
    1.	�������� ����������:
      a.	���� p_param_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� P_PARAM_NAME �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.DEL_MD_PARAMETERS�
        �	p_severity_code  = �E�
    */

    IF p_param_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� p_param_name �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    /*
    2.	��� ������ � ������� MD_PARAMETERS, � ������� PARAM_NAME = p_param_name ����������� �������� �����:
      �	ACTIVE_FLAG = �N�
      �	CHANGE_DATE = SYSDATE
      �	PATCH_CODE = p_patch_code
    */

      UPDATE MD_PARAMETERS
         SET ACTIVE_FLAG = 'N',
             CHANGE_DATE = SYSDATE,
             PATCH_CODE = nvl(p_patch_code, PATCH_CODE)
       WHERE PARAM_NAME = p_param_name;

      /* 3. ������������� ���������� */

      COMMIT;


  /* 4. ���� ���������� */

  EXCEPTION
    WHEN OTHERS THEN
    IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
         P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
         P_ERRMSG_TEXT => '��������� ������',
         P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
         P_SEVERITY_CODE => 'S',
         P_SQLERRM_TEXT => SQLERRM
       );
    END IF;
    RAISE;

  END;

  PROCEDURE UPSERT_MD_IPCOBJPARAMS (
      p_folder_name         IN VARCHAR2 /* �������� ��������� �������� ����� ���������, ������������� � ������� IPC. */
    , p_workflow_name       IN VARCHAR2 /* �������� ��������� �������� �������� ���������. */
    , p_ipcobjtype_code     IN VARCHAR2 DEFAULT 'WORKFLOW' /* �������� ��������� �������� ��� ������� IPC, �� ��������� �������� ����������� ������ ����� ����������.*/
    , p_ipcobject_name      IN VARCHAR2 DEFAULT NULL /* �������� ��������� �������� ���������� ��� ������� IPC, ��� �������� ������������ ������� ������������ �������� ���������.*/
    , p_param_name          IN VARCHAR2 /* ����������� ��� ���������, ��� �������� ������������ ������� ���������� ��������.*/
    , p_loadingmode_code    IN VARCHAR2 DEFAULT 'INCREMENT' /* �������� ��������� �������� ������ ��������, ��� �������� ������������ ������� ���������� ��������. */
    , p_reglamenttype_code  IN VARCHAR2 DEFAULT 'REGULAR_D' /* �������� ��������� �������� ���� ���������� ��������, ��� �������� ������������ ������� ���������� ��������.*/
    , p_paramvaluetype_code IN VARCHAR2 /* ����������� ��� �������� ��������� � ������������ � ��������� �������� DCT_PARAMVALUETYPES. */
    , p_param_value         IN VARCHAR2 /* ����������� �������� ��������� ��� ������� ��� ���������� � ����������� �� ���������� ���� ��������.*/
    , p_logging_flag        IN VARCHAR2 DEFAULT 'Y' /* ����������� ���������� ������� (Y|N), ������� ���������� ������������� ����������� ������������ �������� � ������� LOG_PARAMPREVVALUE. */
    , p_patch_code          IN VARCHAR2 DEFAULT NULL /* ��������� ��������� ������������ ����� �����, � ������� �������� ���������.*/

  )
  IS
    v_check_flag NUMBER;
  BEGIN
  /*
      1.  �������� ����������:
        a.  ���� p_folder_name ����� NULL,
            �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
            �  P_EXCEPTION_NAME = �e_paramvalue_empty�
            �  P_ERRMSG_TEXT = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
            �  P_PLSQLUNIT_NAME = �API_METADATA.UPSERT_MD_IPCOBJPARAMS�
            �  P_SEVERITY_CODE = �E�
        b.  ���� p_workflow_name ����� NULL,
            �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
            �  P_EXCEPTION_NAME = �e_paramvalue_empty�
            �  P_ERRMSG_TEXT = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
            �  P_PLSQLUNIT_NAME = �API_METADATA.UPSERT_MD_IPCOBJPARAMS�
            �  P_SEVERITY_CODE = �E�
        c.  ���� p_param_name ����� NULL,
            �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
            �  P_EXCEPTION_NAME = �e_paramvalue_empty�
            �  P_ERRMSG_TEXT = ��������� ��������� P_PARAM_NAME �� ����� ��������� �������� NULL�
            �  P_PLSQLUNIT_NAME = �API_METADATA.UPSERT_MD_IPCOBJPARAMS�
            �  P_SEVERITY_CODE = �E�
        d.  ���� p_paramvaluetype_code ����� NULL,
            �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
            �  P_EXCEPTION_NAME = �e_paramvalue_empty�
            �  P_ERRMSG_TEXT = ��������� ��������� P_PARAMVALUETYPE_CODE �� ����� ��������� �������� NULL�
            �  P_PLSQLUNIT_NAME = �API_METADATA.UPSERT_MD_IPCOBJPARAMS�
            �  P_SEVERITY_CODE = �E�

      2.  ���� ������� ������ � ������� MD_IPCOBJECTS, � �������:
            ?  FOLDER_NAME         = p_folder_name
            ?  WORKFLOW_NAME       = p_workflow_name
            ?  IPCOBJTYPE_CODE     = p_ipcobjtype_code
            ?  IPCOBJECT_NAME      = p_ipcobject_name
            ?  PARAM_NAME          = p_param_name
            ?  LOADINGMODE_CODE    = p_loadingmode_code
            ?  REGLAMENTTYPE_CODE  = p_reglamenttype_code
          �� ����������� ��������� ������ � ������� MD_IPCOBJPARAMS � ���������� �������� �����:
            ?  PARAMVALUETYPE_CODE = p_paramvaluetype_code
            ?  PARAM_VALUE         = p_param_value
            ?  LOGGING_FLAG        = p_logging_flag
            ?  CHANGE_DATE         = SYSDATE
            ?  PATCH_CODE          = p_patch_code
          ����� ����������� ����� ������ � ������� MD_IPCOBJPARAMS �� ���������� �����:
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

      3.  ����������� ������������� ���������� ��
      4.  ���� ��� ���������� ��������� �������� ����������,
          ��:
          a.  ���� SQLCODE �� ������ � �������� [-20999;-20000],
              �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
                ?  P_EXCEPTION_NAME = SQLCODE
                ?  P_ERRMSG_TEXT = ���������� �������
                ?  P_PLSQLUNIT_NAME = �API_METADATA.UPSERT_MD_IPCOBJPARAMS�
                ?  P_SEVERITY_CODE = �S�
                ?  P_SQLERRM_TEXT = SQLERRM
          b.  ���������� ��������� ����������.*/

  /* 1. �������� ���������� */
    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );

    END IF;

    IF p_param_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� P_PARAM_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

  /* 2. �������� ������� ������ � ���������� INSERT ��� UPDATE */
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
        /* 1.1 �������������� �������� ���������� ��� ����������*/
        IF p_paramvaluetype_code IS NULL THEN
          UTL_ERRHANDLERS.RAISE_ERROR(
              P_EXCEPTION_NAME => 'e_paramvalue_empty',
              P_ERRMSG_TEXT => '�������� ��������� P_PARAMVALUETYPE_CODE �� ����� ��������� �������� NULL',
              P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
              P_SEVERITY_CODE => 'E',
              P_SQLERRM_TEXT => NULL
          );
        END IF;

        IF p_param_value IS NULL THEN
          UTL_ERRHANDLERS.RAISE_ERROR(
              P_EXCEPTION_NAME => 'e_paramvalue_empty',
              P_ERRMSG_TEXT => '�������� ��������� P_PARAM_VALUE �� ����� ��������� �������� NULL',
              P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_IPCOBJPARAMS',
              P_SEVERITY_CODE => 'E',
              P_SQLERRM_TEXT => NULL
          );
        END IF;

        /* 1.2 ����������� ������ � ������� MD_IPCOBJPARAMS */
        INSERT INTO MD_IPCOBJPARAMS(
                FOLDER_NAME, WORKFLOW_NAME, IPCOBJTYPE_CODE, IPCOBJECT_NAME, PARAM_NAME, LOADINGMODE_CODE, REGLAMENTTYPE_CODE, PARAMVALUETYPE_CODE, PARAM_VALUE, LOGGING_FLAG, CHANGE_DATE, PATCH_CODE
                )
            VALUES (
                p_folder_name, p_workflow_name, p_ipcobjtype_code, p_ipcobject_name, p_param_name, p_loadingmode_code, p_reglamenttype_code, p_paramvaluetype_code, p_param_value, p_logging_flag, SYSDATE, p_patch_code
                );

    ELSIF v_check_flag = 1 THEN
        /* 2. ����������� ������ � ������� MD_IPCOBJPARAMS */
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

  /* 3. ������������� ���������� */
    COMMIT;

  /* 4. ���� ���������� */

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '��������� ������',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;
  END;

  PROCEDURE DEL_MD_IPCOBJPARAMS(
        p_folder_name         IN VARCHAR2 /* �������� ��������� �������� ����� ���������, ������������� � ������� IPC. */
      , p_workflow_name       IN VARCHAR2 /* �������� ��������� �������� �������� ���������. */
      , p_ipcobjtype_code     IN VARCHAR2 /* �������� ��������� �������� ��� ������� IPC, �� ��������� �������� ����������� ������ ����� ����������. */
      , p_ipcobject_name      IN VARCHAR2 /* �������� ��������� �������� ���������� ��� ������� IPC, ��� �������� ������������ ������� ������������ �������� ���������. */
      , p_param_name          IN VARCHAR2 /* ����������� ��� ���������, ��� �������� ������������ ������� ���������� ��������. */
      , p_loadingmode_code    IN VARCHAR2 /* �������� ��������� �������� ������ ��������, ��� �������� ������������ ������� ���������� ��������.  */
      , p_reglamenttype_code  IN VARCHAR2 /* �������� ��������� �������� ���� ���������� ��������, ��� �������� ������������ ������� ���������� ��������. */
    )
  IS
  BEGIN

  /* 1. �������� ���������� */
    IF p_folder_name IS NULL  THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_workflow_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );

    END IF;
    IF p_ipcobjtype_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� P_IPCOBJTYPE_CODE �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_param_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� P_PARAM_NAME �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_loadingmode_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� P_LOADINGMODE_CODE �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

    IF p_reglamenttype_code IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT => '�������� ��������� P_REGLAMENTTYPE_CODE �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_IPCOBJPARAMS',
          P_SEVERITY_CODE => 'E',
          P_SQLERRM_TEXT => NULL
      );
    END IF;

  /* 2. �������� ���������� ��������� */
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

  /* 3. ������������� ���������� */
    COMMIT;

  /* 4. ���� ���������� */
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '��������� ������',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;
  END;



    PROCEDURE UPSERT_MD_TABLES(
    /*
    ��������� ��������� ���������� ��� ������ �������
    ����������:
      ��������� ������������� ��� ��������� (���������� ��� ����������) ����������� ������ ������ � ���������� ��������
      � ���������� ��������� ����������� ��� ����������� ���� ������ � ����������� ������ �������.
    ��� ���������: API
    */

    p_schema_name IN VARCHAR2, /* �������� ��������� �������� ����� ����� �������, � ������� ��������� �������*/
    p_table_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
    p_table_desc IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� �������� ������� ������� */
    p_patch_code          IN VARCHAR2 DEFAULT NULL /* ��������� ��������� ������������ ����� �����, � ������� �������� ���������.*/
  )
  IS

      v_check_flag INTEGER;

  BEGIN
    /*
    1.	�������� ����������:
      a.	���� p_schema_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� p_schema_name �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_TABLES�
        �	p_severity_code  = �E�
    */
    IF p_schema_name IS NULL THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT => '�������� ��������� p_schema_name �� ����� ��������� �������� NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_TABLES',
        P_SEVERITY_CODE => 'E'
      );
    END IF;

    /*
      b.	���� p_table_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� p_table_name �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_TABLES�
        �	p_severity_code  = �E�
    */

    IF p_table_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT => '�������� ��������� p_table_name �� ����� ��������� �������� NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_TABLES',
        P_SEVERITY_CODE => 'E'
      );

      /*
      2.	���� ������� ������ � ������� MD_TABLES, � �������:
      � SCHEMA_NAME   = p_schema_name
      � TABLE_NAME    = p_table_name
        �� ����������� ��������� ������ � ������� MD_TABLES � ���������� �������� �����:
        � TABLE_DESC       = p_table_desc
        � CHANGE_DATE      = SYSDATE
        � PATCH_CODE       = p_patch_code
      ����� ����������� ������ � ������� MD_TABLES �� ���������� �����:
      � SCHEMA_NAME      = p_schema_name
      � TABLE_NAME       = p_table_name
      � TABLE_DESC       = p_table_desc
      � CHANGE_DATE      = SYSDATE
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
    3.	����������� ������������� ���������� ��
    */
    COMMIT;

    /*
    4.	���� ��� ���������� ��������� �������� ����������,
    ��:
      a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_TABLES�
        �	p_severity_code  = �S�
        �	p_sqlerrm_text   = SQLERRM
      b.	���������� ��������� ����������
    */

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '��������� ������',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;
  END;


  PROCEDURE REMOVE_MD_TABLES(
    /*
    ��������� ����������� �������� ���������� ��� ������� �������
    ����������:
      ��������� ������������� ��� �������� ����������� ������ ������ � ���������� ��������
      � ���������� ��������� ����������� ��� ����������� ���� ������ � ������� ��������� ������ �������
    ��� ���������:
      API
    */
    p_schema_name IN VARCHAR2, /* �������� ��������� �������� ����� ����� �������, � ������� ��������� ������� */
    p_table_name IN VARCHAR2 /* �������� ��������� �������� SQL-����� ������� ������� */
  )
  IS
  BEGIN
    /*
    1.	�������� ����������:
      a.	���� p_schema_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� p_schema_name �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.REMOVE_MD_TABLES�
        �	p_severity_code  = �E�
    */

    IF p_schema_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '�������� ��������� p_schema_name �� ����� ��������� �������� NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.REMOVE_MD_TABLES',
        P_SEVERITY_CODE  => 'E'
      );
    END IF;
    /*
      b.	���� p_table_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� p_table_name �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.REMOVE_MD_TABLES�
        �	p_severity_code  = �E�
    */

    IF p_table_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '�������� ��������� p_table_name �� ����� ��������� �������� NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.REMOVE_MD_TABLES',
        P_SEVERITY_CODE  => 'E'
      );
    END IF;

    /*
    2.	��������� ������ �� ������� MD_COLUMNS, � �������:
      �	SCHEMA_NAME   = p_schema_name
      �	TABLE_NAME    = p_table_name
    */

    DELETE
      FROM MD_COLUMNS
     WHERE SCHEMA_NAME = p_schema_name
       AND TABLE_NAME  = p_table_name;

    /*
    3.	��������� ������ �� ������� MD_TABLES, � �������:
      �	SCHEMA_NAME   = p_schema_name
      �	TABLE_NAME    = p_table_name
    */

    DELETE
      FROM MD_TABLES
     WHERE SCHEMA_NAME = p_schema_name
       AND TABLE_NAME  = p_table_name;

    /*
    4.	����������� ������������� ���������� ��
    */

    COMMIT;

    /*
    5.	���� ��� ���������� ��������� �������� ����������,
    ��:
    a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
    �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
      �	p_exception_name = SQLCODE
      �	p_errmsg_text    = ���������� �������
      �	p_plsqlunit_name = �API_METADATA.REMOVE_MD_TABLES�
      �	p_severity_code  = �S�
      �	p_sqlerrm_text   = SQLERRM
    b.	���������� ��������� ����������.
    */

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '��������� ������',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;

  END;


  PROCEDURE UPSERT_MD_COLUMNS(
    /*
    ��������� ��������� ���������� ��� �������� ������ �������
    ����������:
      ��������� ������������� ��� ���������(���������� ��� ����������) ����������� �������� ������ ������� � ���������� ��������
      � ���������� ��������� ����������� ��� ����������� ������ � ��������� ������ �������
    */
    p_schema_name        IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������, � ������� ��������� ������� */
    p_table_name         IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� �������. */
    p_column_name        IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������������/����������� ���� �������. */
    p_deletedkey_flag    IN VARCHAR2, /* �������� ��������� �������� ��� ����������� ����� ���� ��� ����������� ����� ��� �������� */
    p_nvl_flag           IN VARCHAR2, /* �������� ��������� �������� ��� ����������� ����� ���� ��� ����������� ��������� �������������� ����� ������� NVL */
    p_columntype_code    IN VARCHAR2,
    p_default_value      IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� �� ���������, ������������ ��� �������� �������, ������� ������������ ��� ��������� NVL*/
    p_ref_scheme_name    IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� SQL-����� �����, � ������� ��������� �������, �� ������� ��������� ������� */
    p_ref_table_name     IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� SQL-����� �������, �� ������� ��������� ������� */
    p_ref_expression_sql IN VARCHAR2 DEFAULT NULL, /* �������� ��������� �������� SQL-���������, �������� �������� �������� ��������� ������������ ������� ��� ���������� ���� DM*_STG.KEYBRIDGE.CODE */
    p_insnewkey_flag     IN VARCHAR2 DEFAULT NULL, /* ����, ������� ����������, ��� �� ��������� ������������ ����� ���������� �������� ��������� ��������� ����������� ������ DK */
    p_patch_code         IN NUMBER DEFAULT NULL    /* �������� ��������� �������� �������������� ������������ ������, � ������ �������� �����������. */
  )
  IS
    v_check_flag NUMBER;
  BEGIN
    /*
    1.	�������� ����������:
      a.	���� p_schema_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� p_schema_name �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_COLUMNS�
        �	p_severity_code  = �E�
    */
    IF p_schema_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '�������� ��������� p_schema_name �� ����� ��������� �������� NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      b.	���� p_table_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = �e_paramvalue_empty�
        �	p_errmsg_text    = ��������� ��������� p_table_name �� ����� ��������� �������� NULL�
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_COLUMNS�
        �	p_severity_code  = �E�
    */

    IF p_table_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '�������� ��������� p_table_name �� ����� ��������� �������� NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
        c.	���� p_column_name ����� NULL,
          �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
          � p_exception_name = �e_paramvalue_empty�
          � p_errmsg_text    = ��������� ��������� p_column_name �� ����� ��������� �������� NULL�
          � p_plsqlunit_name = �API_METADATA.UPSERT_MD_COLUMNS�
          � p_severity_code  = �E�
    */

    IF p_column_name IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '�������� ��������� p_column_name �� ����� ��������� �������� NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      e.	���� p_deletedkey_flag ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� p_deletedkey_flag �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_METADATA.UPSERT_MD_COLUMNS�
        � p_severity_code  = �E�
    */

    IF p_deletedkey_flag IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
          P_EXCEPTION_NAME => 'e_paramvalue_empty',
          P_ERRMSG_TEXT    => '�������� ��������� p_deletedkey_flag �� ����� ��������� �������� NULL',
          P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
          P_SEVERITY_CODE  => 'E',
          P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
      f. ���� p_nvl_flag ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� p_nvl_flag �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_METADATA.UPSERT_MD_COLUMNS�
        � p_severity_code  = �E�
    */

    IF p_nvl_flag IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '�������� ��������� p_nvl_flag �� ����� ��������� �������� NULL',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
        g.	���� p_nvl_flag = �Y� � p_default_value ����� NULL,
          �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
          � p_exception_name = �e_paramvalue_empty�
          � p_errmsg_text    = ��������� ��������� p_default_value �� ����� ��������� �������� NULL, ��� ��� ��� �������� ���������� ��������� NULL �������� (P_NVL_FLAG = [Y])�
          � p_plsqlunit_name = �API_METADATA.UPSERT_MD_COLUMNS�
          � p_severity_code  = �E�

    */

    IF p_nvl_flag = 'Y' and p_default_value IS NULL
      THEN
      UTL_ERRHANDLERS.RAISE_ERROR(
        P_EXCEPTION_NAME => 'e_paramvalue_empty',
        P_ERRMSG_TEXT    => '�������� ��������� p_default_value �� ����� ��������� �������� NULL, ��� ��� ��� �������� ���������� ��������� NULL �������� (P_NVL_FLAG = [Y])',
        P_PLSQLUNIT_NAME => 'API_METADATA.UPSERT_MD_COLUMNS',
        P_SEVERITY_CODE  => 'E',
        P_SQLERRM_TEXT   => NULL
      );
    END IF;

    /*
    2.	���� ������� ������ � ������� MD_COLUMNS, � �������:
      � SCHEMA_NAME   = p_schema_name
      � TABLE_NAME    = p_table_name
      � COLUMN_NAME   = p_column_name
        �� ����������� ��������� ������ � ������� MD_COLUMNS � ���������� �������� �����:
        � COLUMNTYPE_CODE    = p_columntype_code
        � DELETEDKEY_FLAG    = p_deletedkey_flag
        � NVL_FLAG           = p_nvl_flag
        � DEFAULT_VALUE      = p_default_value
        � REF_SCHEME_NAME    = p_ref_scheme_name
        � REF_TABLE_NAME     = p_ref_table_name
        � REF_EXPRESSION_SQL = p_ref_expression_sql
        � INSNEWKEY_FLAG     = p_insnewkey_flag
        � CHANGE_DATE        = SYSDATE
        � PATCH_CODE         = p_patch_code
    ����� ����������� ������ � ������� MD_TABLES �� ���������� �����:
      � SCHEMA_NAME        = p_schema_name
      � TABLE_NAME         = p_table_name
      � COLUMN_NAME        = p_column_name
      � COLUMNTYPE_CODE    = p_columntype_code
      � DELETEDKEY_FLAG    = p_deletedkey_flag
      � NVL_FLAG           = p_nvl_flag
      � DEFAULT_VALUE      = p_default_value
      � REF_SCHEME_NAME    = p_ref_scheme_name
      � REF_TABLE_NAME     = p_ref_table_name
      � REF_EXPRESSION_SQL = p_ref_expression_sql
      � INSNEWKEY_FLAG     = p_insnewkey_flag
      � CHANGE_DATE        = SYSDATE
      � PATCH_CODE         = p_patch_code
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
    3.	����������� ������������� ���������� ��
    */

    COMMIT;

    /*
    4.	���� ��� ���������� ��������� �������� ����������,
      ��:
      a.	���� SQLCODE �� ������ � �������� [-20999;-20000],
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR  � �����������:
        �	p_exception_name = SQLCODE
        �	p_errmsg_text    = ���������� �������
        �	p_plsqlunit_name = �API_METADATA.UPSERT_MD_COLUMNS�
        �	p_severity_code  = �S�
        �	p_sqlerrm_text   = SQLERRM
      b.	���������� ��������� ����������.
    */

  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE NOT BETWEEN -20999 AND -20000 THEN
        UTL_ERRHANDLERS.RAISE_ERROR(
           P_EXCEPTION_NAME => TO_CHAR(SQLCODE),
           P_ERRMSG_TEXT => '��������� ������',
           P_PLSQLUNIT_NAME => 'API_METADATA.DEL_MD_PARAMETERS',
           P_SEVERITY_CODE => 'S',
           P_SQLERRM_TEXT => SQLERRM
         );
      END IF;
      RAISE;

  END;

END API_METADATA;
/