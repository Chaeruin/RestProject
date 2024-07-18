package heart.project.repository.member;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class MemberUpdateApiDto {
    @JsonProperty("password") // JSON 필드명 설정
    private String password;

    @JsonProperty("nickname") // JSON 필드명 설정
    private String nickname;

    @JsonProperty("gender") // JSON 필드명 설정
    private String gender;

    @JsonProperty("birthdate") // JSON 필드명 설정
    private String birthdate;

    public MemberUpdateApiDto() {
    }

    public MemberUpdateApiDto(String password, String nickname, String gender, String birthdate) {
        this.password = password;
        this.nickname = nickname;
        this.gender = gender;
        this.birthdate = birthdate;
    }
}