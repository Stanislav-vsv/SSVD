begin
execute immediate 'drop table MMD_TEMPLATES CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE MMD_TEMPLATES
(
  TEMPLATE_CODE      VARCHAR2(128 BYTE)         NOT NULL,
  TOOL_CODE          VARCHAR2(128 BYTE)         NOT NULL,
  CLASS_CODE         VARCHAR2(128 BYTE)         NOT NULL,
  TEMPLATE_NAME      VARCHAR2(512 BYTE)         NOT NULL,
  METHOD_CODE        VARCHAR2(128 BYTE),
  BASEOBJTYPE_CODE   VARCHAR2(128 BYTE),
  PHYS_OBJTYPE_CODE  VARCHAR2(128 BYTE),
  TEMPLATE_TEXT      CLOB                       NOT NULL,
  STRUCTKIND_CODE    VARCHAR2(128 BYTE),
  MODULETYPE_CODE    VARCHAR2(128 BYTE)
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

COMMENT ON TABLE MMD_TEMPLATES IS 'Шаблоны для генерации программного кода. Структура будет уточнена после первой итерации обсуждений.';

COMMENT ON COLUMN MMD_TEMPLATES.TEMPLATE_CODE IS 'Уникальный код шаблона';

COMMENT ON COLUMN MMD_TEMPLATES.TOOL_CODE IS 'Инструмент, для которого определяется шаблон';

COMMENT ON COLUMN MMD_TEMPLATES.CLASS_CODE IS 'Класс, для которого определен шаблон';

COMMENT ON COLUMN MMD_TEMPLATES.TEMPLATE_NAME IS 'Наименование шаблона';

COMMENT ON COLUMN MMD_TEMPLATES.METHOD_CODE IS 'Код метода, для которого определен шаблон';

COMMENT ON COLUMN MMD_TEMPLATES.BASEOBJTYPE_CODE IS 'Код базового типа объекта, для которого определен шаблон ';

COMMENT ON COLUMN MMD_TEMPLATES.PHYS_OBJTYPE_CODE IS 'Код физического типа объекта инструмента, для которого определен шаблон ';

COMMENT ON COLUMN MMD_TEMPLATES.TEMPLATE_TEXT IS 'Исходный код шаблона';

COMMENT ON COLUMN MMD_TEMPLATES.STRUCTKIND_CODE IS 'Код структуры';

COMMENT ON COLUMN MMD_TEMPLATES.MODULETYPE_CODE IS 'Код модуля';

CREATE UNIQUE INDEX MMD_TEMPLATES_PK ON MMD_TEMPLATES
(TEMPLATE_CODE)
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