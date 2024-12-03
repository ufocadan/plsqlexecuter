ALTER SESSION SET CURRENT_SCHEMA = BESPROD;
/

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
/

PRC_AEGL_12073
ROPFTFP
PRC_TAHSDAGIT_12142_4
ZORUNLUMETODLIB2

select * from t_tasimatakip where tarih >= trunc(sysdate) - 1
  order by id desc;

select * from t_akajobs order by aka_jobid desc;

Begin
    update t_sysprm 
      -- set prmval = 'Eser.Tokman@viennalife.com.tr;zeka.birman@viennalife.com.tr;kivanc.manzakoglu@viennalife.com.tr;TeknikFinansalRaporlamaveButcelemeBolumu@viennalife.com.tr;FonYonetimi@viennalife.com.tr;beshayat.bakim@agito.com.tr;OlayVeProblemYonetimi@viennalife.com.tr;operasyonyonetim@viennalife.com.tr; omer.kara@viennalife.com.tr; betul.senbulbul@viennalife.com.tr;'
      set prmval = 'unal.focadan@agito.com.tr'
        where prmname = 'SENDMAIL_HAYATFON_TO';
    commit;    
End;
/

select * from t_sysprm  where prmname = 'SENDMAIL_FONSONUC_FROM';

select * from t_sysprm  where prmname = 'SENDMAIL_HAYATFON_TO';

select nvl(to_number(GetSysprmVal('HAYAT_FONLAMA_MODE')),0) from dual;

select * from tefaswsparametre;

select * from temlikwsparametre;

create table tmp_wsparams as
    select *
      from wsparams 
     where alias = 'DEVALUATOR' ;
     /
     
select * from tmp_wsparams;
/

Begin
    update wsparams 
        set apiurl = 'https://service-test.viennalife.com.tr/common/agito-devaulator/devaluator/'
        , walletdir = 'file:/var/opt/oracle/dbaas_acfs/VLPROD/wallet'
        , walletpass = 'FBxSK+VQ9_xe8ts'
          where alias = 'DEVALUATOR';
    Commit;  
End;      
/

select *
      from wsparams 
     where alias = 'DEVALUATOR' 
       and ortam = sys_context('USERENV', 'DB_NAME');
       /

select *
      from wsparams 
     where alias = 'DEVALUATOR' 
       and ortam = sys_context('USERENV','DB_UNIQUE_NAME');
       /
       
Begin
  update wsparams set ortam = sys_context('USERENV','DB_UNIQUE_NAME')  
     where alias = 'DEVALUATOR' 
       and ortam = sys_context('USERENV', 'DB_NAME');
       
  commit;
End;
/       

select sys_context('USERENV', 'DB_NAME') from dual;
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

begin
	   utl_recomp.recomp_parallel;
end;
/ 

ROPFTFP

ZORUNLUMETODLIB2

PRC_TAHSDAGIT_12142_4

PRC_AEGL_12073

AEGL_8409_PROC1

AEGL_8698_PROC1

select sys_context('USERENV','DB_UNIQUE_NAME') from dual;

Begin
  update wsparams set ortam = sys_context('USERENV','DB_UNIQUE_NAME')  
     where alias = 'DEVALUATOR' 
       and ortam = sys_context('USERENV', 'DB_NAME');
       
  commit;
End;
/         

TPG10KPS11_TMNT_KONTROL_FORMUL

TPG10KPO11_TMNT_KONTROL_FORMUL

ins_tasimatakip

htazlib

zeyllib

ytmtransutil

DECLARE
  v_rtn              NUMBER;
  v_sqlerrm          VARCHAR2 (4000);
  v_hayatfonlamode   NUMBER
    := NVL (TO_NUMBER (GetSysprmVal ('HAYAT_FONLAMA_MODE')), 0); -- <AEGL-12236>
BEGIN
  IF v_hayatfonlamode = 0
  THEN
    besprod.hayatfonla;
  ELSIF v_hayatfonlamode = 1
  THEN
    besprod.prc_HayatFonlaByPolidJob;                          -- <AEGL-12236>
  END IF;

  writeakajobserrlog (51, 'BASARILI');
EXCEPTION
  WHEN OTHERS
  THEN
    v_sqlerrm := SUBSTR (SQLERRM, 1, 3999);
    writeakajobserrlog (51, v_sqlerrm);
END;
/

YTMLIB

YTMUTIL

YTMWS


Declare
    v_mailHtml clob;
Begin
     v_mailHtml := fnc_getHytFonMailHtmlByKume(p_kumeseq => 2221920);
     p (v_mailHtml);
End;
/

select fd.fonkod
          ,fon.sirano
          ,s.urunkod
          ,b.kumeseq
      from brkhareket  b
          ,sonpol      s
          ,fonmetod    f
          ,fonmetoddet fd
          ,fon         fon
     where 1=1
       and b.kumeseq = 2221920
       and s.polid = b.polid
       and s.tarifeno = f.tarifeno
       and s.dovkod = f.dovkod
       and nvl(f.kapatar, '01/01/2100') > trunc(sysdate)
       and f.metodid = (Select max(metodid)
                          from fonmetod
                         where branskod = f.branskod
                           and tarifeno = f.tarifeno
                           and dovkod = f.dovkod
                           and nvl(kapatar, '01/01/2100') > trunc(sysdate))
       and fd.metodid = f.metodid
       and fon.fonkod = fd.fonkod
     group by fd.fonkod
             ,fon.sirano
             ,s.urunkod
             ,b.kumeseq
     order by fon.sirano;

GetSysprmVal

TahsPkgBr

select * from uwstatmap;

select * from t_sysprm where prmname like '%BASIM%';

select * from tahsmaster where fistar >= '07/05/2024'
   -- and fisno is null
   and branskod = 'E'
 order by seq desc;


select * from besprod.t_brkharkume where tarih >= trunc(sysdate) 
        -- and kaynak = 'SRV'
    order by kumeseq desc;
    
select * from besprod.t_otofonlamajobmaster
        order by seq desc;

select * from besprod.t_otofonlamajobdetail
            where mseq = 220          
              and hata is not null
        order by seq desc;

select * from besprod.t_otofonlamajobdetail
            where mseq = 213
              and hata is null
        order by seq desc;

select * from brkhareket
        where kumeseq = 2397617
              -- and fonseq is not null
              -- and fonseq is null
            order by harseq desc;
    
select count(distinct polid) from brkhareket
        where kumeseq = 2397617
            order by harseq desc;

select * from brkhareket
            where fontar >= trunc(sysdate);

select * from brkharfon
            where fontar >= trunc(sysdate);
        
select count(distinct polid) from brkharfon
            where fontar = trunc(sysdate);
    
select SigUtil.SysParam('SENDMAIL_HAYATFON_TO') from dual;    

select * from akajobs where lower(aciklama) like '%fonla%'

select * from akajobserrlog where TARIH >= TRUNC(SYSDATE)-1 order by tarih desc;

select * from errorlog where crttar >= TRUNC(SYSDATE) order by crttar asc;

select * from errorlog where crttar >= TRUNC(SYSDATE) order by crttar desc;

select * from akajobserrlog where aka_jobid = '51' order by tarih desc;

select * from akajobs where aka_jobid = '180'; 

select * from dba_jobs where job = 3180;

select * from dba_jobs_RUNNING;

select * from akajobserrlog where aka_jobid = '51'
    order by tarih desc;
    
DELETE FROM BESPROD.T_HFONLIB_BUYFUNDUNITS_TMP
      WHERE POLID = :B1    
    
besprod.hayatfonla;  

ins_tasimatakip

/*
Declare
  v_rtn     number;
  v_sqlerrm varchar2(4000);
Begin
  besprod.hayatfonla;
  writeakajobserrlog(51, 'BASARILI');
Exception
  When others then
    v_sqlerrm := sqlerrm;
    writeakajobserrlog(51, v_sqlerrm);
End;
*/

CREATE OR REPLACE procedure BESPROD."HAYATFONLA" as
  cursor c is
    Select *
      From urun
     where uruntip ='BRK';
  v_message varchar2(4000) := null;
  v_kumeseq number;
  v_cnt     number;
  v_tarih   date := trunc(sysdate);
begin
  if not akalib.IsWorkingDay(v_tarih) then
    return;
  end if;

  for r in c loop
    begin
      v_kumeseq := besprod.hfonlib.crtfonharkume(p_urunkod => r.kod,
                                               p_tarifeno => null,
                                               p_gf => null,
                                               p_dovkod => null,
                                               p_polid => null,
                                               p_harneden => 3,
                                               p_tarih => v_tarih,
                                               p_aciklama => 'OTOMATIK FONLAMA',
                                               p_kumetip => 'K',
                                               p_kaynak => 'SRV');

      v_message := v_message ||r.kod ||' :>> Fonlama hatasýz tamamlandý. KumeSeq:' || v_kumeseq ||'<br><br>';
      Commit;

      v_cnt := besprod.hfonlib.buyfundunits(p_urunkod => r.kod,
                                            p_tarifeno => null,
                                            p_gf => null,
                                            p_dovkod => null,
                                            p_polid => null,
                                            p_asof => v_tarih);

      Commit;

  --    hayatfonlaMailText(v_kumeseq);
      hytfonmail.updtbrkharkumesonuc(v_kumeseq,v_message);



   exception when others then
      v_message := v_message ||r.kod ||' :>> '  || sqlerrm ||'<br><br>';
      hytfonmail.updtbrkharkumesonuc(v_kumeseq,v_message);
      rollback;
    end;    
  end loop;

      hytfonmail.gethytfonmailhtml(v_tarih,null, null);
  p(v_message);

  UTL_MAIL.send(sender => SigUtil.SysParam('SENDMAIL_FONSONUC_FROM'),
    recipients => SigUtil.SysParam('SENDMAIL_HAYATFON_TO'),
    subject => to_char(v_tarih,'dd/MM/rrrr') ||  ' Hayat Fonlama',
    cc => null,
    mime_type => 'text/html; charset=iso-8859-9',
    message => v_message );
end;  /* GOLDENGATE_DDL_REPLICATION */
/

