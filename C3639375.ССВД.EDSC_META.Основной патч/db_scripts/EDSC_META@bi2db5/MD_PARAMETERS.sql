begin
execute immediate 'drop table MD_PARAMETERS CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE MD_PARAMETERS
(
  PARAM_NAME     VARCHAR2(128 BYTE)             NOT NULL,
  PARAM_DESC     VARCHAR2(4000 BYTE)            NOT NULL,
  DATATYPE_CODE  VARCHAR2(128 BYTE)             NOT NULL,
  ACTIVE_FLAG    VARCHAR2(1 BYTE)               NOT NULL,
  CHANGE_DATE    DATE                           NOT NULL,
  PATCH_CODE     VARCHAR2(128 BYTE)
)
TABLESPACE EDSC_META;

COMMENT ON TABLE MD_PARAMETERS IS 'Реестр параметров';

COMMENT ON COLUMN MD_PARAMETERS.PARAM_NAME IS 'Физическое имя параметра в формате IPC ';

COMMENT ON COLUMN MD_PARAMETERS.PARAM_DESC IS 'Описание назначения параметра.';

COMMENT ON COLUMN MD_PARAMETERS.DATATYPE_CODE IS 'Тип объекта IPC, для которого определяются настройки ETL. Ссылка на таблицу DCT_IPCOBJTYPES';

COMMENT ON COLUMN MD_PARAMETERS.ACTIVE_FLAG IS 'Логический признак, определяющий является параметр действующим или нет. ';

COMMENT ON COLUMN MD_PARAMETERS.CHANGE_DATE IS 'Дата последнего изменения информации о параметре';

COMMENT ON COLUMN MD_PARAMETERS.PATCH_CODE IS 'Номер последнего патча, в котором внесены изменения.';

CREATE UNIQUE INDEX MD_PARAMETERS_PK ON MD_PARAMETERS
(PARAM_NAME)
TABLESPACE EDSC_META;

ALTER TABLE MD_PARAMETERS ADD (
  CONSTRAINT MD_PARAMETERS_PK
  PRIMARY KEY
  (PARAM_NAME)
  USING INDEX MD_PARAMETERS_PK
  ENABLE VALIDATE);