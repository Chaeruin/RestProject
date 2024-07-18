package heart.project.repository.emotion;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class EmotionUpdateApiDto {

    @JsonProperty("emotionType") // JSON 필드명 설정
    private String emotionType;

    public EmotionUpdateApiDto() {
    }

    public EmotionUpdateApiDto(String emotionType) {
        this.emotionType = emotionType;
    }
}