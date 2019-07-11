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

COMMENT ON TABLE MD_IPCOBJECTS IS 'Объекты IPC';

COMMENT ON COLUMN MD_IPCOBJECTS.FOLDER_NAME IS 'Имя папки, в которой находится объект';

COMMENT ON COLUMN MD_IPCOBJECTS.WORKFLOW_NAME IS 'Имя потока';

COMMENT ON COLUMN MD_IPCOBJECTS.PURPOSETYPE_CODE IS 'Тип функционально назначения объекта IPC';

COMMENT ON COLUMN MD_IPCOBJECTS.IPCOBJECT_DESC IS 'Описание объекта IPC';

COMMENT ON COLUMN MD_IPCOBJECTS.ACTIVE_FLAG IS 'Логический признак, определяющий является объект IPC действующим или нет.';

COMMENT ON COLUMN MD_IPCOBJECTS.CHANGE_DATE IS 'Дата последнего изменения информации о событии.';

COMMENT ON COLUMN MD_IPCOBJECTS.PATCH_CODE IS 'Номер последнего патча, в котором внесены изменения.';

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