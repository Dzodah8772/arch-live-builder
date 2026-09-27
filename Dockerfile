# CyberOS ISO build container
# Builds only CyberOS-standalone, not unrelated files from the repository.
FROM archlinux:base

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

RUN pacman -Syu --noconfirm \
      archiso \
      bash \
      coreutils \
      dosfstools \
      git \
      grep \
      gawk \
      parted \
      rsync \
      sed \
      sudo \
      util-linux \
    && pacman -Scc --noconfirm

WORKDIR /workspace

COPY CyberOS-standalone/ /workspace/

RUN chmod +x /workspace/build.sh \
    /workspace/airootfs/usr/local/bin/cyber-install \
    /workspace/tests/run-tests.sh \
    && bash /workspace/tests/run-tests.sh

ENTRYPOINT ["bash", "/workspace/build.sh"]
