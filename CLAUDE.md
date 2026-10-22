# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 저장소 개요

k8s 환경 문제 진단용 유틸리티 Docker 이미지 저장소다. 하나의 이미지 = Dockerfile을 담은 하나의 디렉토리라는 규약이고, 현재 이미지는 `macgyver/` 하나다 (mysql-client, redis-cli, kubectl, jq, grpcurl, rclone, vegeta, ali, websocketd, aws-shell, iredis 등을 담은 스위스아미칼).

- 이미지: `ghcr.io/unchartedsky/macgyver`
- 런타임 사용 예: `kubectl run -it --rm test --image unchartedsky/macgyver -- bash`

과거 해결 사례는 `docs/solutions/`에 문서화한다 — 버그·베스트프랙티스·워크플로 패턴을 카테고리별로 정리하고, 각 문서는 `module`, `tags`, `problem_type` 필드의 YAML frontmatter를 갖는다.

## 명령어

```bash
# 전체 이미지 빌드 (Dockerfile을 담은 디렉토리를 자동 탐색)
make image          # ghcr.io/unchartedsky/<디렉토리명>:<단축sha> + latest 태그

# 빌드 + GHCR 푸시
make deploy

# 단일 이미지 로컬 빌드
docker buildx build -t ghcr.io/unchartedsky/macgyver:dev macgyver/

# 멀티아치 빌드 (CI와 동일)
docker buildx build --platform linux/amd64,linux/arm64 macgyver/
```

테스트·린트는 없다. 검증은 빌드 성공이 전부다.

## CI/CD

`.github/workflows/dockerimage.yml` (Dockerize): main 브랜치 푸시 중 `macgyver/**` 또는 워크플로 파일 자체가 바뀔 때만 멀티아치(amd64+arm64) 빌드해 GHCR로 푸시한다. 태그는 `sha-<단축sha>`와 `latest` 두 개다. 캐시는 `type=gha`.

## Dockerfile 작업 시 주의점

과거 CVE 2,708건 해소 작업에서 정착한 규약이다.

- **베이스 이미지 태그 고정** — 부동 태그(`python:3`)를 쓰면 업스트림 업데이트가 CVE 폭탄을 그대로 실어 온다. `python:3.15-bookworm`처럼 구체적으로 고정한다.
- **멀티아치 다운로드** — GitHub 릴리스 바이너리는 `${TARGETOS}/${TARGETARCH}`로 아치를 맞춘다. 단, 에셋 명명이 아치마다 다르면(grpcurl의 `x86_64`) case로 매핑한다. arm64 에셋이 아예 없는 도구(slackcat)는 `if [ "${TARGETARCH}" = "amd64" ]` 가드로 amd64 전용 설치한다.
- **apt 저장소 키** — kubic 저장소는 Debian 12 + gpg 키링 방식(`/usr/share/keyrings/`)으로 등록한다. 옛 Debian 10 방식은 저장소가 죽어 있다.
- **Python 도구** — requirements.txt의 도구(aws-shell, iredis, raven-bash 등)는 `app` 사용자(uid 1000)로 `pip install --user` 하며, `~/.local/bin`이 PATH에 있다.
- **Sentry 연동** — `SENTRY_DSN` 환경변수로 런타임에 주입하며, 이벤트 전송은 raven-bash가 담당한다.

## 에이전트 작업 규약

After a solved, verified problem, offer once to invoke the `ce-compound` skill at the completion checkpoint only when the work produced durable project reasoning that is not readily recoverable from the final code, tests, types, comments, or existing documentation, and losing it would plausibly cause recurrence, material risk, or substantial rediscovery. Apply this counterfactual: if the learning document disappeared, would a future engineer reading the final implementation still be likely to repeat the mistake or redo substantial investigation? If not, do not offer. Completion, effort, and diff size alone are not enough. Offer at the checkpoint so a qualifying learning can ship in the PR that produced it, and only where the repository treats captured learnings as tracked, committed knowledge.

Write every report, summary, or handoff to the user through the `ce-noslop` skill. This applies when you are the top-level agent writing to the user, not when you are a subagent reporting to its caller. Do not apply it to code, config, verbatim quotes, or text the user asked to post as written.
