FROM python:3.13-slim-bookworm

ARG HERMES_COMMIT=24fd22b94df040d843eb280ff197a4bcd99a6fc3

ENV DEBIAN_FRONTEND=noninteractive \
    HERMES_HOME=/opt/data \
    HERMES_INSTALL_DIR=/usr/local/lib/hermes-agent \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash ca-certificates curl git openssh-client build-essential ffmpeg ripgrep \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL --retry 3 \
      "https://raw.githubusercontent.com/NousResearch/hermes-agent/${HERMES_COMMIT}/scripts/install.sh" \
      -o /tmp/hermes-install.sh \
    && chmod 0755 /tmp/hermes-install.sh \
    && /tmp/hermes-install.sh \
      --skip-setup \
      --skip-browser \
      --skip-computer-use \
      --non-interactive \
      --commit "${HERMES_COMMIT}" \
      --force-commit \
      --dir "${HERMES_INSTALL_DIR}" \
      --hermes-home "${HERMES_HOME}" \
    && rm -f /tmp/hermes-install.sh \
    && hermes --version

RUN mkdir -p /opt/luke-hermes /opt/data
COPY hermes-config.yaml /opt/luke-hermes/config.yaml
COPY start-hermes.sh /opt/luke-hermes/start-hermes.sh
RUN chmod 0755 /opt/luke-hermes/start-hermes.sh

EXPOSE 8642
CMD ["sh", "/opt/luke-hermes/start-hermes.sh"]
