package heart.project.domain;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class Emotion {

    private int emotionId;

    @NotEmpty
    private int diaryId; // diary Id, 외래키

    @NotEmpty
    private String memberId; // member ID, 외래키

    @NotEmpty
    private String emotionType; // 감정 타입

    @NotEmpty
    private String emotionTime; // 감정 시간

}