declare
  v_sqlerrm varchar2(4000);
  begin
  
    writeakajobserrlog(163,  'Ýhtar Kümesi Olusturma Job ý baþladý ');

    OTOIhtarKume('H', trunc(sysdate));

    writeakajobserrlog(163,  'Ýhtar Kümesi Olusturma Job ý bitti ');
    
    commit ;
    
    IhtarKumesiCikmayan; -- AEGL-7521   
    
    writeakajobserrlog(163,  'Ýhtar Kümesi Olusturma Jobý rapor gönderimi tamamlandý. ');


exception
  when others then
   v_sqlerrm := substr(sqlerrm,1,3900);
   writeakajobserrlog(163, ' Ýhtar Kümesi Olusturma Job hata oluþtu-' || v_sqlerrm);
end;

select * from police where polid = 2332667

/*****************/

ALTER SYSTEM SET pga_aggregate_limit=0 SCOPE=BOTH;

/*****************/

select ctable.polid, ctable.stat, ctable.zeyltantar
          ,count(*) as sayac from (
select t.polid as polid
          ,(p.status || p.substatus) as stat
          ,(select tantar from zeyl z where z.polid = p.polid 
                                            and z.zeylno = p.sonzeylno) 
                                            as zeyltantar
      from tahsilat t
          ,police   p
          ,urun     u
     where t.borctip in ('P', 'A')
       and t.intiktar <= trunc(sysdate)
       and t.tantar <= trunc(sysdate)
       and t.processtar is null
       and p.polid = t.polid
       and p.urunkod <> 'AKTR'
       and p.branskod = 'H'
       and u.kod = p.urunkod
       and u.uruntip = 'BRK'
       and (p.status || p.substatus) in ('MM', 'IT') ) ctable
     group by ctable.polid
             ,ctable.stat
             ,ctable.zeyltantar
     order by ctable.polid;
     
select distinct t.polid, p.stat, p.zeyltantar
      from tahsilat t, sonpol p, tarife tr, urun u
     where t.polid = nvl(null, t.polid)
       and t.borctip in ('P', 'A')
       and t.intiktar <= trunc(sysdate)
       and t.tantar <= trunc(sysdate)
       and t.processtar is null
       and p.polid = t.polid
       and p.urunkod = nvl(null, p.urunkod)
       and p.urunkod <> 'AKTR'
       and p.branskod = 'H'
       and p.tarifeno = nvl(null, p.tarifeno)
       and p.dovkod = nvl(null, p.dovkod)
       and u.kod = p.urunkod
       and u.uruntip = 'BRK'
       and tr.branskod = p.branskod
       and tr.tarifeno = p.tarifeno
       and tr.gf = nvl(null, tr.gf)
       and p.stat in ('MM', 'IT')
     order by t.polid;     
     
select t.*
      from tahsilat t
          ,police   p
          ,urun     u
     where t.borctip in ('P', 'A')
       and t.intiktar <= trunc(sysdate)
       and t.tantar <= trunc(sysdate)
       and t.processtar is null
       and p.polid = t.polid
       and p.urunkod <> 'AKTR'
       and p.branskod = 'H'
       and u.kod = p.urunkod
       and u.uruntip = 'BRK'
       and (p.status || p.substatus) in ('MM', 'IT')
     order by t.tahsno;

execute immediate 'alter session set nls_date_format=''DD/MM/YYYY''';     
execute immediate 'alter session set nls_numeric_characters = ''.,''';     

t_otofonlamajobmaster

t_otofonlamajobdetail

select * from sonpol where polid in (2420612) ; -- 2824958

select * from tahsilat where polid in (2420612) and borctip = 'P' 
  and processtar is null
order by tahsno desc;

select * from odeplan_v where polid in (2420612) ;

select * from zeyl2 where polid in (2420612) ;

select * from brkhareket where tahsno in (select tahsno from tahsilat where polid in (2420612) and borctip = 'P') order by harseq desc;

select * from brkharfon where harseq in ( select harseq from brkhareket where tahsno in (select tahsno from tahsilat where polid in (2420612) and borctip = 'P' and processtar is not null) )

select * from ytmtransactionlog where polid in (2420612) order by seq desc;

Begin
 delete from brkharfon where harseq in ( select harseq from brkhareket where tahsno in (select tahsno from tahsilat where polid in (2128289, 2698273) and borctip = 'P' and processtar is not null) );
 delete from brkhareket where tahsno in (select tahsno from tahsilat where polid in (2128289, 2698273) and borctip = 'P' and processtar is not null);
 update tahsilat set processtar = null where tahsno in (select tahsno from tahsilat where polid in (2128289, 2698273) and borctip = 'P' and processtar is not null);
 commit;
End;
/

select Sigutil.sysparam('IHTARCIKMAYANPOLICELER_BODY') from dual;

select Sigutil.sysparam('IHTARCIKMAYANPOLICELER_SUBJECT') from dual;

select * from hayatfonmail;

select * from fonmetod where kapatar is not null;

select * from t_sysprm where prmname like 'SENDMAIL_%'

hytfonmail.gethytfonmailhtml(p_tarih => v_tarih, p_kumeseq => v_kumeseq);

select t.polid as polid
          ,count(*) as sayac
      from tahsilat t
          ,police   p
          ,urun     u
     where t.borctip in ('P', 'A')
       and t.intiktar <= trunc(sysdate)
       and t.tantar <= trunc(sysdate)
       and t.processtar is null
       and p.polid = t.polid
       and p.urunkod <> 'AKTR'
       and p.branskod = 'H'
       and u.kod = p.urunkod
       and u.uruntip = 'BRK'
       and (p.status || p.substatus) in ('MM', 'IT')
     group by t.polid
     order by t.polid;

select h.*
      from  brkhareket h, sonpol p, tarife tr, urun u
      where h.polid = nvl(null, h.polid)
        and h.islemtar <= trunc(sysdate)
        and h.fonseq is null
        and h.fontar <= trunc(sysdate)
        and p.polid = h.polid
        and p.urunkod = nvl(null, p.urunkod)
        and p.branskod = 'H'
        and p.tarifeno = nvl(null, p.tarifeno)
        and p.dovkod = nvl(null, p.dovkod)
        and u.kod = p.urunkod
        and u.uruntip = 'BRK'
        and tr.branskod = p.branskod
        and tr.tarifeno = p.tarifeno
        and tr.gf = nvl(null, tr.gf)
      order by h.fontar, h.polid;
      
select h.polid as polid
          ,count(*) as sayac
      from brkhareket h
          ,sonpol     p
          ,urun       u
     where h.islemtar <= trunc(sysdate)
       and h.fonseq is null
       and h.fontar <= trunc(sysdate)
       and p.polid = h.polid
       and p.branskod = 'H'
       and u.kod = p.urunkod
       and u.uruntip = 'BRK'
     group by h.polid
     order by h.polid;      
     
select distinct h.polid
      from  brkhareket h, sonpol p, tarife tr, urun u
      where h.polid = nvl(null, h.polid)
        and h.islemtar <= trunc(sysdate)
        and h.fonseq is null
        and h.fontar <= trunc(sysdate)
        and p.polid = h.polid
        and p.urunkod = nvl(null, p.urunkod)
        and p.branskod = 'H'
        and p.tarifeno = nvl(null, p.tarifeno)
        and p.dovkod = nvl(null, p.dovkod)
        and u.kod = p.urunkod
        and u.uruntip = 'BRK'
        and tr.branskod = p.branskod
        and tr.tarifeno = p.tarifeno
        and tr.gf = nvl(null, tr.gf)
      order by h.polid;     
     
select * from brkhareket where polid = 1982086
        and fonseq is null
    order by harseq desc;     
    
select fd.fonkod, fon.sirano,s.URUNKOD,b.kumeseq
        from brkhareket b, sonpol s, fonmetod f, fonmetoddet fd, fon fon
       where b.kumeseq = 2131080
         and s.polid = b.polid
         and s.tarifeno = f.tarifeno
         and s.dovkod = f.dovkod
         -- and nvl(f.kapatar, to_date('01012100', 'ddmmyyyy')) > trunc(sysdate)
         and f.metodid = (Select max(metodid) from fonmetod f1
                           where f1.branskod = f.branskod
                             and f1.tarifeno = f.tarifeno
                             and f1.dovkod = f.dovkod
                             and nvl(f1.kapatar, to_date('01012100', 'ddmmyyyy')) > trunc(sysdate)
                             )
         and fd.metodid = f.metodid
         and fon.fonkod = fd.fonkod
       group by fd.fonkod, fon.sirano,s.URUNKOD,b.kumeseq
       order by fon.sirano;
       
-- Create Index BESPROD.T_FONMETOD for mailing improvements
CREATE INDEX BESPROD.I_FONMETOD_DOVKOD ON BESPROD.T_FONMETOD
(BRANSKOD, TARIFENO, DOVKOD)
COMPRESS;
/

-- DROP INDEX BESPROD.I_FONMETOD_DOVKOD;

ALTER SYSTEM FLUSH SHARED_POOL;

select sysdate from dual;  
  
select GetSysprmVal('HAYAT_FONLAMA_MODE') from dual;

select GetSysprmVal('SENDMAIL_FONSONUC_FROM') from dual;

select GetSysprmVal('SENDMAIL_HAYATFON_TO') from dual;

select GetSysprmVal('SENDMAIL_HAYATFON_SUBJECT') from dual;

select GetSysprmVal('SENDMAIL_HAYATFON_BODY') from dual;  

select sysdate from dual;

select passlib.getdecode(t.psw), t.* from users t where t.username = 'BESPROD';

select passlib.getdecode(t.psw), t.* from users t where t.username = 'AKA';

Begin
 update t_users t set psw = 1, enable = 'T'  where t.username = 'AKA';
 commit;
End;
/

select * from fondeger where tarih = trunc(sysdate)-3
    and fonkod in ('D01', 'T01')
union all
select * from besprod.t_fondeger where tarih = trunc(sysdate)
    and fonkod in ('D01', 'T01');

begin
 besprod.AddFondeger(trunc(sysdate)-1);
 commit;
end;
/

istrue

hytfonmail.updtbrkharkumesonuc

tahspkgbr

select * from police where poltantar >= trunc(sysdate) order by akarowid desc;


