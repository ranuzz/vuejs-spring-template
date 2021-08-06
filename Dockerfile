FROM openjdk:11

RUN apt-get update && apt-get install -y -q --no-install-recommends \
        maven \
    && rm -rf /var/lib/apt/lists/*

COPY mvnw /usr/src/project/
COPY mvnw.cmd /usr/src/project/
COPY pom.xml /usr/src/project/
COPY .mvn/ /usr/src/project/.mvn
COPY api/ /usr/src/project/api
COPY webapp/ /usr/src/project/webapp

RUN cd /usr/src/project/api/src/main/resources && mkdir public

WORKDIR /usr/src/project

RUN mvn clean install

CMD ["java", "-jar",  "api/target/api-0.0.1-SNAPSHOT.jar"]