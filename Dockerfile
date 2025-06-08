FROM openjdk:17-jdk-slim

RUN useradd -m green-user

WORKDIR /app

USER green-user

ENV APP_ENV=production

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]