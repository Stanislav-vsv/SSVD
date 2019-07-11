/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_UPLOAD  (Package) 
--
CREATE OR REPLACE PACKAGE EDSC_META.API_UPLOAD
AUTHID CURRENT_USER
AS

  TYPE hash_aat IS TABLE OF VARCHAR2(32767)  -- Associative array type
       INDEX BY VARCHAR2(32767);

  v_debug_mode BOOLEAN := FALSE;

  /* ��������� ��� ������� ��������, ����� ������ ���������� �� ��� �����. � ������� ��������� ����������� ������� ��������
   ��� ��-��� ����� � �������������� �������  */

  PROCEDURE TRUNC_TABLE(
    p_shema_name IN VARCHAR2,
    p_table_name IN VARCHAR2
  );

  PROCEDURE TRUNC_TABLE_PARTITION(
    p_shema_name     IN VARCHAR2,
    p_table_name     IN VARCHAR2,
    p_partition_name IN VARCHAR2
  );

  PROCEDURE DEL_TABLE(
    p_shema_name IN VARCHAR2,
    p_table_name IN VARCHAR2
  );

  PROCEDURE NONUNIQUE_INDEX_UNUSE(
    p_schema_name IN VARCHAR2 DEFAULT USER,
    p_table_name  IN VARCHAR2,
    p_start_date  IN DATE DEFAULT NULL,
    p_end_date    IN DATE DEFAULT NULL
  );

  PROCEDURE NONUNIQUE_INDEX_REBUILD(
    p_schema_name IN VARCHAR2 DEFAULT USER,
    p_table_name  IN VARCHAR2,
    p_start_date  IN DATE DEFAULT NULL,
    p_end_date    IN DATE DEFAULT NULL
  );


  PROCEDURE TRUNC_PARTITIONS(
    p_schema_name   IN VARCHAR2 DEFAULT user,
    p_table_name    IN VARCHAR2,
    p_start_date    IN DATE,
    p_end_date      IN DATE,
    p_partition_fmt IN VARCHAR2
  );

  /* ��������� ��� ������� �����������, ����� ������ ���������� �� ��� �����. � ������� ��������� ����������� ������� ��������
   ��� ��-��� ����� � �������������� �������  */
  PROCEDURE TRUNC_SUBPARTITION(
    p_schema_name       IN VARCHAR2 DEFAULT user,
    p_table_name        IN VARCHAR2,
    p_start_date        IN DATE,
    p_end_date          IN DATE,
    p_partition_fmt     IN VARCHAR2,
    p_subpartition_name IN VARCHAR2
  );
  
  PROCEDURE EXECUTE_QUERY(
      p_folder_name       IN VARCHAR2    /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
    , p_workflow_name     IN VARCHAR2  /* �������� ��������� �������� ����� ������ IPC */
    , p_procedure_name    IN VARCHAR2  /* �������� ��������� �������� ����� ���������, � ������� ����������� ������������ SQL-������ */
    , p_targettable_name  IN VARCHAR2
    , p_job_id            IN NUMBER   /* �������� ��������� �������� �������������� ���������� ������� ETL-��������, � ������� ������� ��������� ����������� � ����������� Dynamic SQL. */
    , p_sql_text          IN CLOB       /* �������� ��������� ����� ������������� SQL-�������, ������� ����������� � ������ ���� ��� ����� ����� ���������. */
    );

  /* ��������� ��� ������ � ��������� */
  PROCEDURE get_template(p_proc_template_name IN VARCHAR2, p_variables IN hash_aat, o_clob OUT CLOB);
  PROCEDURE get_template_variable(p_proc_template_name IN VARCHAR2, p_variables IN hash_aat, o_clob OUT CLOB);
  PROCEDURE get_sql_stmt(p_proc_template_name IN VARCHAR2, p_variables IN hash_aat, o_clob OUT CLOB);
  PROCEDURE get_sql_stmt(p_template_name IN VARCHAR2, p_variables IN hash_aat, o_clob OUT CLOB);

  PROCEDURE REPLACE_SDIM(
  /*
    ����������:
    ��������� ������������� ��� �������������� ������� � �������� ������� ������������
      (*SDIM, *LDIM, *LOV) ������� ���������� � ������� � ����������� ���� ������������.
    ��������� ������ �������� � ���� ������ ������������ ������������: ������ �������� �
     ������ ������ �� ������ DMDELTA ��� ���������������� �����������.
    ��������� ������������ � ������ ��������� ����������.
    ��� ���������: API
  */
    p_folder_name        IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC*/
    p_workflow_name      IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
    p_source_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
    p_source_table_name  IN VARCHAR2, /* �������� ��������� �������� SQL-����� �������-��������� */
    p_target_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
    p_target_table_name  IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
    p_job_id             IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
    p_as_of_day          IN DATE DEFAULT SYSDATE /* �������� ��������� �������� ���� ���������� ���������������� ���� */
  );

  PROCEDURE REPLACE_STRAN(
  /*
    ����������:
    ��������� ������������� ��� �������������� ������� � �������� ������ ���� *STRAN
     ������� ���������� � ������� � ����������� ���� ������������.
    ��������� ������ �������� � ���� ������������ � ��������������� �������� ������ �� ������.
    ��� ���������: API
   */
    p_folder_name        IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
    p_workflow_name      IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
    p_source_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
    p_source_table_name  IN VARCHAR2, /* �������� ��������� �������� SQL-����� �������-��������� */
    p_target_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
    p_target_table_name  IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
    p_column_date        IN VARCHAR2 DEFAULT 'VALUE_DAY', /* �������� ��������� �������� SQL-����� ����, �� ��������� �������� �������������� ����������� �������� */
    p_start_date         IN DATE DEFAULT NULL, /* �������� ��������� �������� ���� ������ �������, � ������� ������������ ����� ������ �� �������-��������� */
    p_end_date           IN DATE DEFAULT NULL, /* �������� ��������� �������� ���� ��������� �������, �� ������� ������������ ����� ������ �� �������-��������� */
    p_partition_fmt      IN VARCHAR2 DEFAULT 'yyyymmdd', /* �������� ��������� �������� ������� ������������� ��� ��� ����������� ����� �������� */
    p_truncate_table     IN NUMBER DEFAULT 0, /* �������� ��������� �������� �������� ������ ������� ������� ��� �������������� ��������: 1 - ���������, 0 - �� ��������� */
    p_job_id             IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
    p_as_of_day          IN DATE DEFAULT SYSDATE /* �������� ��������� �������� ���� ���������� ���������������� ���� */
  );


  PROCEDURE REPLACE_SSTAT(
  /*
    ����������:
    ��������� ������������� ��� �������������� ������� � �������� ������ ���� *SSTAT
      ������� ���������� � ������� � ����������� ���� ������������
    ��������� ������ �������� � ���� ������������ � ��������������� �������� ������ �� ��������� ������.
    ��� ���������: API
  */
    p_folder_name        IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC*/
    p_workflow_name      IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
    p_source_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
    p_source_table_name  IN VARCHAR2, /* �������� ������� �������� SQL-����� �������-��������� */
    p_target_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
    p_target_table_name  IN VARCHAR2,  /* �������� ��������� �������� SQL-����� ������� ������� */
    p_column_date        IN VARCHAR2 DEFAULT 'VALUE_DAY',
    p_start_date         IN DATE DEFAULT NULL, /* �������� ��������� �������� ���� ������ ������� ������ */
    p_end_date           IN DATE DEFAULT NULL , /* �������� ��������� �������� ���� ��������� ������� ������ */
    p_truncate_table     IN NUMBER DEFAULT 0, /* �������� ��������� �������� �������� ������ ������� ������� ��� �������������� ��������: 1 - ���������, 0 - �� ��������� */
    p_partition_fmt      IN VARCHAR2 DEFAULT 'yyyymmdd', /* �������� ��������� �������� ������� ������������� ��� ��� ����������� ����� �������� */
    p_job_id             IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
    p_as_of_day          IN DATE DEFAULT SYSDATE  /* �������� ��������� �������� ���� ���������� ���������������� ���� */
  );

  PROCEDURE REPLACE_SAGG(
  /*
    ����������:
    ��������� ������������� ��� �������������� ������� � �������� ������ ���� *SAGG
      ������� ���������� � ������� � ����������� ���� ������������.
    ��������� ������ �������� � ���� ������������ � ��������������� �������� ������ �� ��������� ������.
    ��� ���������: API
  */
    p_folder_name        IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC*/
    p_workflow_name      IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
    p_source_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
    p_source_table_name  IN VARCHAR2, /* �������� ������� �������� SQL-����� �������-��������� */
    p_target_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
    p_target_table_name  IN VARCHAR2,  /* �������� ��������� �������� SQL-����� ������� ������� */
    p_column_date        IN VARCHAR2, /* �������� ��������� ��� �������� �������, ������� ���������� ���� ������ */
    p_start_date         IN DATE, /* �������� ��������� �������� ���� ������ ������� ������ */
    p_end_date           IN DATE, /* �������� ��������� �������� ���� ��������� ������� ������ */
    p_truncate_table     IN NUMBER DEFAULT 0, /* �������� ��������� �������� �������� ������ ������� ������� ��� �������������� ��������: 1 - ���������, 0 - �� ��������� */
    p_partition_fmt      IN VARCHAR2 DEFAULT 'yyyymmdd', /* �������� ��������� �������� ������� ������������� ��� ��� ����������� ����� �������� */
    p_job_id             IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
    p_as_of_day          IN DATE DEFAULT SYSDATE  /* �������� ��������� �������� ���� ���������� ���������������� ���� */
  );

  PROCEDURE MERGE_DIM2SDIM(
  /*
    ����������:
    ��������� ������������� ��� ������������� ������� � ��������������� �������� ������ ���� *DIM ������� ����������
      � ������� � ��������������� ���� *DIM � *SDIM
    ��������� ����������� � ������ ��������� ����������.
    ��� ���������: API
  */
    p_folder_name IN VARCHAR2,        /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
    p_workflow_name      IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
    p_source_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
    p_source_table_name  IN VARCHAR2, /* �������� ��������� �������� SQL-����� �������-��������� */
    p_target_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
    p_target_table_name  IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
    p_job_id             IN NUMBER,   /* �������� ��������� �������� �������������� ���������� ������� ETL */
    p_as_of_day          IN DATE DEFAULT SYSDATE,      /* �������� ��������� �������� ���� ���������� ���������������� ���� */
    p_loading_mode       IN VARCHAR2  /* �������� ��������� �������� ������ ��������: INITIAL ��� INCREMENT */
  );

  PROCEDURE MERGE_STAT2HIST(
  /*
    ����������:
    ��������� ������������� ��� ������������� ������� � ��������������� �������� ������ ���� *DIM ������� ����������
      � ������� � ��������������� ���� *STAT � *HIST
    ��������� ����������� � ������ ��������� ����������.
    ��� ���������: API
  */
    p_folder_name        IN VARCHAR2,        /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
    p_workflow_name      IN VARCHAR2,      /* �������� ��������� �������� ����� ������ IPC */
    p_source_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
    p_source_table_name  IN VARCHAR2,  /* �������� ��������� �������� SQL-����� �������-��������� */
    p_target_schema_name IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
    p_target_table_name  IN VARCHAR2,  /* �������� ��������� �������� SQL-����� ������� ������� */
    p_start_date         IN DATE,
    p_end_date           IN DATE,
    p_job_id             IN NUMBER,               /* �������� ��������� �������� �������������� ���������� ������� ETL */
    p_as_of_day          IN DATE DEFAULT SYSDATE,      /* �������� ��������� �������� ���� ���������� ���������������� ���� */
    p_loading_mode       IN VARCHAR2        /* �������� ��������� �������� ������ ��������: INITIAL ��� INCREMENT */
  );

  PROCEDURE COMPLEX_SHIST(
    p_folder_name  IN VARCHAR2,
    p_workflow_name IN VARCHAR2,
    p_source_schema_name IN VARCHAR2,
    p_source_table_name IN VARCHAR2,
    p_target_schema_name IN VARCHAR2,
    p_target_table_name IN VARCHAR2,
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_job_id IN NUMBER,
    p_as_of_day IN DATE DEFAULT SYSDATE,
    p_loading_mode IN VARCHAR2
  );


 PROCEDURE MERGE_ANY2STRAN(
    p_folder_name        IN VARCHAR2,
    p_workflow_name      IN VARCHAR2,
    p_source_schema_name IN VARCHAR2,
    p_source_table_name  IN VARCHAR2, 
    p_target_schema_name IN VARCHAR2, 
    p_target_table_name  IN VARCHAR2, 
    p_job_id             IN NUMBER, 
    p_as_of_day          IN DATE,
    p_loading_mode       IN VARCHAR2
  );

 PROCEDURE UPDATE_MERGE_ANY2STRAN(
    p_folder_name        IN VARCHAR2,
    p_workflow_name      IN VARCHAR2,
    p_source_schema_name IN VARCHAR2,
    p_source_table_name  IN VARCHAR2, 
    p_target_schema_name IN VARCHAR2, 
    p_target_table_name  IN VARCHAR2, 
    p_job_id             IN NUMBER, 
    p_as_of_day          IN DATE,
    p_loading_mode       IN VARCHAR2
  );  
  
PROCEDURE DEL_MERGE_ANY2STRAN(
    p_folder_name        IN VARCHAR2,
    p_workflow_name      IN VARCHAR2,
    p_source_schema_name IN VARCHAR2,
    p_source_table_name  IN VARCHAR2, 
    p_target_schema_name IN VARCHAR2, 
    p_target_table_name  IN VARCHAR2, 
    p_job_id             IN NUMBER, 
    p_as_of_day          IN DATE,
    p_delete_filter      IN VARCHAR2,
    p_loading_mode       IN VARCHAR2
  );

END API_UPLOAD;
/

