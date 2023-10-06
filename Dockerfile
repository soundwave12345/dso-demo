FROM maven:3.6.3-openjdk-17 as BUILD
WORKDIR /app
COPY . .
RUN mvn package -DskipTests


FROM openjdk:22-slim AS RUN
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar
ARG USER=devops
ENV HOME /home/$USER
RUN adduser --disabled-login $USER && \
chown $USER:$USER /run/demo.jar
RUN apt-get update \
 && apt-get install -y curl
HEALTHCHECK --interval=30s --timeout=10s --retries=2 --start-period=20s \
CMD curl -f http://localhost:8080/ || exit 1
USER $USER

EXPOSE 8080
CMD java  -jar /run/demo.jar
 