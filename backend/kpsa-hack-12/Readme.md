# Database Schema Documentation

## Description
이 문서는 데이터베이스 스키마의 설계와 테이블 간의 관계를 설명합니다. 이 스키마는 사용자 정보, 레벨, 증상, 행동, FCM 토큰 관리, 그리고 사용자 채팅 로그 등을 저장하고 관리하기 위해 설계되었습니다.

---

## Tables Overview

### 1. **`member`**
회원 정보를 저장하는 테이블입니다.

| Column        | Type         | Nullability | Description                          |
|---------------|--------------|-------------|--------------------------------------|
| `idx`         | BIGINT       | NOT NULL    | 순번 (Primary Key, AUTO_INCREMENT)  |
| `id`          | BIGINT       | UNIQUE      | SNS Social ID (고유값)              |
| `email`       | VARCHAR(255) | Nullable    | 이메일                               |
| `name`        | VARCHAR(100) | Nullable    | 이름                                 |
| `nickname`    | VARCHAR(50)  | Nullable    | 닉네임                               |
| `birth`       | VARCHAR(10)  | Nullable    | 생년월일                             |
| `gender`      | VARCHAR(5)   | Nullable    | 성별                                 |
| `status`      | VARCHAR(20)  | NOT NULL    | 상태 (예: ACTIVE, INACTIVE)          |
| `visited`     | BIGINT       | NOT NULL    | 방문 횟수                            |
| `response_cnt`| BIGINT       | NOT NULL    | 대처 횟수                            |
| `created_at`  | TIMESTAMP    | NOT NULL    | 생성 시각 (`CURRENT_TIMESTAMP`)     |
| `updated_at`  | TIMESTAMP    | NOT NULL    | 업데이트 시각 (ON UPDATE CURRENT_TIMESTAMP) |

---

### 2. **`Symptoms`**
사용자가 가진 증상을 저장하는 테이블입니다.

| Column        | Type         | Nullability | Description   |
|---------------|--------------|-------------|---------------|
| `idx`         | BIGINT       | NOT NULL    | 순번 (Primary Key, AUTO_INCREMENT) |
| `symptoms`    | VARCHAR(255) | Nullable    | 증상 이름     |

---

### 3. **`actions`**
특정 상황 및 행동을 저장하는 테이블입니다.

| Column        | Type         | Nullability | Description   |
|---------------|--------------|-------------|---------------|
| `idx`         | BIGINT       | NOT NULL    | 순번 (Primary Key, AUTO_INCREMENT) |
| `space`       | VARCHAR(255) | Nullable    | 상황 이름     |

---

### 4. **`member_level`**
회원의 레벨, 선택 공간 및 점수를 관리하는 테이블입니다.

| Column         | Type         | Nullability | Description                          |
|----------------|--------------|-------------|--------------------------------------|
| `idx`          | BIGINT       | NOT NULL    | 순번 (Primary Key, AUTO_INCREMENT)  |
| `member_id`    | BIGINT       | NOT NULL    | `member.id`와 연결된 외래 키         |
| `level`        | VARCHAR(255) | Nullable    | 사용자 레벨                          |
| `choice_space` | TEXT         | Nullable    | 사용자가 선택한 공간 (최대 6개)      |
| `total_score`  | VARCHAR(255) | Nullable    | 사용자의 현재 점수                   |

**Relationships**
- Foreign Key: `member_id REFERENCES member(id) ON DELETE CASCADE`

---

### 5. **`level_info`**
레벨별 메타데이터를 저장하는 테이블입니다.

| Column        | Type         | Nullability | Description               |
|---------------|--------------|-------------|---------------------------|
| `level`       | VARCHAR(255) | NOT NULL    | 사용자 레벨 (Primary Key) |
| `one_line_text`| VARCHAR(255)| Nullable    | 한 줄 요약                |
| `emotion_text` | VARCHAR(255)| Nullable    | 감성 메시지               |
| `courage_text` | VARCHAR(255)| Nullable    | 용기 안내 메시지          |

---

### 6. **`member_llm_data`**
회원의 채팅 정보를 저장하는 테이블입니다.

| Column        | Type         | Nullability | Description              |
|---------------|--------------|-------------|--------------------------|
| `idx`         | BIGINT       | NOT NULL    | 순번 (Primary Key, AUTO_INCREMENT) |
| `member_id`   | BIGINT       | NOT NULL    | `member.id`와 연결된 외래 키        |
| `member_logs` | MEDIUMTEXT   | Nullable    | 사용자의 채팅 로그        |

**Relationships**
- Foreign Key: `member_id REFERENCES member(id) ON DELETE CASCADE`

---

### 7. **`fcm_token_manage`**
Firebase Cloud Messaging(FCM) 토큰 관리를 위한 테이블입니다.

| Column        | Type         | Nullability | Description            |
|---------------|--------------|-------------|------------------------|
| `member_id`   | BIGINT       | NOT NULL    | `member.id`와 연결된 외래 키  |
| `token`       | VARCHAR(255) | Nullable    | FCM 토큰               |

**Relationships**
- Foreign Key: `member_id REFERENCES member(id) ON DELETE CASCADE`

---

## Table Relationships
1. `member` → `member_level`: **1 대 1 관계**
    - 외래 키: `member_level.member_id REFERENCES member.id`

2. `member` → `member_llm_data`: **1 대 다 관계**
    - 외래 키: `member_llm_data.member_id REFERENCES member.id`

3. `member` → `fcm_token_manage`: **1 대 1 관계**
    - 외래 키: `fcm_token_manage.member_id REFERENCES member.id`

4. `member_level` → `level_info`: **N 대 1 관계**
    - 외래 키: `level_info.level REFERENCES member_level.level`

---

## Features
- **정규화된 구조**: 데이터 정합성을 유지하고 중복 데이터를 줄이도록 설계.
- **확장 가능**: 추후 새로운 레벨, 증상, 행동 등을 쉽게 추가 가능.
- **외래 키 연동**: 회원 삭제 시 관련 데이터를 자동으로 삭제 (`ON DELETE CASCADE`).
- **FCM 통합**: Firebase Cloud Messaging을 사용한 푸시 알림 관리.

---

## ERD Diagram
아래는 간단한 테이블 간 관계를 시각화한 ERD 다이어그램입니다:
