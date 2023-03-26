package fi.backend.bookstore;


import org.springframework.beans.factory.annotation.Autowired;
import static org.springframework.boot.autoconfigure.security.servlet.PathRequest.toH2Console;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableMethodSecurity(securedEnabled = true)
public class WebSecurityConfig{
    @Autowired
    private UserDetailsService userDetailsService;	
	
    @Bean
    public SecurityFilterChain configure(HttpSecurity http) throws Exception {
        http
        .authorizeHttpRequests()
        	.requestMatchers("/css/**").permitAll() // Enable css when logged out
        	.requestMatchers(toH2Console()).permitAll()
        	.requestMatchers("/signup", "/saveuser").permitAll()
        	.anyRequest().authenticated()
        	.and()
        	.csrf().ignoringRequestMatchers(toH2Console())
        	  .and()
        	  .headers().frameOptions().disable()
        	  .and()
      .formLogin()
          .loginPage("/login")
          .defaultSuccessUrl("/books", true)
          .permitAll()
          .and()
      .logout()
          .permitAll()
          .and()
      .httpBasic();
     return http.build();   
    }
    
    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(new BCryptPasswordEncoder());
    }
}