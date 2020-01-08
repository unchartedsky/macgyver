![](https://github.com/unchartedsky/macgyver/workflows/.github/workflows/dockerimage.yml/badge.svg)
[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://hub.docker.com/r/unchartedsky/macgyver/)

# macgyver

mysql-client, redis-cli 등 k8s 환경에서 문제를 진단할 때 필요한 유틸리티 도커 이미지

``` bash
kubectl run -it --rm test --image unchartedsky/macgyver -- bash
```

## 참고 자료

- [ViktorStiskala/raven-bash](https://github.com/ViktorStiskala/raven-bash)
- [Sending Sentry Events from Bash](https://blog.sentry.io/2017/11/28/sentry-bash)
