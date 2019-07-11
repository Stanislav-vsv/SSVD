delete from DCT_PARAMVALUETYPES;

INSERT INTO DCT_PARAMVALUETYPES(PARAMVALUETYPE_CODE, PARAMVALUETYPE_NAME, PARAMVALUETYPE_DESC, PATCH_CODE)
  VALUES ('STATIC', '—татическое значение параметра', 'ќпредел€ет, что значение параметра €вл€етс€ статическим и не вычисл€етс€ в процессе исполнени€ ETL.', 'INITIAL');

INSERT INTO DCT_PARAMVALUETYPES
(PARAMVALUETYPE_CODE, PARAMVALUETYPE_NAME, PARAMVALUETYPE_DESC, PATCH_CODE)
  VALUES('DYNAMIC', '¬ычислимое значение параметра', 'ќпредел€ет, что значение параметра €вл€етс€ динамическим и подлежит вычислению в процессе исполнени€ ETL.', 'INITIAL');
  
COMMIT;




