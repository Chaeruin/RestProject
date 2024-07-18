package heart.project.service.chat;

import heart.project.domain.Chat;
import heart.project.repository.chat.ChatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository chatRepository;

    // 새로운 채팅방 ID를 생성하여 반환하는 메서드
    public int newChatId() {
        return chatRepository.findLargestChatId();
    }

    // 회원이 전송한 채팅을 저장하는 메서드
    public void memberChatSave(Chat memberChat) {
        chatRepository.memberChatSave(memberChat);
    }

    // AI가 생성한 채팅을 저장하는 메서드
    public void aiChatSave(Chat aiChat) {
        chatRepository.aiChatSave(aiChat);
    }

    // 주어진 채팅방 ID에 해당하는 채팅들을 반환하는 메서드
    public List<Chat> findById(Integer chatId) {
        return chatRepository.findById(chatId);
    }

    // 주어진 회원 ID에 해당하는 채팅들을 반환하는 메서드
    public List<Chat> findByMemberId(String memberId) {
        return chatRepository.findByMemberId(memberId);
    }
}

