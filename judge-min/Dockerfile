FROM dmoj/judge-small

ENV DMOJ_HOST "0.0.0.0"
ENV JUDGE_NAME "judge"
ENV KEY "key"


COPY docker-entry /docker-entry


USER root
RUN chown judge /docker-entry

USER judge

ENTRYPOINT ["/docker-entry"]