package heart.project.repository.memberaction;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class MemberActionUpdateApiDto {

    @JsonProperty("afterEmotion") // JSON 필드명 설정
    private String afterEmotion;

    public MemberActionUpdateApiDto() {
    }

    public MemberActionUpdateApiDto(String afterEmotion) {
        this.afterEmotion = afterEmotion;
    }
}