package com.agito.plsqlexecuter.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import com.agito.plsqlexecuter.service.*;

import java.util.concurrent.CompletableFuture;

@RestController
public class PlsqlController {

    @Autowired
    private PlsqlExecutorService executorService;

    @GetMapping("/execute-plsql")
    public CompletableFuture<String> executePlsql() {
        // This returns immediately, while the execution happens asynchronously
        return executorService.executePlsqlAsync();
    }
}