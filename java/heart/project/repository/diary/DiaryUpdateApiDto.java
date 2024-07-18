package heart.project.repository.diary;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class DiaryUpdateApiDto {

    @JsonProperty("memberId") // JSON 필드명 설정
    private String memberId;

    @JsonProperty("writeDate") // JSON 필드명 설정
    private String writeDate;

    @JsonProperty("content") // JSON 필드명 설정
    private String content;

    @JsonProperty("emotionType") // JSON 필드명 설정
    private String emotionType; // 임시로 받는 감정 타입

    public DiaryUpdateApiDto() {
    }

    public DiaryUpdateApiDto(String memberId, String writeDate, String content) {
        this.memberId = memberId;
        this.writeDate = writeDate;
        this.content = content;
    }
}