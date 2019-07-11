delete from DCT_EXCEPTIONS;

INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
  VALUES (-20999, 'e_complex_error', '������� ���������� ������', '''������� ���������� ������. �������� ��� exception''', 'INITIAL');
INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
  VALUES (-20101, 'e_paramvalue_empty', '������ �������� ��������� (������� NULL)',
          '��������� ��������� �|| <������������>||' ||'� �� ����� ��������� �������� NULL�', 'INITIAL');
INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
VALUES (-20102, 'e_paramvalue_bad', '�������� �������� ���������',
        '��������� �������� ��������� �|| <������������>||' ||
        '�. ��� ��������� ����� ���� ���������� ��������� ��������:�||<������������������������>', 'INITIAL');

INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
VALUES (-20103, 'e_md_columns_empty�', '����������� �������� � MD_COLUMNS', 'N/A', 'INITIAL');

INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
VALUES (-20201, 'e_metadata_not_found', '�� ������ ������ ����������', 'N/A', 'INITIAL');

commit;