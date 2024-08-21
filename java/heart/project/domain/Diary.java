package heart.project.domain;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class Diary {

    private int diaryId; // diary ID, 기본키

    @NotEmpty
    private String memberId; // member ID, 외래키

    @NotEmpty
    private String writeDate; // 작성 일자

    @NotEmpty
    private String content; // 일기 내용

    private String beforeEmotion; // 임시로 받는 감정

    private String afterEmotion; // 임시로 받는 감정

}
