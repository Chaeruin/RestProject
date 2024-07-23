package heart.project.domain;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.time.LocalDate;

@Data
public class Action {

    private int actionId;

    @NotEmpty
    private String emotionType; // 감정 타입

    @NotEmpty
    private String category; // 카테고리

    @NotEmpty
    private String action; // 행동

    @NotEmpty
    private int reward; // 리워드

    private int memberActionId; // member_action 테이블에서 가져오는 멤버 행동 아이디

    private String status; // member_action 테이블에서 가져오는 상태
}
