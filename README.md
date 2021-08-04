---
title: "VueJS Spring boot project Scaffold"
date: 2021-07-21T23:27:20+05:30
summary: 'Setting a template project with VueJS and Spring Boot'
tags: ["vuejs", "spring", "java"]
---


## The Project

This post is about setting up a web application project with VueJS frontend and spring boot backend. The project will compile as a single fat jar which will include both frontend and backend components. Maven will handle both UI and API builds.
Choose a name for the project `vuejs-spring-template`, write a little readme in the project directory and then follow up.

Finished code is [here]()

## VueJS Scaffold

* Make sure you have latest version of `node` installed, I suggest using nvm to manage multiple version

```sh
# default -> v14.16.1
nvm list
```

* Install vue-cli
```sh
# version 4.5+
npm install -g @vue/cli
```

* Create webapp for the project
Make sure to select the feature manually and select `vuex` and `Router`.

```sh
# vuejs version 3+
vue create webapp
```


## Spring Boot Scaffold

* Make sure java version is 11+
```sh
java -version
```

* Go to `https://start.spring.io/`. Use the preselected versions and project setting (Maven, Spring 2.5.3, Java 11) and fill up the required fields.
* give your project a name `api`
* add `Spring Data JPA` and `Spring Web` Dependency
* Export the scaffold and copy the folder in project directory

## Project Directory

At this point your project directory should look like this.

```sh
├── README.md
├── api
└── webapp
```

Since this whole project will be built using `maven`, its time to move some files and make sure that `pom` files are managing all aspects of build and publishing.
* go to `api` directory
* move `.mvn`, `mvnw`, `mvnw.cmd` and `pom.xml` from `api` directory to the project root
* Create `pom.xml` in `webapp` and `api` folder

We have `three` `pom.xml` files now and we will edit them one-by-one. The project directory should now be looking like this.

```sh
.
├── README.md
├── api
│   ├── HELP.md
│   ├── pom.xml
│   └── src
├── mvnw
├── mvnw.cmd
├── pom.xml
└── webapp
    ├── README.md
    ├── babel.config.js
    ├── --
    ├── package-lock.json
    ├── package.json
    ├── pom.xml
    ├── public
    └── src
```

## Project `pom.xml`

* Remove `build`, `dependencies` and `properties` section
* Add the `module` section that points to `webapp` and `api` projects.
* make sure packaging is pom : `<packaging>pom</packaging>`
* Artifact Id is project name

[Final]()

## WebApp `pom.xml`

* This is going to be blank at the start.
* `<parent>` tag will refer to the project `pom`
* We will be using `https://github.com/eirslett/frontend-maven-plugin` to compile the VueJS project.

[Final]()

## API `pom.xml`

* `<parent>` tag will refer to the project `pom`
* Most of the component will remain the same from the initial version
* Use `maven-resources-plugin` to copy VueJS build files
```xml
<plugin>
    <artifactId>maven-resources-plugin</artifactId>
    <executions>
        <execution>
        <id>copy Vue.js frontend content</id>
        <phase>generate-resources</phase>
        <goals>
            <goal>copy-resources</goal>
        </goals>
        <configuration>
            <outputDirectory>src/main/resources/public</outputDirectory>
            <overwrite>true</overwrite>
            <resources>
            <resource>
                <directory>${project.parent.basedir}/webapp/dist</directory>
                <includes>
                <include>css/</include>
                <include>img/</include>
                <include>js/</include>
                <include>index.html</include>
                <include>favicon.ico</include>
                </includes>
            </resource>
            </resources>
        </configuration>
        </execution>
    </executions>
</plugin>
```
* `H2` will be used for DB

## Compile and Run

* mvn clean install
* java -jar api/target/api-0.0.1-SNAPSHOT.jar

This will display the VueJS generated web app at the root url `http://localhost:8080.`

## API

This was just the build and integration stuff. To make a real application I'll create an API endpoint and add some dummy data to it then I'll use VueJS frontend to call that API to fetch and display that data.

Since the `jar` build is for production and deploy everything from the same domain the `API` calls don't need any special handling.

## Dev Setup

But for development with fast reload and everything it is ideal to run the frontend and backend build separately. To do that add a config file in the `webapp` directory to proxy the api requests.

```js
// vue.config.js
module.exports = {
    devServer: {
      proxy: {
        '/api': {
          target: 'http://localhost:8083',
          ws: true,
          changeOrigin: true
        },
      }
    },
    outputDir: 'target/dist',
    assetsDir: 'static',
    lintOnSave: false
};
```

Make sure that spring server is running at port `8083` by adding `server.port=8083` in `application.properties`. Then run both builds independently and develop.

```sh
cd api
mvn clean install
java -jar target/api-0.0.1-SNAPSHOT.jar
```

```sh
cd webapp
npm run serve
```
