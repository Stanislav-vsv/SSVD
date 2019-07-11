begin
execute immediate 'drop table MD_IPCOBJPARAMS CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE MD_IPCOBJPARAMS
(
  FOLDER_NAME          VARCHAR2(128 BYTE)       NOT NULL,
  WORKFLOW_NAME        VARCHAR2(128 BYTE)       NOT NULL,
  IPCOBJTYPE_CODE      VARCHAR2(25 BYTE)        DEFAULT 'WORKFLOW'            NOT NULL,
  IPCOBJECT_NAME       VARCHAR2(128 BYTE),
  PARAM_NAME           VARCHAR2(128 BYTE)       NOT NULL,
  LOADINGMODE_CODE     VARCHAR2(25 BYTE)        NOT NULL,
  REGLAMENTTYPE_CODE   VARCHAR2(25 BYTE)        NOT NULL,
  PARAMVALUETYPE_CODE  VARCHAR2(128 BYTE)       NOT NULL,
  PARAM_VALUE          VARCHAR2(4000 BYTE)      NOT NULL,
  LOGGING_FLAG         CHAR(1 BYTE)             DEFAULT 'N'                   NOT NULL,
  CHANGE_DATE          DATE                     DEFAULT SYSDATE               NOT NULL,
  PATCH_CODE           VARCHAR2(128 BYTE)
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


COMMENT ON TABLE MD_IPCOBJPARAMS IS 'Параметры в объектах IPC';

COMMENT ON COLUMN MD_IPCOBJPARAMS.FOLDER_NAME IS 'Имя папки. Ссылка на составной ключ MD_IPCOBJECTS';

COMMENT ON COLUMN MD_IPCOBJPARAMS.WORKFLOW_NAME IS 'Имя потока, для которого объявляется значение параметра. Ссылка на составной ключ MD_IPCOBJECTS';

COMMENT ON COLUMN MD_IPCOBJPARAMS.IPCOBJTYPE_CODE IS 'Определяет тип объекта IPC, для которого в файле параметров.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.IPCOBJECT_NAME IS 'Имя объекта (сессия, ворклет) для которого будет создаваться секция в файле параметров.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.PARAM_NAME IS 'Физическое имя параметра. Ссылка на таблицу MD_PARAMETERS.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.LOADINGMODE_CODE IS 'Указыается режим для какого режима выполняется определ';

COMMENT ON COLUMN MD_IPCOBJPARAMS.REGLAMENTTYPE_CODE IS 'Указывается, для какого типа регламента  определяется значение параметра.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.PARAMVALUETYPE_CODE IS 'Тип значения параметра. Ссылка на таблицу DCT_PARAMVALUETYPES. Возможные значения: (STATIC,DYNAMIC,SQL)';

COMMENT ON COLUMN MD_IPCOBJPARAMS.PARAM_VALUE IS 'Значение параметра. Правила заполнения определены в зависимости от типа данных параметра в разделе «Правила заполнения значений параметров».';

COMMENT ON COLUMN MD_IPCOBJPARAMS.LOGGING_FLAG IS 'Флаг, определяющий выполнять журналирование значений параметров в LOG_PARAMPREVVALUE или нет.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.CHANGE_DATE IS 'Дата последнего изменения информации о параметре в объекте IPC.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.PATCH_CODE IS 'Номер последнего патча, в котором внесены изменения.';

CREATE UNIQUE INDEX MD_IPCOBJPARAMS_PK ON MD_IPCOBJPARAMS
(FOLDER_NAME, WORKFLOW_NAME, IPCOBJTYPE_CODE, IPCOBJECT_NAME, PARAM_NAME, 
LOADINGMODE_CODE, REGLAMENTTYPE_CODE)
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