package heart.project.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

@Data
public class MemberAction {

    private int memberActionId; // memberAction ID, 기본키

    @NotEmpty
    private int actionId; // action ID, 외래키

    @NotEmpty
    private String memberId; // member ID, 외래키

    @NotEmpty
    private String status; // 상태

    @NotEmpty
    private String beforeEmotion; // 행동하기 이전 감정

    @NotEmpty
    private String afterEmotion; // 행동하기 이후 감정

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyyMMdd")
    @NotNull
    private LocalDate recommendationDate; // 추천한 날짜

    private String action; // action 테이블에서 가져오는 행동 내용
}
