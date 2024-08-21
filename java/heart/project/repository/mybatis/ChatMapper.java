package heart.project.repository.mybatis;

import heart.project.domain.Chat;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ChatMapper {

    // 가장 큰 채팅방 ID를 반환하는 메서드
    int findLargestChatId();

    // 회원이 전송한 채팅을 저장하는 메서드
    void memberChatSave(Chat memberChat);

    // AI가 생성한 채팅을 저장하는 메서드
    void aiChatSave(Chat aiChat);

    // 주어진 채팅방 ID에 해당하는 채팅들을 반환하는 메서드
    List<Chat> findById(Integer chatId);

    // 주어진 회원 ID에 해당하는 채팅들을 반환하는 메서드
    List<Chat> findByMemberId(String memberId);
}
