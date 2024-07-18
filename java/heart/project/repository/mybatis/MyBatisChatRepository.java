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

    @Override
    public int findLargestChatId() {
        // 채팅방 ID 생성 및 설정
        int largestChatRoomId = chatMapper.findLargestChatId();
        int chatId;

        if (largestChatRoomId == 0) {
            chatId = 1;
        } else {
            chatId = largestChatRoomId + 1;
        }

        return chatId;
    }

    @Override
    public void memberChatSave(Chat memberChat) {
        chatMapper.memberChatSave(memberChat);
    }

    @Override
    public void aiChatSave(Chat aiChat) {
        chatMapper.aiChatSave(aiChat);
    }

    @Override
    public List<Chat> findById(Integer chatId) {
        return chatMapper.findById(chatId);
    }

    @Override
    public List<Chat> findByMemberId(String memberId) {
        return chatMapper.findByMemberId(memberId);
    }
}
