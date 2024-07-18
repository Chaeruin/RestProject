package heart.project;

import heart.project.config.MyBatisConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

@Import(MyBatisConfig.class)
@SpringBootApplication(scanBasePackages = "heart.project.controller")
public class ProjectApplication {

	public static void main(String[] args) {
		SpringApplication.run(ProjectApplication.class, args);
	}

}
