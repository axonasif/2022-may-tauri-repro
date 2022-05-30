FROM rust:1.61-slim-bullseye as builder
WORKDIR /opt/overtone
COPY . .
RUN apt update -yq && \
	apt install -yq libwebkit2gtk-4.0-dev \
	build-essential \
	curl \
	wget \
	libssl-dev \
	libgtk-3-dev \
	libayatana-appindicator3-dev \
	librsvg2-dev && \
	apt autoremove && \
	apt clean && \
	rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*
RUN cd src-tauri && cargo build --release

FROM gitpod/workspace-full-vnc
WORKDIR /opt/overtone
RUN apt update -yq && \
	apt upgrade -yq && \
	apt install -yq libgtk-3-dev && \
	apt autoremove && \
	apt clean && \
	rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*
COPY --from=builder /opt/overtone/src-tauri/target/release/ /opt/overtone
ENTRYPOINT ["overtone"]