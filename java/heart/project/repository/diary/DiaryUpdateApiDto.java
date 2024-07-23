package heart.project.repository.diary;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class DiaryUpdateApiDto {

    @JsonProperty("content") // JSON 필드명 설정
    private String content;

    @JsonProperty("afterEmotion") // JSON 필드명 설정
    private String afterEmotion; // 임시로 받는 감정

    public DiaryUpdateApiDto() {
    }

    public DiaryUpdateApiDto(String content) {
        this.content = content;
    }
}