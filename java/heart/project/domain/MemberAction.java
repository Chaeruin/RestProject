package heart.project.domain;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class MemberAction {

    private int memberActionId;

    @NotEmpty
    private int actionId; // action Id, 외래키

    @NotEmpty
    private String memberId; // member ID, 외래키

    @NotEmpty
    private String status; // 상태

    @NotEmpty
    private String beforeEmotion; // 행동하기 이전 감정

    @NotEmpty
    private String afterEmotion; // 행동하기 이후 감정

    private String action; // action 테이블에서 가져오는 행동 내용
}
