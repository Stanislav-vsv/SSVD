begin
execute immediate 'drop table DCT_COLUMNTYPES CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE DCT_COLUMNTYPES
(
  COLUMNTYPE_CODE  VARCHAR2(1 BYTE)             NOT NULL,
  COLUMNTYPE_NAME  VARCHAR2(255 BYTE)           NOT NULL,
  COLUMNTYPE_DESC  VARCHAR2(512 BYTE),
  CHANGE_DATE      DATE                         DEFAULT SYSDATE               NOT NULL,
  PATCH_CODE       VARCHAR2(128 BYTE)           NOT NULL
)
TABLESPACE EDSC_META
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCOMPRESS ;

COMMENT ON TABLE DCT_COLUMNTYPES IS 'Словарь функциональных типов атрибутов.';

COMMENT ON COLUMN DCT_COLUMNTYPES.COLUMNTYPE_CODE IS 'Код функционального типа атрибута. Все коды определяются в таблице';

COMMENT ON COLUMN DCT_COLUMNTYPES.COLUMNTYPE_NAME IS 'Наименование функционального типа атрибута';

COMMENT ON COLUMN DCT_COLUMNTYPES.COLUMNTYPE_DESC IS 'Определение функционального типа атрибута';

COMMENT ON COLUMN DCT_COLUMNTYPES.CHANGE_DATE IS 'Дата последнего изменения информации о событии.';

COMMENT ON COLUMN DCT_COLUMNTYPES.PATCH_CODE IS 'Номер последнего патча, в котором внесены изменения.';