package heart.project.domain;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class Action {

    private int actionId;

    @NotEmpty
    private String emotionType; // 감정 타입

    @NotEmpty
    private String category; // 카테고리

    @NotEmpty
    private String action; // 행동
}
