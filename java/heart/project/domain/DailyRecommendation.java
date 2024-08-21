package heart.project.domain;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.time.LocalDate;

@Data
public class DailyRecommendation {

    private int dailyRecommendationsId; // dailyRecommendation ID, 기본키

    private int memberActionId; // member action ID, 외래키

    @NotEmpty
    private int actionId; // action ID, 외래키

    @NotEmpty
    private String memberId; // member ID, 외래키

    private String action; // action 테이블에서 가져오는 행동 내용

    private String status; // member_action 테이블에서 가져오는 상태

    @NotEmpty
    private String emotionType; // 감정 타입

    @NotEmpty
    private String category; // 카테고리

    @NotEmpty
    private LocalDate recommendationDate; // 추천한 날짜
}
