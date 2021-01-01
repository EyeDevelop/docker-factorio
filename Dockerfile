FROM ubuntu

RUN apt-get update -y && apt-get install -y bash curl tar xz-utils zip unzip

ENV PUID 1000
ENV PGID 1000
ENV FACTORIO_VERSION latest
ENV SAVENAME save
ENV RCON_PASSWORD adminadmin

COPY entrypoint.sh /entrypoint.sh
CMD [ "/entrypoint.sh" ]