ALTER SESSION SET CURRENT_SCHEMA = BESPROD;
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
/
Declare
  v_rtn     number;
  v_sqlerrm varchar2(4000);
  v_hayatfonlamode number := nvl(to_number(GetSysprmVal('HAYAT_FONLAMA_MODE')),0); -- <AEGL-12236>
Begin
  if v_hayatfonlamode = 0 then
    besprod.hayatfonla;
  elsif v_hayatfonlamode = 1 then
    besprod.prc_HayatFonlaByPolidJob; -- <AEGL-12236>
  end if;
  writeakajobserrlog(51, 'BASARILI');
Exception
  When others then
    v_sqlerrm := substr(sqlerrm, 1, 3999);
    writeakajobserrlog(51, v_sqlerrm);
End;
/

SELECT * FROM DBA_JOBS WHERE JOB = 3051;

SELECT * FROM AKAJOBS WHERE AKA_JOBID = 51

SELECT * FROM AKAJOBSERRLOG WHERE AKA_JOBID = 51 AND TARIH >= TRUNC(SYSDATE) ORDER BY TARIH;

SELECT * FROM DBA_JOBS_RUNNING;

Begin
    besprod.prc_HayatFonlaByPolidJob;
End;

select  URUNKOD as Urun_Kodu
                      ,TARIFENO as Tarife_No
                      ,POLID as Kayit_No
                      ,HATA as Hata_Mesaji
                      from BESPROD.T_OTOFONLAMAJOBDETAIL where hata is not null and mseq = 1;
/
select * from akajobs where lower(jobsql) like '%odul%';
/

declare
  v_tarih date;
begin
  writeakajobserrlog(177, 'Ýlk Beþ Yýl Ödül Tutarý Fonlama Jobý baþladý.');
  v_tarih := trunc(sysdate);
  PRC_ILKBESYILODULFONLANMAJOB(v_tarih);
  writeakajobserrlog(177, 'Ýlk Beþ Yýl Ödül Tutarý Fonlama Jobý bitti');
  commit;
exception
  when others then
    writeakajobserrlog(177, substr('Ýlk Beþ Yýl Ödül Tutarý Fonlama Jobý hata oluþtu - Job Tarihi: ' || v_tarih || ' - ' || sqlerrm, 1, 1000));
    rollback;
end;
/

select * from ilkbesyiloduljob_log order by seq desc;

select Sigutil.sysparam('ILKBESYILODULFONLANMA_TO') from dual;

select * from users where username = 'AKA';

select passlib.getdecode(psw) from users where username = 'AKA';

BESPROD.SSPLIB

select * from all_objects
    where 1=1
     and owner = 'BESPROD'
     and status <> 'VALID'
    order by last_ddl_time desc;
/

select * from all_objects
    where 1=1
     and owner = 'BESPROD'
     and status = 'VALID'
    order by last_ddl_time desc;
/

BEGIN
  DBMS_UTILITY.COMPILE_SCHEMA(schema => 'BESPROD', compile_all => FALSE, reuse_settings => TRUE);
END;
/

select * from all_source where owner = 'BESPROD' and lower(text) like '%execute immediate%'  and lower(text) like '%into%';

/****************************/

-- 2824958

ORA-20202: BirikimTransfer > CalcThsBP > Polid: 2824958, Vadezeylno:1, ,Vadetar: 06/03/2024,Birikim Prim Hesaplamasý Yapýlýrken Bölen Sýfýra Eþit Hatasý Oluþtu ORA-01476: bölen sýfýra eþittir satýr: ORA-06512: konum "BESPROD.HFONLIB",  satýr 204
 - ERRORLOG: 7257686
 
 SELECT vadetar
        as v_ilkvadetar
        FROM odeplan_v o
       WHERE     o.polid = 2824958
             AND o.ilkprim = 'X'
             AND o.borctip = 'P';

select * from sonpol where polid = 2824958;

select * from odeplan_v where polid = 2824958;

select * from tahsilat where polid = 2824958 order by tahsno desc;

select * from brkhareket_v where polid = 2824958;

select * from brkharfon where polid = 2824958;

select * from sigtmnt where polid = 2824958 order by zeylno, tmntkod;

select * from zeyl2 where polid = 2824958;

select * from odeplan where polid = 2824958 order by vadetar desc;

select * from tahsmaster where seq in ( select distinct seq from tahsilat where polid = 2824958) order by seq;

select * from tahshesap where hesapno = '45958';

select y.id, y.* from ytmtransactionlog y where polid = 2824958 order by seq; -- 481463

select * from ytmtahsilat where id in (select y.id from ytmtransactionlog y where polid = 2824958) order by seq;

select * from ytmodeplan where polid = 2642779;

select * from odeplanlog where polid = 2642779 and vadetar = '22/03/2024' order by zeylno;

/***************************/

/***************************/

select * from besprod.t_fondeger where tarih >= '01/07/2024' and fonkod in ('T01', 'D01') order by tarih;

select * from besprod.t_fondeger where tarih = '22/01/2024' and fonkod in ('T01', 'D01');

select * from besprod.t_fondeger where tarih = '23/01/2024' and fonkod in ('T01', 'D01');

select * from besprod.t_fondeger where tarih = '29/07/2024' and fonkod in ('T01', 'D01');

select DOVKOD, TARIH, BIRIM, DOVAL, DOVSAT,  EFKAL, EFKSAT from BESPROD.T_DOVKUR where tarih >= '16/10/2024' order by tarih;

/****************************/

mailorderprocess

tefasutil

ytmtransutil

select * from akajobs order by aka_jobid desc;

select * from tahsmaster where crttar >= trunc(sysdate) order by seq desc;

/****************************/

-- POLID LISTESI

-- 2841086
-- 2420612
-- 2278945
-- 2393160
-- 2479059

SSPLIB

/****************************/

ORA-20202: BirikimTransfer > CalcThsBP > Polid: 2841086, Vadezeylno:1, ,Vadetar: 26/04/2024,Birikim Prim Hesaplamasý Yapýlýrken Bölen Sýfýra Eþit Hatasý Oluþtu ORA-01476: bölen sýfýra eþittir satýr: ORA-06512: konum "BESPROD.HFONLIB",  satýr 204
 - ERRORLOG: 14200248
ORA-20202: BirikimTransfer > CalcThsBP > Polid: 2420612, Vadezeylno:66, ,Vadetar: 16/01/2024,Birikim Prim Hesaplamasý Yapýlýrken Bölen Sýfýra Eþit Hatasý Oluþtu ORA-01476: bölen sýfýra eþittir satýr: ORA-06512: konum "BESPROD.HFONLIB",  satýr 204
 - ERRORLOG: 14200247
 
ORA-20202: BirikimTransfer > Zeylden düzeltmeden önce ana tahsilatýn fonlanmasý gerkeiyor Tahsilatno :42475649 - ERRORLOG: 14445378
ORA-20202: BirikimTransfer > CalcThsBP > Polid: 2393160, Vadezeylno:5, ,Vadetar: 22/02/2024,Birikim Prim Hesaplamasý Yapýlýrken Bölen Sýfýra Eþit Hatasý Oluþtu ORA-01476: bölen sýfýra eþittir satýr: ORA-06512: konum "BESPROD.HFONLIB",  satýr 204
 - ERRORLOG: 14445115
ORA-20202: BirikimTransfer > CalcThsBP > Polid: 2278945, Vadezeylno:10, ,Vadetar: 26/03/2024,Birikim Prim Hesaplamasý Yapýlýrken Bölen Sýfýra Eþit Hatasý Oluþtu ORA-01476: bölen sýfýra eþittir satýr: ORA-06512: konum "BESPROD.HFONLIB",  satýr 204
 - ERRORLOG: 14445112 
 
 
select * from besprod.t_brkharkume where tarih >= trunc(sysdate) and kaynak = 'SRV'
    order by kumeseq desc; 

select * from besprod.t_otofonlamajobmaster
        order by seq desc;

select * from besprod.t_otofonlamajobdetail
            where mseq = 130 
            and hata is not null
        order by seq desc;

SELECT (SELECT MAX (zeylno)
                    FROM odeplan
                   WHERE     polid = t.polid
                         AND vadetar = t.vadetar
                         AND borctip = t.borctip)  odeplan_vadezeylno,
                 (SELECT PROCESSTAR
                    FROM tahsilat
                   WHERE     polid = t.polid
                         AND tahsno = t.ilgilitahsno
                         AND borctip = t.borctip)  ilgilitahsno_processtar,        
                 t.*
            FROM tahsilat t
           WHERE     polid = 2841086
                 AND vadezeylno IS NOT NULL
                 AND processtar IS NULL
                 AND borctip = 'P'
                 -- AND ACIKLAMA = 'ZEYLDEN DUZELTME ISLEMI'
                 -- AND ILGILITAHSNO IS NOT NULL
        ORDER BY tahsno DESC

select * from tahsilat where polid = 2841086 order by tahsno desc;

select * from tahsilat_log where polid = 2841086 and tahsno = 42324610 order by logtar desc;

select * from tahsilat_log where polid = 2841086 and seq = 6126041 order by logtar desc;

select * from brkhareket_v where polid = 2841086;

select * from odeplan_v where polid = 2841086;

select * from odeplan where polid = 2479059 and vadetar < '17/05/2031' and odepid = 1489618;

select * from odeplan_v where polid = 2479059 and vadetar < '17/05/2031' and odepid = 1489618 
  -- and tahsilat is not null
  ;

select * from odeplan where polid = 2479059 and vadetar >= '17/05/2031' and odepid != 1489618; 

select * from odeplan where polid = 2479059 and vadetar >= '17/05/2031' and odepid != 1489618;

select * from tahsilat where polid = 2479059 and vadetar < '17/05/2031' and odepid = 1489618;

select * from tahsilat where polid = 2479059 and vadetar = '17/06/2024';

select * from tahsilat where polid = 2479059 and tahsno = 42475649;

select * from tahsilat where polid = 2479059 and tahsno = 34008011;

select * from zeyl2 where polid = 2479059 order by zeylno desc;

select * from polodeyen where polid = 2479059 order by zeylno desc;

