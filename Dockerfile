FROM python:3.13-slim-bookworm

# Hermes comes from DNA Web's fork, dnawebai/hermes-agent. Its main branch mirrors Nous Research's upstream, so this pin
# installs the same code as before; the fork lets DNA Web patch Hermes without waiting on upstream.
ARG HERMES_REPO=dnawebai/hermes-agent
ARG HERMES_COMMIT=24fd22b94df040d843eb280ff197a4bcd99a6fc3

ENV DEBIAN_FRONTEND=noninteractive \
    HERMES_HOME=/opt/data \
    HERMES_INSTALL_DIR=/usr/local/lib/hermes-agent \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash ca-certificates curl git openssh-client build-essential ffmpeg ripgrep \
    && rm -rf /var/lib/apt/lists/*

# The installer at this commit hard-codes the upstream repository, so point its clone at the fork. The checks after
# the install fail the build unless the fork at exactly the pinned commit was installed.
RUN curl -fsSL --retry 3 \
      "https://raw.githubusercontent.com/${HERMES_REPO}/${HERMES_COMMIT}/scripts/install.sh" \
      -o /tmp/hermes-install.sh \
    && sed -i "s#NousResearch/hermes-agent\.git#${HERMES_REPO}.git#g" /tmp/hermes-install.sh \
    && grep -q "${HERMES_REPO}.git" /tmp/hermes-install.sh \
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
    && test "$(git -C "${HERMES_INSTALL_DIR}" remote get-url origin)" = "https://github.com/${HERMES_REPO}.git" \
    && test "$(git -C "${HERMES_INSTALL_DIR}" rev-parse HEAD)" = "${HERMES_COMMIT}" \
    && hermes --version

RUN mkdir -p /opt/luke-hermes /opt/data
COPY hermes-config.yaml /opt/luke-hermes/config.yaml
COPY start-hermes.sh /opt/luke-hermes/start-hermes.sh
RUN chmod 0755 /opt/luke-hermes/start-hermes.sh

EXPOSE 8642
CMD ["sh", "/opt/luke-hermes/start-hermes.sh"]
