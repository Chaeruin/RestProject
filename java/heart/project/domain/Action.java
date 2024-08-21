package heart.project.domain;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class Action {

    private int actionId; // action ID, 기본키

    @NotEmpty
    private String emotionType; // 감정 타입

    @NotEmpty
    private String category; // 행동 카테고리

    @NotEmpty
    private String action; // 행동

    @NotEmpty
    private int reward; // 리워드

    private int memberActionId; // member_action 테이블에서 가져오는 멤버 행동 ID

    private String status; // member_action 테이블에서 가져오는 행동 상태
}
