#!/usr/bin/env bash
set -euxo pipefail

sudo chown "$(whoami):$(whoami)" -R .

export APPIMAGE_EXTRACT_AND_RUN=1
wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && chmod +x appimagetool-x86_64.AppImage


if [[ "$GUISCRCPY_TYPE" == "r" ]]; then
  SCRCPY_APPIMAGE_DOWNLOAD_URL="$(curl -sL https://api.github.com/repos/srevinsaju/scrcpy-appimage/releases/latest | jq -r '.assets[].browser_download_url' | grep -v 'zsync')"
  export SCRCPY_APPIMAGE_DOWNLOAD_URL

  wget -q "$SCRCPY_APPIMAGE_DOWNLOAD_URL"
  chmod +x scrcpy*.AppImage
  ./scrcpy*.AppImage --appimage-extract
  mv squashfs-root guiscrcpy.AppDir/scrcpy

else
  cp pyappimage/AppRun.standalone.sh guiscrcpy.AppDir/AppRun && chmod +x guiscrcpy.AppDir/AppRun
fi

mkdir _build

./appimagetool-x86_64.AppImage guiscrcpy.AppDir -n \
  -u "gh-releases-zsync|srevinsaju|guiscrcpy|continuous|guiscrcpy-*.$GUISCRCPY_TYPE.*.AppImage.zsync" \
  "_build/guiscrcpy-min-$GUISCRCPY_VERSION.$GUISCRCPY_TYPE.$GUISCRCPY_GLIB_VERSION-$GUISCRCPY_MACHINE.AppImage"