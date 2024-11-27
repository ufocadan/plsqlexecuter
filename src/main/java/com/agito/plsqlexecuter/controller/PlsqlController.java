package com.agito.plsqlexecuter.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import com.agito.plsqlexecuter.service.*;

@RestController
public class PlsqlController {

    @Autowired
    private PlsqlExecutorService executorService;

    @GetMapping("/execute-plsql")
    public String executePlsql() {
        executorService.executePlsql();
        return "PL/SQL script executed successfully!";
    }
}
