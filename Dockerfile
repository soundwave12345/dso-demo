FROM maven:3.6.3-openjdk-17 as BUILD
WORKDIR /app
COPY . .
RUN mvn package -DskipTests


FROM openjdk:22-slim AS RUN
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar
EXPOSE 8080
CMD java  -jar /run/demo.jar
 