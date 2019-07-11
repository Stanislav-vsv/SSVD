delete from DCT_LOADINGMODES;

insert into DCT_LOADINGMODES(loadingmode_code, loadingmode_name, loadingmode_desc, PATCH_CODE)
VALUES ('INITIAL', 'Инициализирующая загрузка', NULL, 'INITIAL');

insert into DCT_LOADINGMODES(loadingmode_code, loadingmode_name, loadingmode_desc, PATCH_CODE)
VALUES ('INCREMENT', 'Инкрементальная загрузка', NULL, 'INITIAL');

insert into DCT_LOADINGMODES(loadingmode_code, loadingmode_name, loadingmode_desc, PATCH_CODE)
VALUES ('RELOADING', 'Перезагрузка данных', NULL, 'INITIAL');
commit;