/* Formatted on 09/05/2024 14:56:14 (QP5 v5.391) */
BEGIN
  UPDATE tahsilat
     SET vadetar = '17/05/2031'
   WHERE polid = 2479059 AND vadetar < '17/05/2031' AND odepid = 1489618;

  UPDATE odeplan
     SET dovtutar = 0
   WHERE polid = 2479059 AND vadetar >= '17/05/2031' AND odepid != 1489618;

  DELETE FROM odeplan
        WHERE polid = 2479059 AND vadetar < '17/05/2031' AND odepid = 1489618;
END;
/


--1489618
--1489619

select * from brkhareket_v where polid = 2420612;

select (select max(zeylno) from odeplan where polid = t.polid and vadetar = t.vadetar and borctip = t.borctip) odeplan_vadezeylno, t.* from tahsilat t where polid = 2420612 and vadezeylno is not null and processtar is null and borctip = 'P' order by tahsno desc; 

select t.VADEZEYLNO, o.ZEYLNO, t.*,  o.* from tahsilat t, odeplan o where t.polid = 2420612 and t.vadezeylno = 66 
    and t.polid = o.polid
    and o.vadetar = t.vadetar
  order by o.zeylno desc;
  
SELECT vadetar
        as v_ilkvadetar
        FROM odeplan_v o
       WHERE     o.polid = 2841086
             AND o.ilkprim = 'X'
             AND o.borctip = 'P';

select * from sonpol where polid = 2841086;

select * from odeplan_v where polid = 2841086;

select * from zeyl2 where polid = 2841086 order by zeylno desc;

select * from tahsilat where polid = 2841086 order by tahsno desc;

select * from tahsmaster where seq = 6126041;

select * from tahsilat where seq = 6126041;

select * from tahsilat_log where tahsno = 42324610 order by logtar desc;

select t.VADEZEYLNO, o.ZEYLNO, t.*,  o.* from tahsilat t, odeplan o where t.polid = 2841086 and t.vadezeylno = 1 
    and t.polid = o.polid
    and o.vadetar = t.vadetar
  order by o.zeylno desc;  
  
select * from ytmtransactionlog where polid = 2479059 order by seq desc;  

select * from ytmodeplan where polid = 2479059 order by seq desc;

select * from ytmzeyl where polid = 2479059 order by seq desc;

select * from ytmtahsilat where polid = 2479059 order by seq desc;

select * from brkhareket_v where polid = 2841086;

select * from brkharfon where polid = 2420612;

select * from sigtmnt where polid = 2420612 order by zeylno, tmntkod;

select * from zeyl2 where polid = 2420612 order by zeylno desc;

select * from odeplan where polid = 2824958 order by vadetar desc;

select * from tahsmaster where seq in ( select distinct seq from tahsilat where polid = 2824958) order by seq;

select * from tahshesap where hesapno = '45958';

select y.id, y.* from ytmtransactionlog y where polid = 2824958 order by seq; -- 481463

select * from ytmtahsilat where id in (select y.id from ytmtransactionlog y where polid = 2824958) order by seq;

select * from ytmodeplan where polid = 2642779;

select * from odeplanlog where polid = 2642779 and vadetar = '22/03/2024' order by zeylno;

-- 2842226 -> ORA-20202: BirikimTransfer > CalcThsBP > Polid: 2842226, Vadezeylno:1, ,Vadetar: 07/05/2024,Birikim Prim Hesaplamasý Yapýlýrken Bölen Sýfýra Eþit Hatasý Oluþtu ORA-01476: bölen sýfýra eþittir satýr: ORA-06512: konum "BESPROD.HFONLIB",  satýr 204 - ERRORLOG: 17330539 
-- 2842221 -> ORA-20202: BirikimTransfer > CalcThsBP > Polid: 2842221, Vadezeylno:1, ,Vadetar: 07/05/2024,Birikim Prim Hesaplamasý Yapýlýrken Bölen Sýfýra Eþit Hatasý Oluþtu ORA-01476: bölen sýfýra eþittir satýr: ORA-06512: konum "BESPROD.HFONLIB",  satýr 204 - ERRORLOG: 17330538
-- 2318680 -> ORA-20202: BirikimTransfer > CalcThsBP > Polid: 2318680, Vadezeylno:14, ,Vadetar: 30/04/2024,Birikim Prim Hesaplamasý Yapýlýrken Bölen Sýfýra Eþit Hatasý Oluþtu ORA-01476: bölen sýfýra eþittir satýr: ORA-06512: konum "BESPROD.HFONLIB", satýr 204  - ERRORLOG: 17330537

select t.polid as polid
          ,count(*) as sayac
      from tahsilat t
          ,police   p
          ,urun     u
     where t.borctip in ('P', 'A')
       and t.intiktar <= trunc(sysdate)
       and t.tantar <= trunc(sysdate)
       and t.processtar is null
       and p.polid = t.polid
       and p.urunkod <> 'AKTR'
       and p.branskod = 'H'
       and u.kod = p.urunkod
       and u.uruntip = 'BRK'
       and (p.status || p.substatus) in ('MM', 'IT')
     group by t.polid
     order by t.polid;

select h.*
      from  brkhareket h, sonpol p, tarife tr, urun u
      where h.polid = nvl(null, h.polid)
        and h.islemtar <= trunc(sysdate)
        and h.fonseq is null
        and h.fontar <= trunc(sysdate)
        and p.polid = h.polid
        and p.urunkod = nvl(null, p.urunkod)
        and p.branskod = 'H'
        and p.tarifeno = nvl(null, p.tarifeno)
        and p.dovkod = nvl(null, p.dovkod)
        and u.kod = p.urunkod
        and u.uruntip = 'BRK'
        and tr.branskod = p.branskod
        and tr.tarifeno = p.tarifeno
        and tr.gf = nvl(null, tr.gf)
        AND P.polid in (2842226, 2842221, 2318680)
      order by h.fontar, h.polid;
      
select h.polid as polid
          ,count(*) as sayac
      from brkhareket h
          ,sonpol     p
          ,urun       u
     where h.islemtar <= trunc(sysdate)
       and h.fonseq is null
       and h.fontar <= trunc(sysdate)
       and p.polid = h.polid
       and p.branskod = 'H'
       and u.kod = p.urunkod
       and u.uruntip = 'BRK'
       AND P.polid in (2842226, 2842221, 2318680)
     group by h.polid
     order by h.polid;      
     
select distinct h.polid
      from  brkhareket h, sonpol p, tarife tr, urun u
      where h.polid = nvl(null, h.polid)
        and h.islemtar <= trunc(sysdate)
        and h.fonseq is null
        and h.fontar <= trunc(sysdate)
        and p.polid = h.polid
        and p.urunkod = nvl(null, p.urunkod)
        and p.branskod = 'H'
        and p.tarifeno = nvl(null, p.tarifeno)
        and p.dovkod = nvl(null, p.dovkod)
        and u.kod = p.urunkod
        and u.uruntip = 'BRK'
        and tr.branskod = p.branskod
        and tr.tarifeno = p.tarifeno
        and tr.gf = nvl(null, tr.gf)
        AND P.polid in (2842226, 2842221, 2318680)
      order by h.polid;     
      
select (SELECT to_char(MIN (vadetar),'DD')
                    FROM odeplan
                   WHERE     polid = t.polid
                         AND borctip = t.borctip)  odeplan_vadegun, 
                   (SELECT min(odepid)
                    FROM odeplan
                   WHERE     polid = t.polid
                         AND borctip = t.borctip) odeplan_odepid,      
                   (SELECT MAX (zeylno)
                    FROM odeplan
                   WHERE     polid = t.polid
                         AND borctip = t.borctip)  odeplan_vadezeylno, t.*
      from tahsilat t
          ,police   p
          ,urun     u
     where t.borctip in ('P', 'A')
       and t.intiktar <= trunc(sysdate)
       and t.tantar <= trunc(sysdate)
       and t.processtar is null
       and p.polid = t.polid
       and p.urunkod <> 'AKTR'
       and p.branskod = 'H'
       and u.kod = p.urunkod
       and u.uruntip = 'BRK'
       and (p.status || p.substatus) in ('MM', 'IT')
       AND P.polid in (/* 2842226  ,2842221 , */ 2318680 )
     order by t.vadetar;
          
select * from zeyl2 o where o.polid in (2318680);

select * from tahsilat t where t.polid in (2318680);
     
select * from odeplan_v o where o.polid in (2318680);
/

ALTER SESSION SET CURRENT_SCHEMA = BESPROD;
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
/

DECLARE
  proc   CONSTANT VARCHAR2 (50) := '007_create_job_AEGL_13584.sql';
  v_sql           VARCHAR2 (32000) := q'[DECLARE
    proc   CONSTANT VARCHAR2 (100)
                        := '007_create_job_AEGL_13584.sql' ;
BEGIN
    --
    BESPROD.prc_processytmduedatedatav13584_1;
    --
    COMMIT;
EXCEPTION
    WHEN OTHERS
    THEN
        stdio.perror (proc, SUBSTR (SQLERRM, 1, 3999));
END;]';
BEGIN
  DBMS_SCHEDULER.create_job (job_name          => 'BESPROD.AEGL_13584_1_JOB',
                             job_type          => 'PLSQL_BLOCK',
                             job_action        => v_sql,
                             start_date        => SYSTIMESTAMP,
                             end_date          => NULL,
                             repeat_interval   => NULL,
                             enabled           => TRUE,
                             auto_drop         => TRUE,
                             comments          => 'BESPROD.AEGL_13584_1_JOB');
EXCEPTION
  WHEN OTHERS
  THEN
    stdio.perror (proc, SQLERRM);
END;
/

select * from provlog where listtar >= trunc(sysdate)-4;
/

/* Formatted on 04/07/2024 2:29:23 PM (QP5 v5.388) */
SELECT *
  FROM tahsilat ths
 WHERE ths.tahsno IN
           (SELECT thsin.tahsno
             FROM BESPROD.T_TAHSILAT thsin
            WHERE     thsin.BORCTIP IN ('P')
                  AND thsin.DOVTUTARTOLERANS < 0
                  AND thsin.ACIKLAMA LIKE '%VCOLLECT%');
                  
                  
