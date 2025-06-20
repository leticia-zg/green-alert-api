package br.com.fiap.monitor_tree_api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;

@SpringBootApplication
@OpenAPIDefinition(
	info = @Info(
		title = "Monitor Tree", 
		version = "v1", 
		description = "REST API desenvolvida para monitoramneto de sensores de temperatura e humidade"))
public class App {

	public static void main(String[] args) {
		SpringApplication.run(App.class, args);

	}

}
