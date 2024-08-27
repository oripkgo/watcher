package com.watcher.config;

import javax.sql.DataSource;

import com.watcher.common.CommonIntercepter;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;
import org.springframework.web.servlet.view.tiles3.TilesViewResolver;

import java.io.File;

@Configuration
@MapperScan(basePackages="com.watcher.business.*.mapper")
@EnableTransactionManagement						// TransactionManager 적용에 관해 설정하는 어노테이션
public class WatcherConfig implements WebMvcConfigurer {

	@Autowired
	ApplicationContext applicationContext;

	@Autowired
	CommonIntercepter commonIntercepter;

	@Value("${db.url}")
	String url;
	@Value("${db.username}")
	String username;
	@Value("${db.password}")
	String password;
	@Value("${db.driver-class-name}")
	String driverClassName;

	@Value("${upload.path}")
	private String connectPath;
	@Value("${upload.root}")
	private String resourcePath;

	static public String file_separator;

	@Value("${cors.origin}")
	private String corsOrigin;


	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {

		file_separator = File.separator;

		registry.addResourceHandler(connectPath+"/**")
				.addResourceLocations("file:///"+resourcePath+connectPath+"/");

	}


	// tiles (s)
	@Bean
	public TilesConfigurer tilesConfigurer() {

		final TilesConfigurer configurer = new TilesConfigurer();

		configurer.setDefinitions(new String[] {"/WEB-INF/tiles/tiles.xml"});
		configurer.setCheckRefresh(true);
		return configurer;
	}


	@Bean
	public TilesViewResolver tilesViewResolber() {

		final TilesViewResolver tilesViewResolver = new TilesViewResolver();

		tilesViewResolver.setViewClass(TilesView.class);
		return tilesViewResolver;
	}
	// tiles (e)


	// DB 설정 (s)
	@Bean
	@Qualifier("mariaDBDataSource")
	@ConfigurationProperties(prefix = "spring.datasource")
	public DataSource mysqlDataSource() {
		return DataSourceBuilder.create()
				.url(url)
				.username(username)
				.password(password)
				.driverClassName(driverClassName)
				.build();
	}


	@Bean
	public SqlSessionFactory sqlSessionFactory(@Qualifier("mariaDBDataSource") DataSource dataSource) throws Exception {

		final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();

		sessionFactory.setDataSource(dataSource);
//		this.transactionManager(dataSource);

		sessionFactory.setMapperLocations(applicationContext.getResources("classpath:mybatis/mapper/**/*.xml"));
		sessionFactory.setConfigLocation(applicationContext.getResource("classpath:config/mybatis-config.xml"));

		sessionFactory.getObject().getConfiguration().setMapUnderscoreToCamelCase(true);		// ex : user_id를 userId로

		return sessionFactory.getObject();

	}


//	@Bean
//	public DataSourceTransactionManager transactionManager(@Qualifier("mariaDBDataSource") DataSource dataSource) {
//		DataSourceTransactionManager manager = new DataSourceTransactionManager();
//		manager.setDataSource(dataSource);
//		return manager;
//	}


	@Bean
	public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) throws Exception {
		final SqlSessionTemplate sqlSessionTemplate = new SqlSessionTemplate(sqlSessionFactory);
		return sqlSessionTemplate;
	}
	// DB 설정 (e)


	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(commonIntercepter)
				.excludePathPatterns("/comm/token")
				.addPathPatterns("/**");
	}


	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/**")
				.allowedOrigins(corsOrigin)
				.allowedMethods(
						HttpMethod.GET.name(),
						HttpMethod.HEAD.name(),
						HttpMethod.POST.name(),
						HttpMethod.PUT.name(),
						HttpMethod.DELETE.name());
	}


//	@Bean
//	public ThreadPoolTaskScheduler taskScheduler() {
//		ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
//
//		scheduler.setPoolSize(2);	// 원하는 스레드 개수로 설정
//		scheduler.setThreadNamePrefix("my-scheduler-");
//		scheduler.setWaitForTasksToCompleteOnShutdown(true);
//		scheduler.setAwaitTerminationSeconds(30);
//
//		return scheduler;
//	}

}
