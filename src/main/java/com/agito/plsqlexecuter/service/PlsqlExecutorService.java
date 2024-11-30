package com.agito.plsqlexecuter.service;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class PlsqlExecutorService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

     /**
     * Executes the PL/SQL script for a specific policyId asynchronously.
     *
     * @param policyId       the ID of the policy
     */
    @Async // Mark this method as asynchronous
    public CompletableFuture<String> executePlsqlForPolicyAsync(Long policyId){
      String plsqlScript = """
            DECLARE
  v_polid NUMBER := ?; -- Bind variable
  proc CONSTANT VARCHAR2(100) := 'PLSQL_EXECUTER_SERVICE.sql';
BEGIN
  FOR r IN (SELECT *
              FROM zeyl
             WHERE polid = v_polid
               AND zeylno IN (SELECT sonzeylno FROM sonpol WHERE polid = v_polid)
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
  DBMS_OUTPUT.PUT_LINE('Executing PL/SQL script for Policy ID: ' || v_polid);
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
        """;

        try {
          jdbcTemplate.update(connection -> {
              var preparedStatement = connection.prepareStatement(plsqlScript);
              preparedStatement.setLong(1, policyId); // Bind the variable
              return preparedStatement;
          });
          return CompletableFuture.completedFuture("PL/SQL script executed for Policy ID: " + policyId + " successfully!");
      } catch (Exception e) {
          return CompletableFuture.failedFuture(e);
      }
       
    }

    /**
     * Executes the PL/SQL script for a specific policyId and addendumNumber asynchronously.
     *
     * @param policyId       the ID of the policy
     * @param addendumNumber the number of the addendum
     */
    @Async
    public void executePlsqlForPolicyAndAddendumAsync(Long policyId, Integer addendumNumber) {
       
      String plsqlScript = """
            DECLARE
  v_polid NUMBER := ?; -- Bind variable
  v_addendum_number NUMBER := ?; -- Bind variable
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
        """;

        try {
            jdbcTemplate.update(connection -> {
                var preparedStatement = connection.prepareStatement(plsqlScript);
                preparedStatement.setLong(1, policyId);        // Bind policyId
                preparedStatement.setInt(2, addendumNumber);   // Bind addendumNumber
                return preparedStatement;
            });
            System.out.println("PL/SQL script executed for policy ID: " + policyId + " and addendum number: " + addendumNumber + " successfully!");
        } catch (Exception e) {
            System.err.println("Error executing PL/SQL for policy ID " + policyId + " and addendum number " + addendumNumber + ": " + e.getMessage());
        }
    }

    /**
     * Executes the PL/SQL script for creating a proposal asynchronously.
     *
     * @param webserviceLogId the ID of the web service log
     * @param proposalNumber  the proposal number
     */
    @Async
    public void createProposalAsync(Long webserviceLogId, String proposalNumber) {
        String plsqlScript = """
            DECLARE
  v_webservicelogid   NUMBER := ?;
  v_proposalNumber    VARCHAR2 (100) := ?;
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
        """;

        try {
            jdbcTemplate.update(connection -> {
                var preparedStatement = connection.prepareStatement(plsqlScript);
                preparedStatement.setLong(1, webserviceLogId);  // Bind v_webservicelogid
                preparedStatement.setString(2, proposalNumber); // Bind v_proposalNumber
                return preparedStatement;
            });
            System.out.println("Proposal created with webservicelogid: " + webserviceLogId + ", proposalNumber: " + proposalNumber);
        } catch (Exception e) {
            System.err.println("Error creating proposal with webservicelogid: " + webserviceLogId + ", proposalNumber: " + proposalNumber + ": " + e.getMessage());
        }
    }

    /**
     * Endpoint to issue policy for vcollect.
     *
     * @param policyId the ID of the policy
     * @param aracitcno the identity number of Agency
     */
    @Async
    public void policelestirvcAsync(Long policyId, String aracitcno) {
        String plsqlScript = """
           DECLARE
  v_policelestir ws_func_beshyt_v2_policelestirtype := ws_func_beshyt_v2_policelestirtype();
  v_policeek ws_func_beshyt_v2_policeekrec := ws_func_beshyt_v2_policeekrec();
  v_islemtip VARCHAR2(255);
  i          NUMBER;
  x          ws_func_beshyt_v2_policelestirrec := ws_func_beshyt_v2_policelestirrec();
  v_polno    NUMBER;
  v_tahsno   NUMBER;
  v_sqlerrm     VARCHAR2 (4000);
  v_polid number := ?;
  v_aracitcno VARCHAR2(255) := ?;
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
    ROLLBACK;
END; 
        """;

        try {
            jdbcTemplate.update(connection -> {
                var preparedStatement = connection.prepareStatement(plsqlScript);
                preparedStatement.setLong(1, policyId);  // Bind policyId
                preparedStatement.setString(2, aracitcno); // Bind aracitcno
                return preparedStatement;
            });
            System.out.println("Proposal created with policyId: " + policyId + ", aracitcno: " + aracitcno);
        } catch (Exception e) {
            System.err.println("Error creating proposal with policyId: " + policyId + ", aracitcno: " + aracitcno + ": " + e.getMessage());
        }
    }
}