select * from zeyltips where zeyltip = '92';                  

/*******************************/

SELECT *
  FROM POLICE
 WHERE POLID = 2230657;

  SELECT *
    FROM TAHSILAT
   WHERE POLID = 2230657
ORDER BY TAHSNO DESC;

SELECT *
  FROM tahsilat
 WHERE     polid = 2230657
       AND borctip = 'F'
       AND aciklama LIKE '%Ara Verme Zeyili  2230657%';

SELECT *
  FROM tahsmaster
 WHERE seq IN
         (
6097477,
6097479,
6097480,
6097481,
6097482,
6097483);

  SELECT *
    FROM ZEYL2
   WHERE POLID = 2230657
ORDER BY ZEYLNO DESC;

SELECT *
  FROM ODEPLAN_V
 WHERE POLID = 2230657;

  SELECT *
    FROM ODEPLAN
   WHERE POLID = 2230657 AND VADETAR > '29/02/2024'
ORDER BY SEQ;

select PASSLIB.GETDECODE(psw) from besprod.t_users where username = 'AKA';

select * from besprod.t_users where username = 'AKA';

update besprod.t_users set psw = 1, enable = 'T' where username = 'AKA';

select * from ytmtransactionlog where polid = 2230657 order by seq;

select * from ytmzeyl where id = 1040106;

 SELECT t.*
            FROM tahsmaster t
           WHERE     t.fisno IS NULL
                 AND t.sec = 'Y'
                 AND INSTR('<K><T><H><O>', tahstip) > 0
                 AND t.torbahesapno = '8888'
                 AND t.tutar <> t.fark
                 and t.fistar between to_date('01/07/2024','dd/mm/yyyy') and to_date('31/07/2024','dd/mm/yyyy') 
        ORDER BY fistar;

/**********************************/

SSPLIB

select * from jsonwstanim;

select * from mernisara where tcno = '27938029538';

select * from akajobserrlog where tarih >= trunc(sysdate)-30 order by tarih desc;

declare
  -- Non-scalar parameters require additional processing 
  v_result SsplibResponseOutputTyp:= SsplibResponseOutputTyp();
  v_musteriBilgi TYP_SSPLIBREQUEST_UPDATEMERNIS:= TYP_SSPLIBREQUEST_UPDATEMERNIS();
begin
  -- Call the function
 v_musteriBilgi.tckn := '27938029538';
 v_musteriBilgi.dogumtar := '28/01/1986' ;
 v_result := ssplib.UpdateMernis(p_musteriBilgi => v_musteriBilgi);
end;
/

select * from ssplog where tarih >= trunc(sysdate) order by seq desc;

select * from wslog where crtdate >= trunc(sysdate)-1 order by seq desc;

/**********************************/

Declare 
 reckimlik   kimlikdogrula.reckimliktype;
 v_entegseq  number;
Begin
 reckimlik.TCKimlikNo := '27938029538';
 reckimlik.Dogumtar := to_date('28/01/1986', 'DD/MM/YYYY');
 kimlikdogrula.TCKimlikNo(reckimlik => reckimlik, p_entegseq => v_entegseq); 
End;
/ 

declare 
v_kimlik  KIMLIKDOGRULA_NEW.recKimlikType_new;
begin  
  
  v_kimlik.KimlikNo := '27938029538';
  v_kimlik.Dogumtar := to_date('28/01/1986', 'DD/MM/YYYY');
  
  KIMLIKDOGRULA_NEW.sorgula(v_kimlik);
  dbms_output.put_line(v_kimlik.HataKod);
  dbms_output.put_line(v_kimlik.HataMsg);
end;
/

select * from  DBA_NETWORK_ACLS where host like '%apigateway.aegon.com.tr%';

select * from  DBA_NETWORK_ACLS where host like '%apigw-test.viennalife.com.tr%';

select * from  DBA_NETWORK_ACLS where host like '%apigw.viennalife.com.tr%';

DBA_NETWORK_ACL_PRIVILEGES 
/sys/acls/besprod_aeglocal.xml

select * from DBA_NETWORK_ACL_PRIVILEGES where acl = '/sys/acls/besprod_aeglocal.xml';

DECLARE
  v_file UTL_FILE.FILE_TYPE;
