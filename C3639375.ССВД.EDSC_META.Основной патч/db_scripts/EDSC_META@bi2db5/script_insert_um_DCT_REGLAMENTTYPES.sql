delete from DCT_REGLAMENTTYPES;

INSERT INTO DCT_REGLAMENTTYPES (REGLAMENTTYPE_CODE, REGLAMENTTYPE_NAME, REGLAMENTTYPE_DESC, PATCH_CODE)
  VALUES ( 'REGULAR_D', '���������� ���������', NULL , 'INITIAL');
  
INSERT INTO DCT_REGLAMENTTYPES (REGLAMENTTYPE_CODE, REGLAMENTTYPE_NAME, REGLAMENTTYPE_DESC, PATCH_CODE)
  VALUES ( 'REGULAR_W', '������������ ���������', NULL , 'INITIAL');
  
INSERT INTO DCT_REGLAMENTTYPES (REGLAMENTTYPE_CODE, REGLAMENTTYPE_NAME, REGLAMENTTYPE_DESC, PATCH_CODE)
  VALUES ( 'REGULAR_M', '����������� ���������', NULL, 'INITIAL' );
  
INSERT INTO DCT_REGLAMENTTYPES (REGLAMENTTYPE_CODE, REGLAMENTTYPE_NAME, REGLAMENTTYPE_DESC, PATCH_CODE)
  VALUES ( 'RELOAD', '��������� ������������ ������', NULL, 'INITIAL' );
  
INSERT INTO DCT_REGLAMENTTYPES (REGLAMENTTYPE_CODE, REGLAMENTTYPE_NAME, REGLAMENTTYPE_DESC, PATCH_CODE)
  VALUES ( 'CYCLE', '��������� ����������� ������������ ������', NULL, 'INITIAL' );
  
COMMIT;