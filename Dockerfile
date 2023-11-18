ARG FROM_BASE=${DOCKER_REGISTRY:-s2.ubuntu.home:5000/}${CONTAINER_OS:-alpine}/openjdk/${JAVA_VERSION:-17.0.9_p8-r0}:${BASE_TAG:-latest}
FROM $FROM_BASE

# name and version of this docker image
ARG CONTAINER_NAME=kafka-eagle
# Specify CBF version to use with our configuration and customizations
ARG CBF_VERSION

# include our project files
COPY build Dockerfile /tmp/

# set to non zero for the framework to show verbose action scripts
#    (0:default, 1:trace & do not cleanup; 2:continue after errors)
ENV DEBUG_TRACE=0


ENV KAFKA_UID=1000
ARG KAFKA_USER_NAME=kafka
ARG KE_HOME=/opt/kafka-eagle

    
# kafka-eagle version being bundled in this docker image
ARG KAFKA_EAGLE_VERSION=3.0.1
LABEL version.kafka-eagle=$KAFKA_EAGLE_VERSION


# build content
RUN set -o verbose \
    && chmod u+rwx /tmp/build.sh \
    && /tmp/build.sh "$CONTAINER_NAME" "$DEBUG_TRACE" "$TZ" \
    && ([ "$DEBUG_TRACE" != 0 ] || rm -rf /tmp/*)


WORKDIR "$KE_HOME"
EXPOSE 8048 8080

ENTRYPOINT [ "docker-entrypoint.sh" ]
#CMD ["$CONTAINER_NAME"]
CMD ["kafka-eagle"]
