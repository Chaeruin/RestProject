package heart.project.controller.login;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class LoginApiForm {

    @NotEmpty
    private String loginId; // 로그인 ID

    @NotEmpty
    private String password; // 비밀번호
}
