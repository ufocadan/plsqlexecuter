package com.agito.plsqlexecuter.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

@Configuration
@EnableAsync
public class AsyncConfig {

    @Bean(name = "taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10); // Number of core threads
        executor.setMaxPoolSize(20); // Maximum threads
        executor.setQueueCapacity(500); // Queue size for tasks
        executor.setThreadNamePrefix("PlsqlExecutor-");
        executor.initialize();
        return executor;
    }
}