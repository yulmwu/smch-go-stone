# Runtime-only image that expects the app jar to be built locally first.
# It downloads platform-appropriate JavaFX modules at build time.

FROM eclipse-temurin:11-jre as runtime

ARG TARGETPLATFORM
ENV JFX_VERSION=25.0.1 \
    JFX_DIR=/opt/javafx \
    APP_DIR=/app

RUN set -eux; \
    mkdir -p "$JFX_DIR" "$APP_DIR"; \
    # Map Docker platform to OpenJFX classifier
    case "$TARGETPLATFORM" in \
      linux/amd64)   ARCH=linux-x64 ;; \
      linux/arm64)   ARCH=linux-aarch64 ;; \
      *) echo "Unsupported TARGETPLATFORM: $TARGETPLATFORM" >&2; exit 1 ;; \
    esac; \
    # Fetch required JavaFX modules for the platform
    for MOD in base graphics controls fxml; do \
      URL="https://repo1.maven.org/maven2/org/openjfx/javafx-${MOD}/${JFX_VERSION}/javafx-${MOD}-${JFX_VERSION}-${ARCH}.jar"; \
      curl -fsSL "$URL" -o "$JFX_DIR/javafx.${MOD}.jar"; \
    done

# Copy pre-built app jar and external libs into image
COPY target/*.jar ${APP_DIR}/app.jar
# Include legacy driver for older servers (optional)
# (Optional legacy) COPY vendor/ojdbc6.jar ${APP_DIR}/lib/

# Fetch JFoenix compatible with modern JavaFX
RUN curl -fsSL -o ${APP_DIR}/lib/jfoenix-9.0.10.jar \
      https://repo1.maven.org/maven2/com/jfoenix/jfoenix/9.0.10/jfoenix-9.0.10.jar

# Fetch modern Oracle JDBC driver compatible with XE 21c
RUN curl -fsSL -o ${APP_DIR}/lib/ojdbc8-21.11.0.0.jar \
      https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc8/21.11.0.0/ojdbc8-21.11.0.0.jar

WORKDIR ${APP_DIR}

# Run with JavaFX on module-path and app/libs on classpath
CMD ["bash","-lc","java --module-path $JFX_DIR --add-modules javafx.controls,javafx.fxml --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-exports=javafx.graphics/com.sun.javafx.css=ALL-UNNAMED --add-exports=javafx.graphics/com.sun.javafx.scene=ALL-UNNAMED --add-exports=javafx.controls/com.sun.javafx.scene.control=ALL-UNNAMED -Djdbc.drivers=oracle.jdbc.OracleDriver -cp app.jar:/app/lib/jfoenix-9.0.10.jar:/app/lib/ojdbc8-21.11.0.0.jar application.Main"]
