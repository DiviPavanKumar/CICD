# Use Eclipse Temurin JDK 17 base image
FROM eclipse-temurin:17-jre

# Set the working directory inside the container
WORKDIR /opt/app

# Copy the Spring Boot jar file into the image
COPY target/spring-boot-web.jar app.jar

# Expose the default Spring Boot port (optional, useful for documentation)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
