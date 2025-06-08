FROM openjdk:17-jdk-slim

RUN useradd -m green-user

WORKDIR /app

# Copia o JAR e já atribui a permissão ao usuário
COPY --chown=green-user:green-user minha-api.jar app.jar

USER green-user

ENV APP_ENV=production

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]