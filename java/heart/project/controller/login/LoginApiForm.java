package heart.project.controller.login;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class LoginApiForm {

    @NotEmpty
    private String loginId;

    @NotEmpty
    private String password;
}
