delete from DCT_LOADINGMODES;

insert into DCT_LOADINGMODES(loadingmode_code, loadingmode_name, loadingmode_desc, PATCH_CODE)
VALUES ('INITIAL', '���������������� ��������', NULL, 'INITIAL');

insert into DCT_LOADINGMODES(loadingmode_code, loadingmode_name, loadingmode_desc, PATCH_CODE)
VALUES ('INCREMENT', '��������������� ��������', NULL, 'INITIAL');

insert into DCT_LOADINGMODES(loadingmode_code, loadingmode_name, loadingmode_desc, PATCH_CODE)
VALUES ('RELOADING', '������������ ������', NULL, 'INITIAL');
commit;