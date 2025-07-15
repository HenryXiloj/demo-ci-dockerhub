# CI/CD with GitHub Actions, Docker Hub, and Spring Boot

This repository demonstrates how to build a CI/CD pipeline using **GitHub Actions** for a Spring Boot application built with **Maven**, containerized using **Docker**, and published to **Docker Hub**.

📘 Blog Post: [CI with GitHub Actions, Docker Hub, and Spring Boot](https://jarmx.blogspot.com/2022/09/ci-with-github-actions-docker-hub-and.html)

---

## 🛠 Technologies Used

- Spring Boot with Maven
- GitHub Actions for CI/CD
- Docker and Docker Hub
- Java 17

---

## 🚀 Workflow Overview

The CI/CD pipeline includes the following steps:

1. **Trigger**: On every push or pull request to the `master` branch.
2. **Checkout Code**: Uses `actions/checkout`.
3. **Build Project**: With Maven and JDK 17.
4. **Build Docker Image**: Using `docker/build-push-action`.
5. **Push to Docker Hub**: With GitHub secrets for credentials.

---

## 📂 GitHub Actions Workflow

The workflow file `.github/workflows/ci.yml`:

```yaml
name: Publish Docker Image

on:
  push:
    branches: [ "master" ]
  pull_request:
    branches: [ "master" ]

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Set up JDK 17
        uses: actions/setup-java@v2
        with:
          java-version: '17'
          distribution: 'adopt'
          cache: maven

      - name: Build with Maven
        run: mvn -B package --file pom.xml

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v2
        with:
          context: .
          push: true
          tags: dockerhubuser/dockerHubRepository:${{ github.run_number }}
```

---

## 🐳 Dockerfile

```dockerfile
FROM openjdk:17-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

---

## 🔐 GitHub Secrets

You need to configure the following secrets in your GitHub repository:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN` (can be generated from Docker Hub > Account Settings > Security)

---

## ▶️ Running the Workflow

Once set up, the workflow will automatically run on every push or pull request to `master`. It will:

- Build your Spring Boot JAR
- Build and tag the Docker image
- Push the image to Docker Hub

---

## 📌 References

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Docker Build Push GitHub Action](https://github.com/docker/build-push-action)
- [YouTube CI/CD Demo](https://www.youtube.com/watch?v=R8_veQiYBjI)
