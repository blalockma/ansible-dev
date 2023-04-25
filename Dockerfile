FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl wget git build-essential sudo && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get install -y ansible && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS user
ARG TAGS
RUN addgroup --gid 1000 mason
RUN adduser --gecos mason --uid 1000 --gid 1000 --disabled-password mason
RUN adduser mason sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER mason
WORKDIR /home/mason

FROM user
COPY --chown=mason:mason . ./ansible-dev
