delete from dct_statuses;

insert into dct_statuses(status_code, status_name, status_desc, PATCH_CODE)
values ('RUNNING', '�����������', NULL, 'INITIAL');

insert into dct_statuses(status_code, status_name, status_desc, PATCH_CODE)
values ('FAILED', '���������� ��������', NULL, 'INITIAL');

insert into dct_statuses(status_code, status_name, status_desc, PATCH_CODE)
values ('SUCCEEDED', '������� ����������', NULL, 'INITIAL');

commit;