BEGIN
  v_file := UTL_FILE.FOPEN('/var/opt/oracle/dbaas_acfs/VLENT/', 'wallet', 'R');
  UTL_FILE.FCLOSE(v_file);
  DBMS_OUTPUT.PUT_LINE('File opened successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- exec utl_http.set_wallet('file:/var/opt/oracle/dbaas_acfs/VLENT/db_wallet/', 'FBxSK+VQ9_xe8ts');

exec utl_http.set_wallet('file:/var/opt/oracle/dbaas_acfs/VLENT/wallet/', 'FBxSK+VQ9_xe8ts');

select utl_http.request('https://service-test.viennalife.com.tr/common/agito-devaulator/devaluator/') from dual;

select utl_http.request('https://apigw-test.viennalife.com.tr/common/kps-service/birlesik-sorgulama/') from dual;

Begin
  update BESPROD.T_JSONWSTANIM jwst
   set wsurl =
       (select replace(jwstin.wsurl, 'apigw.viennalife.com.tr', 'apigw-test.viennalife.com.tr')
          from BESPROD.T_JSONWSTANIM jwstin
         where jwstin.wsname = jwst.wsname)
       ,jwst.wallet ='file:/var/opt/oracle/dbaas_acfs/VLENT/wallet'
       ,jwst.password = 'FBxSK+VQ9_xe8ts'   
  where instr(jwst.wsurl, 'https://apigw.viennalife.com.tr') > 0;
  update BESPROD.T_JSONWSTANIM set username = 'FGpnpQMeICfYOIJR53kN41rBXwd8eGQD', password = 'b4nVwLmAaAUz9mDe' where username is not null;  
  update BESPROD.T_JSONWSTANIM set wallet = 'file:/var/opt/oracle/dbaas_acfs/VLENT/wallet', walletpass = 'FBxSK+VQ9_xe8ts' where wallet is not null ;
End;
/

/***************************************/

select /*+ parallel auto */ * from besprod.workbookservice_log where crttar >= trunc(sysdate) order by seq desc;
/

DECLARE
  TYPE id_array IS TABLE OF besprod.workbookservice_log.seq%TYPE;
  l_ids id_array;
BEGIN
  SELECT seq
  BULK COLLECT INTO l_ids
  FROM besprod.workbookservice_log
  WHERE crttar >= TRUNC(SYSDATE);
  
  FORALL i IN 1..l_ids.COUNT
    DELETE FROM besprod.workbookservice_log
    WHERE seq = l_ids(i);
  
  COMMIT;
END;
/

declare 
	v_return WorkbookDef.string_list;
    v_cnt PLS_INTEGER;
    v_filename varchar2(200);
Begin
    v_return := workbooklib.getWorkbooks();
    v_cnt   := v_return.FIRST;
    WHILE v_cnt IS NOT NULL
    LOOP
     v_filename := v_return (v_cnt);
     if v_filename in ( 'ROP_MK_2024_SURPRIMSIZ.xlsx') then
       workbooklib.getworkbook(v_filename);
     end if;  
	 commit;
     v_cnt := v_return.NEXT (v_cnt);
    END LOOP;
	commit;
End;
/

select * from workbook_tmp where name = 'YB2022.xlsx';

select * from workbook_tmp where name = 'YB2022_ZEYL.xlsx';

BEGIN
  ins_tasimatakip ('AEGL-12236',
                   '002-install_dml_AEGL_12236.sql',
                   1,
                   '002-install_dml_AEGL_12236.sql');
END;
/

--2609289

select * from hihbpol where polid = 2609289;

select * from zeyl2 where polid = 2609289;

select * from hihbar where dosyano = 138802 and sonerneden = 'F';

select * from brkhareket_v where polid = 2609289 order by harseq desc;

Begin
  update hihbpol set polstatus = 98 where polid = 2609289;
  update hihbar set ihbstatus = 98 where dosyano = 138802 and sonerneden = 'F';
End;
/

-- 2666465

select * from hihbpol where polid = 2666465;

select * from zeyl2 where polid = 2666465 order by zeylno desc;


--

select yt.* from ytmtransactionlog yt, ytmzeyl yz where yt.id = yz.id and nvl(yt.iptal,'F')='F' and nvl(yt.isaktarildi,'F')='F' and yz.zeyltip = '100' order by yt.hata;

BEGIN    
 For r In ( select distinct yt.polid from ytmtransactionlog yt, ytmzeyl yz where yt.id = yz.id and nvl(yt.iptal,'F')='F' and nvl(yt.isaktarildi,'F')='F' and yz.zeyltip = '100' )
 Loop
    DBMS_OUTPUT.disable;
    --
    YtmTransLib.sendYtmTransaction (p_tarih   => NULL,
                                    p_seq     => NULL,
                                    p_id      => NULL,
                                    p_polid   => r.polid);
  End Loop;
  --
  COMMIT;
 EXCEPTION
  WHEN OTHERS
  THEN
    ROLLBACK;
    Stdio.Perror ('Hata', SQLERRM);
END;
/

select yt.* from ytmtransactionlog yt, ytmzeyl yz where yt.id = yz.id and nvl(yt.iptal,'F')='F' and nvl(yt.isaktarildi,'F')='T'
 and logtar >= trunc(sysdate) order by yt.seq;
 
select yt.* from ytmtransactionlog yt, ytmtahsilat ytt where yt.id = ytt.id and nvl(yt.iptal,'F')='F' and nvl(yt.isaktarildi,'F')='T'
 and logtar >= trunc(sysdate) order by yt.seq; 

select yt.* from ytmtransactionlog yt, ytmodeplan yo where yt.id = yo.id and nvl(yt.iptal,'F')='F' and nvl(yt.isaktarildi,'F')='T'
 and logtar >= trunc(sysdate) order by yt.seq; 
 
 select * from sonpol where polid = 2815806;
 
 select * from zeyl2 where polid = 2815806;
 
 select * from odeplan_v where polid = 2815806;
 
 select * from tahsilat where polid = 2815806 order by tahsno desc;
 
 select * from tahakkuk where polid = 2815806 order by seq desc;
 
 select * from t_ytmtransactionlog_log order by seq desc;
 
select * from zeyl2 where polid = 2371508 ; 

select * from odeplan_v where polid = 2371508 ;

select * from tahsilat where polid = 2371508  order by tahsno desc;

select * from ytmzeyl where polid = 2371508 order by seq desc ;

select * from ytmtahsilat where polid = 2371508 order by seq desc ;

select * from ytmiptal where polid = 2371508 ;

select * from ihtbatchlog where polid = 2371508 order by batchseq desc;

ZeylLib

select * from sonpol where polid = 2087810 ;

select * from urun where kod = 'UYV';

ins_tasimatakip

select h.polid, h.dosyano, h.sonerneden, p.branskod, h.polstatus, hb.dilgelistar, hb.onaytar
        from hihbpol   h
            ,police    p
            ,sigortali s
            ,hihbar    hb
       where h.polid = p.polid
         and p.sonzeylno = s.zeylno
         and p.polid = s.polid
         and h.dosyano = hb.dosyano
         and h.sonerneden = hb.sonerneden
         and s.pid = hb.pid
         and p.branskod in ('H', 'K')
         and h.sonerneden not in ('IK', 'MI')
         and ((h.polstatus = 31 and h.sonerneden in ('KH', 'TM') and hb.dilgelistar = trunc(sysdate)-3) or
             (h.polstatus = 40 and h.sonerneden not in ('KH', 'TM')) and hb.onaytar = trunc(sysdate)-3)
         -- and h.bimrefno is null
         ;
         
         
select * from bimrefnolog where kumeseq = 417 order by seq desc; 

select * from t_jsonwstanim;

ins_tasimatakip

select * from hsonerdeger where degerkod = '101';

select * from sonpol where polid = 1957510;

select * from sonpol where tarifeno = '0032' and status = 'M' and substatus = 'M' order by poltantar desc;

htazlib

select * from hsonerdeger where degerkod = '101';

ikrazPkg.GetAnlikBorc

select * from besprod.police where polid=2884005 ;

select * from besprod.police_log where polid=2884005  order by logtar desc;

select * from besprod.zeyl2 where polid=2884005 ;

select * from besprod.sigortali where polid=2884005 ;

select * from besprod.odeplan_v where polid=2884005 ;

select * from besprod.tahsototanzim where polid=2884005 ;

select * from besprod.tahsilat where polid=2884005 ;

select * from besprod.ytmtahsilat where polid=2884005 ;

select * from besprod.ytmtransactionlog where polid=2884005 ;

select * from besprod.t_odeplanlog where polid=2884005 order by vadetar,crttar;

select * from besprod.police where polid=2884005;

select * from besprod.police_log where polid=2884005 order by logtar desc;

select * from besprod.zeyl2 where polid=2884005;

select * from besprod.odeplan_v where polid=2884005;

select * from besprod.ytmodeplan where polid=2884005;

select * from besprod.ytmtransactionlog where polid=2884005;

select * from besprod.t_odeplan where polid=2884005;

select * from besprod.t_odeplanlog where polid=2884005 order by vadetar,crttar;

-----

select * from besprod.police where polid=2912273  ;

select * from besprod.police_log where polid=2912273 order by logtar desc;

select * from besprod.zeyl2 where polid=2912273  ;

select * from besprod.sigortali where polid=2912273  ;

select * from besprod.odeplan_v where polid=2912273  ;

select * from besprod.tahsototanzim where polid=2912273  ;

select * from besprod.tahsilat where polid=2912273 order by tahsno desc ;

select * from besprod.ytmtahsilat where polid=2912273 ;

select * from besprod.ytmtransactionlog where polid=2912273 ;

-- 2586627

select * from besprod.ytmtransactionlog where polid=2586627 order by seq desc ;

select * from besprod.ytmzeyl where polid=2586627  ;

select * from besprod.police where polid=2586627  ;

select  * from errorlog where seq = 67303460;

select * from besprod.zeyl2 where polid=2586627  ;

select * from besprod.odeplan_v where polid=2586627  ;

----- PL/SQL Call Stack -----
  object      line  object
  handle    number  name
0x7ebc7500       244  package body BESPROD.STDIO.ERROR
0x7ebc7500       269  package body BESPROD.STDIO.PERROR
0x7ec7d498      3923  package body BESPROD.ZEYLLIB.CHECKPRMZEYLYIL
0x7ec7d498      6072  package body BESPROD.ZEYLLIB.DOPRMDEGZEYL
0x7ec7d498      6288  package body BESPROD.ZEYLLIB.DOPRMDEGZEYL
0x7c5bf580       677  package body BESPROD.YTMTRANSUTIL.DO_PRIMDEGZEYL
0x7c5bf580      2164  package body BESPROD.YTMTRANSUTIL.PROCESSYTMZEYL
0x7c5bf580       411  package body BESPROD.YTMTRANSUTIL.PROCESSYTMTRANSACTIONLOG
0x7e8d3c50       103  package body BESPROD.YTMTRANSLIB.SENDYTMTRANSACTION
0x649353a0         2  anonymous block

TahsPkgBr

WORKBOOKLIB

select SigUtil.SysParam('ENVID2') from dual;

ins_tasimatakip

select * from zeyl2 where polid = 2666439;

select * from odeplan_v where polid = 2666439;

select * from tarifetmnt where tarifeno = 'ROLD_1';

select * from besprod.t_tarifeformul where tarifeno = 'ROLD_1';

select * from tarifetmnt where tarifeno = 'ROLFR_3';

select * from besprod.t_tarifeformul where tarifeno = 'ROLFR_3';

select * from kurallar where kural = 'UYV_ROP_TEMINAT_FORMUL_V2';

select * from tarife where nvl(aylikazalan,'F') = 'T';

select * from sonpol where tarifeno in ( select tarifeno from tarife where nvl(aylikazalan,'F') = 'T' ) and poltantar between trunc(sysdate) - 300 and trunc(sysdate) 
 -- and status || substatus = 'MM'
 ; 

select * from sonpol where tarifeno like '%FR%' and poltantar between trunc(sysdate) - 300 and trunc(sysdate) ; 

select trunc(create_date), count(1) from ytmtransactionlog where islemtip = 'O' and trunc(create_date) between '01/10/2024' and '31/10/2024' and nvl(iptal,'F')='F' group by  trunc(create_date) order by 1 desc;

  SELECT /*+ parallel auto */
         polid, COUNT (1)
    FROM odeplan_v ov
   WHERE     1 = 1
         AND ov.borctip = 'P'
         AND ov.vadetar BETWEEN TRUNC (SYSDATE) - 300 AND TRUNC (SYSDATE)
         AND ov.DOVTUTAR <>
             (SELECT SUM (ov1.dovtutar)
                FROM odeplan_v ov1
               WHERE     polid = ov1.polid
                     AND ov1.vadetar = AKALIB.ADDMONTHS (ov.vadetar, -1)
                     AND ov1.BORCTIP = ov.borctip
                     AND ov1.odepid = ov.odepid)
  AND ov.polid = 2869059
GROUP BY polid;
  
 select * from workbooks order by seq desc; 
 
 SELECT *
                  FROM workbookparams
                 WHERE wbseq = 167
              ORDER BY seq;
              
 select * from all_source where lower(text) like '%returning%' and owner = 'BESPROD'; 
 
 
EXEC DBMS_JOB.RUN(12343);
 
 
 Begin
   For r In ( select *from dba_jobs where instr(what, 'ytmTransLib.sendYtmTransactionPart') > 0 )
   Loop
   
   End Loop;
 End;
 /
 
SAPLIB

select max(seq) from sapws_log;

select * from sapws_log where seq = 352;

SELECT * FROM soapwstanim;

SELECT * FROM jsonwstanim;

SELECT * FROM wsparams;

SELECT SigUtil.SysParam('APPTYPE') FROM DUAL;

Begin
  update soapwstanim set walletpassword = 'FBxSK+VQ9_xe8ts', walletpath = '/var/opt/oracle/dbaas_acfs/VLPROD/wallet'
    where wsortam = SigUtil.SysParam('APPTYPE');
    commit;
End;
/
 
 -- /u01/app/oracle/admin/AGNPP/wallet/	
 -- D12jru+-89dhasy
 
 select * from  DBA_NETWORK_ACLS;
 
 BEGIN
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(host       => 'sap-g0q.viennainsurancegroup.com',
                                         lower_port => 443,
                                         upper_port => 443,
                                         ace        => xs$ace_type(privilege_list => xs$name_list('connect'),
                                                                   principal_name => 'BESPROD',
                                                                   principal_type => xs_acl.ptype_db));
END;
/

begin
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
    acl             => '/sys/acls/sapagitowebservice.xml',
    description     => 'Network permissions for sapagitowebservice',
    principal       => 'BESPROD',
    is_grant        => True,
    privilege       => 'connect');
end;
/

begin
  DBMS_NETWORK_ACL_ADMIN.SET_HOST_ACL (
     host         => 'sap-g0q.viennainsurancegroup.com',
     lower_port   => 443,
     upper_port   => 443,
     acl          => '/sys/acls/sapagitowebservice.xml');
end;
/

/* Formatted on 12/02/2024 11:05:59 (QP5 v5.391) */
ALTER SESSION SET CURRENT_SCHEMA = BESPROD;
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
/
DECLARE
  proc CONSTANT VARCHAR2(50) := '001-install_dml_AEGL_14139.sql';
BEGIN
  update soapwstanim
     set walletpassword = 'FBxSK+VQ9_xe8ts'
        ,walletpath     = '/var/opt/oracle/dbaas_acfs/VLPROD/wallet'
   where wsortam in ('PREPROD', 'CANLI');
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    stdio.perror(proc, SQLERRM);
END;
/

BEGIN
  INS_TASIMATAKIP ('AEGL-14139',
                   '001-install_dml_AEGL_14139.sql',
                   1,
                   '001-install_dml_AEGL_14139.sql');
END;
/


select * from besprod.odeplan_vcollect  where polid in (2068825, 1937838, 1970149);

select count(1) from besprod.odeplan_vcollect;

select * from sonpol where polid = 2555517;

