package com.prims;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class TimsPrimsApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(TimsPrimsApplication.class, args);
    }

    /** 외부 Tomcat (WAR 배포) 지원 */
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(TimsPrimsApplication.class);
    }
}
