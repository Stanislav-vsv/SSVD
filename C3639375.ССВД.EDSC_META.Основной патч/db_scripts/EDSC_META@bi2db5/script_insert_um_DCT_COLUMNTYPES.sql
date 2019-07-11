delete from DCT_COLUMNTYPES;

INSERT INTO DCT_COLUMNTYPES(COLUMNTYPE_CODE, COLUMNTYPE_NAME, COLUMNTYPE_DESC, CHANGE_DATE, PATCH_CODE)
  VALUES ('K', '�������� ����', '������������ ��� ����� �������, ������� ������ � ��������� ����', SYSDATE, 'INITIAL');

INSERT INTO DCT_COLUMNTYPES(COLUMNTYPE_CODE, COLUMNTYPE_NAME, COLUMNTYPE_DESC, CHANGE_DATE, PATCH_CODE)
  VALUES ('C', '������������ ����',
          '������������ ��� �����, �� ������ ��������� �������� � ����������� �������� ������� ������������ ����� ��� �� ����� ����������� ������.',
          SYSDATE, 'INITIAL');

INSERT INTO DCT_COLUMNTYPES(COLUMNTYPE_CODE, COLUMNTYPE_NAME, COLUMNTYPE_DESC, CHANGE_DATE, PATCH_CODE)
  VALUES('N', '����, �� ������������ � ���������',
         '������������ ��� �����, ������� �� ��������� � ��������� ������� � ���������� ��������, �� �������� �������� �����������.',
         SYSDATE, 'INITIAL'
        );

INSERT INTO DCT_COLUMNTYPES(COLUMNTYPE_CODE, COLUMNTYPE_NAME, COLUMNTYPE_DESC, CHANGE_DATE, PATCH_CODE)
  VALUES('F', '����������� ������� �������� ����',
         '������������ ��� �����,  � ������� ���������� ����������� ������ NOT NULL �������� �� ���� ����������� ������� �������.',
         SYSDATE  , 'INITIAL'     
        );

COMMIT;