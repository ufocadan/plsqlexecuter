package com.agito.plsqlexecuter.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

@Service
public class PlsqlExecutorService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void executePlsql() {
        String plsqlScript = """
            DECLARE
  v_polid NUMBER := 2579711; -- Bind variable
  proc CONSTANT VARCHAR2(100) := '001_AEGL_11466.sql';
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
  DBMS_OUTPUT.PUT_LINE('PL/SQL script executed successfully.');
END;
        """;

        jdbcTemplate.execute((Connection connection) -> {
            try (CallableStatement statement = connection.prepareCall(plsqlScript)) {
                statement.execute();

                // Enable DBMS_OUTPUT
                try (CallableStatement enableOutput = connection.prepareCall("BEGIN DBMS_OUTPUT.ENABLE(1000000); END;")) {
                    enableOutput.execute();
                }

                // Retrieve DBMS_OUTPUT content
                try (CallableStatement getOutput = connection.prepareCall(
                    "DECLARE " +
                    "  l_line VARCHAR2(255); " +
                    "  l_done NUMBER; " +
                    "BEGIN " +
                    "  LOOP " +
                    "    DBMS_OUTPUT.GET_LINE(l_line, l_done); " +
                    "    EXIT WHEN l_done = 1; " +
                    "    DBMS_OUTPUT.PUT_LINE(l_line); " +
                    "  END LOOP; " +
                    "END;")) {
                    getOutput.execute();
                }
            } catch (SQLException e) {
                throw new RuntimeException("Error executing PL/SQL script", e);
            }
            return null;
        });
    }
}