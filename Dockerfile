# ============================================================
# RuoYi-Vue Backend Dockerfile
# 多阶段构建：Maven 编译 → JRE 运行
# ============================================================
# ---- 构建阶段 ----
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /build
COPY pom.xml ./
COPY ruoyi-common/pom.xml ruoyi-common/
COPY ruoyi-framework/pom.xml ruoyi-framework/
COPY ruoyi-system/pom.xml ruoyi-system/
COPY ruoyi-admin/pom.xml ruoyi-admin/
COPY ruoyi-quartz/pom.xml ruoyi-quartz/
COPY ruoyi-generator/pom.xml ruoyi-generator/
COPY ruoyi-workflow/pom.xml ruoyi-workflow/
# 先下载依赖（利用 Docker 缓存层）
RUN apk add --no-cache maven && mvn dependency:go-offline -B || true

COPY . .
RUN mvn clean package -DskipTests -B

# ---- 运行阶段 ----
FROM eclipse-temurin:17-jre-alpine

RUN addgroup -S ruoyi && adduser -S ruoyi -G ruoyi
WORKDIR /app
COPY --from=builder /build/ruoyi-admin/target/*.jar app.jar
RUN chown -R ruoyi:ruoyi /app

USER ruoyi
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
