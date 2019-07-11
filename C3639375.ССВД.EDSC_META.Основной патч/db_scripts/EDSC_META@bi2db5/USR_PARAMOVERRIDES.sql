begin
execute immediate 'drop table USR_PARAMOVERRIDES CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE USR_PARAMOVERRIDES
(
  REG_LOADING_ID     NUMBER(38),
  LOADING_ID         NUMBER(38),
  JOB_ID             NUMBER(38),
  IPCOBJTYPE_CODE    VARCHAR2(128 BYTE)         NOT NULL,
  IPCOBJECT_NAME     VARCHAR2(128 BYTE),
  REG_FOLDER_NAME    VARCHAR2(128 BYTE),
  REG_WORKFLOW_NAME  VARCHAR2(128 BYTE),
  FOLDER_NAME        VARCHAR2(128 BYTE)         NOT NULL,
  WORKFLOW_NAME      VARCHAR2(128 BYTE)         NOT NULL,
  PARAM_NAME         VARCHAR2(128 BYTE)         NOT NULL,
  PARAM_VALUE        VARCHAR2(4000 BYTE),
  CYCLE_ORDER_NO     VARCHAR2(25 BYTE)          DEFAULT 0                     NOT NULL,
  CYCLE_STATUS       VARCHAR2(4000 BYTE)        DEFAULT 'N/A'                 NOT NULL,
  CYCLE_LOADING_ID   NUMBER(38)
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

COMMENT ON TABLE USR_PARAMOVERRIDES IS 'Переопределение значений параметров';

COMMENT ON COLUMN USR_PARAMOVERRIDES.REG_LOADING_ID IS 'Идентификатор запуска Регламентного Потока. При ручной вставке не заполняется. Формируется и заполняется автоматически в процедуре INIT JOB';

COMMENT ON COLUMN USR_PARAMOVERRIDES.LOADING_ID IS 'Идентификатор запуска Управляющего Потока. При ручной вставке не заполняется. Формируется и заполняется автоматически в процедуре INIT JOB';

COMMENT ON COLUMN USR_PARAMOVERRIDES.JOB_ID IS 'Идентификатор запуска функционального Потока. При ручной вставке не заполняется. Формируется и заполняется автоматически в процедуре INIT JOB';

COMMENT ON COLUMN USR_PARAMOVERRIDES.IPCOBJTYPE_CODE IS 'Определяет тип объекта IPC, для которого в файле параметров. Ссылка на таблицу DCT_IPCOBJTYPES. ';

COMMENT ON COLUMN USR_PARAMOVERRIDES.IPCOBJECT_NAME IS 'Имя объекта (сессия, ворклет) для которого будет создаваться секция в файле параметров. ';

COMMENT ON COLUMN USR_PARAMOVERRIDES.REG_FOLDER_NAME IS 'Папка Регламентного потока, в рамках которого будет запуск';

COMMENT ON COLUMN USR_PARAMOVERRIDES.REG_WORKFLOW_NAME IS 'Имя Регламентного потока, в рамках которого будет запуск';

COMMENT ON COLUMN USR_PARAMOVERRIDES.FOLDER_NAME IS 'Папка JOB или CTL или REG потока, для которого требуется переопределение';

COMMENT ON COLUMN USR_PARAMOVERRIDES.WORKFLOW_NAME IS 'Наименование JOB или CTL или REG потока, для которого требуется переопределение';

COMMENT ON COLUMN USR_PARAMOVERRIDES.PARAM_NAME IS 'Наименование параметра, значение которого требуется переопределить';

COMMENT ON COLUMN USR_PARAMOVERRIDES.PARAM_VALUE IS 'Значение параметра';

COMMENT ON COLUMN USR_PARAMOVERRIDES.CYCLE_ORDER_NO IS 'Порядок циклического запуска потоков';

COMMENT ON COLUMN USR_PARAMOVERRIDES.CYCLE_STATUS IS 'Статус циклического запуска потока';

COMMENT ON COLUMN USR_PARAMOVERRIDES.CYCLE_LOADING_ID IS 'LOADING_ID потока, запустившего циклическую обработку';