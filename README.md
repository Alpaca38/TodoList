# TodoList
![image](https://github.com/Alpaca38/TodoList/assets/137505484/a49aaa38-3d38-4a16-9ae7-56080e7930c2)
<img width="282" alt="스크린샷 2023-08-29 오후 4 55 27" src="https://github.com/Alpaca38/TodoList/assets/137505484/33739e46-ba4e-420f-abe2-744c5c37c2f9">

- Model: 데이터를 처리하는 역할
    - 앱에서 사용되는 데이터를 다루는 영역
    - 데이터의 저장, 수정, 삭제를 담당
    - 데이터의 상태 변경에 대한 알림을 View 혹은 Controller에 전달
- View: UI를 표시하는 역할
    - 앱 사용자가 보게 되는 부분 담당(UIView등)
    - 데이터를 표시하고 사용자의 입력을 받아 처리
    - 데이터의 변경을 감지하여 변경된 내용을 화면에 반영
- Controller: Model과 View사이의 인터페이스 역할
    - Model과 View 사이에서 데이터를 주고받는 역할
    - View에서 발생하는 이벤트를 처리, Model을 업데이트
    - Model에서 변경된 내용을 View에 전달하여 화면을 업데이트