/* This object may not be sorted properly in the script due to cirular references. */
--
-- API_UPLOAD  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY EDSC_META.API_UPLOAD
AS
   v_variable_of_arrays   hash_aat;

   PROCEDURE print_clob (p_clob IN CLOB)
   AS
      l_offset   NUMBER DEFAULT 1;
   BEGIN
      LOOP
         EXIT WHEN l_offset > DBMS_LOB.getlength (p_clob);
         DBMS_OUTPUT.put_line (DBMS_LOB.SUBSTR (p_clob, 255, l_offset));
         l_offset := l_offset + 255;
      END LOOP;
   END;


   PROCEDURE TRUNC_TABLE (p_shema_name IN VARCHAR2, p_table_name IN VARCHAR2)
   IS
      v_sql   VARCHAR2 (4000);
   BEGIN
      v_sql :=
            'TRUNCATE TABLE '
         || p_shema_name
         || '.'
         || p_table_name
         || ' DROP STORAGE';

      IF NOT v_debug_mode
      THEN
         EXECUTE IMMEDIATE v_sql;
      ELSE
         DBMS_OUTPUT.PUT_LINE (v_sql);
      END IF;
   END;


   PROCEDURE DEL_TABLE (p_shema_name IN VARCHAR2, p_table_name IN VARCHAR2)
   IS
      v_sql   VARCHAR2 (4000);
   BEGIN
      v_sql := 'DELETE ' || p_shema_name || '.' || p_table_name;

      IF NOT v_debug_mode
      THEN
         EXECUTE IMMEDIATE v_sql;
      ELSE
         DBMS_OUTPUT.PUT_LINE (v_sql);
      END IF;
   END;

   PROCEDURE TRUNC_TABLE_PARTITION (p_shema_name        VARCHAR2,
                                    p_table_name        VARCHAR2,
                                    p_partition_name    VARCHAR2)
   IS
   BEGIN
      EXECUTE IMMEDIATE
            'ALTER TABLE '
         || p_shema_name
         || '.'
         || p_table_name
         || ' TRUNCATE PARTITION '
         || p_partition_name;
   END;

   PROCEDURE NONUNIQUE_INDEX_UNUSE (p_schema_name   IN VARCHAR2 DEFAULT USER,
                                    p_table_name    IN VARCHAR2,
                                    p_start_date    IN DATE DEFAULT NULL,
                                    p_end_date      IN DATE DEFAULT NULL)
   IS
      v_index_statement   VARCHAR2 (4000);
      v_index_name        VARCHAR2 (256);
      v_part_name         VARCHAR2 (256);
   BEGIN
      FOR ind
         IN (SELECT INDEX_NAME
               FROM DBA_INDEXES
              WHERE     TABLE_NAME = p_table_name
                    AND OWNER = p_schema_name
                    AND UNIQUENESS = 'NONUNIQUE'
                    AND PARTITIONED = 'NO')
      LOOP
         v_index_statement :=
               'ALTER INDEX '
            || p_schema_name
            || '.'
            || ind.INDEX_NAME
            || ' UNUSABLE';
         DBMS_OUTPUT.PUT_LINE (v_index_statement);

         EXECUTE IMMEDIATE (v_index_statement);
      END LOOP;

      FOR ind
         IN (SELECT i.index_name index_name, ip.partition_name
               FROM DBA_IND_PARTITIONS ip
                    INNER JOIN DBA_INDEXES i ON ip.INDEX_NAME = i.INDEX_NAME
              WHERE     i.TABLE_NAME = p_table_name
                    AND i.OWNER = p_schema_name
                    AND i.UNIQUENESS = 'NONUNIQUE'
                    AND i.PARTITIONED = 'YES'
                    AND ip.PARTITION_NAME NOT LIKE '%M%'
                    AND SUBSTR (RPAD (ip.PARTITION_NAME, 9, '01'), 2) >=
                           CASE
                              WHEN p_start_date IS NOT NULL
                              THEN
                                 TO_CHAR (p_start_date, 'YYYYMMDD')
                              ELSE
                                 '1'
                           END
                    AND SUBSTR (RPAD (ip.PARTITION_NAME, 9, '01'), 2) <=
                           CASE
                              WHEN p_end_date IS NOT NULL
                              THEN
                                 TO_CHAR (p_end_date, 'YYYYMMDD')
                              ELSE
                                 '9'
                           END)
      LOOP
         v_index_name := ind.index_name;
         v_part_name := ind.partition_name;
         v_index_statement :=
               'ALTER INDEX '
            || p_schema_name
            || '.'
            || v_index_name
            || ' MODIFY PARTITION '
            || v_part_name
            || ' UNUSABLE';

         DBMS_OUTPUT.PUT_LINE (v_index_statement);
      --EXECUTE IMMEDIATE (v_index_statement);

      END LOOP;

      FOR ind
         IN (SELECT i.index_name, ip.partition_name
               FROM DBA_IND_PARTITIONS ip
                    JOIN DBA_INDEXES i ON ip.INDEX_NAME = i.INDEX_NAME
              WHERE     i.TABLE_NAME = p_table_name
                    AND i.OWNER = p_schema_name
                    AND i.UNIQUENESS = 'NONUNIQUE'
                    AND i.PARTITIONED = 'YES'
                    AND (   (    ip.PARTITION_NAME = 'PMAX'
                             AND p_end_date IS NULL)
                         OR (    ip.PARTITION_NAME = 'PMIN'
                             AND p_start_date IS NULL)))
      LOOP
         v_index_name := ind.index_name;
         v_part_name := ind.partition_name;
         v_index_statement :=
               'ALTER INDEX '
            || v_index_name
            || ' MODIFY PARTITION '
            || v_part_name
            || 'UNUSABLE';

         IF NOT v_debug_mode
         THEN
            EXECUTE IMMEDIATE v_index_statement;
         ELSE
            DBMS_OUTPUT.PUT_LINE (v_index_statement);
         END IF;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE NOT BETWEEN -20999 AND -20000
         THEN
            UTL_ERRHANDLERS.RAISE_ERROR (
               P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
               P_ERRMSG_TEXT      => '��������� ������',
               P_PLSQLUNIT_NAME   => 'API_METADATA.DEL_MD_PARAMETERS',
               P_SEVERITY_CODE    => 'S',
               P_SQLERRM_TEXT     => SQLERRM);
         END IF;

         RAISE;
   END;


   PROCEDURE NONUNIQUE_INDEX_REBUILD (
      p_schema_name   IN VARCHAR2 DEFAULT USER,
      p_table_name    IN VARCHAR2,
      p_start_date    IN DATE DEFAULT NULL,
      p_end_date      IN DATE DEFAULT NULL)
   IS
      /*
      ��������� ������������� ��� ������������ ������������ ��������
      */

      v_index_statement   VARCHAR2 (32000);
      v_ind_name          VARCHAR2 (256);
      v_part_name         VARCHAR2 (256);
   BEGIN
      FOR ind
         IN (SELECT INDEX_NAME, DEGREE
               FROM DBA_INDEXES
              WHERE     TABLE_NAME = p_table_name
                    AND OWNER = p_schema_name
                    AND UNIQUENESS = 'NONUNIQUE'
                    AND PARTITIONED = 'NO')
      LOOP
         v_index_statement :=
               'ALTER INDEX '
            || p_schema_name
            || '.'
            || ind.INDEX_NAME
            || ' REBUILD PARALLEL '
            || TO_CHAR (TRIM (ind.DEGREE));
         DBMS_OUTPUT.put_line (v_index_statement);
      -- execute immediate (v_index_statement)
      END LOOP;

      FOR ind
         IN (SELECT i.INDEX_NAME, ip.PARTITION_NAME, i.DEGREE
               FROM DBA_IND_PARTITIONS ip
                    JOIN DBA_INDEXES i ON ip.INDEX_NAME = i.INDEX_NAME
              WHERE     i.TABLE_NAME = p_table_name
                    AND i.OWNER = p_schema_name
                    AND i.UNIQUENESS = 'NONUNIQUE'
                    AND i.PARTITIONED = 'YES'
                    AND ip.PARTITION_NAME NOT LIKE '%M%'
                    AND SUBSTR (RPAD (ip.PARTITION_NAME, 9, '01'), 2) >=
                           CASE
                              WHEN p_start_date IS NOT NULL
                              THEN
                                 TO_CHAR (p_start_date, 'yyyymmdd')
                              ELSE
                                 '1'
                           END
                    AND SUBSTR (RPAD (ip.PARTITION_NAME, 9, '01'), 2) <=
                           CASE
                              WHEN p_end_date IS NOT NULL
                              THEN
                                 TO_CHAR (p_end_date, 'yyyymmdd')
                              ELSE
                                 '9'
                           END)
      LOOP
         v_index_statement :=
               'ALTER INDEX '
            || p_schema_name
            || '.'
            || ind.INDEX_NAME
            || ' REBUIILD PARTITION '
            || ind.PARTITION_NAME
            || ' PARALLEL '
            || TO_CHAR (TRIM (ind.DEGREE));
         DBMS_OUTPUT.PUT_LINE (v_index_statement);
      --EXECUTE IMMEDIATE (v_index_statement);
      END LOOP;

      FOR ind
         IN (SELECT i.INDEX_NAME, ip.PARTITION_NAME, i.DEGREE
               FROM DBA_IND_PARTITIONS ip
                    JOIN DBA_INDEXES i ON i.INDEX_NAME = ip.INDEX_NAME
              WHERE     i.TABLE_NAME = p_table_name
                    AND i.OWNER = p_table_name
                    AND i.UNIQUENESS = 'NONUNIQUE'
                    AND i.PARTITIONED = 'YES'
                    AND (   (    ip.PARTITION_NAME = 'PMAX'
                             AND p_end_date IS NULL)
                         OR (    ip.PARTITION_NAME = 'PMIN'
                             AND p_start_date IS NULL)))
      LOOP
         v_index_statement :=
               'ALTER INDEX '
            || p_schema_name
            || '.'
            || ind.INDEX_NAME
            || ' REBUILD PARTITION '
            || ind.PARTITION_NAME
            || ' PARALLEL '
            || TO_CHAR (TRIM (ind.DEGREE));

         IF NOT v_debug_mode
         THEN
            EXECUTE IMMEDIATE v_index_statement;
         ELSE
            DBMS_OUTPUT.PUT_LINE (v_index_statement);
         END IF;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE NOT BETWEEN -20999 AND -20000
         THEN
            UTL_ERRHANDLERS.RAISE_ERROR (
               P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
               P_ERRMSG_TEXT      => '��������� ������',
               P_PLSQLUNIT_NAME   => 'API_METADATA.DEL_MD_PARAMETERS',
               P_SEVERITY_CODE    => 'S',
               P_SQLERRM_TEXT     => SQLERRM);
         END IF;

         RAISE;
   END NONUNIQUE_INDEX_REBUILD;


   PROCEDURE TRUNC_PARTITIONS (p_schema_name     IN VARCHAR2 DEFAULT USER,
                               p_table_name      IN VARCHAR2,
                               p_start_date      IN DATE,
                               p_end_date        IN DATE,
                               p_partition_fmt   IN VARCHAR2)
   IS
      v_trunc_statement   VARCHAR2 (4000);
   BEGIN
      /* ������������ �������� �� ������������ ������� */
      IF p_partition_fmt NOT IN ('yyyymmdd', 'yyyymm')
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_bad',
            P_ERRMSG_TEXT      => '������ �������� ������ ���� yyyymmdd ��� yyyymm',
            P_PLSQLUNIT_NAME   => '<��� ������>.TRUNC_PARTITIONS',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /* ���� ������ - yyyymmdd, �� ������������ ������� ���� ������� ��������, ������� ���������
         ����� p_start_date � p_end_date ������������
      */

      IF p_partition_fmt = 'yyyymmdd'
      THEN
         FOR loop_date
            IN (    SELECT p_start_date + LEVEL - 1 AS dat
                      FROM DUAL
                CONNECT BY LEVEL <=
                              TRUNC (p_end_date) - TRUNC (p_start_date) + 1)
         LOOP
            v_trunc_statement :=
                  'ALTER TABLE '
               || p_schema_name
               || '.'
               || p_table_name
               || ' TRUNCATE PARTITION FOR( TO_DATE('''
               || TO_CHAR (loop_date.dat, 'yyyymmdd')
               || ''', ''yyyymmdd''))';

            --dbms_output.put_line(v_trunc_statement);

            DECLARE
               partition_not_exist   EXCEPTION;
               PRAGMA EXCEPTION_INIT (partition_not_exist, -2149);
            BEGIN
               EXECUTE IMMEDIATE v_trunc_statement;
            EXCEPTION
               WHEN partition_not_exist
               THEN
                  --dbms_output.put_line('No such partition');
                  UTL_ERRHANDLERS.RAISE_ERROR (
                     P_EXCEPTION_NAME   => 'e_complex_error',
                     P_SEVERITY_CODE    => 'W',
                     P_SQLERRM_TEXT     => NULL,
                     P_PLSQLUNIT_NAME   => 'API_UPLOAD.TRUNC_SUBPARTITION',
                     P_ERRMSG_TEXT      => '������� ��������� �����������, ������� �� ����������');
               WHEN OTHERS
               THEN
                  IF SQLCODE NOT BETWEEN -20999 AND -20000
                  THEN
                     UTL_ERRHANDLERS.RAISE_ERROR (
                        P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
                        P_ERRMSG_TEXT      => '��������� ������',
                        P_PLSQLUNIT_NAME   => 'API_METADATA.DEL_MD_PARAMETERS',
                        P_SEVERITY_CODE    => 'S',
                        P_SQLERRM_TEXT     => SQLERRM);
                  END IF;

                  RAISE;
            END;
         END LOOP;
      END IF;

      /* ���� ������ - yyyymm, �� �������������� ������� ���� �������� ��������, ������� � ������, � �������
         ����� p_start_date � ���������� �������, � ������� ����� p_end_date
      */

      IF p_partition_fmt = 'yyyymm'
      THEN
         FOR loop_date
            IN (    SELECT ADD_MONTHS (TRUNC (LAST_DAY (p_start_date)),
                                       LEVEL - 1)
                              AS dat
                      FROM DUAL
                CONNECT BY LEVEL <=
                                MONTHS_BETWEEN (
                                   TRUNC (LAST_DAY (p_end_date)),
                                   TRUNC (LAST_DAY (p_start_date)))
                              + 1)
         LOOP
            v_trunc_statement :=
                  'ALTER TABLE '
               || p_schema_name
               || '.'
               || p_table_name
               || ' TRUNCATE PARTITION FOR( TO_DATE('''
               || TO_CHAR (loop_date.dat, 'yyyymmdd')
               || ''', ''yyyymmdd''))';

            DECLARE
               partition_not_exist   EXCEPTION;
               PRAGMA EXCEPTION_INIT (partition_not_exist, -2149);
            BEGIN
               EXECUTE IMMEDIATE v_trunc_statement;
            EXCEPTION
               WHEN partition_not_exist
               THEN
                  --dbms_output.put_line('No such partition');
                  UTL_ERRHANDLERS.RAISE_ERROR (
                     P_EXCEPTION_NAME   => 'e_complex_error',
                     P_SEVERITY_CODE    => 'W',
                     P_SQLERRM_TEXT     => NULL,
                     P_PLSQLUNIT_NAME   => 'API_UPLOAD.TRUNC_PARTITION',
                     P_ERRMSG_TEXT      => '������� ��������� �����������, ������� �� ����������');
               WHEN OTHERS
               THEN
                  IF SQLCODE NOT BETWEEN -20999 AND -20000
                  THEN
                     UTL_ERRHANDLERS.RAISE_ERROR (
                        P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
                        P_ERRMSG_TEXT      => '��������� ������',
                        P_PLSQLUNIT_NAME   => 'API_METADATA.DEL_MD_PARAMETERS',
                        P_SEVERITY_CODE    => 'S',
                        P_SQLERRM_TEXT     => SQLERRM);
                  END IF;

                  RAISE;
            END;
         END LOOP;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE NOT BETWEEN -20999 AND -20000
         THEN
            UTL_ERRHANDLERS.RAISE_ERROR (
               P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
               P_ERRMSG_TEXT      => '��������� ������',
               P_PLSQLUNIT_NAME   => 'API_METADATA.DEL_MD_PARAMETERS',
               P_SEVERITY_CODE    => 'S',
               P_SQLERRM_TEXT     => SQLERRM);
         END IF;

         RAISE;
   END;



   PROCEDURE TRUNC_SUBPARTITION (p_schema_name         IN VARCHAR2 DEFAULT USER,
                                 p_table_name          IN VARCHAR2,
                                 p_start_date          IN DATE,
                                 p_end_date            IN DATE,
                                 p_partition_fmt       IN VARCHAR2,
                                 p_subpartition_name   IN VARCHAR2)
   IS
      v_trunc_statement   VARCHAR2 (4000);
   BEGIN
      /* ������������ �������� �� ������������ ������� */
      IF p_partition_fmt NOT IN ('yyyymmdd', 'yyyymm')
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_bad',
            P_ERRMSG_TEXT      => '������ �������� ������ ���� yyyymmdd ��� yyyymm',
            P_PLSQLUNIT_NAME   => '<��� ������>.TRUNC_PARTITIONS',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      IF p_partition_fmt = 'yyyymmdd'
      THEN
         FOR loop_date
            IN (    SELECT p_start_date + LEVEL - 1 AS dat
                      FROM DUAL
                CONNECT BY LEVEL <=
                              TRUNC (p_end_date) - TRUNC (p_start_date) + 1)
         LOOP
            v_trunc_statement :=
                  'ALTER TABLE '
               || p_schema_name
               || '.'
               || p_table_name
               || ' TRUNCATE SUBPARTITION FOR( TO_DATE('''
               || TO_CHAR (loop_date.dat, 'yyyymmdd')
               || ''', ''yyyymmdd''), '''
               || p_subpartition_name
               || ''')';

            --dbms_output.put_line(v_trunc_statement);
            --dbms_output.put_line(v_trunc_statement);

            DECLARE
               partition_not_exist   EXCEPTION;
               PRAGMA EXCEPTION_INIT (partition_not_exist, -2149);
            BEGIN
               EXECUTE IMMEDIATE v_trunc_statement;
            EXCEPTION
               WHEN partition_not_exist
               THEN
                  --dbms_output.put_line('No such partition');
                  UTL_ERRHANDLERS.RAISE_ERROR (
                     P_EXCEPTION_NAME   => 'e_complex_error',
                     P_SEVERITY_CODE    => 'W',
                     P_SQLERRM_TEXT     => NULL,
                     P_PLSQLUNIT_NAME   => 'API_UPLOAD.TRUNC_SUBPARTITION',
                     P_ERRMSG_TEXT      => '������� ��������� �����������, ������� �� ����������');
               WHEN OTHERS
               THEN
                  IF SQLCODE NOT BETWEEN -20999 AND -20000
                  THEN
                     UTL_ERRHANDLERS.RAISE_ERROR (
                        P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
                        P_ERRMSG_TEXT      => '��������� ������',
                        P_PLSQLUNIT_NAME   => 'API_METADATA.DEL_MD_PARAMETERS',
                        P_SEVERITY_CODE    => 'S',
                        P_SQLERRM_TEXT     => SQLERRM);
                  END IF;

                  RAISE;
            END;
         END LOOP;
      END IF;

      /* ���� ������ - yyyymm, �� �������������� ������� ���� �������� ��������, ������� � ������, � �������
         ����� p_start_date � ���������� �������, � ������� ����� p_end_date
      */

      IF p_partition_fmt = 'yyyymm'
      THEN
         FOR loop_date
            IN (    SELECT ADD_MONTHS (TRUNC (LAST_DAY (p_start_date)),
                                       LEVEL - 1)
                              AS dat
                      FROM DUAL
                CONNECT BY LEVEL <=
                                MONTHS_BETWEEN (
                                   TRUNC (LAST_DAY (p_end_date)),
                                   TRUNC (LAST_DAY (p_start_date)))
                              + 1)
         LOOP
            v_trunc_statement :=
                  'ALTER TABLE '
               || p_schema_name
               || '.'
               || p_table_name
               || ' TRUNCATE SUBPARTITION FOR( TO_DATE('''
               || TO_CHAR (loop_date.dat, 'yyyymmdd')
               || ''', ''yyyymmdd''),'''
               || p_subpartition_name
               || ''')';

            DECLARE
               partition_not_exist   EXCEPTION;
               PRAGMA EXCEPTION_INIT (partition_not_exist, -2149);
            BEGIN
               EXECUTE IMMEDIATE v_trunc_statement;
            EXCEPTION
               WHEN partition_not_exist
               THEN
                  --dbms_output.put_line('No such partition');
                  UTL_ERRHANDLERS.RAISE_ERROR (
                     P_EXCEPTION_NAME   => 'e_complex_error',
                     P_SEVERITY_CODE    => 'W',
                     P_SQLERRM_TEXT     => NULL,
                     P_PLSQLUNIT_NAME   => 'API_UPLOAD.TRUNC_SUBPARTITION',
                     P_ERRMSG_TEXT      => '������� ��������� ��������, ������� �� ����������');
               WHEN OTHERS
               THEN
                  IF SQLCODE NOT BETWEEN -20999 AND -20000
                  THEN
                     UTL_ERRHANDLERS.RAISE_ERROR (
                        P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
                        P_ERRMSG_TEXT      => '��������� ������',
                        P_PLSQLUNIT_NAME   => 'API_METADATA.DEL_MD_PARAMETERS',
                        P_SEVERITY_CODE    => 'S',
                        P_SQLERRM_TEXT     => SQLERRM);
                  END IF;

                  RAISE;
            END;
         END LOOP;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE NOT BETWEEN -20999 AND -20000
         THEN
            UTL_ERRHANDLERS.RAISE_ERROR (
               P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
               P_ERRMSG_TEXT      => '��������� ������',
               P_PLSQLUNIT_NAME   => 'API_METADATA.DEL_MD_PARAMETERS',
               P_SEVERITY_CODE    => 'S',
               P_SQLERRM_TEXT     => SQLERRM);
         END IF;

         RAISE;
   END;

   PROCEDURE EXECUTE_QUERY (p_folder_name        IN VARCHAR2 /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
                                                            ,
                            p_workflow_name      IN VARCHAR2 /* �������� ��������� �������� ����� ������ IPC */
                                                            ,
                            p_procedure_name     IN VARCHAR2 /* �������� ��������� �������� ����� ���������, � ������� ����������� ������������ SQL-������ */
                                                            ,
                            p_targettable_name   IN VARCHAR2,
                            p_job_id             IN NUMBER /* �������� ��������� �������� �������������� ���������� ������� ETL-��������, � ������� ������� ��������� ����������� � ����������� Dynamic SQL. */
                                                          ,
                            p_sql_text           IN CLOB /* �������� ��������� ����� ������������� SQL-�������, ������� ����������� � ������ ���� ��� ����� ����� ���������. */
                                                        )
   IS
      v_start_dttm   DATE;
      v_rows_cnt     NUMBER;
      v_error_msg    VARCHAR2 (4000);
   BEGIN
      v_start_dttm := SYSDATE;
      /*
        ���������� ������ ������� ����� ��������� EXECUTE_QUERY
      */
      API_SQL.LOG_SQL (
         p_folder_name        => p_folder_name,
         p_workflow_name      => p_workflow_name,
         p_proc_name          => p_procedure_name || ' via EXECUTE_QUERY',
         p_targettable_name   => p_targettable_name,
         p_sqlerrm_text       => '',
         p_job_id             => p_job_id,
         p_start_dttm         => v_start_dttm,
         p_message_text       => 'Start EXECUTE_QUERY',
         p_sql_text           => p_sql_text);

      BEGIN
      
        IF NOT v_debug_mode
          THEN
          EXECUTE IMMEDIATE p_sql_text;
          v_rows_cnt := SQL%ROWCOUNT;
            ELSE
          print_clob(p_sql_text);
        END IF;
      

      EXCEPTION
         WHEN OTHERS
         THEN
            IF SQLCODE NOT BETWEEN -20999 AND -20000
            THEN
               v_error_msg := SQLERRM;

               UPDATE LOG_SQL
                  SET SQLERRM_TEXT = v_error_msg
                WHERE     FOLDER_NAME = p_folder_name
                      AND WORKFLOW_NAME = p_workflow_name
                      AND PROC_NAME =
                             p_procedure_name || ' via EXECUTE_QUERY'
                      AND TARGETTABLE_NAME = p_targettable_name
                      AND JOB_ID = p_job_id
                      AND START_DTTM = v_start_dttm
                      AND MESSAGE_TEXT = 'Start EXECUTE_QUERY';

               COMMIT;
               UTL_ERRHANDLERS.RAISE_ERROR (
                  P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
                  P_ERRMSG_TEXT      => '��������� ������',
                  P_PLSQLUNIT_NAME   => 'API_UPLOAD.EXECUTE_QUERY',
                  P_SEVERITY_CODE    => 'S',
                  P_SQLERRM_TEXT     => v_error_msg);
            END IF;

            RAISE;
      END;

      /*
        ���������� �������� ���������� ������� ����� ��������� EXECUTE_QUERY
      */
      API_SQL.LOG_SQL (
         p_folder_name        => p_folder_name,
         p_workflow_name      => p_workflow_name,
         p_proc_name          => p_procedure_name || 'via EXECUTE_QUERY',
         p_targettable_name   => p_targettable_name,
         p_sqlerrm_text       => '',
         p_job_id             => p_job_id,
         p_start_dttm         => v_start_dttm,
         p_end_dttm           => SYSDATE,
         p_rows_cnt           => v_rows_cnt,
         p_message_text       => 'End EXECUTE_QUERY',
         p_sql_text           => p_sql_text);
   END;

   PROCEDURE get_sql_stmt (p_template_name   IN     VARCHAR2,
                           p_variables       IN     hash_aat,
                           o_clob               OUT CLOB)
   IS
      v_tmp_clob            CLOB;
      v_res_clob            CLOB;
      v_var                 VARCHAR2 (32767);
      v_completeness_flag   BOOLEAN := TRUE;

      CURSOR c1
      IS
         SELECT TEMPLATE_CODE
           FROM MMD_TEMPLATES
          WHERE CLASS_CODE = 'DMM_UPLOAD_prepare';
   BEGIN
      v_res_clob := p_template_name;

      WHILE v_completeness_flag
      LOOP
         v_completeness_flag := FALSE;

         FOR c IN c1
         LOOP
            IF sys.DBMS_LOB.INSTR (v_res_clob, c.TEMPLATE_CODE, 1) > 0
            THEN
               get_template_variable (c.TEMPLATE_CODE,
                                      p_variables,
                                      v_tmp_clob);
               v_res_clob :=
                  API_HELPERS.CLOBREPLACE (v_res_clob,
                                           c.TEMPLATE_CODE,
                                           v_tmp_clob);
               --dbms_output.put_line(v_res_clob);
               v_completeness_flag := TRUE;
            END IF;
         END LOOP;
      END LOOP;

      --dbms_output.put_line(v_res_clob);


      v_var := p_variables.FIRST;

      LOOP
         EXIT WHEN v_var IS NULL;
         --dbms_output.put_line(v_var || p_variables(v_var));
         v_res_clob :=
            API_HELPERS.CLOBREPLACE (v_res_clob, v_var, p_variables (v_var));
         --dbms_output.put_line(v_res_clob);
         v_var := p_variables.NEXT (v_var);
      END LOOP;

      --dbms_output.put_line(v_res_clob);
      o_clob := v_res_clob;
   END;


   PROCEDURE get_sql_stmt (p_proc_template_name   IN     VARCHAR2,
                           p_variables            IN     hash_aat,
                           o_clob                    OUT CLOB)
   IS
      v_tmp_clob   CLOB;
      v_res_clob   CLOB;


      CURSOR c1
      IS
         SELECT TEMPLATE_CODE
           FROM MMD_TEMPLATES
          WHERE CLASS_CODE = 'DMM_UPLOAD_prepare';
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('a');
      get_template (p_proc_template_name, p_variables, v_res_clob);
      --dbms_output.put_line('REPLACE template end');

      DBMS_OUTPUT.PUT_LINE ('a');

      FOR c IN c1
      LOOP
         get_template_variable (c.TEMPLATE_CODE, p_variables, v_tmp_clob);
         v_res_clob :=
            API_HELPERS.CLOBREPLACE (v_res_clob, c.TEMPLATE_CODE, v_tmp_clob);
      --dbms_output.put_line(v_res_clob);
      END LOOP;

      DBMS_OUTPUT.PUT_LINE ('a');

      o_clob := v_res_clob;
   END;

   PROCEDURE get_template_variable (p_proc_template_name   IN     VARCHAR2,
                                    p_variables            IN     hash_aat,
                                    o_clob                    OUT CLOB)
   IS
      v_var             VARCHAR2 (255);
      v_clob_template   CLOB;
      v_sql_stmt        CLOB;
      v_clob_result     CLOB;
   BEGIN
      --DBMS_OUTPUT.PUT_LINE('a');

      SELECT TEMPLATE_TEXT
        INTO v_clob_template
        FROM MMD_TEMPLATES
       WHERE     CLASS_CODE = 'DMM_UPLOAD_prepare'
             AND TEMPLATE_CODE = p_proc_template_name;

      --dbms_output.put_line(v_clob_template);

      v_var := p_variables.FIRST;

      v_sql_stmt :=
            'SELECT'
         || CHR (10)
         || v_clob_template
         || ' FROM (select t1.*,t2.data_type
    from  MD_COLUMNS t1
    left join all_tab_columns t2 on  t1.schema_name = t2.owner
              and t1.table_name = t2.table_name
              and t1.column_name = t2.column_name
            WHERE t1.Schema_name = ''%v_target_schema_name%'' '
         || CHR (10)
         || 'and t1.TABLE_NAME = ''%v_target_table_name%'')';

      LOOP
         EXIT WHEN v_var IS NULL;
         --dbms_output.put_line(v_var || p_variables(v_var));
         v_sql_stmt :=
            API_HELPERS.CLOBREPLACE (v_sql_stmt, v_var, p_variables (v_var));
         --dbms_output.put_line(v_sql_stmt);
         v_var := p_variables.NEXT (v_var);
      END LOOP;

      DBMS_OUTPUT.put_line (v_sql_stmt);

      EXECUTE IMMEDIATE v_sql_stmt INTO v_clob_result;

      DBMS_OUTPUT.PUT_LINE (v_clob_result);
      --dbms_output.put_line('end of clob template generation');



      o_clob := v_clob_result;
   END;

   PROCEDURE get_template (p_proc_template_name   IN     VARCHAR2,
                           p_variables            IN     hash_aat,
                           o_clob                    OUT CLOB)
   IS
      v_var             VARCHAR2 (255);
      v_clob_template   CLOB;
   BEGIN
      v_var := p_variables.FIRST;

      SELECT TEMPLATE_TEXT
        INTO v_clob_template
        FROM MMD_TEMPLATES
       WHERE     CLASS_CODE = 'DMM_UPLOAD'
             AND TEMPLATE_CODE = p_proc_template_name;

      --dbms_output.put_line(v_clob_template);

      LOOP
         EXIT WHEN v_var IS NULL;
         --dbms_output.put_line(v_var || p_variables(v_var));
         v_clob_template :=
            API_HELPERS.CLOBREPLACE (v_clob_template,
                                     v_var,
                                     p_variables (v_var));
         --dbms_output.put_line(v_clob_template);
         v_var := p_variables.NEXT (v_var);
      END LOOP;

      o_clob := v_clob_template;
   END;

   PROCEDURE REPLACE_SDIM (p_folder_name          IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC*/
                           p_workflow_name        IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
                           p_source_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
                           p_source_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� �������-��������� */
                           p_target_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
                           p_target_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
                           p_job_id               IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
                           p_as_of_day            IN DATE DEFAULT SYSDATE /* �������� ��������� �������� ���� ���������� ���������������� ���� */
                                                                         )
   IS
      v_cnt                   NUMBER;
      v_res_clob              CLOB;
      v_source_columns_list   CLOB;
      v_target_columns_list   CLOB;
      v_insert_sql_stmt       CLOB;
      v_insert_sql_buffer     VARCHAR2 (32767);
      v_full_source_name      VARCHAR2 (256);
      v_full_target_name      VARCHAR2 (256);
      v_delete_sql_stmt       VARCHAR2 (4000);
      v_proc_start_date       DATE;
      v_start_cur_stmt_date   DATE;

      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* ��������� ������ ����� ������ */
      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;

      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (SYSDATE, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;

      /* 1. ������������ [����/����� ������ ���������] = SYSDATE */

      v_proc_start_date := SYSDATE;

      /*
        2. ��� ����������� ������ ������ ��������� ���������� API_ETL.LOG_SQL � �����������:
          � p_folder_name      = <p_folder_name>
          � p_workflow_name    = <p_workflow_name>
          � p_proc_name        = �API_UPLOAD.REPLACE_SDIM�
          � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
          � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
          � p_job_id           = <p_job_id>
          � p_start_dttm       = sysdate
          � p_message_text     = �Start API_UPLOAD.REPLACE_SDIM�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SDIM',
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_proc_start_date,
         P_MESSAGE_TEXT       => 'Start API_UPLOAD.REPLACE_SDIM',
         P_SQL_TEXT           => NULL);

      /*
        3. �������� ����������:
          a. ���� p_folder_name ����� NULL,
          �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
            � P_EXCEPTION_NAME = �e_paramvalue_empty�
            � P_ERRMSG_TEXT    = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
            � P_PLSQLUNIT_NAME = �API_UPLOAD.REPLACE_SDIM�
            � P_SEVERITY_CODE  = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
          b. ���� p_workflow_name ����� NULL,
          �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
            � P_EXCEPTION_NAME = �e_paramvalue_empty�
            � P_ERRMSG_TEXT    = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
            � P_PLSQLUNIT_NAME = �API_UPLOAD.REPLACE_SDIM�
            � P_SEVERITY_CODE  = �E�
      */

      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
            c. ���� p_source_schema_name ����� NULL,
            �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
              � P_EXCEPTION_NAME = �e_paramvalue_empty�
              � P_ERRMSG_TEXT    = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
              � P_PLSQLUNIT_NAME = �API_UPLOAD.REPLACE_SDIM�
              � P_SEVERITY_CODE  = �E�
      */

      IF p_source_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
          d. ���� p_source_table_name ����� NULL,
          �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
            � P_EXCEPTION_NAME = �e_paramvalue_empty�
            � P_ERRMSG_TEXT    = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
            � P_PLSQLUNIT_NAME = �API_UPLOAD.REPLACE_SDIM�
            � P_SEVERITY_CODE  = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
          e. ���� p_target_schema_name ����� NULL,
          �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
            � P_EXCEPTION_NAME = �e_paramvalue_empty�
            � P_ERRMSG_TEXT    = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
            � P_PLSQLUNIT_NAME = �API_UPLOAD.REPLACE_SDIM�
            � P_SEVERITY_CODE  = �E�
      */

      IF p_target_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
            f. ���� p_target_table_name ����� NULL,
            �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
              � P_EXCEPTION_NAME = �e_paramvalue_empty�
              � P_ERRMSG_TEXT    = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
              � P_PLSQLUNIT_NAME = �API_UPLOAD.REPLACE_SDIM�
            � P_SEVERITY_CODE    = �E�
        */

      IF p_target_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
          g. ���� p_job_id ����� NULL,
          �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
            � P_EXCEPTION_NAME = �e_paramvalue_empty�
            � P_ERRMSG_TEXT = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
            � P_PLSQLUNIT_NAME = �API_UPLOAD.REPLACE_SDIM�
            � P_SEVERITY_CODE = �E�
      */

      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_JOB_ID �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      4. ����������� �������� ������� ����� ��� �������� � ������� ���������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME  = <p_target_table_name>
        ���� �� ������� �� ����� ������,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_md_columns_empty�
        � P_ERRMSG_TEXT    = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.REPLACE_SDIM�
        � P_SEVERITY_CODE  = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      5. ����������� <������ ����� ������� �������> � <������ ����� �������� ���������> �� ������� ������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME  = <p_target_table_name>
      */

      /* v_source_columns_list := get_SOURCE_COLUMNS(
         P_TARGET_SCHEMA_NAME => p_target_schema_name,
         P_TARGET_TABLE_NAME  => p_target_table_name,
         P_AS_OF_DAY          => p_as_of_day
       );

       v_target_columns_list := get_TARGET_COLUMNS(
         P_TARGET_SCHEMA_NAME => p_target_schema_name,
         P_TARGET_TABLE_NAME  => p_target_table_name
       );*/


      --     DBMS_OUTPUT.PUT_LINE(v_source_columns_list);
      --     DBMS_OUTPUT.PUT_LINE(v_target_columns_list);

      /*
          SELECT LISTAGG(CASE WHEN COLUMN_NAME IN ('JOB_INSERT', 'JOB_UPDATE') THEN 'DMSJOB'
                              WHEN COLUMN_NAME IN ('DWSCMIX', 'EMIX') THEN 'DMSEMIX'
                              WHEN COLUMN_NAME =  'AS_OF_DAY' THEN 'TO_DATE(''' || TO_CHAR(p_as_of_day,'yyyymmdd') || ''', ''yyyymmdd'')'
                              WHEN NVL_FLAG    =  'Y' THEN 'NVL(' || COLUMN_NAME || ',''' || DEFAULT_VALUE || ''')'
                              ELSE COLUMN_NAME
                         END, ',') WITHIN GROUP (ORDER BY COLUMN_NAME) s,
                 LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY COLUMN_NAME) s
            INTO v_source_columns_list, v_target_columns_list
            FROM MD_COLUMNS
           WHERE SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME  = p_target_table_name
        GROUP BY SCHEMA_NAME, TABLE_NAME;
      */

      /*
        6. ����������� <SQL ��������> �� �������:
        INSERT INTO <p_target_schema_name>.<p_target_table_name>
                   (<������ ����� ������� �������>)
        SELECT
                   <������ ����� �������� ���������>
        FROM <p_source_schema_name>.<p_source_table_name>
      */

      /*    v_insert_sql_stmt := 'INSERT INTO ' || v_full_target_name || CHR(10) ||
            '(' || v_target_columns_list || ')' || CHR(10) ||
            'SELECT' || CHR(10) ||
            v_source_columns_list || CHR(10) ||
            'FROM ' || v_full_source_name;*/


      /*    UTL_HELPERS.APPEND_TEXT(v_insert_sql_stmt, v_insert_sql_buffer, 'INSERT INTO ' || v_full_target_name || CHR(10) || '(' );
          UTL_HELPERS.APPEND_TEXT(v_insert_sql_stmt, v_insert_sql_buffer, v_target_columns_list);
          UTL_HELPERS.APPEND_TEXT(v_insert_sql_stmt, v_insert_sql_buffer, ')' || CHR(10) ||'SELECT' || CHR(10));
          UTL_HELPERS.APPEND_TEXT(v_insert_sql_stmt, v_insert_sql_buffer, v_source_columns_list);
          UTL_HELPERS.APPEND_TEXT(v_insert_sql_stmt, v_insert_sql_buffer, CHR(10) || 'FROM ' || v_full_source_name);
          DBMS_LOB.writeappend (v_insert_sql_stmt, LENGTH(v_insert_sql_buffer), v_insert_sql_buffer);*/
      /*  7. ������������ [����/����� ������ �����] = SYSDATE */


      get_sql_stmt (p_proc_template_name   => '%REPLACE_SDIM%',
                    p_variables            => v_variable_of_arrays,
                    o_clob                 => v_insert_sql_stmt);

      v_start_cur_stmt_date := SYSDATE;

      /*
     8. ���������� ������ ����� ������� ������� ������� � ������� API_SQL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SDIM�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_message_text     = �Start delete all rows from <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SDIM',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       =>    'Start delete all rows from '
                                 || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /*
      9. ����������� ������� ������ ������� �������:
            DELETE FROM <p_target_schema_name>.<p_target_table_name>
      */

      v_delete_sql_stmt := 'DELETE FROM ' || v_full_target_name;

      EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.REPLACE_SDIM',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_delete_sql_stmt);

      --    EXECUTE IMMEDIATE v_delete_sql_stmt;

      /*
      10. ���������� ��������� ����� ������� ������� ������� c ������� API_SQL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SDIM�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_end_dttm         = SYSDATE
        � p_message_text     = �End delete all rows from <p_target_schema_name>.<p_target_table_name>�
       */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SDIM',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       =>    'End delete all rows from '
                                 || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /* 11.���������������� [����/����� ������ �����] = SYSDATE; */

      v_start_cur_stmt_date := SYSDATE;

      /*
      12. ���������� ������ ����� �������� ������ � ������� ������� � ������� API_SQL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SDIM�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_message_text     = �Start insert into <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SDIM',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => NULL,
         P_MESSAGE_TEXT       => 'Start insert into ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /* 13. ����������� <SQL ��������> */
      --dbms_output.put_line(v_insert_sql_stmt);

      EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.REPLACE_SDIM',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_insert_sql_stmt);
      --    EXECUTE IMMEDIATE v_insert_sql_stmt;

      /*  14. ����������� ������������� ��������� ������ � ������� �������. */

      COMMIT;

      /*
      15. ���������� ��������� ����� �������� ������ � ������� ������� � ������� API_SQL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SDIM�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_end_dttm         = SYSDATE
        � p_message_text     = �End insert into <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SDIM',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'End insert into ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /*
      16. ���������� ��������� ������ ��������� � ������� API_SQL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SDIM�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ ���������]
        � p_end_dttm         = SYSDATE
        � p_message_text     = �End API_UPLOAD.REPLACE_SDIM�
       */

      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.REPLACE_SDIM',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_proc_start_date,
                       P_END_DTTM           => SYSDATE,
                       P_MESSAGE_TEXT       => 'End API_UPLOAD.REPLACE_SDIM',
                       P_SQL_TEXT           => NULL);
   /*
   17. ���� ��� ���������� ��������� �������� ����������,
     ��:
     a. ���� SQLCODE �� ������ � �������� [-20999;-20000],
     �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
       � P_EXCEPTION_NAME = SQLCODE
       � P_ERRMSG_TEXT    = ���������� �������
       � P_PLSQLUNIT_NAME = �API_UPLOAD.REPLACE_SDIM�
       � P_SEVERITY_CODE  = �S�
       � P_SQLERRM_TEXT   = SQLERRM
     b. ���������� ��������� ����������.

    */

   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE NOT BETWEEN -20999 AND -20000
         THEN
            UTL_ERRHANDLERS.RAISE_ERROR (
               P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
               P_ERRMSG_TEXT      => '��������� ������',
               P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
               P_SEVERITY_CODE    => 'S',
               P_SQLERRM_TEXT     => SQLERRM);
         END IF;

         RAISE;
   END;


   PROCEDURE REPLACE_STRAN (
      p_folder_name          IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
      p_workflow_name        IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
      p_source_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
      p_source_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� �������-��������� */
      p_target_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
      p_target_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
      p_column_date          IN VARCHAR2 DEFAULT 'VALUE_DAY', /* �������� ��������� �������� SQL-����� ����, �� ��������� �������� �������������� ����������� �������� */
      p_start_date           IN DATE DEFAULT NULL, /* �������� ��������� �������� ���� ������ �������, � ������� ������������ ����� ������ �� �������-��������� */
      p_end_date             IN DATE DEFAULT NULL, /* �������� ��������� �������� ���� ��������� �������, �� ������� ������������ ����� ������ �� �������-��������� */
      p_partition_fmt        IN VARCHAR2 DEFAULT 'yyyymmdd', /* �������� ��������� �������� ������� ������������� ��� ��� ����������� ����� �������� */
      p_truncate_table       IN NUMBER DEFAULT 0, /* �������� ��������� �������� �������� ������ ������� ������� ��� �������������� ��������: 1 - ���������, 0 - �� ��������� */
      p_job_id               IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
      p_as_of_day            IN DATE DEFAULT SYSDATE /* �������� ��������� �������� ���� ���������� ���������������� ���� */
                                                    )
   IS
      v_start_proc_date       DATE;
      v_column_date           VARCHAR2 (4000);
      v_start_cur_stmt_date   DATE;
      v_full_source_name      VARCHAR2 (4000);
      v_full_target_name      VARCHAR2 (4000);
      v_cnt                   NUMBER;
      v_source_columns_list   VARCHAR2 (4000);
      v_target_columns_list   VARCHAR2 (4000);
      v_partition_existence   BOOLEAN;
      v_delete_stmt           VARCHAR2 (4000);
      v_start_date            DATE;
      v_end_date              DATE;
      v_insert_sql_stmt       VARCHAR2 (4000);
      v_truncate_stmt         VARCHAR2 (4000);
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      v_column_date := NVL (p_column_date, 'VALUE_DAY');
      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;

      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (SYSDATE, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;
      /* 1. ������������ [����/����� ������ ���������] = SYSDATE */

      v_start_proc_date := SYSDATE;

      /*
      2. ���������� ������ ������ ��������� � ������� API_SQL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_STRAN�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ ���������]
        � p_message_text     = �Start API_UPLOAD.REPLACE_STRAN�
       */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_END_DTTM           => NULL,
         P_MESSAGE_TEXT       => 'Start API_UPLOAD.REPLACE_STRAN',
         P_SQL_TEXT           => NULL);

      /*
      3. �������� ����������:
        a. ���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
          � p_exception_name = �e_paramvalue_empty�
          � p_errmsg_text    = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
          � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
          � p_severity_code  = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      b. ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
        � p_severity_code  = �E�
      */

      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      c. ���� p_source_schema_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
        � p_severity_code  = �E�
      */

      IF P_SOURCE_SCHEMA_NAME IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      d. ���� p_source_table_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
        � p_severity_code  = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_source_table_name �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e. ���� p_target_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
        � p_severity_code  = �E�
      */

      IF P_TARGET_SCHEMA_NAME IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;


      /*
      f. ���� p_target_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
        � p_severity_code  = �E�
      */

      IF P_TARGET_TABLE_NAME IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      g. ���� p_start_date ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_START_DATE �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
        � p_severity_code  = �E�
      */

      IF p_start_date IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_start_date �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      h. ���� p_end_date ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_END_DATE �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
        � p_severity_code  = �E�
      */

      IF p_end_date IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_end_date �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      i. ���� p_job_id ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
      � p_exception_name = �e_paramvalue_empty�
      � p_errmsg_text    = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
      � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
      � p_severity_code  = �E�
      */


      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_job_id �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;



      /*
      4. ���� �� ������� �� ����� ������ � ������� ���������� MD_COLUMNS �� �������:
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME  = <p_target_table_name>
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_md_columns_empty�
        � p_errmsg_text    = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_STRAN�
        � p_severity_code  = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;


      /*
      5. ����������� <������ ����� ������� �������> � <������ ����� �������� ���������> �� ������� ������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME  = <p_target_table_name>
      */



      /*    v_source_columns_list := get_SOURCE_COLUMNS(
            P_TARGET_SCHEMA_NAME => p_target_schema_name,
            P_TARGET_TABLE_NAME  => p_target_table_name,
            P_AS_OF_DAY          => p_as_of_day
          );

          v_target_columns_list := get_TARGET_COLUMNS(
            P_TARGET_SCHEMA_NAME => p_target_schema_name,
            P_TARGET_TABLE_NAME  => p_target_table_name
          );*/



      /*    SELECT LISTAGG(CASE WHEN COLUMN_NAME IN ('JOB_INSERT', 'JOB_UPDATE') THEN 'DMSJOB'
                              WHEN COLUMN_NAME IN ('DWSCMIX', 'EMIX') THEN 'DMSEMIX'
                              WHEN COLUMN_NAME = 'AS_OF_DAY' THEN 'TO_DATE(''' || TO_CHAR(p_as_of_day,'yyyymmdd') || ''', ''yyyymmdd'')'
                              WHEN NVL_FLAG    = 'Y' THEN 'NVL(' || COLUMN_NAME || ',''' || DEFAULT_VALUE || ''')'
                              ELSE COLUMN_NAME
                         END, ',') WITHIN GROUP (ORDER BY COLUMN_NAME) s,
                 LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY COLUMN_NAME) s
            INTO v_source_columns_list, v_target_columns_list
            FROM MD_COLUMNS
           WHERE SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME  = p_target_table_name
        GROUP BY SCHEMA_NAME, TABLE_NAME;*/

      /*
      6. ����������� <SQL �������>:
        � ���� <p_truncate_table = 1,
        �� ������� ��������� �� �������:
        TRUNCATE TABLE <p_target_schema_name>.<p_target_table_name>
        � ���� <p_truncate_table> = 0,
        �� ����������� �������� ������ ��� ������ �������� ������� <p_target_schema_name>.<p_target_table_name>, ����� ������� ��������� ����� [����������� ���������] � [������������ ���������] �� �������:
        ALTER TABLE <p_target_schema_name>.<p_target_table_name>
        TRUNCATE PARTITION [PARTITION_NAME]
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM all_tab_partitions
       WHERE     table_owner = p_target_schema_name
             AND table_name = p_target_table_name;

      v_partition_existence := v_cnt <> 0;

      v_start_date := p_start_date;
      v_end_date := p_end_date;

      IF p_truncate_table = 1
      THEN
         v_truncate_stmt := 'TRUNCATE TABLE ' || v_full_target_name;
      ELSE
         IF NOT v_partition_existence
         THEN
            v_delete_stmt :=
                  'DELETE FROM '
               || v_full_target_name
               || ' WHERE '
               || v_column_date
               || ' >= TO_DATE('''
               || TO_CHAR (v_start_date, 'yyyymmdd')
               || ''', ''yyyymmdd'') AND '
               || v_column_date
               || ' < TO_DATE('''
               || TO_CHAR (TRUNC (v_end_date) + 1, 'yyyymmdd')
               || ''', ''yyyymmdd'')';
         --dbms_output.put_line(v_delete_stmt);
         ELSE
            -- TODO: ����������� ���������� ������ truncate
            NULL;
         END IF;
      END IF;

      /*
      7. ����������� <SQL ��������> �� �������:
        INSERT INTO <p_target_schema_name>.<p_target_table_name>
                   (<������ ����� ������� �������>)
        SELECT
                   <������ ����� �������� ���������>
        FROM <p_source_schema_name>.<p_source_table_name>
      */


      get_sql_stmt (p_proc_template_name   => '%REPLACE_STRAN%',
                    p_variables            => v_variable_of_arrays,
                    o_clob                 => v_insert_sql_stmt);

      /*
          v_insert_sql_stmt := 'INSERT INTO ' || p_target_schema_name || '.' || p_target_table_name || CHR(10) ||
            '(' || v_target_columns_list || ')' || CHR(10) ||
            'SELECT' || CHR(10) ||
            v_source_columns_list || CHR(10) ||
            'FROM ' || v_full_source_name;
      */

      /* 8. ������������ [����/����� ������ �����] = SYSDATE */

      v_start_cur_stmt_date := SYSDATE;

      /*
      9. ���������� ������ ����� ������� ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
          � p_folder_name      = <p_folder_name>
          � p_workflow_name    = <p_workflow_name>
          � p_proc_name        = �API_UPLOAD.REPLACE_SAGG�
          � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
          � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
          � p_job_id           = <p_job_id>
          � p_start_dttm       = [����/����� ������ �����]
          � p_message_text     = �Start truncate table <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       => 'Start truncate table ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /* 10. ����������� <SQL �������> */

      IF NOT v_partition_existence
      THEN
         EXECUTE_QUERY (p_folder_name        => p_folder_name,
                        p_workflow_name      => p_workflow_name,
                        p_procedure_name     => 'API_UPLOAD.REPLACE_STRAN',
                        p_targettable_name   => v_full_target_name,
                        p_job_id             => p_job_id,
                        p_sql_text           => v_delete_stmt);
      --      EXECUTE IMMEDIATE v_delete_stmt;
      ELSE
         IF p_truncate_table = 1
         THEN
            EXECUTE_QUERY (p_folder_name        => p_folder_name,
                           p_workflow_name      => p_workflow_name,
                           p_procedure_name     => 'API_UPLOAD.REPLACE_STRAN',
                           p_targettable_name   => v_full_target_name,
                           p_job_id             => p_job_id,
                           p_sql_text           => v_truncate_stmt);
         --        EXECUTE IMMEDIATE v_truncate_stmt;
         ELSE
            TRUNC_PARTITIONS (p_table_name      => p_target_table_name,
                              p_partition_fmt   => p_partition_fmt,
                              p_start_date      => p_start_date,
                              p_end_date        => p_end_date);
         END IF;
      END IF;

      /*
      11. ���������� ��������� ����� ������� ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_STRAN�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_end_dttm         = SYSDATE
        � p_message_text     = �End truncate table <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'End truncate table ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /* 12. ���������������� [����/����� ������ �����] = SYSDATE */

      v_start_cur_stmt_date := SYSDATE;

      /*
      13. ���������� ������ ����� �������� ������ � ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_STRAN�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_message_text     = �Start insert into <p_target_schema_name>.<p_target_table_name>�
       */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => NULL,
         P_MESSAGE_TEXT       => 'Start insert into ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /* 14. ����������� <SQL ��������> */
      EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.REPLACE_STRAN',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_insert_sql_stmt);
      --    EXECUTE IMMEDIATE v_insert_sql_stmt;

      /* 15. ����������� ������������� ��������� ������ � ������� �������. */

      COMMIT;

      /*
      16. ���������� ��������� ����� �������� ������ � ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_STRAN�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_end_dttm       = SYSDATE
        � p_message_text     = �End insert into <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'End insert into ' || p_target_table_name,
         P_SQL_TEXT           => NULL);

      /*
      17. ���������� ��������� ������ ��������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_STRAN�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ ���������]
        � p_end_dttm         = SYSDATE
        � p_message_text     = �End API_UPLOAD.REPLACE_SAGG�
      */

      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.REPLACE_STRAN',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_start_proc_date,
                       P_END_DTTM           => SYSDATE,
                       P_MESSAGE_TEXT       => 'END API_UPLOAD.REPLACE_STRAN',
                       P_SQL_TEXT           => NULL);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE NOT BETWEEN -20999 AND -20000
         THEN
            UTL_ERRHANDLERS.RAISE_ERROR (
               P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
               P_ERRMSG_TEXT      => '��������� ������',
               P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_STRAN',
               P_SEVERITY_CODE    => 'S',
               P_SQLERRM_TEXT     => SQLERRM);
         END IF;

         RAISE;
   END;


   PROCEDURE REPLACE_SSTAT (
      p_folder_name          IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC*/
      p_workflow_name        IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
      p_source_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
      p_source_table_name    IN VARCHAR2, /* �������� ������� �������� SQL-����� �������-��������� */
      p_target_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
      p_target_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
      p_column_date          IN VARCHAR2 DEFAULT 'VALUE_DAY',
      p_start_date           IN DATE DEFAULT NULL, /* �������� ��������� �������� ���� ������ ������� ������ */
      p_end_date             IN DATE DEFAULT NULL, /* �������� ��������� �������� ���� ��������� ������� ������ */
      p_truncate_table       IN NUMBER DEFAULT 0, /* �������� ��������� �������� �������� ������ ������� ������� ��� �������������� ��������: 1 - ���������, 0 - �� ��������� */
      p_partition_fmt        IN VARCHAR2 DEFAULT 'yyyymmdd', /* �������� ��������� �������� ������� ������������� ��� ��� ����������� ����� �������� */
      p_job_id               IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
      p_as_of_day            IN DATE DEFAULT SYSDATE /* �������� ��������� �������� ���� ���������� ���������������� ���� */
                                                    )
   IS
      v_start_proc_date       DATE;
      v_start_cur_stmt_date   DATE;
      v_full_source_name      VARCHAR2 (4000);
      v_full_target_name      VARCHAR2 (4000);
      v_cnt                   NUMBER;
      v_source_columns_list   VARCHAR2 (4000);
      v_target_columns_list   VARCHAR2 (4000);
      v_partition_existence   BOOLEAN;
      v_sql                   CLOB;
      v_delete_stmt           VARCHAR2 (4000);
      v_start_date            DATE;
      v_end_date              DATE;
      v_insert_sql_stmt       VARCHAR2 (4000);
      v_truncate_stmt         VARCHAR2 (4000);
      v_column_date           VARCHAR2 (4000);
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* 1. ������������ [����/����� ������ ���������] = SYSDATE */

      v_column_date := NVL (p_column_date, 'VALUE_DAY');
      v_start_proc_date := SYSDATE;

      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;

      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (SYSDATE, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;

      /*
      2. ���������� ������ ������ ��������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SSTAT�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = SYSDATE
        � p_message_text     = �Start API_UPLOAD.REPLACE_SAGG�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SSTAT',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_MESSAGE_TEXT       => 'Start API_UPLOAD.REPLACE_SSTAT',
         P_SQL_TEXT           => NULL);

      /*
      3. �������� ����������:
        a. ���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
        � p_severity_code  = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
        b. ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
          � p_exception_name = �e_paramvalue_empty�
          � p_errmsg_text    = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
          � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
          � p_severity_code  = �E�
      */

      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      c. ���� p_source_schema_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
        � p_severity_code  = �E�
      */

      IF P_SOURCE_SCHEMA_NAME IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      d. ���� p_source_table_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
      � p_exception_name = �e_paramvalue_empty�
      � p_errmsg_text    = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
      � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
      � p_severity_code  = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_source_table_name �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e. ���� p_target_schema_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
        � p_severity_code  = �E�
      */

      IF P_TARGET_SCHEMA_NAME IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      f. ���� p_target_table_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
        � p_severity_code  = �E�
      */

      IF P_TARGET_TABLE_NAME IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      g. ���� p_start_date ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_START_DATE �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
        � p_severity_code  = �E�
      */

      IF p_start_date IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_start_date �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      h. ���� p_end_date ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_END_DATE �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
        � p_severity_code  = �E�
      */

      IF p_end_date IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_end_date �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      i. ���� p_job_id ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
      � p_exception_name = �e_paramvalue_empty�
      � p_errmsg_text    = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
      � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
      � p_severity_code  = �E�
      */


      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_job_id �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      4. ���� �� ������� �� ����� ������ � ������� ���������� MD_COLUMNS �� �������:
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME  = <p_target_table_name>
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_md_columns_empty�
        � p_errmsg_text    = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SSTAT�
        � p_severity_code  = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      5. ����������� <������ ����� ������� �������> � <������ ����� �������� ���������> �� ������� ������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME  = <p_target_table_name>
      */
      /*
          v_source_columns_list := get_SOURCE_COLUMNS(
            P_TARGET_SCHEMA_NAME => p_target_schema_name,
            P_TARGET_TABLE_NAME  => p_target_table_name,
            P_AS_OF_DAY          => p_as_of_day
          );

          v_target_columns_list := get_TARGET_COLUMNS(
            P_TARGET_SCHEMA_NAME => p_target_schema_name,
            P_TARGET_TABLE_NAME  => p_target_table_name
          );
      */



      /*    SELECT LISTAGG(CASE WHEN COLUMN_NAME IN ('JOB_INSERT', 'JOB_UPDATE') THEN 'DMSJOB'
                              WHEN COLUMN_NAME IN ('DWSCMIX', 'EMIX') THEN 'DMSEMIX'
                              WHEN COLUMN_NAME = 'AS_OF_DAY' THEN 'TO_DATE(''' || TO_CHAR(p_as_of_day,'yyyymmdd') || ''', ''yyyymmdd'')'
                              WHEN NVL_FLAG    = 'Y' THEN 'NVL(' || COLUMN_NAME || ',''' || DEFAULT_VALUE || ''')'
                              ELSE COLUMN_NAME
                         END, ',') WITHIN GROUP (ORDER BY COLUMN_NAME) s,
                 LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY COLUMN_NAME) s
            INTO v_source_columns_list, v_target_columns_list
            FROM MD_COLUMNS
           WHERE SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME  = p_target_table_name
        GROUP BY SCHEMA_NAME, TABLE_NAME;*/

      --dbms_output.put_line(v_target_columns_list);
      --dbms_output.put_line(v_source_columns_list);
      /*
      6. ����������� <SQL �������>:
        � ���� <p_truncate_table = 1,
        �� ������� ��������� �� �������:
        TRUNCATE TABLE <p_target_schema_name>.<p_target_table_name>
        � ���� <p_truncate_table> = 0,
        �� ����������� �������� ������ ��� ������ �������� ������� <p_target_schema_name>.<p_target_table_name>, ����� ������� ��������� ����� [����������� ���������] � [������������ ���������] �� �������:
        ALTER TABLE <p_target_schema_name>.<p_target_table_name>
        TRUNCATE PARTITION [PARTITION_NAME]
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM all_tab_partitions
       WHERE     table_owner = p_target_schema_name
             AND table_name = p_target_table_name;

      v_partition_existence := v_cnt <> 0;

      v_start_date := p_start_date;
      v_end_date := p_end_date;

      IF p_truncate_table = 1
      THEN
         /* TODO: ����������� ��������� ������ truncate
          v_truncate_stmt := 'TRUNCATE TABLE '||v_full_target_name; */
         --v_truncate_stmt := 'RUNCATE TABLE  ' || v_full_target_name;
         v_delete_stmt := 'DELETE FROM ' || v_full_target_name;
      ELSE
         IF NOT v_partition_existence
         THEN
            v_delete_stmt :=
                  'DELETE FROM '
               || v_full_target_name
               || ' WHERE '
               || v_column_date
               || ' >= TO_DATE('''
               || TO_CHAR (v_start_date, 'yyyymmdd')
               || ''', ''yyyymmdd'') AND '
               || v_column_date
               || ' < TO_DATE('''
               || TO_CHAR (TRUNC (v_end_date) + 1, 'yyyymmdd')
               || ''', ''yyyymmdd'')';
            DBMS_OUTPUT.put_line (v_delete_stmt);
         --     EXECUTE IMMEDIATE v_delete_stmt;
         ELSE
            -- TODO: ����������� ���������� ������ truncate
            NULL;
         /*
         v_delete_stmt := 'DELETE FROM ' || v_full_target_name || ' WHERE ' || v_column_date || ' >= TO_DATE(''' ||
             TO_CHAR(v_start_date, 'yyyymmdd') || ''', ''yyyymmdd'') AND '|| v_column_date || ' < TO_DATE(''' || TO_CHAR(trunc(v_end_date)+1, 'yyyymmdd') || ''', ''yyyymmdd'')';
         */
         END IF;
      END IF;

      /*
      7. ����������� <SQL ��������> �� �������:
        INSERT INTO <p_target_schema_name>.<p_target_table_name>
                   (<������ ����� ������� �������>)
        SELECT
                   <������ ����� �������� ���������>
        FROM <p_source_schema_name>.<p_source_table_name>
      */

      get_sql_stmt (p_proc_template_name   => '%REPLACE_SSTAT%',
                    p_variables            => v_variable_of_arrays,
                    o_clob                 => v_insert_sql_stmt);

      /*

          v_insert_sql_stmt := 'INSERT INTO ' || p_target_schema_name || '.' || p_target_table_name || CHR(10) ||
            '(' || v_target_columns_list || ')' || CHR(10) ||
            'SELECT' || CHR(10) ||
            v_source_columns_list || CHR(10) ||
            'FROM ' || v_full_source_name;
      */

      --dbms_output.put_line(v_insert_sql_stmt);

      /* 8. ������������ [����/����� ������ �����] = SYSDATE */

      v_start_cur_stmt_date := SYSDATE;

      /*
      9. ���������� ������ ����� ������� ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
          � p_folder_name      = <p_folder_name>
          � p_workflow_name    = <p_workflow_name>
          � p_proc_name        = �API_UPLOAD.REPLACE_SSTAT�
          � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
          � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
          � p_job_id           = <p_job_id>
          � p_start_dttm       = [����/����� ������ �����]
          � p_message_text     = �Start truncate table <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SSTAT',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       => 'Start truncate table ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /* 10. ����������� <SQL �������> */

      IF NOT v_partition_existence
      THEN
         EXECUTE_QUERY (p_folder_name        => p_folder_name,
                        p_workflow_name      => p_workflow_name,
                        p_procedure_name     => 'API_UPLOAD.REPLACE_SSTAT',
                        p_targettable_name   => v_full_target_name,
                        p_job_id             => p_job_id,
                        p_sql_text           => v_delete_stmt);
      --EXECUTE IMMEDIATE v_delete_stmt;
      ELSE
         IF p_truncate_table = 1
         THEN
         
            TRUNC_TABLE (p_shema_name => p_target_schema_name, 
                         p_table_name => p_target_table_name);
--            EXECUTE_QUERY (p_folder_name        => p_folder_name,
--                           p_workflow_name      => p_workflow_name,
--                           p_procedure_name     => 'API_UPLOAD.REPLACE_SSTAT',
--                           p_targettable_name   => v_full_target_name,
--                           p_job_id             => p_job_id,
--                           p_sql_text           => v_truncate_stmt);

            --EXECUTE IMMEDIATE v_truncate_stmt;
         ELSE
            /* TODO: ����������� ���������� ������ truncate
            FOR x in to_number(to_char(p_start_date, 'j'))..to_number(to_char(p_end_date, 'j')) LOOP
              --dbms_output.put_line( 'ALTER TABLE ' || v_full_target_name || ' TRUNCATE PARTITION P' || to_char(to_date(x, 'j'), 'yyyymmdd'));
              EXECUTE IMMEDIATE 'ALTER TABLE ' || v_full_target_name || ' TRUNCATE PARTITION P' || to_char(to_date(x, 'j'), 'yyyymmdd');
            END LOOP;
            */

            TRUNC_PARTITIONS (p_table_name      => p_target_table_name,
                              p_partition_fmt   => p_partition_fmt,
                              p_start_date      => p_start_date,
                              p_end_date        => p_end_date);
         END IF;
      END IF;

      /*
      11. ���������� ��������� ����� ������� ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SSTAT�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_end_dttm         = SYSDATE
        � p_message_text     = �End truncate table <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SSTAT',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'End truncate table ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /* 12. ���������������� [����/����� ������ �����] = SYSDATE */

      v_start_cur_stmt_date := SYSDATE;

      /*
      13. ���������� ������ ����� �������� ������ � ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SSTAT�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_message_text     = �Start insert into <p_target_schema_name>.<p_target_table_name>�
       */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SSTAT',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => NULL,
         P_MESSAGE_TEXT       => 'Start insert into ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /* 14. ����������� <SQL ��������> */

      EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.REPLACE_SSTAT',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_insert_sql_stmt);

      --EXECUTE IMMEDIATE v_insert_sql_stmt;

      /* 15. ����������� ������������� ��������� ������ � ������� �������. */

      COMMIT;

      /*
      16. ���������� ��������� ����� �������� ������ � ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SSTAT�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_end_dttm         = SYSDATE
        � p_message_text     = �End insert into <p_target_schema_name>.<p_target_table_name>�
      */


      /*���� ����������
      
      
      */
      
       v_sql :=   q'{BEGIN
    %v_target_schema_name%.GATHER_TABLE_STATS(P_OWNER => '%v_target_schema_name%' , P_ENTITY_NAME => '%v_target_table_name%', P_ESTIMATE_PERCENT => 0.0001);
    END;}';

       
      get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);


      EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.REPLACE_SSTAT',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_sql);

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SSTAT',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'End insert into ' || p_target_table_name,
         P_SQL_TEXT           => NULL);

      /*
      17. ���������� ��������� ������ ��������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SSTAT�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ ���������]
        � p_end_dttm       = SYSDATE
        � p_message_text = �End API_UPLOAD.REPLACE_SAGG�
      */


      


      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.REPLACE_SSTAT',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_start_proc_date,
                       P_END_DTTM           => SYSDATE,
                       P_MESSAGE_TEXT       => 'END API_UPLOAD.REPLACE_SSTAT',
                       P_SQL_TEXT           => NULL);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE NOT BETWEEN -20999 AND -20000
         THEN
            UTL_ERRHANDLERS.RAISE_ERROR (
               P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
               P_ERRMSG_TEXT      => '��������� ������',
               P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SSTAT',
               P_SEVERITY_CODE    => 'S',
               P_SQLERRM_TEXT     => SQLERRM);
         END IF;

         RAISE;
   END;

   PROCEDURE REPLACE_SAGG (
      p_folder_name          IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC*/
      p_workflow_name        IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
      p_source_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
      p_source_table_name    IN VARCHAR2, /* �������� ������� �������� SQL-����� �������-��������� */
      p_target_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
      p_target_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
      p_column_date          IN VARCHAR2,
      p_start_date           IN DATE, /* �������� ��������� �������� ���� ������ ������� ������ */
      p_end_date             IN DATE, /* �������� ��������� �������� ���� ��������� ������� ������ */
      p_truncate_table       IN NUMBER DEFAULT 0, /* �������� ��������� �������� �������� ������ ������� ������� ��� �������������� ��������: 1 - ���������, 0 - �� ��������� */
      p_partition_fmt        IN VARCHAR2 DEFAULT 'yyyymmdd', /* �������� ��������� �������� ������� ������������� ��� ��� ����������� ����� �������� */
      p_job_id               IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
      p_as_of_day            IN DATE DEFAULT SYSDATE /* �������� ��������� �������� ���� ���������� ���������������� ���� */
                                                    )
   IS
      v_start_proc_date       DATE;
      v_start_cur_stmt_date   DATE;
      v_full_source_name      VARCHAR2 (4000);
      v_full_target_name      VARCHAR2 (4000);
      v_cnt                   NUMBER;
      v_source_columns_list   VARCHAR2 (4000);
      v_target_columns_list   VARCHAR2 (4000);
      v_partition_existence   BOOLEAN;
      v_delete_stmt           VARCHAR2 (4000);
      v_start_date            DATE;
      v_end_date              DATE;
      v_insert_sql_stmt       VARCHAR2 (4000);
      v_truncate_stmt         VARCHAR2 (4000);
      v_column_date           VARCHAR2 (4000);

      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* 1. ������������ [����/����� ������ ���������] = SYSDATE */

      v_start_proc_date := SYSDATE;

      v_column_date := NVL (p_column_date, 'VALUE_DAY');
      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;

      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (SYSDATE, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;

      /*
      2. ���������� ������ ������ ��������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SAGG�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = SYSDATE
        � p_message_text     = �Start API_UPLOAD.REPLACE_SAGG�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SAGG',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_MESSAGE_TEXT       => 'Start API_UPLOAD.REPLACE_SAGG',
         P_SQL_TEXT           => NULL);

      /*3. �������� ����������:
        a. ���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
        � p_severity_code  = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
        b. ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
          � p_exception_name = �e_paramvalue_empty�
          � p_errmsg_text    = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
          � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
          � p_severity_code  = �E�
      */

      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      c. ���� p_source_schema_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
        � p_severity_code  = �E�
      */

      IF P_SOURCE_SCHEMA_NAME IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      d. ���� p_source_table_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
      � p_exception_name = �e_paramvalue_empty�
      � p_errmsg_text    = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
      � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
      � p_severity_code  = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_source_table_name �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e. ���� p_target_schema_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
        � p_severity_code  = �E�
      */

      IF P_TARGET_SCHEMA_NAME IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      f. ���� p_target_table_name ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
        � p_severity_code  = �E�
      */

      IF P_TARGET_TABLE_NAME IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      g. ���� p_start_date ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_START_DATE �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
        � p_severity_code  = �E�
      */

      IF p_start_date IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_start_date �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      h. ���� p_end_date ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_paramvalue_empty�
        � p_errmsg_text    = ��������� ��������� P_END_DATE �� ����� ��������� �������� NULL�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
        � p_severity_code  = �E�
      */

      IF p_end_date IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_end_date �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      i. ���� p_job_id ����� NULL,
      �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
      � p_exception_name = �e_paramvalue_empty�
      � p_errmsg_text    = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
      � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
      � p_severity_code  = �E�
      */


      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� p_job_id �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;



      /*
      4. ���� �� ������� �� ����� ������ � ������� ���������� MD_COLUMNS �� �������:
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME  = <p_target_table_name>
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � p_exception_name = �e_md_columns_empty�
        � p_errmsg_text    = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        � p_plsqlunit_name = �API_UPLOAD.REPLACE_SAGG�
        � p_severity_code  = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;


      /*
      5. ����������� <������ ����� ������� �������> � <������ ����� �������� ���������> �� ������� ������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME  = <p_target_table_name>


       */

      /*
          v_source_columns_list := get_SOURCE_COLUMNS(
            P_TARGET_SCHEMA_NAME => p_target_schema_name,
            P_TARGET_TABLE_NAME  => p_target_table_name,
            P_AS_OF_DAY          => p_as_of_day
          );

          v_target_columns_list := get_TARGET_COLUMNS(
            P_TARGET_SCHEMA_NAME => p_target_schema_name,
            P_TARGET_TABLE_NAME  => p_target_table_name
          );
      */



      /*    SELECT LISTAGG(CASE WHEN COLUMN_NAME IN ('JOB_INSERT', 'JOB_UPDATE') THEN 'DMSJOB'
                              WHEN COLUMN_NAME IN ('DWSCMIX', 'EMIX') THEN 'DMSEMIX'
                              WHEN COLUMN_NAME = 'AS_OF_DAY' THEN 'TO_DATE(''' || TO_CHAR(p_as_of_day,'yyyymmdd') || ''', ''yyyymmdd'')'
                              WHEN NVL_FLAG    = 'Y' THEN 'NVL(' || COLUMN_NAME || ',''' || DEFAULT_VALUE || ''')'
                              ELSE COLUMN_NAME
                         END, ',') WITHIN GROUP (ORDER BY COLUMN_NAME) s,
                 LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY COLUMN_NAME) s
            INTO v_source_columns_list, v_target_columns_list
            FROM MD_COLUMNS
           WHERE SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME  = p_target_table_name
        GROUP BY SCHEMA_NAME, TABLE_NAME;*/

      -- dbms_output.put_line(v_target_columns_list);
      -- dbms_output.put_line(v_source_columns_list);


      /*
      6. ����������� <SQL �������>:
        � ���� <p_truncate_table = 1,
        �� ������� ��������� �� �������:
        TRUNCATE TABLE <p_target_schema_name>.<p_target_table_name>
        � ���� <p_truncate_table> = 0,
        �� ����������� �������� ������ ��� ������ �������� ������� <p_target_schema_name>.<p_target_table_name>, ����� ������� ��������� ����� [����������� ���������] � [������������ ���������] �� �������:
        ALTER TABLE <p_target_schema_name>.<p_target_table_name>
        TRUNCATE PARTITION [PARTITION_NAME]
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM all_tab_partitions
       WHERE     table_owner = p_target_schema_name
             AND table_name = p_target_table_name;


      v_partition_existence := v_cnt <> 0;

      v_start_date := p_start_date;
      v_end_date := p_end_date;

      IF p_truncate_table = 1
      THEN
         /* TODO: ����������� ��������� ������ truncate
          v_truncate_stmt := 'TRUNCATE TABLE '||v_full_target_name; */
         v_truncate_stmt := 'TRUNCATE TABLE ' || v_full_target_name;
         v_delete_stmt := 'DELETE FROM ' || v_full_target_name;
      ELSE
         IF NOT v_partition_existence
         THEN
            v_delete_stmt :=
                  'DELETE FROM '
               || v_full_target_name
               || ' WHERE '
               || v_column_date
               || ' >= TO_DATE('''
               || TO_CHAR (v_start_date, 'yyyymmdd')
               || ''', ''yyyymmdd'') AND '
               || v_column_date
               || ' < TO_DATE('''
               || TO_CHAR (TRUNC (v_end_date) + 1, 'yyyymmdd')
               || ''', ''yyyymmdd'')';
            DBMS_OUTPUT.put_line (v_delete_stmt);
         --     EXECUTE IMMEDIATE v_delete_stmt;
         ELSE
            -- TODO: ����������� ���������� ������ truncate
            /* v_delete_stmt := 'DELETE FROM ' || v_full_target_name || ' WHERE ' || v_column_date || ' >= TO_DATE(''' ||
                              TO_CHAR(v_start_date, 'yyyymmdd') || ''', ''yyyymmdd'') AND '|| v_column_date || ' < TO_DATE(''' || TO_CHAR(trunc(v_end_date)+1, 'yyyymmdd') || ''', ''yyyymmdd'')';
            */
            NULL;
         END IF;
      END IF;

      /*
      7. ����������� <SQL ��������> �� �������:
        INSERT INTO <p_target_schema_name>.<p_target_table_name>
                   (<������ ����� ������� �������>)
        SELECT
                   <������ ����� �������� ���������>
        FROM <p_source_schema_name>.<p_source_table_name>
      */

      get_sql_stmt (p_proc_template_name   => '%REPLACE_SAGG%',
                    p_variables            => v_variable_of_arrays,
                    o_clob                 => v_insert_sql_stmt);



      DBMS_OUTPUT.put_line (v_insert_sql_stmt);


      /*
      8. ������������ [����/����� ������ �����] = SYSDATE
      */

      v_start_cur_stmt_date := SYSDATE;

      /*
      9. ���������� ������ ����� ������� ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
          � p_folder_name      = <p_folder_name>
          � p_workflow_name    = <p_workflow_name>
          � p_proc_name        = �API_UPLOAD.REPLACE_SAGG�
          � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
          � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
          � p_job_id           = <p_job_id>
          � p_start_dttm       = [����/����� ������ �����]
          � p_message_text     = �Start truncate table <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SAGG',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       => 'Start truncate table ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /*
      10. ����������� <SQL �������>
      */

      IF NOT v_partition_existence
      THEN
         EXECUTE IMMEDIATE v_delete_stmt;
      ELSE
         IF p_truncate_table = 1
         THEN
            EXECUTE_QUERY (p_folder_name        => p_folder_name,
                           p_workflow_name      => p_workflow_name,
                           p_procedure_name     => 'API_UPLOAD.REPLACE_SAGG',
                           p_targettable_name   => v_full_target_name,
                           p_job_id             => p_job_id,
                           p_sql_text           => v_truncate_stmt);
--            EXECUTE IMMEDIATE v_truncate_stmt;
         ELSE
            /* TODO: ����������� ���������� ������ truncate
            FOR x in to_number(to_char(p_start_date, 'j'))..to_number(to_char(p_end_date, 'j')) LOOP
              --dbms_output.put_line( 'ALTER TABLE ' || v_full_target_name || ' TRUNCATE PARTITION P' || to_char(to_date(x, 'j'), 'yyyymmdd'));
              EXECUTE IMMEDIATE 'ALTER TABLE ' || v_full_target_name || ' TRUNCATE PARTITION P' || to_char(to_date(x, 'j'), 'yyyymmdd');
            END LOOP;
            */

            TRUNC_PARTITIONS (p_table_name      => p_target_table_name,
                              p_partition_fmt   => p_partition_fmt,
                              p_start_date      => p_start_date,
                              p_end_date        => p_end_date);
         END IF;
      END IF;

      /*
      11. ���������� ��������� ����� ������� ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SAGG�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_end_dttm         = SYSDATE
        � p_message_text     = �End truncate table <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SAGG',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'End truncate table ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /*
      12. ���������������� [����/����� ������ �����] = SYSDATE
       */

      v_start_cur_stmt_date := SYSDATE;

      /*
      13. ���������� ������ ����� �������� ������ � ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SAGG�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_message_text     = �Start insert into <p_target_schema_name>.<p_target_table_name>�
       */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SAGG',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => NULL,
         P_MESSAGE_TEXT       => 'Start insert into ' || v_full_target_name,
         P_SQL_TEXT           => NULL);

      /*
      14. ����������� <SQL ��������>
      */
      EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.REPLACE_SAGG',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_insert_sql_stmt);
      --EXECUTE IMMEDIATE v_insert_sql_stmt;

      /*
      15. ����������� ������������� ��������� ������ � ������� �������.
      */

      COMMIT;

      /*
      16. ���������� ��������� ����� �������� ������ � ������� ������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SAGG�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ �����]
        � p_end_dttm       = SYSDATE
        � p_message_text     = �End insert into <p_target_schema_name>.<p_target_table_name>�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.REPLACE_SAGG',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'End insert into ' || p_target_table_name,
         P_SQL_TEXT           => NULL);

      /*
      17. ���������� ��������� ������ ��������� � ������� API_ETL.LOG_SQL, ��������� � �����������:
        � p_folder_name      = <p_folder_name>
        � p_workflow_name    = <p_workflow_name>
        � p_proc_name        = �API_UPLOAD.REPLACE_SAGG�
        � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
        � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
        � p_job_id           = <p_job_id>
        � p_start_dttm       = [����/����� ������ ���������]
        � p_end_dttm       = SYSDATE
        � p_message_text = �End API_UPLOAD.REPLACE_SAGG�
      */

      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.REPLACE_SAGG',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_start_proc_date,
                       P_END_DTTM           => SYSDATE,
                       P_MESSAGE_TEXT       => 'END API_UPLOAD.REPLACE_SAGG',
                       P_SQL_TEXT           => NULL);
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE NOT BETWEEN -20999 AND -20000
         THEN
            UTL_ERRHANDLERS.RAISE_ERROR (
               P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
               P_ERRMSG_TEXT      => '��������� ������',
               P_PLSQLUNIT_NAME   => 'API_UPLOAD.REPLACE_SAGG',
               P_SEVERITY_CODE    => 'S',
               P_SQLERRM_TEXT     => SQLERRM);
         END IF;

         RAISE;
   END;

   PROCEDURE MERGE_DIM2SDIM (p_folder_name          IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
                             p_workflow_name        IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
                             p_source_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
                             p_source_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� �������-��������� */
                             p_target_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
                             p_target_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
                             p_job_id               IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
                             p_as_of_day            IN DATE DEFAULT SYSDATE, /* �������� ��������� �������� ���� ���������� ���������������� ���� */
                             p_loading_mode         IN VARCHAR2 /* �������� ��������� �������� ������ ��������: INITIAL ��� INCREMENT */
                                                               )
   IS
      v_insert_sql_stmt       CLOB;
      v_start_proc_date       DATE;
      v_full_source_name      VARCHAR2 (255);
      v_full_target_name      VARCHAR2 (255);
      v_cnt                   NUMBER;
      v_source_columns_list   CLOB;
      v_target_columns_list   CLOB;
      v_upd_columns_list      CLOB;
      v_key_columns_list      CLOB;
      v_sql                   CLOB;
      v_start_cur_stmt_date DATE;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* 1. ������������ [����/����� ������ ���������] = SYSDATE */
      v_start_proc_date := SYSDATE;
      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;

      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (SYSDATE, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;
      v_variable_of_arrays ('%v_source_schema_name%') := p_source_schema_name;
      v_variable_of_arrays ('%v_source_table_name%') := p_source_table_name;
      v_variable_of_arrays ('%v_dmsjob%') := p_job_id;



      /*
        2. ��� ����������� ������ ������ ��������� ���������� API_ETL.LOG_SQL � �����������:
          � p_folder_name = <p_folder_name>
          � p_workflow_name = <p_workflow_name>
          � p_proc_name = �API_UPLOAD.MERGE_HDIM2SDIM�
          � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
          � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
          � p_job_id = <p_job_id>
          � p_start_dttm = sysdate
          � p_message_text = �Start API_UPLOAD.MERGE_HDIM2SDIM�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.MERGE_DIM2SDIM',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_MESSAGE_TEXT       => 'START API_UPLOAD.MERGE_DIM2SIM');

      /* 3. �������� ���������� */
      /*
      a. ���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      b. ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */
      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      c. ���� p_source_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_source_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      d. ���� p_source_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e. ���� p_target_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_target_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      f. ���� p_target_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_target_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      g. ���� p_job_id ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_JOB_ID �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      h. ���� p_loading_mode ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e. ���� p_loading_mode �� ������������� ��������� INITIAL ��� INCREMENT,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_bad�
        � P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL ��� INCREMENT�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode NOT IN ('INITIAL', 'INCREMENT')
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_bad',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL ��� INCREMENT',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      4. ����������� �������� ������� ����� ��� �������� � ������� ���������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME = <p_target_table_name>
      ���� �� ������� �� ����� ������,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_md_columns_empty�
        � P_ERRMSG_TEXT = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_DIM2SDIM',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      5. ����������� <������ ����� ������� �������> � <������ ����� �������� ���������> �� ������� ������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME = <p_target_table_name>
      */



      IF p_LOADING_MODE = 'INITIAL'
      THEN
         REPLACE_SDIM (P_FOLDER_NAME          => p_folder_name,
                       P_WORKFLOW_NAME        => p_workflow_name,
                       P_SOURCE_SCHEMA_NAME   => p_source_schema_name,
                       P_SOURCE_TABLE_NAME    => p_source_table_name,
                       P_TARGET_SCHEMA_NAME   => p_target_schema_name,
                       P_TARGET_TABLE_NAME    => p_target_table_name,
                       P_JOB_ID               => p_job_id,
                       P_AS_OF_DAY            => p_as_of_day);
      ELSE
         /*
             v_source_columns_list := get_SOURCE_COLUMNS(
               P_TARGET_SCHEMA_NAME => p_target_schema_name,
               P_TARGET_TABLE_NAME  => p_target_table_name,
               P_AS_OF_DAY          => p_as_of_day
             );

             v_target_columns_list := get_TARGET_COLUMNS(
               P_TARGET_SCHEMA_NAME => p_target_schema_name,
               P_TARGET_TABLE_NAME  => p_target_table_name
             );

             v_key_columns_list :=  get_KEY_COLUMNS(
               P_TARGET_SCHEMA_NAME => p_target_schema_name,
               P_TARGET_TABLE_NAME => p_target_table_name,
               P_SOURCE_TABLE_NAME  => p_source_table_name
             );

             v_upd_columns_list := get_UPD_COLUMNS(
               P_TARGET_SCHEMA_NAME => p_target_schema_name,
               P_TARGET_TABLE_NAME  => p_target_table_name,
               P_SOURCE_TABLE_NAME  => p_source_table_name,
               P_AS_OF_DAY          => p_as_of_day
             );*/



         /* check VALID_TO existence */

         /*    SELECT count(*)
               INTO v_cnt
               FROM all_tab_columns
              WHERE OWNER       = p_source_schema_name
                AND TABLE_NAME  = p_source_table_name
                AND COLUMN_NAME = 'VALID_FROM';*/

         get_sql_stmt (p_proc_template_name   => '%MERGE_DIM2SDIM%',
                       p_variables            => v_variable_of_arrays,
                       o_clob                 => v_insert_sql_stmt);


         DBMS_OUTPUT.PUT_LINE (v_insert_sql_stmt);
         EXECUTE_QUERY (p_folder_name        => p_folder_name,
                        p_workflow_name      => p_workflow_name,
                        p_procedure_name     => 'API_UPLOAD.REPLACE_SSTAT',
                        p_targettable_name   => v_full_target_name,
                        p_job_id             => p_job_id,
                        p_sql_text           => v_insert_sql_stmt);
         --EXECUTE IMMEDIATE v_insert_sql_stmt;

 v_start_cur_stmt_date := SYSDATE;
   
  
    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => NULL,
            P_MESSAGE_TEXT       =>    'Start gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

 
    v_sql :=   q'{BEGIN
    %v_target_schema_name%.GATHER_TABLE_STATS(P_OWNER => '%v_target_schema_name%' , P_ENTITY_NAME => '%v_target_table_name%', P_ESTIMATE_PERCENT => 0.0001);
    END;}';

       
    get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);


    EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.MERGE_STAT2HIST',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_sql);
   
    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'End gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);
         COMMIT;
      END IF;
   END;


   PROCEDURE MERGE_STAT2HIST (/*
                                ����������:
                                ��������� ������������� ��� ������������� ������� � ��������������� �������� ������ ���� *DIM ������� ����������
                                  � ������� � ��������������� ���� *STAT � *HIST
                                ��������� ����������� � ������ ��������� ����������.
                                ��� ���������: API
                              */
                              p_folder_name          IN VARCHAR2, /* �������� ��������� �������� ����� ����� IPC, � ������� ����������� ������ IPC */
                              p_workflow_name        IN VARCHAR2, /* �������� ��������� �������� ����� ������ IPC */
                              p_source_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� �������-��������� */
                              p_source_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� �������-��������� */
                              p_target_schema_name   IN VARCHAR2, /* �������� ��������� �������� SQL-����� ����� ������� ������� */
                              p_target_table_name    IN VARCHAR2, /* �������� ��������� �������� SQL-����� ������� ������� */
                              p_start_date           IN DATE,
                              p_end_date             IN DATE,
                              p_job_id               IN NUMBER, /* �������� ��������� �������� �������������� ���������� ������� ETL */
                              p_as_of_day            IN DATE DEFAULT SYSDATE, /* �������� ��������� �������� ���� ���������� ���������������� ���� */
                              p_loading_mode         IN VARCHAR2 /* �������� ��������� �������� ������ ��������: INITIAL ��� INCREMENT */
                                                                )
   IS
      v_insert_sql_stmt       CLOB;
      v_start_cur_stmt_date   DATE;
      v_start_proc_date       DATE;
      v_full_source_name      VARCHAR2 (255);
      v_full_target_name      VARCHAR2 (255);
      v_cnt                   NUMBER;
      v_sql                   CLOB;
      v_source_columns_list   CLOB;
      v_target_columns_list   CLOB;
      v_upd_columns_list      CLOB;
      v_key_columns_list      CLOB;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* 1. ������������ [����/����� ������ ���������] = SYSDATE */
      v_start_proc_date := SYSDATE;
      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;


      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (SYSDATE, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;
      v_variable_of_arrays ('%v_source_schema_name%') := p_source_schema_name;
      v_variable_of_arrays ('%v_source_table_name%') := p_source_table_name;
      v_variable_of_arrays ('%v_dmsjob%') := p_job_id;
      v_variable_of_arrays ('%v_folder_name%') := p_folder_name;
      v_variable_of_arrays ('%v_workflow_name%') := p_workflow_name;
      v_variable_of_arrays ('%v_start_date%') := p_start_date;
      v_variable_of_arrays ('%v_end_date%') := p_end_date;
      v_variable_of_arrays ('%v_loading_mode%') := p_loading_mode;
      v_variable_of_arrays ('%v_pby%') := 'PARTITION BY';

      /*
        2. ��� ����������� ������ ������ ��������� ���������� API_ETL.LOG_SQL � �����������:
          � p_folder_name = <p_folder_name>
          � p_workflow_name = <p_workflow_name>
          � p_proc_name = �API_UPLOAD.MERGE_STAT2HIST�
          � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
          � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
          � p_job_id = <p_job_id>
          � p_start_dttm = sysdate
          � p_message_text = �Start API_UPLOAD.MERGE_STAT2HIST�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_MESSAGE_TEXT       => 'START API_UPLOAD.MERGE_STAT2HIST');

      /* 3. �������� ���������� */
      /*
      a. ���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      b. ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */
      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      c. ���� p_source_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_STAT2HIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_source_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      d. ���� p_source_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_STAT2HIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e. ���� p_target_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_STAT2HIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_target_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      f. ���� p_target_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_STAT2HIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_target_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      g. ���� p_job_id ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_STAT2HIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_JOB_ID �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      h. ���� p_loading_mode ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_STAT2HIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e. ���� p_loading_mode �� ������������� ��������� INITIAL ��� INCREMENT,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_bad�
        � P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL ��� INCREMENT�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_DIM2SDIM�
        � P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode NOT IN ('INITIAL', 'INCREMENT')
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_bad',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL ��� INCREMENT',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      4. ����������� �������� ������� ����� ��� �������� � ������� ���������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME = <p_target_table_name>
      ���� �� ������� �� ����� ������,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_md_columns_empty�
        � P_ERRMSG_TEXT = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_STAT2HIST�
        � P_SEVERITY_CODE = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_STAT2HIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      5. ����������� <������ ����� ������� �������> � <������ ����� �������� ���������> �� ������� ������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME = <p_target_table_name>
      */


      IF p_loading_mode = 'INITIAL'
      THEN
         v_sql := 'TRUNCATE TABLE ' || v_full_target_name || ' DROP STORAGE';


         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       => 'START TRUNCATE ' || v_full_target_name,
            P_SQL_TEXT           => v_sql);

         DBMS_OUTPUT.put_line (v_sql);
         -- EXECUTE IMMEDIATE v_sql;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       => 'END TRUNCATE ' || v_full_target_name,
            P_SQL_TEXT           => v_sql);


         v_sql :=
            q'{insert /*+ append*/
                   into %v_target_schema_name%.%v_target_table_name% (%TARGET_COLUMNS_LIST%)
                   select /*+  parallel(4) */
                          %SOURCE_COLUMNS_LIST%
                     from %v_source_schema_name%.%v_source_table_name%
                }';


         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         DBMS_OUTPUT.put_line (v_sql);
      /*
      select *
      from mmd_templates

       */

      ELSE
         v_sql :=
            q'{
                  alter table %v_source_schema_name%.%v_source_table_name% truncate partition PPREVIOUS
               }';

         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         DBMS_OUTPUT.put_line (v_sql);

         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       =>    'START TRUNCATE PARTITION PPREVIOUS IN  '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

         --execute immediate v_sql;
         IF NOT v_debug_mode
         THEN
            EXECUTE IMMEDIATE v_sql;
         ELSE
            DBMS_OUTPUT.PUT_LINE (
               '��� 3. ��������������� ������� ������ PPREVIOUS � ������� _DMDELTA');
            DBMS_OUTPUT.PUT_LINE (v_sql);
         END IF;


         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'END TRUNCATE PARTITION PPREVIOUS IN  '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);


         --* ��������������� ������� ������ PDELTA � ������� _DMDELTA


         v_sql :=
            q'{
                  alter table %v_source_schema_name%.%v_source_table_name% truncate partition PDELTA
               }';

         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       =>    'START TRUNCATE PARTITION PDELTA IN  '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

         --execute immediate v_sql;
         IF NOT v_debug_mode
         THEN
            EXECUTE IMMEDIATE v_sql;
         ELSE
            DBMS_OUTPUT.PUT_LINE (
               '��� 3. ��������������� ������� ������ PDELTA � ������� _DMDELTA');
            DBMS_OUTPUT.PUT_LINE (v_sql);
         END IF;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'END TRUNCATE PARTITION PDELTA IN  '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);



         --* �������� ���������� ������ � �������� PDELTA *_dmdelta
         v_sql :=
            q'{insert /*+ append*/
                 into %v_source_schema_name%.%v_source_table_name% (%CX_SHIST_SRC_COL_NAMES%, dmsdelta)
                 with delta
                    as
                      (
                       select /*+ dynamic_sampling(%v_source_table_name% 2) */
                        %CX_SHIST_SRC_COL_NAMES%
                        from %v_source_schema_name%.%v_source_table_name%
                      )
                 select /*+ use_hash(%v_source_table_name% %v_target_table_name%) parallel(4) */
                     distinct
                        %CX_SHIST_SRC_COLS_DELTA%,
                        1 dmsdelta
                   from delta left join %v_target_schema_name%.%v_target_table_name%
                                   on ( %CX_SHIST_KEY_JOINS%
                                   and delta.EFFECTIVE_from between %v_target_table_name%.EFFECTIVE_from and %v_target_table_name%.EFFECTIVE_TO
                                   )

                  where
                     (%CX_SHIST_COMPARE%)
              }';

         /*
         select *
         from mmd_templates
         select *
         from md_columns
         */


         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       =>    ' Start copy changed data -> *_dmdelta to  '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

         --execute immediate v_sql;
         IF NOT v_debug_mode
         THEN
            EXECUTE IMMEDIATE v_sql;
         ELSE
            DBMS_OUTPUT.PUT_LINE (
               '��� 4. �������� ���������� ������ � �������� PDELTA *_dmdelta');
            DBMS_OUTPUT.PUT_LINE (v_sql);
         END IF;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    ' END copy changed data -> *_dmdelta to  '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);


         v_sql :=
            q'{insert /*+ append*/
                  all
                 -- ��������� �������� ������ ��������� ����������� ���������, ������������ ��� ����� ������� ���������
                 when 1=1 --EFFECTIVE_FROM <= min_effective_from
                  then into %v_source_schema_name%.%v_source_table_name% (%CX_SHIST_SRC_COL_NAMES%, dmsdelta)
                    values (%CX_SHIST_SRC_COL_NAMES%, 0)
                 --��������� rowid ������� ������� ��� ������������ ��������
                 when 1 = 1
                  then into %v_source_schema_name%.TMP_ROWID_EFF (PROWID,ACT,JOB) values (TGT_ROWID, 'D', DMSJOB)

                 with delta
                    as
                      (
                       select %CX_SHIST_AGG_KEY_COLS%,
                          min(effective_from)  as  min_effective_from
                         from %v_source_schema_name%.%v_source_table_name%
                         where DMSDELTA<>2
                        group by %CX_SHIST_AGG_KEY_COLS%
                      )
                 select /*+ use_hash(%v_source_table_name% %v_target_table_name%) dynamic_sampling(%v_source_table_name% 2) parallel(4) */
                        %v_target_table_name%.rowid as TGT_ROWID,
                        '%v_target_table_name%'     as TARGET_TABLE_NAME,
                          %CX_SHIST_TRG_COLS_DELTA%,
                        min_effective_from
                   from delta,
                        %v_target_schema_name%.%v_target_table_name%
                  where %CX_SHIST_KEY_JOINS%
                    and %v_target_table_name%.EFFECTIVE_TO > min_effective_from
              }';

         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       =>    'Start copy previous data -> *_dmdelta'
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

         --execute immediate 'truncate table ' || p_source_schema_name ||'.tmp_rowid_eff';
         DBMS_OUTPUT.put_line (
            'truncate table ' || p_source_schema_name || '.tmp_rowid_eff');

         --execute immediate v_sql;
         IF NOT v_debug_mode
         THEN
            EXECUTE IMMEDIATE v_sql;
         ELSE
            DBMS_OUTPUT.PUT_LINE (
               '��� 5.�������� ������ �� Hist');
            DBMS_OUTPUT.PUT_LINE (v_sql);
         END IF;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'End copy previous data -> *_dmdelta'
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);



         --* ������� ������ �� ������� �������
         v_sql :=
               'merge /*+ use_hash(t)*/ into '
            || p_target_schema_name
            || '.'
            || p_target_table_name
            || ' t
              using (select PROWID
                       from '
            || p_source_schema_name
            || '.tmp_rowid_eff
                    ) s
                 on (t.rowid = s.PROWID)
              when matched then UPDATE SET t.DELETED_FLAG=t.DELETED_FLAG
                                delete where 1=1';


         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       => 'Start delete rows' || v_full_target_name,
            P_SQL_TEXT           => v_sql);

         --execute immediate v_sql;
         IF NOT v_debug_mode
         THEN
            EXECUTE IMMEDIATE v_sql;
         ELSE
            DBMS_OUTPUT.PUT_LINE (
               '��� 6. ������� ������ �� ������� �������');
            DBMS_OUTPUT.PUT_LINE (v_sql);
         END IF;


         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'End delete rows',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'End copy previous data -> *_dmdelta'
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);



         v_sql :=
            q'{insert
                 all
                 when effective_from < effective_to then into %v_target_schema_name%.%v_target_table_name%
                     (EFFECTIVE_TO, %CX_SHIST_AGG_TRG_COLS%)
               with dmdelta as (
                    select
                       %CX_SHIST_LAGC_COLS%
                       ,src.*
                    from  %v_source_schema_name%.%v_source_table_name% src  where DMSDELTA<>2
                    )
               select /*+ parallel(4)*/
                      LEAD(EFFECTIVE_FROM, 1, TO_DATE('5999-12-31', 'yyyy-mm-dd')) over (%v_pby%  %CX_SHIST_AGG_KEY_COLS% order by  effective_from, EFFECTIVE_TO, dmsdelta) as effective_to,
                      %CX_SHIST_AGG_RESULT_COLS%
                 from dmdelta
                     where %STAT_SHIST_PREV_COMPARE%
             }';

         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       =>    'Start copy changed data -> *_dmdelta'
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

         --execute immediate v_sql;
         IF NOT v_debug_mode
         THEN
            EXECUTE IMMEDIATE v_sql;
         ELSE
            DBMS_OUTPUT.PUT_LINE ('��� 7. ������� ������');
            DBMS_OUTPUT.PUT_LINE (v_sql);
         END IF;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'End copy changed data -> *_dmdelta'
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);
      END IF;
   /* TODO: ���� ���������� */
   
    v_start_cur_stmt_date := SYSDATE;
   
  
    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => NULL,
            P_MESSAGE_TEXT       =>    'Start gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

 
    v_sql :=   q'{BEGIN
    %v_target_schema_name%.GATHER_TABLE_STATS(P_OWNER => '%v_target_schema_name%' , P_ENTITY_NAME => '%v_target_table_name%', P_ESTIMATE_PERCENT => 0.0001);
    END;}';

       
    get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);


    EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.MERGE_STAT2HIST',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_sql);
   
    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_STAT2HIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'End gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);


   END;



   PROCEDURE COMPLEX_SHIST (p_folder_name          IN VARCHAR2,
                            p_workflow_name        IN VARCHAR2,
                            p_source_schema_name   IN VARCHAR2,
                            p_source_table_name    IN VARCHAR2,
                            p_target_schema_name   IN VARCHAR2,
                            p_target_table_name    IN VARCHAR2,
                            p_start_date           IN DATE,
                            p_end_date             IN DATE,
                            p_job_id               IN NUMBER,
                            p_as_of_day            IN DATE DEFAULT SYSDATE,
                            p_loading_mode         IN VARCHAR2)
   IS
      v_insert_sql_stmt       CLOB;
      v_start_cur_stmt_date   DATE;
      v_start_proc_date       DATE;
      v_full_source_name      VARCHAR2 (255);
      v_full_target_name      VARCHAR2 (255);
      v_cnt                   NUMBER;
      v_sql                   CLOB;
      v_source_columns_list   CLOB;
      v_target_columns_list   CLOB;
      v_upd_columns_list      CLOB;
      v_key_columns_list      CLOB;
      v_flag                  INTEGER;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* 1. ������������ [����/����� ������ ���������] = SYSDATE */
      v_start_proc_date := SYSDATE;
      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;


      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (SYSDATE, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;
      v_variable_of_arrays ('%v_source_schema_name%') := p_source_schema_name;
      v_variable_of_arrays ('%v_source_table_name%') := p_source_table_name;
      v_variable_of_arrays ('%v_dmsjob%') := p_job_id;
      v_variable_of_arrays ('%v_folder_name%') := p_folder_name;
      v_variable_of_arrays ('%v_workflow_name%') := p_workflow_name;
      v_variable_of_arrays ('%v_start_date%') := p_start_date;
      v_variable_of_arrays ('%v_end_date%') := p_end_date;
      v_variable_of_arrays ('%v_loading_mode%') := p_loading_mode;
      v_variable_of_arrays ('%v_pby%') := 'PARTITION BY';
      v_variable_of_arrays ('%v_oby%') := 'ORDER BY';
      v_variable_of_arrays ('%v_wind%') :=
         'ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING';

      /*
        2. ��� ����������� ������ ������ ��������� ���������� API_ETL.LOG_SQL � �����������:
          � p_folder_name = <p_folder_name>
          � p_workflow_name = <p_workflow_name>
          � p_proc_name = �API_UPLOAD.COMPLEX_SHIST�
          � p_targettable_name = <p_target_schema_name>.<p_target_table_name>
          � p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
          � p_job_id = <p_job_id>
          � p_start_dttm = sysdate
          � p_message_text = �Start API_UPLOAD.COMPLEX_SHIST�
      */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_MESSAGE_TEXT       => 'START API_UPLOAD.COMPLEX_SHIST');

      /* 3. �������� ���������� */
      /*
      a. ���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      b. ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */
      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      c. ���� p_source_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_source_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      d. ���� p_source_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e. ���� p_target_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_target_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      f. ���� p_target_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_target_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      g. ���� p_job_id ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_JOB_ID �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      h. ���� p_loading_mode ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_empty�
        � P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e. ���� p_loading_mode �� ������������� ��������� INITIAL ��� INCREMENT,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_paramvalue_bad�
        � P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL ��� INCREMENT�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode NOT IN ('INITIAL', 'INCREMENT')
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_bad',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL ��� INCREMENT',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      4. ����������� �������� ������� ����� ��� �������� � ������� ���������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME = <p_target_table_name>
      ���� �� ������� �� ����� ������,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        � P_EXCEPTION_NAME = �e_md_columns_empty�
        � P_ERRMSG_TEXT = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        � P_PLSQLUNIT_NAME = �API_UPLOAD.COMPLEX_SHIST�
        � P_SEVERITY_CODE = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.COMPLEX_SHIST',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      5. ����������� <������ ����� ������� �������> � <������ ����� �������� ���������> �� ������� ������� MD_COLUMNS �� �������
        � SCHEMA_NAME = <p_target_schema_name>
        � TABLE_NAME = <p_target_table_name>
      */

      /*
      ������
      */

      SELECT COUNT (*)
        INTO v_flag
        FROM MD_COLUMNS
       WHERE     TABLE_NAME = p_target_table_name
             AND COLUMN_NAME IN ('TIMESTAMP_FROM', 'TIMESTAMP_TO')
             AND SCHEMA_NAME = p_target_schema_name;

      IF v_flag = 2
      THEN
         v_variable_of_arrays ('%v_start_time%') := 'TIMESTAMP_FROM';
         v_variable_of_arrays ('%v_end_time%') := 'TIMESTAMP_TO';
      ELSE
         v_variable_of_arrays ('%v_start_time%') := 'EFFECTIVE_FROM';
         v_variable_of_arrays ('%v_end_time%') := 'EFFECTIVE_TO';
      END IF;


      -- ��� 1. ���������� ������������ �������� � ������� �������

      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       =>    'START UNUSE NONUNIQUE INDEXES FOR '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);


      NONUNIQUE_INDEX_UNUSE (p_target_schema_name, p_target_table_name);

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       =>    'END UNUSE NONUNIQUE INDEXES FOR '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);

      -- ��� 2. ���� �������������� ��������, �� �������� ������ �� ������� �������


      IF p_loading_mode = 'INITIAL'
      THEN
         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       =>    'START TRUNCATE TABLE '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);


         v_sql := 'TRUNCATE TABLE ' || v_full_target_name || ' DROP STORAGE';

         IF NOT v_debug_mode
         THEN
            DBMS_OUTPUT.PUT_LINE (
               '��� 2. ���� �������������� ��������, �� �������� ������ �� ������� �������');
            DBMS_OUTPUT.PUT_LINE (v_sql);

            EXECUTE IMMEDIATE v_sql;
         ELSE
            DBMS_OUTPUT.PUT_LINE (
               '��� 2. ���� �������������� ��������, �� �������� ������ �� ������� �������');
            DBMS_OUTPUT.PUT_LINE (v_sql);
         END IF;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'END TRUNCATE TABLE '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);
      END IF;


      --* ��� 3. ��������������� ������� ������ PPREVIOUS � ������� _DMDELTA

      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       =>    'START Truncate Partition PPREVIOUS TABLE '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);

      v_sql :=
         q'{
                BEGIN
                 %v_source_schema_name%.TRUNC_PARTITION('%v_source_schema_name%', '%v_source_table_name%', 'PPREVIOUS');
                END;
             }';


      DBMS_OUTPUT.put_line (v_sql);
      DBMS_OUTPUT.put_line (CASE WHEN v_debug_mode THEN '1' ELSE '0' END);
      get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);

      IF NOT v_debug_mode
      THEN
         DBMS_OUTPUT.PUT_LINE (
            '��� 3. ��������������� ������� ������ PPREVIOUS � ������� _DMDELTA');
         DBMS_OUTPUT.PUT_LINE (v_sql);

         EXECUTE IMMEDIATE v_sql;
      ELSE
         DBMS_OUTPUT.PUT_LINE (
            '��� 3. ��������������� ������� ������ PPREVIOUS � ������� _DMDELTA');
         DBMS_OUTPUT.PUT_LINE (v_sql);
      END IF;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       =>    'START Truncate Partition PPREVIOUS TABLE '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);


      --* ��� 4. �������� ����������� ������ � *_dmdelta � ���������� rowid ��� ��������
      v_sql :=
         q'{insert /*+ append*/
                  all
                 -- ��������� �������� ������ ��������� ����������� ���������, ������������ ��� ����� ������� ���������
                 when %v_start_time% <= min_effective_from
                  then into %v_source_schema_name%.%v_source_table_name% (VALID_FROM, %CX_SHIST_SRC_COL_NAMES%, dmsdelta)
                    values (to_date('01.01.1900','dd.mm.yyyy'), %CX_SHIST_SRC_COL_NAMES%, 0)
                 --��������� rowid ������� ������� ��� ������������ ��������
                 when 1 = 1
                  then into %v_source_schema_name%.TMP_ROWID_EFF (PROWID,ACT,JOB) values (TGT_ROWID, 'D', DMSJOB)

                 with delta
                    as
                      (
                       select %CX_SHIST_AGG_KEY_COLS%,
                          min(%v_start_time%) /*keep (dense_rank  first order by valid_from desc, %v_start_time%)*/ as  min_effective_from
                         from %v_source_schema_name%.%v_source_table_name%
                        group by %CX_SHIST_AGG_KEY_COLS%
                      )
                 select /*+ use_hash(%v_source_table_name% %v_target_table_name%) dynamic_sampling(%v_source_table_name% 2) parallel(4) */
                        %v_target_table_name%.rowid as TGT_ROWID,
                        '%v_target_table_name%'     as TARGET_TABLE_NAME,
                        %CX_SHIST_TRG_COLS%,
                        min_effective_from
                   from delta,
                        %v_target_schema_name%.%v_target_table_name%
                  where %CX_SHIST_KEY_JOINS%
                    and %v_target_table_name%.%v_end_time% > min_effective_from
              }';

      get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);

      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       =>    'Start copy previous data -> *_dmdelta'
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);

      TRUNC_TABLE (p_source_schema_name, 'tmp_rowid_eff');

      --* ������� �������� �������

      IF NOT v_debug_mode
      THEN
         DBMS_OUTPUT.PUT_LINE (
            '��� 4. �������� ����������� ������ � *_dmdelta � ���������� rowid ��� ��������');
         DBMS_OUTPUT.PUT_LINE (v_sql);

         EXECUTE IMMEDIATE v_sql;

         v_cnt := SQL%ROWCOUNT;
         COMMIT;
      ELSE
         DBMS_OUTPUT.PUT_LINE (
            '��� 4. �������� ����������� ������ � *_dmdelta � ���������� rowid ��� ��������');
         DBMS_OUTPUT.PUT_LINE (v_sql);
      END IF;


      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       =>    'END copy previous data -> *_dmdelta'
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);


      --* ��� 5. ������� ������ �� ������� �������
      v_sql :=
         q'{merge /*+ use_hash(t)*/ into %v_target_schema_name%.%v_target_table_name% t
              using (select PROWID
                       from %v_source_schema_name%.tmp_rowid_eff
                    ) s
                 on (t.rowid = s.PROWID)
              when matched then UPDATE SET t.JOB_INSERT=t.JOB_INSERT
                                delete where 1=1}';

      get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);

      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       =>    'Start delete rows from '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);

      IF NOT v_debug_mode
      THEN
         DBMS_OUTPUT.PUT_LINE (
            '��� 5. ������� ������ �� ������� �������');
         DBMS_OUTPUT.PUT_LINE (v_sql || CHR (10));

         EXECUTE IMMEDIATE v_sql;

         v_cnt := SQL%ROWCOUNT;
      ELSE
         DBMS_OUTPUT.PUT_LINE (
            '��� 5. ������� ������ �� ������� �������');
         DBMS_OUTPUT.PUT_LINE (v_sql || CHR (10));
      END IF;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       => 'END delete rows from ' || v_full_target_name,
         P_SQL_TEXT           => v_sql);

      --* ��� 6. �������� ������ � �������� ����� ��������
      v_sql :=
            'insert '
         || CASE
               WHEN p_loading_mode = 'INITIAL' THEN ' /*+ append*/ '
               ELSE NULL
            END
         || q'{ all
               when %v_start_time% < %v_end_time% then into %v_target_schema_name%.%v_target_table_name%
                   (%v_end_time%, %CX_SHIST_AGG_TRG_COLS%)

              with
                delta_full as
                              (
                               select *
                                 from
                                      (

                                        select src.*,
                                               first_value(deleted_flag) OVER (PARTITION BY %CX_SHIST_AGG_KEYSRC_COLS%, %v_start_time% ORDER BY valid_from desc, %v_start_time%) as del_last,
                                               min(src.%v_start_time%) OVER (PARTITION BY %CX_SHIST_AGG_KEYSRC_COLS% ORDER BY valid_from desc, %v_start_time%) as ef_prev,
                                               max(src.%v_start_time%) OVER (PARTITION BY %CX_SHIST_AGG_KEYSRC_COLS% ORDER BY valid_from desc, %v_start_time%) as ef_next,
                                               row_number() over (partition by %CX_SHIST_AGG_KEYSRC_COLS%, %v_start_time% order by src.VALID_FROM desc) as rn,
                                               first_value(dmsdelta) OVER (PARTITION BY %CX_SHIST_AGG_KEYSRC_COLS%, %v_start_time% ORDER BY valid_from, %v_start_time%) as dmsdelta_
                                          from %v_source_schema_name%.%v_source_table_name% src
                                      ) src

                                --where del_last <> 'Y' and (dmsdelta = 1 and rn =1  or dmsdelta = 0 and %v_start_time% < ef_prev)
                                --where (dmsdelta = 1 and rn = 1 and del_last <> 'Y' or dmsdelta = 0 and %v_start_time% <= ef_prev)
                                --where rn = 1 and ((dmsdelta = 1 and del_last <> 'Y') or (dmsdelta = 0 and %v_start_time% <= ef_prev))
                               where rn = 1 and (
                                                  (dmsdelta = 1 and case
                                                                     when ((ef_next > %v_start_time%  and deleted_flag <> 'Y') or dmsdelta_ = 0)
                                                                      then 'N'
                                                                     else  del_last
                                                                    end  <> 'Y')
                                                   or
                                                  (dmsdelta = 0 and %v_start_time% <= ef_prev)
                                                 )
                               ),

                dmdelta as (
                             select /*+ dynamic_sampling(src 2) */
                                   %CX_SHIST_AGG_KEYSRC_COLS%,
                                   %CX_SHIST_AGG_BASESRC_COLS%,
                                   src.%v_start_time%,
                                   src.%v_end_time%,
                                   LAST_VALUE(src.deleted_flag) OVER (PARTITION BY %CX_SHIST_AGG_KEYSRC_COLS%, src.%v_start_time% ORDER BY src.valid_from ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS DELETED_FLAG
                               from delta_full src

                              union all

                              -- ��� ����������� ���������� �� %v_end_time% ����������� ���������� � "���������" ����������
                              select /*+ use_hash(src chk) dynamic_sampling(src 2) */
                                     %CX_SHIST_AGG_KEYSRC_COLS%,
                                     %CX_SHIST_AGG_BASESRC_COLS%,
                                     src.%v_end_time% as %v_start_time%,
                                     to_date('31.12.5999','DD.MM.YYYY') as %v_end_time%,
                                     'Y' AS DELETED_FLAG
                                from (
                                      select /*+ dynamic_sampling(%v_source_table_name% 2) */
                                            *
                                        from delta_full
                                       where %v_end_time% != TO_DATE('31.12.5999','DD.MM.YYYY')  and %v_end_time%>%v_start_time%
                                      ) src
                                 left join delta_full chk
                                   on %CX_SHIST_AGG_BROKEN_JOIN% AND src.%v_end_time% = chk.%v_start_time%
                                where %CX_SHIST_AGG_BROKEN_FILTER% AND chk.%v_start_time% IS NULL
                           )

             select /*+ parallel(4)*/
                    LEAD(%v_start_time%, 1, DATE'5999-12-31') over (partition by  %CX_SHIST_AGG_KEY_COLS% order by  %v_start_time% ) as %v_end_time%,
                    %CX_SHIST_AGG_RESULT_COLS%
               from (
                       select
                              XK,
                              %v_start_time%,
                              %CX_SHIST_AGG_GRP_COLS%,
                              %CX_SHIST_LAGC_COLS%
                         from dmdelta
                     )
               where (
                        (%CX_SHIST_NVLC_COLS%)
                        != ((%CX_SHIST_NVLCPREV_COLS%))
                     )
           }';



      get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);

      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       => 'Start insert target ' || v_full_target_name,
         P_SQL_TEXT           => v_sql);


      IF NOT v_debug_mode
      THEN
         DBMS_OUTPUT.PUT_LINE (
            '��� 6. �������� ������ � �������� ����� ��������');
         print_clob (v_sql);

         EXECUTE IMMEDIATE v_sql;

         v_cnt := SQL%ROWCOUNT;
         COMMIT;
      ELSE
         DBMS_OUTPUT.PUT_LINE (
            '��� 6. �������� ������ � �������� ����� ��������');
         DBMS_OUTPUT.put_line (v_sql);
      END IF;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'END insert target ' || v_full_target_name,
         P_SQL_TEXT           => v_sql);


      --* ��� 7. ��������� ����������� ������������ �������� � ������� �������


      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       =>    'Start rebuild nonunique indexes for '
                                 || v_full_target_name,
         P_SQL_TEXT           => NULL);

      NONUNIQUE_INDEX_REBUILD ('%TARGET_SCHEMA%', '%TARGET_TABLE%');

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.COMPLEX_SHIST',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_MESSAGE_TEXT       =>    'End rebuild nonunique indexes for '
                                 || v_full_target_name,
         P_SQL_TEXT           => NULL);
   --* ��� 8. TODO: ���� ���������� � ������� ������� ��� ��������� ��������



   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE NOT BETWEEN -20999 AND -20000
         THEN
            UTL_ERRHANDLERS.RAISE_ERROR (
               P_EXCEPTION_NAME   => TO_CHAR (SQLCODE),
               P_ERRMSG_TEXT      => '��������� ������',
               P_PLSQLUNIT_NAME   => 'API_METADATA.DEL_MD_PARAMETERS',
               P_SEVERITY_CODE    => 'S',
               P_SQLERRM_TEXT     => SQLERRM);
         END IF;

         RAISE;
   END;


   PROCEDURE MERGE_ANY2STRAN (p_folder_name          IN VARCHAR2,
                              p_workflow_name        IN VARCHAR2,
                              p_source_schema_name   IN VARCHAR2,
                              p_source_table_name    IN VARCHAR2,
                              p_target_schema_name   IN VARCHAR2,
                              p_target_table_name    IN VARCHAR2,
                              p_job_id               IN NUMBER,
                              p_as_of_day            IN DATE,
                              p_loading_mode         IN VARCHAR2)
   IS
      v_insert_sql_stmt       CLOB;
      v_start_cur_stmt_date   DATE;
      v_start_proc_date       DATE;
      v_full_source_name      VARCHAR2 (255);
      v_full_target_name      VARCHAR2 (255);
      v_cnt                   NUMBER;
      v_sql                   CLOB;
      v_source_columns_list   CLOB;
      v_target_columns_list   CLOB;
      v_upd_columns_list      CLOB;
      v_key_columns_list      CLOB;
      v_flag                  INTEGER;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* 1.    ������������ [����/����� ������ ���������] = SYSDATE */
      v_start_proc_date := SYSDATE;
      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;


      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (p_as_of_day, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;
      v_variable_of_arrays ('%v_source_schema_name%') := p_source_schema_name;
      v_variable_of_arrays ('%v_source_table_name%') := p_source_table_name;
      v_variable_of_arrays ('%v_dmsjob%') := p_job_id;
      v_variable_of_arrays ('%v_folder_name%') := p_folder_name;
      v_variable_of_arrays ('%v_workflow_name%') := p_workflow_name;
      v_variable_of_arrays ('%v_loading_mode%') := p_loading_mode;
      v_variable_of_arrays ('%v_pby%') := 'PARTITION BY';
      v_variable_of_arrays ('%v_oby%') := 'ORDER BY';
      v_variable_of_arrays ('%v_wind%') :=
         'ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING';


      /*
    2.    ��� ����������� ������ ������ ��������� ���������� API_ETL.LOG_SQL � �����������:
      �    p_folder_name = <p_folder_name>
      �    p_workflow_name = <p_workflow_name>
      �    p_proc_name = �API_UPLOAD.MERGE_2STRAN
      �    p_targettable_name = <p_target_schema_name>.<p_target_table_name>
      �    p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
      �    p_job_id = <p_job_id>
      �    p_start_dttm = sysdate
      �    p_message_text = �Start API_UPLOAD.MERGE_2STRAN
  */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_MESSAGE_TEXT       => 'START API_UPLOAD.MERGE_ANY2STRAN');

      /* 3. �������� ���������� */
      /*
      a.    ���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      b.    ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */
      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      c.    ���� p_source_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_source_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      d.    ���� p_source_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e.    ���� p_target_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_target_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      f.    ���� p_target_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_target_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      g.    ���� p_job_id ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_JOB_ID �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      h.    ���� p_loading_mode ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e.    ���� p_loading_mode �� ������������� ��������� INITIAL ��� INCREMENT,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_bad�
        �    P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL ��� INCREMENT�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode NOT IN ('INITIAL', 'INCREMENT', 'RELOAD')
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_bad',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL, INCREMENT ��� REALOAD',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      4.    ����������� �������� ������� ����� ��� �������� � ������� ���������� MD_COLUMNS �� �������
        �    SCHEMA_NAME = <p_target_schema_name>
        �    TABLE_NAME = <p_target_table_name>
      ���� �� ������� �� ����� ������,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_md_columns_empty�
        �    P_ERRMSG_TEXT = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;



      v_start_proc_date := SYSDATE;


      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_END_DTTM           => NULL,
         P_MESSAGE_TEXT       =>    'BEGIN MERGE_ANY2STRAN '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);



      -- ��� 1. ���� �������������� ��������, �� �������� ������ �� ������� �������. ���� ������������, �� ������� ��������.
      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_start_cur_stmt_date,
                       P_END_DTTM           => NULL,
                       P_MESSAGE_TEXT       => 'Start truncate ',
                       P_SQL_TEXT           => v_sql);


      -- TODO: ����������
      --  if P_INITIAL_LOADING = 1
      --   then
      --     v_sql:= q'{
      --                 begin
      --                   dmrb.TRUNC_TABLE('%TARGET_TABLE%');
      --                 end;
      --                }';
      --     v_sql := replace(v_sql, '%TARGET_TABLE%', P_TGT_TABLE_NAME);
      --       if not p_debug_mode
      --         then
      --           execute immediate (v_sql);
      --         else
      --           dbms_output.put_line(v_sql);
      --       end if;
      --  else
      --     v_sql := 'select distinct to_char(VALUE_DAY,''YYYYMMDD'') from '||P_SRC_SCHEMA_NAME||'.'||P_SRC_TABLE_NAME;
      --       if not p_debug_mode
      --         then
      --           execute immediate (v_sql) bulk collect into vg_processed_period;
      --         else
      --           dbms_output.put_line(v_sql);
      --       end if;
      --     if P_RELOADING = 1
      --     then
      --       if vg_processed_period.count>0
      --         then
      --           for i in vg_processed_period.first..vg_processed_period.last
      --           loop
      --             v_variable(15):= dmsrb.t_variables_rec('PARTITION_NAME', 'P'||vg_processed_period(i));
      --             v_sql := q'{begin
      --                       dmrb.trunc_part(in_table_name => '%TARGET_TABLE%',
      --                                  in_part_name => '%PARTITION_NAME%');
      --                     end;}';
      --             v_sql:= dmsrb.f_prepare_new(v_sql, v_variable);
      --             if not p_debug_mode
      --               then
      --                 execute immediate (v_sql) /*bulk collect into vg_processed_period*/;
      --               else
      --                 dbms_output.put_line(v_sql);
      --             end if;
      --           end loop;
      --        end if;
      --       end if;
      --end if;
      IF p_loading_mode = 'INITIAL'
      THEN
         --      v_sql := 'TRUNCATE TABLE ' || v_full_target_name || ' DROP STORAGE';


         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       => 'START TRUNCATE ' || v_full_target_name,
            P_SQL_TEXT           => v_sql);

         --    dbms_output.put_line(v_sql);
         --    EXECUTE IMMEDIATE v_sql;
         trunc_table (p_target_schema_name, p_target_table_name);

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       => 'END TRUNCATE ' || v_full_target_name,
            P_SQL_TEXT           => v_sql);


         v_sql :=
            q'{insert /*+ append*/
                   into %v_target_schema_name%.%v_target_table_name% (%TARGET_COLUMNS_LIST%)
                   select /*+  parallel(4) */
                          %SOURCE_COLUMNS_LIST%
                     from %v_source_schema_name%.%v_source_table_name%
                }';


         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         DBMS_OUTPUT.put_line (v_sql);
      /*
      select *
      from mmd_templates

       */

      ELSE
         API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                          P_WORKFLOW_NAME      => p_workflow_name,
                          P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
                          P_TARGETTABLE_NAME   => v_full_target_name,
                          P_SOURCETABLE_NAME   => v_full_source_name,
                          P_JOB_ID             => p_job_id,
                          P_START_DTTM         => v_start_cur_stmt_date,
                          P_END_DTTM           => NULL,
                          P_MESSAGE_TEXT       => 'End truncate ',
                          P_SQL_TEXT           => v_sql);

         --* ��� 2. ������ merge ������� �������

         v_sql :=
            'merge /*+ use_hash(%v_target_table_name%)*/ into %v_target_schema_name%.%v_target_table_name%
              using (select %MERGE_SOURCE_COLUMNS_LIST%
                       from %v_source_schema_name%.%v_source_table_name%
                    ) delta
                 on (%CX_SHIST_KEY_JOINS%)
              when matched then
                        update set %MERGE_COLUMNS%
                   when not matched then
                        insert (%TARGET_COLUMNS_LIST%) values (%MERGE_COLUMNS_PFX%)';


         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                          P_WORKFLOW_NAME      => p_workflow_name,
                          P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
                          P_TARGETTABLE_NAME   => v_full_target_name,
                          P_SOURCETABLE_NAME   => v_full_source_name,
                          P_JOB_ID             => p_job_id,
                          P_START_DTTM         => v_start_cur_stmt_date,
                          P_END_DTTM           => NULL,
                          P_MESSAGE_TEXT       => 'Start merge ',
                          P_SQL_TEXT           => v_sql);
      END IF;

      IF NOT v_debug_mode
      THEN
         DBMS_OUTPUT.PUT_LINE (
            '��� 2. ������ merge ������� �������');
         print_clob (v_sql);

         EXECUTE IMMEDIATE v_sql;

         v_cnt := SQL%ROWCOUNT;
         COMMIT;
      ELSE
         DBMS_OUTPUT.PUT_LINE (
            '��� 2. ������ merge ������� �������');
         print_clob (v_sql);
      END IF;

      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_start_cur_stmt_date,
                       P_END_DTTM           => SYSDATE,
                       P_MESSAGE_TEXT       => 'End merge ',
                       P_SQL_TEXT           => v_sql);

      --TODO:
      --* ��� 3. ���� ����������
      --  standart_logs.to_log(P_WORKFLOW_NAME,'UPL_DMDELTA_STRAN_MERGE', P_TGT_TABLE_NAME, null, null, P_DMSJOB, null, null, 0, null, 'Start gather table stat', null);
      ----� ����� �������� ����������
      --
      --
      --  IF vg_processed_period.count>0 THEN
      --    FOR i IN vg_processed_period.first..vg_processed_period.last
      --    LOOP
      --      IF NOT p_debug_mode THEN
      --      begin
      --        dmrb.GATHER_PART_STATS(P_TGT_SCHEMA_NAME, P_TGT_TABLE_NAME, 'P'||vg_processed_period(i), 0.0001);
      --        exception
      --         when others
      --          then if SQLCODE = -20000
      --                then null;
      --                else raise;
      --               end if;
      --      end;
      --      END IF;
      --    END LOOP;
      --  END IF;


      --standart_logs.to_log(P_WORKFLOW_NAME,'UPL_DMDELTA_STRAN_MERGE', P_TGT_TABLE_NAME, null, null, P_DMSJOB, null, null, 0, null, 'End gather table stat', null);

    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => NULL,
            P_MESSAGE_TEXT       =>    'Start gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

 
    v_sql :=   q'{BEGIN
    %v_target_schema_name%.GATHER_TABLE_STATS(P_OWNER => '%v_target_schema_name%' , P_ENTITY_NAME => '%v_target_table_name%', P_ESTIMATE_PERCENT => 0.0001);
    END;}';

       
    get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);


    EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.MERGE_ANY2STRAN',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_sql);
   
    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'End gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);



      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'END MERGE_ANY2STRAN ' || v_full_target_name,
         P_SQL_TEXT           => v_sql);
   END;


   PROCEDURE UPDATE_MERGE_ANY2STRAN (p_folder_name          IN VARCHAR2,
                                     p_workflow_name        IN VARCHAR2,
                                     p_source_schema_name   IN VARCHAR2,
                                     p_source_table_name    IN VARCHAR2,
                                     p_target_schema_name   IN VARCHAR2,
                                     p_target_table_name    IN VARCHAR2,
                                     p_job_id               IN NUMBER,
                                     p_as_of_day            IN DATE,
                                     p_loading_mode         IN VARCHAR2)
   IS
      v_insert_sql_stmt       CLOB;
      v_start_cur_stmt_date   DATE;
      v_start_proc_date       DATE;
      v_full_source_name      VARCHAR2 (255);
      v_full_target_name      VARCHAR2 (255);
      v_cnt                   NUMBER;
      v_sql                   CLOB;
      v_sql_update            CLOB;
      v_source_columns_list   CLOB;
      v_target_columns_list   CLOB;
      v_upd_columns_list      CLOB;
      v_key_columns_list      CLOB;
      v_flag                  INTEGER;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* 1.    ������������ [����/����� ������ ���������] = SYSDATE */
      v_start_proc_date := SYSDATE;
      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;


      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (p_as_of_day, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;
      v_variable_of_arrays ('%v_source_schema_name%') := p_source_schema_name;
      v_variable_of_arrays ('%v_source_table_name%') := p_source_table_name;
      v_variable_of_arrays ('%v_dmsjob%') := p_job_id;
      v_variable_of_arrays ('%v_folder_name%') := p_folder_name;
      v_variable_of_arrays ('%v_workflow_name%') := p_workflow_name;
      v_variable_of_arrays ('%v_loading_mode%') := p_loading_mode;
      v_variable_of_arrays ('%v_pby%') := 'PARTITION BY';
      v_variable_of_arrays ('%v_oby%') := 'ORDER BY';
      v_variable_of_arrays ('%v_wind%') :=
         'ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING';


      /*
    2.    ��� ����������� ������ ������ ��������� ���������� API_ETL.LOG_SQL � �����������:
      �    p_folder_name = <p_folder_name>
      �    p_workflow_name = <p_workflow_name>
      �    p_proc_name = �API_UPLOAD.MERGE_2STRAN
      �    p_targettable_name = <p_target_schema_name>.<p_target_table_name>
      �    p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
      �    p_job_id = <p_job_id>
      �    p_start_dttm = sysdate
      �    p_message_text = �Start API_UPLOAD.MERGE_2STRAN
  */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_MESSAGE_TEXT       => 'START API_UPLOAD.UPDATE_MERGE_ANY2STRAN');

      /* 3. �������� ���������� */
      /*
      a.    ���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      b.    ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */
      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      c.    ���� p_source_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_source_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      d.    ���� p_source_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e.    ���� p_target_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_target_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      f.    ���� p_target_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_target_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      g.    ���� p_job_id ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_JOB_ID �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      h.    ���� p_loading_mode ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e.    ���� p_loading_mode �� ������������� ��������� INITIAL ��� INCREMENT,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_bad�
        �    P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL ��� INCREMENT�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode NOT IN ('INITIAL', 'INCREMENT', 'RELOAD')
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_bad',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL, INCREMENT ��� REALOAD',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      4.    ����������� �������� ������� ����� ��� �������� � ������� ���������� MD_COLUMNS �� �������
        �    SCHEMA_NAME = <p_target_schema_name>
        �    TABLE_NAME = <p_target_table_name>
      ���� �� ������� �� ����� ������,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_md_columns_empty�
        �    P_ERRMSG_TEXT = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.UPDATE_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;



      v_start_proc_date := SYSDATE;


      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_END_DTTM           => NULL,
         P_MESSAGE_TEXT       =>    'BEGIN UPDATE_MERGE_ANY2STRAN '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);



      -- ��� 1. ���� �������������� ��������, �� �������� ������ �� ������� �������. ���� ������������, �� ������� ��������.
      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => NULL,
         P_MESSAGE_TEXT       => 'Start truncate ',
         P_SQL_TEXT           => v_sql);


      -- TODO: ����������
      --  if P_INITIAL_LOADING = 1
      --   then
      --     v_sql:= q'{
      --                 begin
      --                   dmrb.TRUNC_TABLE('%TARGET_TABLE%');
      --                 end;
      --                }';
      --     v_sql := replace(v_sql, '%TARGET_TABLE%', P_TGT_TABLE_NAME);
      --       if not p_debug_mode
      --         then
      --           execute immediate (v_sql);
      --         else
      --           dbms_output.put_line(v_sql);
      --       end if;
      --  else
      --     v_sql := 'select distinct to_char(VALUE_DAY,''YYYYMMDD'') from '||P_SRC_SCHEMA_NAME||'.'||P_SRC_TABLE_NAME;
      --       if not p_debug_mode
      --         then
      --           execute immediate (v_sql) bulk collect into vg_processed_period;
      --         else
      --           dbms_output.put_line(v_sql);
      --       end if;
      --     if P_RELOADING = 1
      --     then
      --       if vg_processed_period.count>0
      --         then
      --           for i in vg_processed_period.first..vg_processed_period.last
      --           loop
      --             v_variable(15):= dmsrb.t_variables_rec('PARTITION_NAME', 'P'||vg_processed_period(i));
      --             v_sql := q'{begin
      --                       dmrb.trunc_part(in_table_name => '%TARGET_TABLE%',
      --                                  in_part_name => '%PARTITION_NAME%');
      --                     end;}';
      --             v_sql:= dmsrb.f_prepare_new(v_sql, v_variable);
      --             if not p_debug_mode
      --               then
      --                 execute immediate (v_sql) /*bulk collect into vg_processed_period*/;
      --               else
      --                 dbms_output.put_line(v_sql);
      --             end if;
      --           end loop;
      --        end if;
      --       end if;
      --end if;
      IF p_loading_mode = 'INITIAL'
      THEN
         --      v_sql := 'TRUNCATE TABLE ' || v_full_target_name || ' DROP STORAGE';


         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_MESSAGE_TEXT       => 'START TRUNCATE ' || v_full_target_name,
            P_SQL_TEXT           => v_sql);

         --    dbms_output.put_line(v_sql);
         --    EXECUTE IMMEDIATE v_sql;
         trunc_table (p_target_schema_name, p_target_table_name);

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       => 'END TRUNCATE ' || v_full_target_name,
            P_SQL_TEXT           => v_sql);


         v_sql :=
            q'{insert /*+ append*/
                   into %v_target_schema_name%.%v_target_table_name% (%TARGET_COLUMNS_LIST%)
                   select /*+  parallel(4) */
                          %SOURCE_COLUMNS_LIST%
                     from %v_source_schema_name%.%v_source_table_name%
                }';


         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         DBMS_OUTPUT.put_line (v_sql);
      /*
      select *
      from mmd_templates

       */

      ELSE
         --* ��� 2. ������ merge ������� �������
         v_sql_update :=
            'update %v_target_schema_name%.%v_target_table_name%
   set %DEL_AS_UPDATE_ANY2STRAN%
   where not exists (select null from %v_source_schema_name%.%v_source_table_name% where %DIM_KEY_COLUMNS_LIST%) AND %v_target_table_name%.DELETED_FLAG <> ''Y''';

         get_sql_stmt (p_template_name   => v_sql_update,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql_update);

         v_sql :=
            'merge /*+ use_hash(%v_target_table_name%)*/ into %v_target_schema_name%.%v_target_table_name%
              using (select %MERGE_SOURCE_COLUMNS_LIST%
                       from %v_source_schema_name%.%v_source_table_name%
                    ) delta
                 on (%CX_SHIST_KEY_JOINS%)
              when matched then
                        update set %MERGE_COLUMNS%
                   when not matched then
                        insert (%TARGET_COLUMNS_LIST%) values (%MERGE_COLUMNS_PFX%)';


         get_sql_stmt (p_template_name   => v_sql,
                       p_variables       => v_variable_of_arrays,
                       o_clob            => v_sql);

         v_start_cur_stmt_date := SYSDATE;

         API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => NULL,
            P_MESSAGE_TEXT       => 'Start merge ',
            P_SQL_TEXT           => v_sql);
      END IF;

      IF NOT v_debug_mode
      THEN
         IF p_loading_mode != 'INITIAL'
         THEN
            DBMS_OUTPUT.PUT_LINE (
               '��� 2. ������ update ������� �������');
            print_clob (v_sql_update);

            EXECUTE IMMEDIATE v_sql_update;
         END IF;

         DBMS_OUTPUT.PUT_LINE (
            '��� 2. ������ merge ������� �������');
         print_clob (v_sql);

         EXECUTE IMMEDIATE v_sql;

         v_cnt := SQL%ROWCOUNT;
         COMMIT;
      ELSE
         IF p_loading_mode != 'INITIAL'
         THEN
            DBMS_OUTPUT.PUT_LINE (
               '��� 2. ������ update ������� �������');
            print_clob (v_sql_update);
         END IF;

         DBMS_OUTPUT.PUT_LINE (
            '��� 2. ������ merge ������� �������');
         print_clob (v_sql);
      END IF;

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_cur_stmt_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       => 'End merge ',
         P_SQL_TEXT           => v_sql);

      --TODO:
      --* ��� 3. ���� ����������
      --  standart_logs.to_log(P_WORKFLOW_NAME,'UPL_DMDELTA_STRAN_MERGE', P_TGT_TABLE_NAME, null, null, P_DMSJOB, null, null, 0, null, 'Start gather table stat', null);
      ----� ����� �������� ����������
      --
      --
      --  IF vg_processed_period.count>0 THEN
      --    FOR i IN vg_processed_period.first..vg_processed_period.last
      --    LOOP
      --      IF NOT p_debug_mode THEN
      --      begin
      --        dmrb.GATHER_PART_STATS(P_TGT_SCHEMA_NAME, P_TGT_TABLE_NAME, 'P'||vg_processed_period(i), 0.0001);
      --        exception
      --         when others
      --          then if SQLCODE = -20000
      --                then null;
      --                else raise;
      --               end if;
      --      end;
      --      END IF;
      --    END LOOP;
      --  END IF;


      --standart_logs.to_log(P_WORKFLOW_NAME,'UPL_DMDELTA_STRAN_MERGE', P_TGT_TABLE_NAME, null, null, P_DMSJOB, null, null, 0, null, 'End gather table stat', null);

    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => NULL,
            P_MESSAGE_TEXT       =>    'Start gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

 
    v_sql :=   q'{BEGIN
    %v_target_schema_name%.GATHER_TABLE_STATS(P_OWNER => '%v_target_schema_name%' , P_ENTITY_NAME => '%v_target_table_name%', P_ESTIMATE_PERCENT => 0.0001);
    END;}';

       
    get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);


    EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_sql);
   
    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'End gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);





      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.UPDATE_MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       =>    'END UPDATE_MERGE_ANY2STRAN '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);
   END;

   PROCEDURE DEL_MERGE_ANY2STRAN (p_folder_name          IN VARCHAR2,
                                  p_workflow_name        IN VARCHAR2,
                                  p_source_schema_name   IN VARCHAR2,
                                  p_source_table_name    IN VARCHAR2,
                                  p_target_schema_name   IN VARCHAR2,
                                  p_target_table_name    IN VARCHAR2,
                                  p_job_id               IN NUMBER,
                                  p_as_of_day            IN DATE,
                                  p_delete_filter        IN VARCHAR2,
                                  p_loading_mode         IN VARCHAR2)
   IS
      v_insert_sql_stmt       CLOB;
      v_start_cur_stmt_date   DATE;
      v_start_proc_date       DATE;
      v_full_source_name      VARCHAR2 (255);
      v_full_target_name      VARCHAR2 (255);
      v_cnt                   NUMBER;
      v_sql                   CLOB;
      v_sql_del               CLOB;
      v_source_columns_list   CLOB;
      v_target_columns_list   CLOB;
      v_upd_columns_list      CLOB;
      v_key_columns_list      CLOB;
      v_flag                  INTEGER;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      /* 1.    ������������ [����/����� ������ ���������] = SYSDATE */
      v_start_proc_date := SYSDATE;
      v_full_source_name := p_source_schema_name || '.' || p_source_table_name;
      v_full_target_name := p_target_schema_name || '.' || p_target_table_name;


      v_variable_of_arrays ('%v_full_source_name%') := v_full_source_name;
      v_variable_of_arrays ('%v_full_target_name%') := v_full_target_name;
      v_variable_of_arrays ('%v_as_of_day%') :=
         TO_CHAR (p_as_of_day, 'YYYYMMDD HH24:MI:SS');
      v_variable_of_arrays ('%v_target_table_name%') := p_target_table_name;
      v_variable_of_arrays ('%v_target_schema_name%') := p_target_schema_name;
      v_variable_of_arrays ('%v_source_schema_name%') := p_source_schema_name;
      v_variable_of_arrays ('%v_source_table_name%') := p_source_table_name;
      v_variable_of_arrays ('%v_dmsjob%') := p_job_id;
      v_variable_of_arrays ('%v_folder_name%') := p_folder_name;
      v_variable_of_arrays ('%v_workflow_name%') := p_workflow_name;
      v_variable_of_arrays ('%v_delete_filter%') := p_delete_filter;
      v_variable_of_arrays ('%v_loading_mode%') := p_loading_mode;
      v_variable_of_arrays ('%v_pby%') := 'PARTITION BY';
      v_variable_of_arrays ('%v_oby%') := 'ORDER BY';
      v_variable_of_arrays ('%v_wind%') :=
         'ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING';


      /*
    2.    ��� ����������� ������ ������ ��������� ���������� API_ETL.LOG_SQL � �����������:
      �    p_folder_name = <p_folder_name>
      �    p_workflow_name = <p_workflow_name>
      �    p_proc_name = �API_UPLOAD.MERGE_2STRAN
      �    p_targettable_name = <p_target_schema_name>.<p_target_table_name>
      �    p_sourcetable_name = <p_source_schema_name>.<p_source_table_name>
      �    p_job_id = <p_job_id>
      �    p_start_dttm = sysdate
      �    p_message_text = �Start API_UPLOAD.MERGE_2STRAN
  */

      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_MESSAGE_TEXT       => 'START API_UPLOAD.DEL_MERGE_ANY2STRAN');

      /* 3. �������� ���������� */
      /*
      a.    ���� p_folder_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_folder_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      b.    ���� p_workflow_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_WORKFLOW_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */
      IF p_workflow_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_FOLDER_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      c.    ���� p_source_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_source_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      d.    ���� p_source_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_source_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_SOURCE_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      e.    ���� p_target_schema_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_target_schema_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_SCHEMA_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      f.    ���� p_target_table_name ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_target_table_name IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_TARGET_TABLE_NAME �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      g.    ���� p_job_id ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_JOB_ID �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_job_id IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_JOB_ID �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      h.    ���� p_loading_mode ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      i.    ���� p_loading_mode �� ������������� ��������� INITIAL ��� INCREMENT,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_bad�
        �    P_ERRMSG_TEXT = ��������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL ��� INCREMENT�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_loading_mode NOT IN ('INITIAL', 'INCREMENT', 'RELOAD')
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_bad',
            P_ERRMSG_TEXT      => '�������� ��������� P_LOADING_MODE ������ ��������� ��������: INITIAL, INCREMENT ��� REALOAD',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      j.    ���� p_del_column_list ����� NULL,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_paramvalue_empty�
        �    P_ERRMSG_TEXT = ��������� ��������� P_DEL_COLUMN_LIST �� ����� ��������� �������� NULL�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      IF p_delete_filter IS NULL
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_paramvalue_empty',
            P_ERRMSG_TEXT      => '�������� ��������� P_DELETE_FILTER �� ����� ��������� �������� NULL',
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;

      /*
      4.    ����������� �������� ������� ����� ��� �������� � ������� ���������� MD_COLUMNS �� �������
        �    SCHEMA_NAME = <p_target_schema_name>
        �    TABLE_NAME = <p_target_table_name>
      ���� �� ������� �� ����� ������,
        �� ���������� UTL_ERRHANDLERS.RAISE_ERROR � �����������:
        �    P_EXCEPTION_NAME = �e_md_columns_empty�
        �    P_ERRMSG_TEXT = ��� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� <p_target_schema_name>.<p_target_table_name>�
        �    P_PLSQLUNIT_NAME = �API_UPLOAD.DEL_MERGE_ANY2STRAN
        �    P_SEVERITY_CODE = �E�
      */

      SELECT COUNT (*)
        INTO v_cnt
        FROM MD_COLUMNS
       WHERE     SCHEMA_NAME = p_target_schema_name
             AND TABLE_NAME = p_target_table_name;

      IF v_cnt = 0
      THEN
         UTL_ERRHANDLERS.RAISE_ERROR (
            P_EXCEPTION_NAME   => 'e_md_columns_empty',
            P_ERRMSG_TEXT      =>    '�� ���������� ���� ��� UPLOAD � ������� MD_COLUMNS ��� '
                                  || v_full_target_name,
            P_PLSQLUNIT_NAME   => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_SEVERITY_CODE    => 'E',
            P_SQLERRM_TEXT     => NULL);
      END IF;



      v_start_proc_date := SYSDATE;


      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_END_DTTM           => NULL,
         P_MESSAGE_TEXT       =>    'BEGIN DEL_MERGE_ANY2STRAN '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);



      -- ��� 1. ���� �������������� ��������, �� �������� ������ �� ������� �������. ���� ������������, �� ������� ��������.
      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_start_cur_stmt_date,
                       P_END_DTTM           => NULL,
                       P_MESSAGE_TEXT       => 'Start truncate ',
                       P_SQL_TEXT           => v_sql);


      -- TODO: ����������
      --  if P_INITIAL_LOADING = 1
      --   then
      --     v_sql:= q'{
      --                 begin
      --                   dmrb.TRUNC_TABLE('%TARGET_TABLE%');
      --                 end;
      --                }';
      --     v_sql := replace(v_sql, '%TARGET_TABLE%', P_TGT_TABLE_NAME);
      --       if not p_debug_mode
      --         then
      --           execute immediate (v_sql);
      --         else
      --           dbms_output.put_line(v_sql);
      --       end if;
      --  else
      --     v_sql := 'select distinct to_char(VALUE_DAY,''YYYYMMDD'') from '||P_SRC_SCHEMA_NAME||'.'||P_SRC_TABLE_NAME;
      --       if not p_debug_mode
      --         then
      --           execute immediate (v_sql) bulk collect into vg_processed_period;
      --         else
      --           dbms_output.put_line(v_sql);
      --       end if;
      --     if P_RELOADING = 1
      --     then
      --       if vg_processed_period.count>0
      --         then
      --           for i in vg_processed_period.first..vg_processed_period.last
      --           loop
      --             v_variable(15):= dmsrb.t_variables_rec('PARTITION_NAME', 'P'||vg_processed_period(i));
      --             v_sql := q'{begin
      --                       dmrb.trunc_part(in_table_name => '%TARGET_TABLE%',
      --                                  in_part_name => '%PARTITION_NAME%');
      --                     end;}';
      --             v_sql:= dmsrb.f_prepare_new(v_sql, v_variable);
      --             if not p_debug_mode
      --               then
      --                 execute immediate (v_sql) /*bulk collect into vg_processed_period*/;
      --               else
      --                 dbms_output.put_line(v_sql);
      --             end if;
      --           end loop;
      --        end if;
      --       end if;
      --end if;

      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_start_cur_stmt_date,
                       P_END_DTTM           => NULL,
                       P_MESSAGE_TEXT       => 'End truncate ',
                       P_SQL_TEXT           => v_sql);

      --* ��� 2. ������ merge ������� �������

      v_sql_del :=
         'update /*+ use_hash(%v_target_table_name%)*/ %v_target_schema_name%.%v_target_table_name%
                 set %DEL_AS_UPDATE_ANY2STRAN%
                  where %v_delete_filter% and deleted_flag != ''Y'' 
                  and not exists (select null from %v_source_schema_name%.%v_source_table_name%  where %DIM_KEY_COLUMNS_LIST%)';

      get_sql_stmt (p_template_name   => v_sql_del,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql_del);

      v_sql :=
         'merge /*+ use_hash(%v_target_table_name%)*/ into %v_target_schema_name%.%v_target_table_name%
              using (select %MERGE_SOURCE_COLUMNS_LIST%
                       from %v_source_schema_name%.%v_source_table_name%
                    ) delta
                 on (%CX_SHIST_KEY_JOINS%)
              when matched then
                        update set %MERGE_COLUMNS%
                   when not matched then
                        insert (%TARGET_COLUMNS_LIST%) values (%MERGE_COLUMNS_PFX%)';


      get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);

      v_start_cur_stmt_date := SYSDATE;

      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_start_cur_stmt_date,
                       P_END_DTTM           => NULL,
                       P_MESSAGE_TEXT       => 'Start delete+merge ',
                       P_SQL_TEXT           => v_sql_del || CHR (10) || v_sql);

      IF NOT v_debug_mode
      THEN
         DBMS_OUTPUT.PUT_LINE (
            '��� 2. ������ delete+merge ������� �������');
         print_clob (v_sql_del);
         print_clob (v_sql);

         EXECUTE IMMEDIATE v_sql_del;

         EXECUTE IMMEDIATE v_sql;

         v_cnt := SQL%ROWCOUNT;
         COMMIT;
      ELSE
         DBMS_OUTPUT.PUT_LINE (
            '��� 2. ������ delete+merge ������� �������');
         print_clob (v_sql_del);
         print_clob (v_sql);
      END IF;

      API_SQL.LOG_SQL (P_FOLDER_NAME        => p_folder_name,
                       P_WORKFLOW_NAME      => p_workflow_name,
                       P_PROC_NAME          => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
                       P_TARGETTABLE_NAME   => v_full_target_name,
                       P_SOURCETABLE_NAME   => v_full_source_name,
                       P_JOB_ID             => p_job_id,
                       P_START_DTTM         => v_start_cur_stmt_date,
                       P_END_DTTM           => SYSDATE,
                       P_MESSAGE_TEXT       => 'End delete+merge ',
                       P_SQL_TEXT           => v_sql_del || CHR (10) || v_sql);

      --TODO:
      --* ��� 3. ���� ����������
      --  standart_logs.to_log(P_WORKFLOW_NAME,'UPL_DMDELTA_STRAN_MERGE', P_TGT_TABLE_NAME, null, null, P_DMSJOB, null, null, 0, null, 'Start gather table stat', null);
      ----� ����� �������� ����������
      --
      --
      --  IF vg_processed_period.count>0 THEN
      --    FOR i IN vg_processed_period.first..vg_processed_period.last
      --    LOOP
      --      IF NOT p_debug_mode THEN
      --      begin
      --        dmrb.GATHER_PART_STATS(P_TGT_SCHEMA_NAME, P_TGT_TABLE_NAME, 'P'||vg_processed_period(i), 0.0001);
      --        exception
      --         when others
      --          then if SQLCODE = -20000
      --                then null;
      --                else raise;
      --               end if;
      --      end;
      --      END IF;
      --    END LOOP;
      --  END IF;


      --standart_logs.to_log(P_WORKFLOW_NAME,'UPL_DMDELTA_STRAN_MERGE', P_TGT_TABLE_NAME, null, null, P_DMSJOB, null, null, 0, null, 'End gather table stat', null);


    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => NULL,
            P_MESSAGE_TEXT       =>    'Start gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);

 
    v_sql :=   q'{BEGIN
    %v_target_schema_name%.GATHER_TABLE_STATS(P_OWNER => '%v_target_schema_name%' , P_ENTITY_NAME => '%v_target_table_name%', P_ESTIMATE_PERCENT => 0.0001);
    END;}';

       
    get_sql_stmt (p_template_name   => v_sql,
                    p_variables       => v_variable_of_arrays,
                    o_clob            => v_sql);


    EXECUTE_QUERY (p_folder_name        => p_folder_name,
                     p_workflow_name      => p_workflow_name,
                     p_procedure_name     => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
                     p_targettable_name   => v_full_target_name,
                     p_job_id             => p_job_id,
                     p_sql_text           => v_sql);
   
    API_SQL.LOG_SQL (
            P_FOLDER_NAME        => p_folder_name,
            P_WORKFLOW_NAME      => p_workflow_name,
            P_PROC_NAME          => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
            P_TARGETTABLE_NAME   => v_full_target_name,
            P_SOURCETABLE_NAME   => v_full_source_name,
            P_JOB_ID             => p_job_id,
            P_START_DTTM         => v_start_cur_stmt_date,
            P_END_DTTM           => SYSDATE,
            P_MESSAGE_TEXT       =>    'End gather table stats -> '
                                    || v_full_target_name,
            P_SQL_TEXT           => v_sql);







      API_SQL.LOG_SQL (
         P_FOLDER_NAME        => p_folder_name,
         P_WORKFLOW_NAME      => p_workflow_name,
         P_PROC_NAME          => 'API_UPLOAD.DEL_MERGE_ANY2STRAN',
         P_TARGETTABLE_NAME   => v_full_target_name,
         P_SOURCETABLE_NAME   => v_full_source_name,
         P_JOB_ID             => p_job_id,
         P_START_DTTM         => v_start_proc_date,
         P_END_DTTM           => SYSDATE,
         P_MESSAGE_TEXT       =>    'END DEL_MERGE_ANY2STRAN '
                                 || v_full_target_name,
         P_SQL_TEXT           => v_sql);
   END;
END API_UPLOAD;
/