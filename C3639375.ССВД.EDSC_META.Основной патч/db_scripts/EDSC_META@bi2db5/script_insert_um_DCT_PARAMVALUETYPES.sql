delete from DCT_PARAMVALUETYPES;

INSERT INTO DCT_PARAMVALUETYPES(PARAMVALUETYPE_CODE, PARAMVALUETYPE_NAME, PARAMVALUETYPE_DESC, PATCH_CODE)
  VALUES ('STATIC', '����������� �������� ���������', '����������, ��� �������� ��������� �������� ����������� � �� ����������� � �������� ���������� ETL.', 'INITIAL');

INSERT INTO DCT_PARAMVALUETYPES
(PARAMVALUETYPE_CODE, PARAMVALUETYPE_NAME, PARAMVALUETYPE_DESC, PATCH_CODE)
  VALUES('DYNAMIC', '���������� �������� ���������', '����������, ��� �������� ��������� �������� ������������ � �������� ���������� � �������� ���������� ETL.', 'INITIAL');
  
COMMIT;