select * from zeyl2 where polid = 2555517 order by zeylno desc;

select * from odeplan_v where polid = 2555517;

select * from hihbpol where polid = 2555517;

select * from hihbar where sonerneden = 'I' and dosyano = 149573;

select * from hihbstatus where statkod = '30';

select * from htazdetay2 where polid = 2555517; 

select * from tahsilat where polid = 2555517 and borctip = 'P' and processtar is null and aciklama not like '%Ara Verme%' order by tahsno desc;

select * from mkraporlog where polid = 2555517 order by raporid desc;

BEGIN    
    p('-----------------------------------------------------'); 
    p('DOVKUR : ' || akalib.kurof('USD', 'ES', '13/09/2024') );
    p('-----------------------------------------------------');
    p('ÝÞTÝRA : ' || htazlib.FindHasarDeger (23,
                            2555517,
                            null,
                            null,
                            '13/09/2024',
                            null,
                            'I',
                            null) );
    p('-----------------------------------------------------');                         
    p('-----------------------------------------------------');                        
    p('PRÝM ÝADESÝ : ' || htazlib.FindHasarDeger (26,
                            2555517,
                            null,
                            null,
                            '13/09/2024',
                            null,
                            'I',
                            null) );
    p('-----------------------------------------------------');
    p('-----------------------------------------------------');                        
END;
/


-- 2825873

select * from police where polid = 2825873;

select * from sonpol where polid = 2825873;

select * from zeyl2 where polid = 2825873 order by zeylno desc;

select * from zeyl_log where polid = 2825873 and logtar >= trunc(sysdate) order by logtar desc;

select * from odeplan_v where polid = 2825873 ;

select * from tahsilat where polid = 2825873 order by tahsno desc;

select * from brkhareket_v where polid = 2825873 and fonseq is null order by harseq desc;

select * from tahakkuk where polid = 2825873 order by seq desc;

select * from errorlog where crttar >= trunc(sysdate) order by seq desc;

select max(seq) from errorlog;

SELECT * FROM T_WEBSERVISLOG WHERE BASVURUNO = 7700426244 ORDER BY ID DESC;

select * from sigortali where basvuruno = 7700426244;

select * from sigtmnt where polid = 2946521; 

select * from sonpol where polid = 2946521; 

Select * from police where polid = 2946521;

select * from sonpol where polid = 2946521;

select * from zeyl2 where polid = 2946521 order by zeylno desc;

select * from zeyl_log where polid = 2946521 and logtar >= trunc(sysdate) order by logtar desc;

select * from odeplan_v where polid = 2946521 ;

select * from tahsilat where polid = 2946521 order by tahsno desc;

select * from brkhareket_v where polid = 2946521 and fonseq is null order by harseq desc;

select * from tahakkuk where polid = 2946521 order by seq desc;

Begin
  update BESPROD.T_JSONWSTANIM jwst
   set wsurl =
       (select replace(jwstin.wsurl, 'apigw.viennalife.com.tr', 'apigw-test.viennalife.com.tr')
          from BESPROD.T_JSONWSTANIM jwstin
         where jwstin.wsname = jwst.wsname)
       ,jwst.wallet ='file:/var/opt/oracle/dbaas_acfs/VLENT/wallet'
       ,jwst.password = 'FBxSK+VQ9_xe8ts'   
  where instr(jwst.wsurl, 'https://apigw.viennalife.com.tr') > 0;
  update BESPROD.T_JSONWSTANIM set username = 'FGpnpQMeICfYOIJR53kN41rBXwd8eGQD', password = 'b4nVwLmAaAUz9mDe' where username is not null;  
  update BESPROD.T_JSONWSTANIM set wallet = 'file:/var/opt/oracle/dbaas_acfs/VLENT/wallet', walletpass = 'FBxSK+VQ9_xe8ts' where wallet is not null ;
End;
/

select * from all_source where owner = 'BESPROD' and upper(text) like '%T_IVR_BILGI%';

select * from BESPROD.T_IVR_BILGI;


-- populatebasvuruaraci

DECLARE
  v_webservicelogid   NUMBER := 4518108;
  v_proposalNumber    VARCHAR2 (100) := 7700426244;
  v_xml               CLOB;
  v_in                ws_func_beshyt_v2_tklfolustur_in;
  v_result            ws_func_beshyt_v2_teklifolusturrec;
  v_sonuc             XMLTYPE;
  v_basvuruno         NUMBER;
  v_sqlerrm           VARCHAR2 (4000);
BEGIN
  SELECT script, TO_NUMBER (basvuruno)
    INTO v_xml, v_basvuruno
    FROM webservislog
   WHERE id = v_webservicelogid;

  --
  xmltype (v_xml).toObject (v_in);

  v_in.p_digsig.basvuruno := v_proposalNumber;
  --
  -- Call
  v_result :=
    besprod.ws_functions_beshyt_v2.teklifolustur (
      p_branskod        => v_in.p_branskod,
      p_tklftype        => v_in.p_tklftype,
      p_tmntlist        => v_in.p_tmntlist,
      p_sigortali       => v_in.p_sigortali,
      p_sigpertel       => v_in.p_sigpertel,
      p_sigperemail     => v_in.p_sigperemail,
      p_sigperadres     => v_in.p_sigperadres,
      p_sigperbanka     => v_in.p_sigperbanka,
      p_sigperkkart     => v_in.p_sigperkkart,
      p_sigetayni       => v_in.p_sigetayni,
      p_siget           => v_in.p_siget,
      p_sigetpertel     => v_in.p_sigetpertel,
      p_sigetperemail   => v_in.p_sigetperemail,
      p_sigetperadres   => v_in.p_sigetperadres,
      p_sigetperbanka   => v_in.p_sigetperbanka,
      p_sigetperkkart   => v_in.p_sigetperkkart,
      p_saglikbilgi     => v_in.p_saglikbilgi,
      p_primbilgi       => v_in.p_primbilgi,
      p_digsig          => v_in.p_digsig,
      p_lehdar          => v_in.p_lehdar,
      p_policeek        => v_in.p_policeek,
      p_kpbilgi         => v_in.p_kpbilgi,
      p_gabilgi         => v_in.p_gabilgi,
      p_fonkarmabilgi   => v_in.p_fonkarmabilgi,
      p_iratbilgi       => v_in.p_iratbilgi,
      p_dmtutar         => v_in.p_dmtutar,
      p_primal          => v_in.p_primal);

  --
  SELECT SYS_XMLGEN (v_result, XMLFormat (enclTag => 'v_result'))
    INTO v_sonuc
    FROM DUAL;

  --
  DBMS_OUTPUT.PUT_LINE (v_sonuc.getclobval ());
  DBMS_OUTPUT.PUT_LINE (
       'Creating proposal with webservicelogid: '
    || v_webservicelogid
    || ', proposalNumber: '
    || v_proposalNumber);
  --
  COMMIT;
EXCEPTION
  WHEN OTHERS
  THEN
    v_sqlerrm := SUBSTR (SQLERRM, 1, 3999);
    DBMS_OUTPUT.PUT_LINE (v_sqlerrm);
    ROLLBACK;
END;
/
                

DECLARE
  v_polid NUMBER := 2825873; -- Bind variable
  v_addendum_number NUMBER := 28; -- Bind variable
  proc CONSTANT VARCHAR2(100) := 'PLSQL_EXECUTER_SERVICE.sql';
BEGIN
  FOR r IN (SELECT *
              FROM zeyl
             WHERE polid = v_polid
               AND zeylno = v_addendum_number
             ORDER BY polid
                     ,zeylno DESC) LOOP
    DELETE FROM tekliflog
     WHERE polid = v_polid
       AND zeylno IN (r.zeylno);
    DELETE FROM tekliflog
     WHERE polid = v_polid
       AND bazzeylno IN (r.zeylno);
  
    UPDATE zeyl
       SET tantar  = TRUNC(SYSDATE)
          ,rejitar = TRUNC(SYSDATE)
     WHERE polid = r.polid
       AND zeylno = r.zeylno;
  
    FOR t IN (SELECT polid
                    ,seq
                FROM tahsilat
               WHERE polid = r.polid
                 AND vadezeylno >= r.zeylno) LOOP
      UPDATE tahsilat
         SET vadezeylno =
             (SELECT MAX(vadezeylno)
                FROM tahsilat
               WHERE polid = t.polid
                 AND vadezeylno < r.zeylno)
       WHERE seq = t.seq;
    END LOOP;
  
    gzeyl.zeylsilgf(r.polid, r.zeylno);
    
    -- Example DBMS_OUTPUT statement
    DBMS_OUTPUT.PUT_LINE('Processed zeylno: ' || r.zeylno);
    
    COMMIT;
  END LOOP;

  -- Final message
  DBMS_OUTPUT.PUT_LINE('Executing PL/SQL script for policy ID: ' || v_polid || ' and addendum number: ' || v_addendum_number);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

--
-- getActiveLifePolicyList - Request
--

declare
  v_result ssplibresponseactivepolicytyp;
  v_polist ssplibrequestpollisttyp := ssplibrequestpollisttyp();
begin
  v_polist.pid := 1561202;
  v_result := "SSPLIB".getActiveLifePolicyList(p_polist => v_polist);
end;
/

--
-- getActiveLifePolicyList - Response
--

select /*+ parallel auto */ * from besprod.t_ssplog where proc = 'getActiveLifePolicyList' and xmlrequest like '%1561202%'
  and tarih >= trunc(sysdate)
order by seq desc;
/

DECLARE
  v_policelestir ws_func_beshyt_v2_policelestirtype := ws_func_beshyt_v2_policelestirtype();
  v_policeek ws_func_beshyt_v2_policeekrec := ws_func_beshyt_v2_policeekrec();
  v_islemtip VARCHAR2(255);
  i          NUMBER;
  x          ws_func_beshyt_v2_policelestirrec := ws_func_beshyt_v2_policelestirrec();
  v_polno    NUMBER;
  v_tahsno   NUMBER;
  v_sqlerrm     VARCHAR2 (4000);
  v_polid number := 2946521;
  v_aracitcno VARCHAR2(255) := '29201182780';
