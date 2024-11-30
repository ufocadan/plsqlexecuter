
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