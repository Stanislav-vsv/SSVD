delete from dct_statuses;

insert into dct_statuses(status_code, status_name, status_desc, PATCH_CODE)
values ('RUNNING', 'Исполняется', NULL, 'INITIAL');

insert into dct_statuses(status_code, status_name, status_desc, PATCH_CODE)
values ('FAILED', 'Завершился неудачно', NULL, 'INITIAL');

insert into dct_statuses(status_code, status_name, status_desc, PATCH_CODE)
values ('SUCCEEDED', 'Успешно завершился', NULL, 'INITIAL');

commit;

