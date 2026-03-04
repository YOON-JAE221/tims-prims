package com.sdr;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class TimsSdrApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(TimsSdrApplication.class, args);
    }

    /** 외부 Tomcat (WAR 배포) 지원 */
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(TimsSdrApplication.class);
    }
}
