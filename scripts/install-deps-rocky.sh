#!/usr/bin/env bash
set -euo pipefail

# Install Java, Maven, and native libs for JavaFX on Rocky Linux (AMD64)

if [[ $EUID -ne 0 ]]; then
  SUDO=sudo
else
  SUDO=
fi

echo "[INFO] Detecting OS..."
source /etc/os-release || true
ID=${ID:-}
if [[ ${ID} != "rocky" && ${ID} != "rhel" && ${ID} != "centos" ]]; then
  echo "[WARN] This script targets Rocky/RHEL/CentOS. Continuing anyway."
fi

echo "[INFO] Updating package metadata"
${SUDO} dnf -y makecache || ${SUDO} dnf -y makecache --refresh

echo "[INFO] Installing JDK, Maven, Git"
${SUDO} dnf -y install \
  java-17-openjdk-devel \
  maven \
  git

echo "[INFO] Installing native libraries for JavaFX (GTK/X11/OpenGL)"
${SUDO} dnf -y install \
  gtk3 \
  glib2 \
  libX11 \
  libXext \
  libXi \
  libXtst \
  libXrender \
  libXrandr \
  libXcursor \
  libXcomposite \
  libXdamage \
  alsa-lib \
  fontconfig \
  freetype \
  dejavu-sans-fonts \
  libdrm \
  mesa-libGL \
  mesa-dri-drivers \
  liberation-fonts \
  libcanberra-gtk3

echo "[INFO] Java version:"
java -version || true
echo "[INFO] Maven version:"
mvn -v || true

echo "[DONE] Dependencies installed. You can now run scripts/build.sh and scripts/run.sh"

