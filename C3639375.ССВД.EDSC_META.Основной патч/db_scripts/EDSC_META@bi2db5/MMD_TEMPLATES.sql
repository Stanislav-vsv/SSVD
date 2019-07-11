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

COMMENT ON TABLE MMD_TEMPLATES IS '������� ��� ��������� ������������ ����. ��������� ����� �������� ����� ������ �������� ����������.';

COMMENT ON COLUMN MMD_TEMPLATES.TEMPLATE_CODE IS '���������� ��� �������';

COMMENT ON COLUMN MMD_TEMPLATES.TOOL_CODE IS '����������, ��� �������� ������������ ������';

COMMENT ON COLUMN MMD_TEMPLATES.CLASS_CODE IS '�����, ��� �������� ��������� ������';

COMMENT ON COLUMN MMD_TEMPLATES.TEMPLATE_NAME IS '������������ �������';

COMMENT ON COLUMN MMD_TEMPLATES.METHOD_CODE IS '��� ������, ��� �������� ��������� ������';

COMMENT ON COLUMN MMD_TEMPLATES.BASEOBJTYPE_CODE IS '��� �������� ���� �������, ��� �������� ��������� ������ ';

COMMENT ON COLUMN MMD_TEMPLATES.PHYS_OBJTYPE_CODE IS '��� ����������� ���� ������� �����������, ��� �������� ��������� ������ ';

COMMENT ON COLUMN MMD_TEMPLATES.TEMPLATE_TEXT IS '�������� ��� �������';

COMMENT ON COLUMN MMD_TEMPLATES.STRUCTKIND_CODE IS '��� ���������';

COMMENT ON COLUMN MMD_TEMPLATES.MODULETYPE_CODE IS '��� ������';

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