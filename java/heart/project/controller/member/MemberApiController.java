package heart.project.controller.member;

import heart.project.domain.Member;
import heart.project.notifier.SlackNotifier;
import heart.project.repository.member.MemberUpdateApiDto;
import heart.project.service.member.MemberService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/members")
public class MemberApiController {

    private final MemberService memberService;

    /**
     * 모든 회원 목록을 반환하는 엔드포인트
     */
    @GetMapping
    public ResponseEntity<List<Member>> members() {
        Member member = new Member(); // 빈 Member 객체 생성
        List<Member> members = memberService.findMembers(member);
        return new ResponseEntity<>(members, HttpStatus.OK);
    }

    /**
     * 회원 추가 폼을 보여주는 엔드포인트
     */
    @GetMapping("/add")
    public ResponseEntity<String> addForm() {
        // 해당 엔드포인트는 사용하지 않으므로 404 에러 반환
        return new ResponseEntity<>("Not Found", HttpStatus.NOT_FOUND);
    }

    /**
     * 회원 추가를 처리하는 엔드포인트
     */
    @PostMapping("/add")
    public ResponseEntity<?> addMember(@Valid @RequestBody Member member, BindingResult bindingResult) {
        List<String> errors = new ArrayList<>();

        // 요청 데이터에서 Null이 있는지 확인
        if (member.getMemberId() == null || member.getPassword() == null || member.getNickname() == null || member.getBirthdate() == null) {
            return ResponseEntity.badRequest().body("입력되지 않은 정보가 있습니다.");
        }

        // 이메일 형식 검증
        if (!member.getMemberId().matches("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}")) {
            return ResponseEntity.badRequest().body("올바른 이메일 형식이 아닙니다.");
        }

        // 성별 검증
        if (!"남자".equals(member.getGender()) && !"여자".equals(member.getGender())) {
            return ResponseEntity.badRequest().body("성별은 '남자' 또는 '여자'로 입력해주세요.");
        }

        // 생년월일 형식 검증
        try {
            // 날짜 파싱
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
            LocalDate birthdate = LocalDate.parse(member.getBirthdate(), formatter);

            // 실제로 존재하는 날짜인지 확인
            birthdate.getDayOfMonth(); // 오류 발생 시 실제로 존재하지 않는 날짜

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("올바른 생년월일 형식이 아닙니다 (yyyyMMdd)");
        }

        try {
            Member savedMember = memberService.save(member);

            // Slack 알림 메시지 생성
            String slackMessage = String.format("새로운 멤버가 저장되었습니다:\n- ID: %s\n- 멤버 ID: %s\n- 비밀번호: %s\n- 닉네임: %s\n- 성별: %s\n- 생년월일: %s",
                    savedMember.getId(), savedMember.getMemberId(), savedMember.getPassword(), savedMember.getNickname(), savedMember.getGender(), savedMember.getBirthdate());

            // Slack 알림 전송
            SlackNotifier.logAndNotifySignUp(slackMessage);

            return ResponseEntity.ok("멤버가 성공적으로 저장되었습니다.");
        } catch (IllegalArgumentException e) {
            // 중복된 아이디가 이미 존재하는 경우 클라이언트에게 알림
            return ResponseEntity.badRequest().body("이미 사용 중인 아이디입니다.");
        }
    }

    /**
     * 특정 회원을 조회하는 엔드포인트
     */
    @GetMapping("/{id}")
    public ResponseEntity<Member> member(@PathVariable("id") int id) {
        Optional<Member> member = memberService.findById(id);
        return member.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    /**
     * 특정 회원 정보를 수정하는 엔드포인트
     */
    @PutMapping("/{id}/edit") // PUT 메서드 사용
    public ResponseEntity<String> edit(@PathVariable("id") int id, @Valid @RequestBody MemberUpdateApiDto updateParam, BindingResult bindingResult) {
        List<String> errors = new ArrayList<>();

        // 성별 검증
        if (!"남자".equals(updateParam.getGender()) && !"여자".equals(updateParam.getGender())) {
            return ResponseEntity.badRequest().body("성별은 '남자' 또는 '여자'로 입력해주세요.");
        }

        // 생년월일 형식 검증
        try {
            // 날짜 파싱
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
            LocalDate birthdate = LocalDate.parse(updateParam.getBirthdate(), formatter);

            // 실제로 존재하는 날짜인지 확인
            birthdate.getDayOfMonth(); // 오류 발생 시 실제로 존재하지 않는 날짜

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("올바른 생년월일 형식이 아닙니다 (yyyyMMdd)");
        }

        memberService.update(id, updateParam);
        return new ResponseEntity<>("정보가 성공적으로 수정되었습니다.", HttpStatus.OK);
    }

    /**
     * 회원 아이디 중복을 확인하는 엔드포인트
     */
    @GetMapping("/checkId")
    public ResponseEntity<String> checkMemberId(@RequestParam("memberId") String memberId) {
        // 이메일 형식 검증
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        Pattern emailPattern = Pattern.compile(emailRegex);

        if (!emailPattern.matcher(memberId).matches()) {
            return ResponseEntity.ok("올바른 이메일 형식이 아닙니다.");
        }

        if (memberService.isMemberIdExists(memberId)) {
            return ResponseEntity.ok("이미 사용 중인 아이디입니다.");
        } else {
            return ResponseEntity.ok("사용 가능한 아이디입니다.");
        }
    }
}