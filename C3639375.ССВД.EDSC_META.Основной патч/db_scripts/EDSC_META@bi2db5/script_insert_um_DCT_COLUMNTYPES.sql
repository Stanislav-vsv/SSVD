delete from DCT_COLUMNTYPES;

INSERT INTO DCT_COLUMNTYPES(COLUMNTYPE_CODE, COLUMNTYPE_NAME, COLUMNTYPE_DESC, CHANGE_DATE, PATCH_CODE)
  VALUES ('K', 'Ключевое поле', 'Определяется для полей таблицы, которое входит в первичный ключ', SYSDATE, 'INITIAL');

INSERT INTO DCT_COLUMNTYPES(COLUMNTYPE_CODE, COLUMNTYPE_NAME, COLUMNTYPE_DESC, CHANGE_DATE, PATCH_CODE)
  VALUES ('C', 'Сравниваемое поле',
          'Определяется для полей, на основе сравнения текущего и предыдущего значения которых определяется будет или не будет обновляться запись.',
          SYSDATE, 'INITIAL');

INSERT INTO DCT_COLUMNTYPES(COLUMNTYPE_CODE, COLUMNTYPE_NAME, COLUMNTYPE_DESC, CHANGE_DATE, PATCH_CODE)
  VALUES('N', 'Поле, не учавствующее в сравнении',
         'Определяется для полей, которые не участвуют в сравнении текущих и предыдущих значений, но загрузка значений выполняется.',
         SYSDATE, 'INITIAL'
        );

INSERT INTO DCT_COLUMNTYPES(COLUMNTYPE_CODE, COLUMNTYPE_NAME, COLUMNTYPE_DESC, CHANGE_DATE, PATCH_CODE)
  VALUES('F', 'Определение первого значения поля',
         'Определяется для полей,  в которых необходимо фиксировать первое NOT NULL значение во всех последующих записях истории.',
         SYSDATE  , 'INITIAL'     
        );

COMMIT;