@Configuration
public class SecurityConfiguration {

        @Autowired
        private UserService service;

        @Bean //빈을 DelegatingFilterProxy와 FilterChainProxy에 연결하여 모든 웹 요청에 보안 필터를 자동 적용
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                .cors().disable()
                                .csrf().disable() // < -- 보안 취약점 개발 환경에서 사용
                                .headers().frameOptions().disable() // < -- 보안 취약점 개발 환경에서 사용
                                .and()
                                .authorizeRequests()
                                .antMatchers("/manager/man_login_Form").authenticated()
                                .antMatchers("/manager/**").hasAuthority("관리자")
                                .anyRequest().permitAll()
                                .and()
                                .formLogin()
                                .loginPage("/manager/man_login_Form")
                                .loginProcessingUrl("/manager/man_login")
                                .defaultSuccessUrl("/manager/main")
                                .failureUrl("/manager/man_login_Form")
                                .permitAll()
                                .and()
                                .logout()
                                .permitAll()
                                .and()
                                .userDetailsService(service);

                return http.build();
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }
}