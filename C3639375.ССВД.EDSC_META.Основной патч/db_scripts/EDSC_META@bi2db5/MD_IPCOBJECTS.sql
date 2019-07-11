begin
execute immediate 'drop table MD_IPCOBJECTS CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE MD_IPCOBJECTS
(
  FOLDER_NAME       VARCHAR2(128 BYTE)          NOT NULL,
  WORKFLOW_NAME     VARCHAR2(128 BYTE)          NOT NULL,
  PURPOSETYPE_CODE  VARCHAR2(25 BYTE)           NOT NULL,
  IPCOBJECT_DESC    VARCHAR2(4000 BYTE),
  ACTIVE_FLAG       CHAR(1 BYTE)                NOT NULL,
  CHANGE_DATE       DATE                        DEFAULT SYSDATE               NOT NULL,
  PATCH_CODE        VARCHAR2(128 BYTE)
)
TABLESPACE EDSC_META
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCOMPRESS ;

COMMENT ON TABLE MD_IPCOBJECTS IS '������� IPC';

COMMENT ON COLUMN MD_IPCOBJECTS.FOLDER_NAME IS '��� �����, � ������� ��������� ������';

COMMENT ON COLUMN MD_IPCOBJECTS.WORKFLOW_NAME IS '��� ������';

COMMENT ON COLUMN MD_IPCOBJECTS.PURPOSETYPE_CODE IS '��� ������������� ���������� ������� IPC';

COMMENT ON COLUMN MD_IPCOBJECTS.IPCOBJECT_DESC IS '�������� ������� IPC';

COMMENT ON COLUMN MD_IPCOBJECTS.ACTIVE_FLAG IS '���������� �������, ������������ �������� ������ IPC ����������� ��� ���.';

COMMENT ON COLUMN MD_IPCOBJECTS.CHANGE_DATE IS '���� ���������� ��������� ���������� � �������.';

COMMENT ON COLUMN MD_IPCOBJECTS.PATCH_CODE IS '����� ���������� �����, � ������� ������� ���������.';

CREATE UNIQUE INDEX MD_IPCOBJECTS_PK ON MD_IPCOBJECTS
(FOLDER_NAME, WORKFLOW_NAME)
TABLESPACE EDSC_META
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );
ALTER TABLE MD_IPCOBJECTS ADD (
  CONSTRAINT MD_IPCOBJECTS_PK
  PRIMARY KEY
  (FOLDER_NAME, WORKFLOW_NAME)
  USING INDEX MD_IPCOBJECTS_PK
  ENABLE VALIDATE);