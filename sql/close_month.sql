ALTER SESSION SET CURRENT_SCHEMA = BESPROD;
/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
/

select * from all_objects
    where 1=1
     and owner = 'BESPROD'
     and status <> 'VALID'
    order by last_ddl_time desc;
/

BEGIN
  DBMS_UTILITY.COMPILE_SCHEMA(schema => 'BESPROD', compile_all => FALSE, reuse_settings => TRUE);
END;
/

﻿select * from besprod.t_AYKAPA_LOG_MASTER
        where donem = '11/2024'
    order by seq desc;

﻿select * from besprod.t_AYKAPA_LOG_MASTER order by seq;

select * from trans where transtip = 100 and transtar = trunc(sysdate) - 1
    order by seq desc;

select count(*) from (
    select * from trans where transtip = 100 and transtar = trunc(sysdate) - 1
        order by seq desc
);

select * from trans where transtip = 100 and transtar = trunc(sysdate) - 31

select count(*) from (
    select tarifeno from trans where transtip = 100 and transtar = trunc(sysdate) - 31
        minus
    select tarifeno from trans where transtip = 100 and transtar = trunc(sysdate) - 1
);
    
select tarifeno from trans where transtip = 100 and transtar = trunc(sysdate) - 31
    minus
select tarifeno from trans where transtip = 100 and transtar = trunc(sysdate) - 1;

select tarifeno from trans where transtip = 100 and transtar = trunc(sysdate) - 1
    minus
select tarifeno from trans where transtip = 100 and transtar = trunc(sysdate) - 31;

/**************************/

SELECT * FROM besprod.SONPOL WHERE POLID IN (           
select p.polid
        from besprod.t_zeyl z, besprod.t_police p
       where z.branskod = 'H'
         and z.tarifeno = z.tarifeno
         and p.status = 'M'
         and z.zeylno = 1
         and z.rejitar between '01/11/2024' and '30/11/2024'
         and p.polid = z.polid
         and p.polcins = 'A'
         and p.policeno is not null
      minus
      select t.polid
        from besprod.t_tahakkuk t
       where t.branskod = 'H'
         and t.tarifeno = t.tarifeno
         and t.thktar between '01/11/2024' and '30/11/2024'
         and t.thktip = 'A');
         
/***************************/

select * from tahsilat where polid = 2157177 order by tahsno desc;         

select * from tahsmaster where seq in (5472029, 5472027);

select * from tahsilat where seq in (5472029, 5472027);

select * from ytmtahsilat where agitotahsno in (41709492, 41709495);

-- 2816991 

select * from SONPOL where polid = 2816991;

select * from zeyl2 where polid = 2816991 order by zeylno desc;

select * from ODEPLAN_V where polid = 2816991;

select * from tahsilat where polid = 2816991;

select * from polodeyen where polid = 2816991;

/*****************************/

select * from akajobs where lower(aciklama) like '%sabit kurlu%' -- 159

select sigutil.getsysparam('OTOZEYL_TO') from dual;

SabitKurVadeZeyl

Zeyllib

select * from sonpol where polid = 2352529;

select * from sigortali where  polid = 2352529 order by zeylno desc;

select * from zeyl2 where  polid = 2352529 order by zeylno desc; -- 277,95

select * from tahsilat where polid = 2352529 order by tahsno desc; 

select * from sigtmnt where  polid = 2352529 order by zeylno desc; -- 277,95

select * from odeplan_v where polid = 2352529 and vadetar = '15/03/2024';

select * from ytmtahsilat where agitotahsno in (41539655, 41539654);

/*****************************/