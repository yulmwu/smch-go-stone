# GO STONE (Rebuilt Maven Project)

이 프로젝트는 `old` 디렉토리에 있던 Eclipse 기반 JavaFX GUI 앱을 100% 동일하게 동작하도록 Maven 기반으로 재구성(new)한 것입니다.

## 구성 요약
- Java 11 타겟, OpenJFX 25 + JFoenix 9.0.10
- JDBC 드라이버: ojdbc8 (21.11.0.0) 사용, 필요 시 ojdbc6 호환 포함
- 로컬 실행 스크립트 제공 (macOS/ARM)
- Dockerfile/Compose 제공 (macOS ARM, Rocky Linux AMD64)
- Docker 이미지는 로컬 빌드된 JAR을 copy 후, 대상 플랫폼에 맞는 JavaFX 모듈 다운로드

## 소스 레이아웃
- `new/src/main/java/application/*.java`
- `new/src/main/resources/fxml/*.fxml`
- `new/src/main/resources/application/application.css`
- `new/vendor/` (자동 캐시: OpenJFX macOS용, JFoenix 9.0.10, ojdbc6.jar)

## 필수 조건
- Java 11+ JDK (macOS 로컬 실행용)
- macOS에서 Docker GUI 출력 시 XQuartz 설치 및 허용 설정 필요

## 데이터베이스 설정
애플리케이션은 Oracle DB를 사용합니다. 연결 불가 시 UI가 오래 멈추지 않도록 5초 타임아웃을 적용했습니다.

- 권장: 내장 Oracle XE 컨테이너 사용
  - DB 기동 및 대기: `bash new/scripts/docker/up-db.sh`
  - (필수) 스키마/계정 부트스트랩: `bash new/scripts/bootstrap-db.sh`
  - 접속 정보(로컬 기본값): `jdbc:oracle:thin:@localhost:1521/XEPDB1`, `scott/1231`

- 외부 Oracle 사용 시 환경변수 설정
  - `DB_URL` (예: `jdbc:oracle:thin:@host:1521/XEPDB1`)
  - `DB_USER` (기본: `scott`)
  - `DB_PASSWORD` (기본: `1231`)

## 로컬(macOS) 실행(권장 순서)
1) DB 기동: `bash new/scripts/docker/up-db.sh`
2) 스키마/계정 생성: `bash new/scripts/bootstrap-db.sh`
3) 앱 빌드: `bash new/scripts/build.sh`
4) 앱 실행: `bash new/scripts/run-macos.sh`
   - 첫 실행 시 OpenJFX(macOS/ARM)과 JFoenix 9.0.10, ojdbc8을 자동 다운로드해 `new/vendor/`에 캐시합니다.
   - 기본 DB는 `localhost:1521/XEPDB1`이며, `DB_URL/DB_USER/DB_PASSWORD`로 변경 가능합니다.

## Docker 빌드/실행
Dockerfile은 로컬에서 빌드한 JAR(`new/target/*.jar`)을 이미지에 copy합니다. 컨테이너 빌드 시 대상 플랫폼(x86_64/arm64)을 감지하여 JavaFX 플랫폼 전용 모듈을 Maven Central에서 받아옵니다.

- 공통 빌드: `new/scripts/docker/build.sh`
- macOS(ARM) 실행: `new/scripts/docker/run-macos.sh`
  - DB를 먼저 자동 기동(amd64 에뮬레이션). DISPLAY는 기본 `host.docker.internal:0`를 사용합니다.
  - 필요 시 `xhost + 127.0.0.1`로 XQuartz 접근 허용.
- Rocky Linux(AMD64) 실행: `new/scripts/docker/run-linux.sh`
  - 일반적으로 `DISPLAY=:0`, `/tmp/.X11-unix` 마운트 필요.
- Compose는 `oracle`(DB) + `go-stone`(앱)을 함께 실행하며, 앱 컨테이너에는 아래 환경변수가 주입됩니다.
  - `DB_URL=jdbc:oracle:thin:@oracle:1521/XEPDB1`
  - `DB_USER=scott`
  - `DB_PASSWORD=1231`

참고: `new/docker-compose.yml`에서 `DOCKER_PLATFORM`으로 앱 아키텍처(`linux/arm64`/`linux/amd64`), `DOCKER_DB_PLATFORM`으로 DB 아키텍처를 설정할 수 있습니다.

## 문제 해결(Troubleshooting)
- 버튼 클릭 시 앱 멈춤 → DB 미접속 가능성 높음
  - 확인: `nc -vz localhost 1521` 또는 컨테이너 내부 `nc -vz oracle 1521`
  - 본 구성은 연결 타임아웃 5초로 설정되어 오프라인 시 빠르게 에러 팝업
- ORA-28040 (Authentication) → ojdbc6 대신 ojdbc8 사용 (이미 스크립트/이미지에 반영)
- ORA-01017 (계정 불일치) → `bash new/scripts/bootstrap-db.sh`로 `SCOTT/1231` 및 스키마 생성

## 유틸 명령 요약
- DB 기동: `bash new/scripts/docker/up-db.sh`
- DB 스키마 생성: `bash new/scripts/bootstrap-db.sh`
- 로컬 빌드: `bash new/scripts/build.sh`
- 로컬 실행(macOS): `bash new/scripts/run-macos.sh`
- Docker 빌드: `bash new/scripts/docker/build.sh`
- Docker 실행(macOS/ARM): `bash new/scripts/docker/run-macos.sh`
- Docker 실행(Rocky/AMD64): `bash new/scripts/docker/run-linux.sh`
