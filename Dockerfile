FROM ubuntu:latest

COPY ./packages.txt ./packages.txt
RUN apt update && apt upgrade && xargs apt install -y --no-install-recommends < ./packages.txt && rm ./packages.txt
RUN curl -fsSL https://tailscale.com/install.sh | sh

RUN mkdir -p /var/run/tailscale /var/cache/tailscale /data/tailscale /data/home
ARG USER="austin"
RUN mkdir -p /data/home/${USER}
RUN ln -s /data/home/${USER} /home/${USER}
RUN useradd --shell /bin/bash ${USER}

RUN echo "%${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
ENV USER_ARG=${USER} 

COPY ./entrypoint.sh /entrypoint.sh
COPY ./start.sh /start.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/start.sh"]