BEGIN
  v_policelestir.polid     := v_polid;
  v_policelestir.aracitcno := v_aracitcno;
  v_policeek.ilktahsgun   := '';
  v_policeek.takiptahsgun := '';
  v_policeek.kampanyakodu := '';
  v_policeek.ek1          := '';
  v_policeek.ek2          := '';
  x := WS_FUNCTIONS_BESHYT_V2.policelestir_vc(p_policelestir => v_policelestir, p_policeek => v_policeek);
  --
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    v_sqlerrm := SUBSTR(SQLERRM, 1, 3999);
    p(v_sqlerrm);
    ROLLBACK;
END;
/

SELECT * FROM T_WEBSERVISLOG WHERE polid = 2946521 ORDER BY ID DESC;

select * from webservislogdet where id in (4670377, 
4670376)

/*****************/
/* WSOnUw */
/*****************/

DECLARE
  p_tklftype     ws_types_beshyt_v2.tklfolusturtype;
  p_sagliksoru   ws_types_beshyt_v2.a_SaglikBilgiType;
  p_onuwbilgi    ws_types_beshyt_v2.WSOnUwBilgiType;
  p_primtype     ws_types_beshyt_v2.primhesaplatype;
  p_tmntlist     ws_types_beshyt_v2.a_tmnttype;
  p_policeek     ws_types_beshyt_v2.PoliceEkRec;
  p_polid        NUMBER;
  x              ws_types_beshyt_v2.UwBilgi;
  v_sqlerrm     VARCHAR2 (4000);
BEGIN
  p_tklftype.aracitcno := '13031935128';
  --
  p_sagliksoru (1).soruno := '603';
  p_sagliksoru (1).cevap := '<HAYIR>';
  p_sagliksoru (1).aciklama := '';
  p_sagliksoru (2).soruno := '610';
  p_sagliksoru (2).cevap := '<HAYIR>';
  p_sagliksoru (2).aciklama := '';
  p_sagliksoru (3).soruno := '608';
  p_sagliksoru (3).cevap := '<HAYIR>';
  p_sagliksoru (3).aciklama := '';
  p_sagliksoru (4).soruno := '626';
  p_sagliksoru (4).cevap := '<HAYIR>';
  p_sagliksoru (4).aciklama := '';
  p_sagliksoru (5).soruno := '615';
  p_sagliksoru (5).cevap := '<HAYIR>';
  p_sagliksoru (5).aciklama := '';
  p_sagliksoru (6).soruno := '597';
  p_sagliksoru (6).cevap := '';
  p_sagliksoru (6).aciklama := '';
  p_sagliksoru (7).soruno := '598';
  p_sagliksoru (7).cevap := '<HAYIR>';
  p_sagliksoru (7).aciklama := '';
  p_sagliksoru (8).soruno := '602';
  p_sagliksoru (8).cevap := '';
  p_sagliksoru (8).aciklama := '';
  p_sagliksoru (9).soruno := '607';
  p_sagliksoru (9).cevap := '<HAYIR>';
  p_sagliksoru (9).aciklama := '';
  p_sagliksoru (10).soruno := '604';
  p_sagliksoru (10).cevap := '<HAYIR>';
  p_sagliksoru (10).aciklama := '';
  p_sagliksoru (11).soruno := '611';
  p_sagliksoru (11).cevap := '<HAYIR>';
  p_sagliksoru (11).aciklama := '';
  p_sagliksoru (12).soruno := '621';
  p_sagliksoru (12).cevap := '<HAYIR>';
  p_sagliksoru (12).aciklama := '';
  p_sagliksoru (13).soruno := '624';
  p_sagliksoru (13).cevap := '<HAYIR>';
  p_sagliksoru (13).aciklama := '';
  p_sagliksoru (14).soruno := '609';
  p_sagliksoru (14).cevap := '<HAYIR>';
  p_sagliksoru (14).aciklama := '';
  p_sagliksoru (15).soruno := '617';
  p_sagliksoru (15).cevap := '<HAYIR>';
  p_sagliksoru (15).aciklama := '';
  p_sagliksoru (16).soruno := '601';
  p_sagliksoru (16).cevap := '';
  p_sagliksoru (16).aciklama := '';
  p_sagliksoru (17).soruno := '600';
  p_sagliksoru (17).cevap := '<HAYIR>';
  p_sagliksoru (17).aciklama := '';
  p_sagliksoru (18).soruno := '605';
  p_sagliksoru (18).cevap := '<HAYIR>';
  p_sagliksoru (18).aciklama := '';
  p_sagliksoru (19).soruno := '606';
  p_sagliksoru (19).cevap := '<HAYIR>';
  p_sagliksoru (19).aciklama := '';
  p_sagliksoru (20).soruno := '599';
  p_sagliksoru (20).cevap := '<HAYIR>';
  p_sagliksoru (20).aciklama := '';
  p_sagliksoru (21).soruno := '614';
  p_sagliksoru (21).cevap := '<HAYIR>';
  p_sagliksoru (21).aciklama := '';
  p_sagliksoru (22).soruno := '596';
  p_sagliksoru (22).cevap := '<HAYIR>';
  p_sagliksoru (22).aciklama := '';
  p_sagliksoru (23).soruno := '619';
  p_sagliksoru (23).cevap := '<HAYIR>';
  p_sagliksoru (23).aciklama := '';
  p_sagliksoru (24).soruno := '612';
  p_sagliksoru (24).cevap := '<HAYIR>';
  p_sagliksoru (24).aciklama := '';
  p_sagliksoru (25).soruno := '616';
  p_sagliksoru (25).cevap := '<HAYIR>';
  p_sagliksoru (25).aciklama := '';
  p_sagliksoru (26).soruno := '625';
  p_sagliksoru (26).cevap := '<EVET>';
  p_sagliksoru (26).aciklama := '';
  p_sagliksoru (27).soruno := '630';
  p_sagliksoru (27).cevap := '';
  p_sagliksoru (27).aciklama := '';
  p_sagliksoru (28).soruno := '624';
  p_sagliksoru (28).cevap := '<HAYIR>';
  p_sagliksoru (28).aciklama := '';
  p_sagliksoru (29).soruno := '625';
  p_sagliksoru (29).cevap := '175';
  p_sagliksoru (29).aciklama := '';
  p_sagliksoru (30).soruno := '626';
  p_sagliksoru (30).cevap := '80';
  p_sagliksoru (30).aciklama := '';
  p_sagliksoru (31).soruno := '630';
  p_sagliksoru (31).cevap := '<HAYIR>';
  p_sagliksoru (31).aciklama := '';
  --
  p_policeek.ilktahsgun := '12112024';
  p_policeek.takiptahsgun := '1';
  p_policeek.kampanyakodu := '1';
  p_policeek.ek1 := '12';
  p_policeek.ek2 := '';
  p_policeek.standart := 'F';
  p_policeek.uretimTip := 'W';
  p_policeek.agitouw := 'F';
  p_onuwbilgi.meslekkod := '3258.02';
  p_onuwbilgi.kimlikno := '50617463316';
  p_onuwbilgi.odetip := 'K';
  p_onuwbilgi.taksitsay := '12';
  p_primtype.tarifeno := 'ROPADM03';
  p_primtype.sigsayi := '1';
  p_primtype.sigdogtar := '28011997';
  p_primtype.sigcins := 'E';
  p_primtype.dovcins := 'TL';
  p_primtype.sure := '12';
  p_primtype.rsksnf := '1';
  p_primtype.tkstsecenek := 'P';
  p_tmntlist (1).tmntkod := 'VKVTM';
  p_tmntlist (1).tmnttutar := '81360.8936009184';
  p_polid := '2946521';
  --
  x :=
    FNC_WsonUw (p_tklftype,
                p_sagliksoru,
                p_onuwbilgi,
                p_primtype,
                p_tmntlist,
                p_policeek,
                p_polid);
  --
  p (x.uwsonuc);
  p (x.uwsonucack);
  p (x.uwhata (1).aciklama);
--
  COMMIT;
EXCEPTION
  WHEN OTHERS
  THEN
    v_sqlerrm := SUBSTR (SQLERRM, 1, 3999);
    p (v_sqlerrm);
    ROLLBACK;
END;
/

ALTER SESSION SET CURRENT_SCHEMA = BESPROD;
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';
/
DECLARE
  v_sqlerrm          VARCHAR2 (4000);
  v_hayatfonlamode   NUMBER
    := NVL (TO_NUMBER (GetSysprmVal ('HAYAT_FONLAMA_MODE')), 0);
BEGIN
  --
  DBMS_OUTPUT.disable;
  --
  IF v_hayatfonlamode = 0
  THEN
    besprod.hayatfonla;
  ELSIF v_hayatfonlamode = 1
  THEN
    besprod.prc_HayatFonlaByPolidJob;
  END IF;
  --
  writeakajobserrlog (51, 'BASARILI');
EXCEPTION
  WHEN OTHERS
  THEN
    v_sqlerrm := SUBSTR (SQLERRM, 1, 3999);
    writeakajobserrlog (51, v_sqlerrm);
END;
/


BEGIN
    DBMS_SCHEDULER.RUN_JOB(job_name => 'AEGL_14185_JOB_PART1');
END;
/

BEGIN
    DBMS_SCHEDULER.RUN_JOB(job_name => 'AEGL_14185_JOB_PART2');
END;
/

BEGIN
    DBMS_SCHEDULER.RUN_JOB(job_name => 'AEGL_14185_JOB_PART3');
END;
/

BEGIN
    DBMS_SCHEDULER.RUN_JOB(job_name => 'AEGL_14185_JOB_PART4');
END;
/

select * from besprod.workbookservice_log where crttar >= trunc(sysdate) order by seq desc;
/

DECLARE
  TYPE id_array IS TABLE OF besprod.workbookservice_log.seq%TYPE;
  l_ids id_array;
BEGIN
  SELECT seq
  BULK COLLECT INTO l_ids
  FROM besprod.workbookservice_log
  WHERE crttar >= TRUNC(SYSDATE);
  
  FORALL i IN 1..l_ids.COUNT
    DELETE FROM besprod.workbookservice_log
    WHERE seq = l_ids(i);
  
  COMMIT;
END;
/