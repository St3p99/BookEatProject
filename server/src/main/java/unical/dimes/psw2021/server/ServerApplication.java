package unical.dimes.psw2021.server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScans;


@SpringBootApplication
@ComponentScans({
        @ComponentScan("unical.dimes.psw2021.server.controller"),
        @ComponentScan("unical.dimes.psw2021.server.service"),
        @ComponentScan("unical.dimes.psw2021.server.repository")}
)
@EntityScan(basePackages = {"unical.dimes.psw2021.server.model"})  // scan JPA entities
public class ServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServerApplication.class, args);
    }


}
