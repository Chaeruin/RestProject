package heart.project.config;

import heart.project.repository.chat.ChatRepository;
import heart.project.repository.diary.DiaryRepository;
import heart.project.repository.emotion.EmotionRepository;
import heart.project.repository.member.MemberRepository;
import heart.project.repository.mybatis.*;
import heart.project.service.chat.ChatService;
import heart.project.service.diary.DiaryService;
import heart.project.service.emotion.EmotionService;
import heart.project.service.login.LoginService;
import heart.project.service.member.MemberService;
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

    @Bean
    public MemberService memberService() {
        return new MemberService(memberRepository());
    }

    @Bean
    public LoginService loginService() {
        return new LoginService(memberRepository());
    }

    @Bean
    public MemberRepository memberRepository() {
        return new MyBatisMemberRepository(memberMapper);
    }

    @Bean
    public DiaryService diaryService() {
        return new DiaryService(diaryRepository());
    }

    @Bean
    public DiaryRepository diaryRepository() {
        return new MyBatisDiaryRepository(diaryMapper);
    }

    @Bean
    public ChatService chatService() {
        return new ChatService(chatRepository());
    }

    @Bean
    public ChatRepository chatRepository() {
        return new MyBatisChatRepository(chatMapper);
    }

    @Bean
    public EmotionService emotionService() {
        return new EmotionService(emotionRepository());
    }

    @Bean
    public EmotionRepository emotionRepository() {
        return new MyBatisEmotionRepository(emotionMapper);
    }
}

