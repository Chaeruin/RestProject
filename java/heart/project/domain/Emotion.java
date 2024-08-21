package heart.project.domain;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class Emotion {

    private int emotionId; // emotion ID, 기본키

    @NotEmpty
    private int diaryId; // diary ID, 외래키

    @NotEmpty
    private String memberId; // member ID, 외래키

    @NotEmpty
    private String beforeEmotion; // 일기 작성 이전 감정

    @NotEmpty
    private String afterEmotion; // 일기 작성 이후 감정

    @NotEmpty
    private String emotionTime; // 감정 시간

}
