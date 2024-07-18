package heart.project.controller.chat;

import heart.project.domain.Chat;
import heart.project.service.chat.ChatService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/chat")
public class ChatTApiController {

    private final ChatService chatService;

    int chatId;

    /**
     * 새로운 채팅방을 생성하는 엔드포인트
     */
    @PostMapping("/newChatRoom")
    public ResponseEntity<Map<String, Object>> newChatRoomId(@RequestBody String flutterRequest) throws UnsupportedEncodingException {
        String checkFlutterRequest = URLDecoder.decode(flutterRequest, "UTF-8");
        System.out.println(checkFlutterRequest);

        // 저장된 채팅방 ID를 가져와 응답에 포함
        chatId = chatService.newChatId();

        // JSON 형식으로 응답 데이터 구성
        Map<String, Object> response = new HashMap<>();
        response.put("message", "채팅방 생성");
        response.put("chatId", chatId);

        // ResponseEntity에 JSON 데이터를 포함하여 응답
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    /**
     * Flutter로부터 메시지를 받고 처리하는 엔드포인트
     */
    @PostMapping("/requestMessageFromFlutter/{chatId}")
    public ResponseEntity<String> flutterMessage(@PathVariable("chatId") int chatId, @RequestBody Chat chat) throws JsonProcessingException {

        System.out.println("chatId: " + chat.getChatId());
        System.out.println("chatContent: " + chat.getChatContent());

        // 멤버가 전송한 메세지를 DB에 저장
        chatService.memberChatSave(chat);

        // 여기에서 메시지를 처리하고 응답을 반환
        String responseMessage = "스프링에서는 flutter 요청 메세지를 잘 받았음";

        ResponseEntity.ok().body(responseMessage);

        String flutterMessage = "{\"messageFromFlutter\":\"" + chat.getChatContent() + "\"}";

        // HTTP 요청을 위한 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // HTTP 요청 본문과 헤더를 포함한 요청 엔티티 생성
        HttpEntity<String> requestEntity = new HttpEntity<>(flutterMessage, headers);

        String flaskEndpoint = "http://3.35.183.52:8081/chatbot/" + chatId; //챗봇(chatId로 방 구분)

        // RestTemplate을 사용하여 Flask 서버에 데이터 요청
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> responseEntity = restTemplate.postForEntity(flaskEndpoint, requestEntity, String.class);

        // Flask 서버에서 받은 응답 출력
        String responseFlaskData = responseEntity.getBody();
        System.out.println(responseFlaskData);

        // ObjectMapper를 사용하여 JSON 데이터를 Java 객체로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseFlaskData);

        // JSON 데이터에서 원하는 값 추출
        String aiResponse = jsonNode.get("response").asText();

        // AI의 답변을 채팅에 저장하기 위해 Chat 객체 생성
        Chat aiChat = new Chat();
        aiChat.setChatId(chat.getChatId()); // 기존 채팅의 chatId 사용
        aiChat.setChatContent(aiResponse); // Flask로부터 받은 응답 데이터를 chatContent로 설정

        // AI의 답변을 DB에 저장
        chatService.aiChatSave(aiChat);

        // 받아온 데이터를 처리하거나 사용
        // 여기서는 그대로 반환
        return ResponseEntity.ok().body(responseFlaskData);
    }

    /**
     * 특정 채팅방의 채팅 기록을 가져오는 엔드포인트
     */
    @GetMapping("/{chatId}")
    public ResponseEntity<List<Chat>> getChatsById(@PathVariable("chatId") Integer chatId) {
        List<Chat> chatsById = chatService.findById(chatId);
        return ResponseEntity.ok(chatsById);
    }

    /**
     * 특정 멤버의 채팅 기록을 가져오는 엔드포인트
     */
    @GetMapping("/member/{memberId}")
    public ResponseEntity<List<Chat>> getChatsByMemberId(@PathVariable("memberId") String memberId) {
        List<Chat> chatsByMemberId = chatService.findByMemberId(memberId);
        return ResponseEntity.ok(chatsByMemberId);
    }
}