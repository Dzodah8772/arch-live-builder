FROM archlinux:base

RUN pacman -Syu --noconfirm archiso git sudo bash \
    && pacman -Scc --noconfirm

WORKDIR /workspace

COPY . /workspace

RUN chmod +x /workspace/scripts/build.sh

ENTRYPOINT ["bash", "/workspace/scripts/build.sh"]
