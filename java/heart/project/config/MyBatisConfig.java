package heart.project.config;

import heart.project.repository.action.ActionRepository;
import heart.project.repository.chat.ChatRepository;
import heart.project.repository.dailyrecommendation.DailyRecommendationRepository;
import heart.project.repository.diary.DiaryRepository;
import heart.project.repository.emotion.EmotionRepository;
import heart.project.repository.member.MemberRepository;
import heart.project.repository.memberaction.MemberActionRepository;
import heart.project.repository.mybatis.*;
import heart.project.service.action.ActionService;
import heart.project.service.chat.ChatService;
import heart.project.service.dailyrecommendation.DailyRecommendationService;
import heart.project.service.diary.DiaryService;
import heart.project.service.emotion.EmotionService;
import heart.project.service.login.LoginService;
import heart.project.service.member.MemberService;
import heart.project.service.memberaction.MemberActionService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class MyBatisConfig {

    private final MemberMapper memberMapper;
    private final DiaryMapper diaryMapper;
    private final ChatMapper chatMapper;
    private final EmotionMapper emotionMapper;
    private final ActionMapper actionMapper;
    private final MemberActionMapper memberActionMapper;
    private final DailyRecommendationMapper dailyRecommendationMapper;

    // MemberService 빈을 생성하는 메서드
    @Bean
    public MemberService memberService() {
        return new MemberService(memberRepository());
    }

    // LoginService 빈을 생성하는 메서드
    @Bean
    public LoginService loginService() {
        return new LoginService(memberRepository());
    }

    // MemberRepository 빈을 생성하는 메서드
    @Bean
    public MemberRepository memberRepository() {
        return new MyBatisMemberRepository(memberMapper);
    }

    // DiaryService 빈을 생성하는 메서드
    @Bean
    public DiaryService diaryService() {
        return new DiaryService(diaryRepository());
    }

    // DiaryRepository 빈을 생성하는 메서드
    @Bean
    public DiaryRepository diaryRepository() {
        return new MyBatisDiaryRepository(diaryMapper);
    }

    // ChatService 빈을 생성하는 메서드
    @Bean
    public ChatService chatService() {
        return new ChatService(chatRepository());
    }

    // ChatRepository 빈을 생성하는 메서드
    @Bean
    public ChatRepository chatRepository() {
        return new MyBatisChatRepository(chatMapper);
    }

    // EmotionService 빈을 생성하는 메서드
    @Bean
    public EmotionService emotionService() {
        return new EmotionService(emotionRepository());
    }

    // EmotionRepository 빈을 생성하는 메서드
    @Bean
    public EmotionRepository emotionRepository() {
        return new MyBatisEmotionRepository(emotionMapper);
    }

    // ActionService 빈을 생성하는 메서드
    @Bean
    public ActionService actionService() {
        return new ActionService(actionRepository());
    }

    // ActionRepository 빈을 생성하는 메서드
    @Bean
    public ActionRepository actionRepository() {
        return new MyBatisActionRepository(actionMapper);
    }

    // DailyRecommendationService 빈을 생성하는 메서드
    @Bean
    public DailyRecommendationService dailyRecommendationService() {
        return new DailyRecommendationService(dailyRecommendationRepository(), actionRepository());
    }

    // DailyRecommendationRepository 빈을 생성하는 메서드
    @Bean
    public DailyRecommendationRepository dailyRecommendationRepository() {
        return new MyBatisDailyRecommendationRepository(dailyRecommendationMapper);
    }

    // MemberActionService 빈을 생성하는 메서드
    @Bean
    public MemberActionService memberActionService() {
        return new MemberActionService(memberActionRepository());
    }

    // MemberActionRepository 빈을 생성하는 메서드
    @Bean
    public MemberActionRepository memberActionRepository() {
        return new MyBatisMemberActionRepository(memberActionMapper);
    }
}

