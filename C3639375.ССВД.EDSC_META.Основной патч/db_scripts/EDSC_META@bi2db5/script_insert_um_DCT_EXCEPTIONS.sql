delete from DCT_EXCEPTIONS;

INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
  VALUES (-20999, 'e_complex_error', '—ложна€ прикладна€ ошибка', '''—ложна€ прикладна€ ошибка. Ќеверное им€ exception''', 'INITIAL');
INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
  VALUES (-20101, 'e_paramvalue_empty', 'ѕустое значение параметра (получен NULL)',
          'С«начение параметра Т|| <»м€ѕараметра>||' ||'С не может принимать значение NULLТ', 'INITIAL');
INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
VALUES (-20102, 'e_paramvalue_bad', 'Ќеверное значение параметра',
        'СЌеверное значение параметра Т|| <»м€ѕараметра>||' ||
        'С. ƒл€ параметра могут быть определены следующие значени€:Т||<—трокаƒопустимых«начений>', 'INITIAL');

INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
VALUES (-20103, 'e_md_columns_emptyТ', 'ќтсутствует значение в MD_COLUMNS', 'N/A', 'INITIAL');

INSERT INTO  DCT_EXCEPTIONS (EXCEPTION_CODE, EXCEPTION_NAME, EXCEPTION_DESC, EXCEPTION_MSG_TEMPLATE, PATCH_CODE)
VALUES (-20201, 'e_metadata_not_found', 'Ќе найден объект метаданных', 'N/A', 'INITIAL');

commit;