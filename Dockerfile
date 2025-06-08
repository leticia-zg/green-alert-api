FROM openjdk:17-jdk-slim

RUN useradd -m green-user

WORKDIR /app

# Copia o arquivo JAR gerado para a imagem
COPY target/*.jar app.jar

# Muda o usuário para o criado anteriormente
USER green-user

ENV APP_ENV=production

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
