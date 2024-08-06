package heart.project.repository.diary;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class DiaryUpdateApiDto {

    @JsonProperty("content") // JSON 필드명 설정
    private String content;

    public DiaryUpdateApiDto() {
    }

    public DiaryUpdateApiDto(String content) {
        this.content = content;
    }
}