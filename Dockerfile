FROM ghcr.io/nousresearch/hermes-agent:v2026.9.7

USER root

COPY --chown=hermes:hermes hermes-config.yaml /opt/luke-hermes/config.yaml
COPY --chown=hermes:hermes start-hermes.sh /opt/luke-hermes/start-hermes.sh
RUN chmod 0755 /opt/luke-hermes/start-hermes.sh

ENV HERMES_HOME=/opt/data
EXPOSE 8642

CMD ["sh", "/opt/luke-hermes/start-hermes.sh"]
