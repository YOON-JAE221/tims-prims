package com.prims.common.config;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import com.prims.common.interceptor.LoginCheckInterceptor;
import com.prims.common.interceptor.AccessCodeInterceptor;
import com.prims.common.interceptor.CommonInterceptor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import java.util.List;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private AppProperties appProperties;

    @Autowired
    private AccessCodeInterceptor accessCodeInterceptor;

    @Autowired
    private CommonInterceptor commonInterceptor;

    /** JSP 뷰 리졸버 명시 등록 */
    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setViewClass(JstlView.class);
        return resolver;
    }

    @Override
    public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setPropertyNamingStrategy(null);
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        objectMapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);

        MappingJackson2HttpMessageConverter customConverter = new MappingJackson2HttpMessageConverter();
        customConverter.setObjectMapper(objectMapper);
        converters.add(0, customConverter);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 환경별 업로드 경로 자동 적용 - 30일 캐싱
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:" + appProperties.getUploadBaseDir())
                .setCachePeriod(2592000);

        // 정적 리소스 (CSS, JS, 이미지 등) - 1년 캐싱
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/")
                .setCachePeriod(31536000);
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 공통 인터셉터 (siteUrl 등 공통 속성 설정)
        registry.addInterceptor(commonInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/resources/**", "/upload/**");

        // 사이트 접속코드 인터셉터 (FO 전체 - USE_YN = 'Y'일 때만 동작)
        registry.addInterceptor(accessCodeInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                    "/accessCode",
                    "/verifyAccessCode",
                    "/login/**",
                    "/admin/**",
                    "/*Mng/**",
                    "/resources/**",
                    "/upload/**",
                    "/file/**",
                    "/error/**"
                );

        // 로그인 체크 인터셉터 (기존 spring-config.xml 에서 이관)
        registry.addInterceptor(new LoginCheckInterceptor())
                .addPathPatterns("/*Mng/**", "/admin/**", "/bbs/*Write*", "/bbs/*save*")
                .excludePathPatterns(
                    "/login/**",
                    "/resources/**",
                    "/admin/mobileBlock",
                    "/bbs/viewBbsWriteQna",
                    "/bbs/saveBbsPstQna",
                    "/bbs/checkSecretPwd",
                    "/bbs/viewBbsDetailQna"
                );
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(new com.prims.common.web.ParamMapArgumentResolver());
    }
}
