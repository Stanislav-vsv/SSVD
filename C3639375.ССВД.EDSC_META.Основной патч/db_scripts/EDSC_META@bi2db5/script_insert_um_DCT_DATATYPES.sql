delete from DCT_DATATYPES;

INSERT INTO DCT_DATATYPES (DATATYPE_CODE, DATATYPE_NAME, DATATYPE_FORMAT, CHANGE_DATE, PATCH_CODE)
VALUES ('VARCHAR2', '���������� ���', null, SYSDATE, 'INITIAL');
INSERT INTO DCT_DATATYPES (DATATYPE_CODE, DATATYPE_NAME, DATATYPE_FORMAT, CHANGE_DATE, PATCH_CODE)
VALUES ('NUMBER', '��������� ��� ������', null, SYSDATE, 'INITIAL');
INSERT INTO DCT_DATATYPES (DATATYPE_CODE, DATATYPE_NAME, DATATYPE_FORMAT, CHANGE_DATE, PATCH_CODE) 
VALUES ('DATE', '����/�����', null, SYSDATE, 'INITIAL');

commit;