package com.agito.plsqlexecuter;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync // Enable Spring's asynchronous processing
public class PlsqlExecutorApplication {

    public static void main(String[] args) {
        SpringApplication.run(PlsqlExecutorApplication.class, args);
    }
}