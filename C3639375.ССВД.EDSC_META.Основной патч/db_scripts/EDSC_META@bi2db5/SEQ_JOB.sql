begin
execute immediate 'drop sequence SEQ_JOB ';
exception when others
  then null;
end;
/

CREATE SEQUENCE SEQ_JOB
  START WITH 2741
  MAXVALUE 9999999999999999999999999999
  MINVALUE 0
  NOCYCLE;