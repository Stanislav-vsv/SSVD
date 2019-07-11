CREATE USER EDSC_META
  IDENTIFIED BY <password>
  DEFAULT TABLESPACE EDSC_META
  TEMPORARY TABLESPACE TEMP
  PROFILE PRF_TECH
  ACCOUNT UNLOCK;

BEGIN
    DBMS_RESOURCE_MANAGER.CLEAR_PENDING_AREA();
    DBMS_RESOURCE_MANAGER.CREATE_PENDING_AREA();
    DBMS_RESOURCE_MANAGER_PRIVS.GRANT_SWITCH_CONSUMER_GROUP('EDSC_META','GRP_TECH',FALSE);
    DBMS_RESOURCE_MANAGER.SET_INITIAL_CONSUMER_GROUP('EDSC_META','GRP_TECH');
    DBMS_RESOURCE_MANAGER.SUBMIT_PENDING_AREA();
END;
/
  GRANT CREATE MATERIALIZED VIEW TO EDSC_META;
  GRANT CREATE SESSION TO EDSC_META;
  GRANT CREATE ANY TYPE TO EDSC_META;
  GRANT CREATE PROCEDURE TO EDSC_META;
  GRANT CREATE SEQUENCE TO EDSC_META;
  GRANT CREATE VIEW TO EDSC_META;
  GRANT UNLIMITED TABLESPACE TO EDSC_META;
  GRANT SELECT ANY DICTIONARY TO EDSC_META;
  GRANT CREATE SYNONYM TO EDSC_META;
  GRANT CREATE TABLE TO EDSC_META;
