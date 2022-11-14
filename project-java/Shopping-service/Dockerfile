# We use a multi-stage dockerfile to build our image
# In the first stage of our build, we use a maven 3.6.1 parent image to create our maven build
FROM maven:3.6.1-jdk-8-alpine AS MAVEN_BUILD

# we then copy the pom.xml and src code files to the docker container
COPY ./ ./

# package our application code used for building our .jar artifacts
RUN mvn clean package

# In the second stage of our build, we use open jdk 8 on alpine 3.9 to build a light weight image
FROM openjdk:8-jre-alpine3.9

# Here,we copy only the artifacts we need from the first stage and discard the rest
COPY --from=MAVEN_BUILD /target/shopping-0.0.1-SNAPSHOT.jar /shopping.jar

# Lastly, we set the startup command to execute the jar
CMD ["java", "-jar", "/shopping.jar"]
