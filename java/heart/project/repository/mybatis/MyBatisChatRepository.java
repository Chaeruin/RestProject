package heart.project.repository.mybatis;

import heart.project.domain.Chat;
import heart.project.repository.chat.ChatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MyBatisChatRepository implements ChatRepository {

    private final ChatMapper chatMapper;

    // 가장 큰 채팅방 ID를 반환하는 메서드
    @Override
    public int findLargestChatId() {
        // 현재까지 저장된 채팅방 중 가장 큰 ID를 조회
        int largestChatRoomId = chatMapper.findLargestChatId();
        int chatId;

        // 가장 큰 채팅방 ID가 0이면, 새로 생성할 채팅방 ID를 1로 설정
        // 그렇지 않으면, 현재 가장 큰 채팅방 ID에 1을 더하여 새 채팅방 ID를 생성
        if (largestChatRoomId == 0) {
            chatId = 1;
        } else {
            chatId = largestChatRoomId + 1;
        }

        // 새로 생성된 채팅방 ID를 반환
        return chatId;
    }

    // 회원이 전송한 채팅을 저장하는 메서드
    @Override
    public void memberChatSave(Chat memberChat) {
        chatMapper.memberChatSave(memberChat);
    }

    // AI가 생성한 채팅을 저장하는 메서드
    @Override
    public void aiChatSave(Chat aiChat) {
        chatMapper.aiChatSave(aiChat);
    }

    // 주어진 채팅방 ID에 해당하는 채팅들을 반환하는 메서드
    @Override
    public List<Chat> findById(Integer chatId) {
        return chatMapper.findById(chatId);
    }

    // 주어진 회원 ID에 해당하는 채팅들을 반환하는 메서드
    @Override
    public List<Chat> findByMemberId(String memberId) {
        return chatMapper.findByMemberId(memberId);
    }
}
