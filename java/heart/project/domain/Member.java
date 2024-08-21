package heart.project.domain;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class Member {

    private int id; // ID, 기본키

    @NotEmpty
    private String memberId; // member ID, 이메일 형식

    @NotEmpty
    private String password; // 비밀번호

    @NotEmpty
    private String nickname; // 닉네임

    @NotEmpty
    private String gender; // 성별

    @NotEmpty
    private String birthdate; // 생년월일
}
