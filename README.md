# 플러스투두 - 아이젠아워 매트릭스를 이용한 투두 모바일 애플리케이션 서비스
![프레젠테이션1](https://github.com/user-attachments/assets/b945c89a-d38b-4cba-bffe-5acb23d51084)

## Description

플러스투두는 아이젠아워 매트릭스를 이용하여 사용자가 작성한 투두 리스트에 대해 한 눈에 쉽게 파악할 수 있다. 
아이젠아워 매트릭스란 중요도와 긴급도를 기반으로 하는 해야할 일을 사분면에 표시한 매트릭스이다. 
사용자가 작성한 투두 리스트를 중요도와 긴급도를 기반으로 사분면에 표시하여 먼저 해야할 일을 한눈에 알 수 있도록 도와준다.

## Features

### **홈 화면**
- 사용자가 작성한 할 일을 아이젠하워 매트릭스에 표시하는 화면이다.
- 남은 할 일 수를 한눈에 볼 수 있다.
- 화면 최하단에는 보고싶은 할 일 목록을 선택할 수있어 간단하게 볼 수 있다.

![홈 화면](https://github.com/user-attachments/assets/46442e4a-388c-480d-8e3e-83d3bb069e99)
![홈 화면 필터 카드 선택](https://github.com/user-attachments/assets/a1f78805-96ac-4cd9-b90c-b058c136e479)

### **캘린더 화면**
- 해당 날짜에 대한 할 일 목록을 볼 수 있다.
- 해당 날짜에 할 일의 개수를 알 수 있다.
    - 3개까지는 점으로 표시되며, 4개 이상일 시 막대기로 표시된다.
- 캘린더의 날짜를 두 번 터치 시 해당 날짜에 바로 할 일을 추가할 수 있다.
  
![캘린더 화면 오늘 날짜](https://github.com/user-attachments/assets/f4a7a3ee-b180-45c4-9fbe-e248d8dd6beb)
![캘린더 화면 날짜 선택](https://github.com/user-attachments/assets/568c002e-b64f-4082-a4c9-521c88802112)

### **할 일 추가 화면**
- 할 일 제목, 메모, 마감일, 긴급도와 중요도를 작성하여 새로운 할 일을 추가할 수 있다.
- 사용자가 지정하여 날짜를 선택할 수 있고, 간단하게 터치 한 번으로 날짜를 지정할 수 있다.
  
![새로운 할 일 화면](https://github.com/user-attachments/assets/56556502-c448-4961-9482-3dac46f1937e)

### **할 일 목록 화면**
- 사용자가 작성한 할 일을 목록별로 볼 수 있는 화면이다.
- 할 일 제목, 마감일, 긴급도와 중요도가 표시된다.
    - 마감일이 지났을 경우, 빨간 텍스트의 미뤄진 일이 표시된다.
- 사용자별로 긴급도 및 중요도를 우선 순위로 하여 정렬할 수 있다.
- 목록을 터치 시 작성한 할 일의 상세 정보를 볼 수 있다.
- 완료된 할 일 목록을 토글할 수 있다.
  
![할 일 목록 화면](https://github.com/user-attachments/assets/36b0cb77-c8df-4c16-a39f-9e39737682de)
![할 일 상세보기](https://github.com/user-attachments/assets/3fff427d-fecd-4706-8476-cd979c58f41b)
![할 일 목록 화면 완료된 할 일 보기](https://github.com/user-attachments/assets/458e2b90-e0f1-4742-bebb-561f042cdbbd)
![완료된 할 일 상세 보기](https://github.com/user-attachments/assets/09638c77-7754-4277-bab2-bb816d836a4f)

### ** 설정 화면**
- 오늘 해야 할 일 개수를 알려주는 알림을 끄고 킬 수 있고, 시간을 설정할 수 있다.
- 캘린더의 시작 요일과 강조 표시를 설정할 수 있다.
  
![설정 화면](https://github.com/user-attachments/assets/f47421e0-3976-4303-bbe7-ea0b0be9f670)

## Development enviroment

`Flutter-SDK` : 3.22.3

`Dart` : 3.2.2

`상태관리` : Riverpod

`데이터베이스` : Isar

## Git rule

### **Tag type**

- `Init` : 프로젝트 생성
- `Feat` : 새로운 기능 추가
- `Mod` : 코드 수정
- `Docs` : 문서 수정
- `Design` : 디자인 수정
- `Minor` : 사소한 코드 수정
- `Refactor` : 코드 리팩토링

### **Commit**

- `태그: 커밋 내용` 의 규칙으로 작성
- 커밋 제목은 영어로 간단하게 작성, 내용은 한글로 작성
