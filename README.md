# 의사결정
* 오전, 오후에 1번씩 하루에 두번 회의하기.
* 1시간이상 고민하지 말고, 팀원끼리 이야기해보기
* 우선은 아이데이션, —> 다 모은뒤 비판.
* 자기가 하루 동안 구현할 기능내에서 자율적으로 집중업무.

# 회의
* 월요일은 일주일동안 할것들 결정하되, 화~금은 스크럼회의를 하되, 1시간은 넘기지 않을 것.
* 버그수정시 같은 트랙팀원과 먼저 해결을 시도해본다. 이후 전체 회의
* 회의시 4명이 돌아가면서 각자한것, 각자할것, 문제점, 이슈, 해결방법 공유.
* 같은 파일 동시에 만지지 x -> Github

# 코딩스타일

## iOS
* 최대한 MARK를 활용한다. (모델, 메소드-> 함수설명을 최대한 자세하게(예외케이스, 인풋 아웃풋 예시, 테스트케이스 파일 이름,위치))
* 변수-> 소문자 카멜케이스, 클래스, 함수-> 대문자 카멜케이스
* 코멘트는 한글이나 영어(이해하기 쉽도록)
* 조건문 작성시, 평행하게 (switch문 활용)
* MVC역할 구분을 철저하게한다. (연관된 기능끼리 묶자)
* 페이지단위로 모델을 만든다. -> 네트워크, 키체인등은 따로 모델만들자
* (클래스 변수가 없는 경우는 static으로 만든다.) 메소드의 위치가 불분명한 경우에는 클래스 인스턴스를 만들어서 이 메소드가 어디서 온건지 확인할 수 있도록하자.
* Swift의 기본 데이터타입에서 기능추가를 구현할경우 extension을 이용하도록 노력한다.
* IBOulet : 라벨은 Label붙히기, 버튼은 Button 등 정확하게 명시해주기
* IBAction : Touched붙히기.
* Notification은 한 파일내에서 보이지 않으므로, Notification쓸 때는 observer와 post가 어디에있는지 명시해주기.
* 각자 컴퓨터에 백업해놓기
* 한파일 동시 수정하지않기.
* 페이지단위로 각자 기능구현하기
* 만약, 데이터가 다른페이지에 전달되거나, 다른페이지에 영향을 줄 경우, 같이 코딩한다.
* iOS 버전 10부터 지원.
* 기기는 iOS 6s+ => 시간남으면 다른 기기 constraint.

## Web
### HTML, CSS
* html, css에 `class`위주로 선언.
* css 주석은 `//`로.
* css `>` 은 잘 쓰지 않는걸로.
* `_`(underscore)사용. `-`(dash)사용 하지않기.

### Javscript
* 브라우저 호환성을 위해 `var` 사용.
* webpack 사용.
* TDD 및 테스트 코드 작성은 안하는 걸로.
* CI툴도 안쓰기.
* `_`(underscore) 쓰지말고 카멜케이스 사용.
* variable, function name은 소문자로 시작.
* function name의 시작은 동사로.
* class 이름은 대문자로 시작.
* variable name은 클라스 이름과 같게 (소문자 시작).
* `jQuery`사용.
* `jQuery`로 select 한 변수앞에 `$`를 붙인다.
* `Handlebar.js` 사용.
* 최대한 `evt.preventDefault()`를 이벤트 붙일때 마다 쓰기
* 브라우저는 크롬, 파폭, ie 사용

### iOS Branch 전략: 아래 형식 반복.
          web
        /
 master -- ios --- zedd ----------------------------------------
                \          \-- dev_i ------------- --/
                 \                 \--function_i--/
                   - dain --------------------------------------
                           \-- dev_i ------------- --/
                                   \--function_i--/

# 기획서
[구글드라이브 문서 링크](https://docs.google.com/document/d/1AHdONY6_3FR-DGF7IWhJUiFNdX7lf49PIo1fCVrTros/edit)     
[백로그 및 기능명세서](https://docs.google.com/spreadsheets/d/1sQyVqDMxfOASDL2I1s4a0OMeQKsRfXXmT3WpCvXb9EU/edit#gid=1784502406)
