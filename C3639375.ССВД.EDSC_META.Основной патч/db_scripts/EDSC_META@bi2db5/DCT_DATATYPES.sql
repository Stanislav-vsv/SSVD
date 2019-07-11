begin
execute immediate 'drop table DCT_DATATYPES CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE DCT_DATATYPES
(
  DATATYPE_CODE    VARCHAR2(25 BYTE)            NOT NULL,
  DATATYPE_NAME    VARCHAR2(255 BYTE)           NOT NULL,
  DATATYPE_FORMAT  VARCHAR2(512 BYTE),
  CHANGE_DATE      DATE                         DEFAULT SYSDATE               NOT NULL,
  PATCH_CODE       VARCHAR2(128 BYTE)           NOT NULL
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

CREATE UNIQUE INDEX DCT_DATATYPES_PK ON DCT_DATATYPES
(DATATYPE_CODE)
TABLESPACE EDSC_META;

ALTER TABLE DCT_DATATYPES ADD (
  CONSTRAINT DCT_DATATYPES_PK
  PRIMARY KEY
  (DATATYPE_CODE)
  USING INDEX DCT_DATATYPES_PK
  ENABLE VALIDATE);
COMMENT ON TABLE DCT_DATATYPES IS 'Типы данных.';

COMMENT ON COLUMN DCT_DATATYPES.DATATYPE_CODE IS 'Уникальный код типа данных.';

COMMENT ON COLUMN DCT_DATATYPES.DATATYPE_NAME IS 'Наименование типа данных';

COMMENT ON COLUMN DCT_DATATYPES.DATATYPE_FORMAT IS 'Строковый формат данных для типа данных по умолчанию';

COMMENT ON COLUMN DCT_DATATYPES.CHANGE_DATE IS 'Дата последнего изменения информации о событии.';

COMMENT ON COLUMN DCT_DATATYPES.PATCH_CODE IS 'Номер последнего патча, в котором внесены изменения.';