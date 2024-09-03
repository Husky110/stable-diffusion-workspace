#!/bin/bash
source /start_scripts/build_basic_folderstructure.sh
A1111_VENV_PATH="/venvs/a1111/venv"
A1111_EXTENSIONS_DIR="/venvs/a1111/extensions"
echo -e "\033[0;36mChecking and Setting up venv...\033[0m"
if [ ! -d /venvs/a1111 ]; then
  mkdir -p /venvs/a1111
  python3.10 -m venv /venvs/a1111/venv
fi
echo -e "\033[0;36mChecking and Setting up Repositories-Folder...\033[0m"
if [ ! -d /venvs/a1111/repositories ]; then
  mkdir /venvs/a1111/repositories
fi
cd /webuis/a1111 && ln -s /venvs/a1111/repositories repositories

echo -e "\033[0;36mChecking and Setting up extensions-folder...\033[0m"
if [ ! -d /venvs/a1111/extensions ]; then
  mkdir /venvs/a1111/extensions
fi
cd /webuis/a1111 && rm -rf extensions && ln -s /venvs/a1111/extensions extensions

echo -e "\033[0;36mInstalling extensions for newbies...\033[0m"
# ControlNet
if [ ! -d "$A1111_EXTENSIONS_DIR/sd-webui-controlnet" ] ;then
  cd "$A1111_EXTENSIONS_DIR" && git clone https://github.com/Mikubill/sd-webui-controlnet.git sd-webui-controlnet
  cd sd-webui-controlnet && rm -rf models && ln -s /models/ControlNet models
fi
# ADetailer
if [ ! -d "$A1111_EXTENSIONS_DIR/adetailer" ] ;then
  cd "$A1111_EXTENSIONS_DIR" && git clone https://github.com/Bing-su/adetailer.git adetailer
fi

echo -e "\033[0;36mChecking and installing Extension-Requirements...\033[0m"
cd "$A1111_EXTENSIONS_DIR"
for dir in */; do

  cd "$A1111_EXTENSIONS_DIR/$dir"
  git pull
  (
    source "$A1111_VENV_PATH/bin/activate"
    if [ -f requirements.txt ]; then
      pip install -r requirements.txt
    fi
  )
  cd "$EXTENSIONS_DIR"
done
# Little fix for Controlnet...
if [ -d "A1111_EXTENSIONS_DIR/sd-webui-controlnet" ] ;then
  (
      source "$A1111_VENV_PATH/bin/activate"
      pip install insightface
  )
fi
echo -e "\033[0;36mFinalizing Setup...\033[0m"
if [ ! -L "/webuis/a1111/config.json" ]; then
  if [ ! -f "/venvs/a1111/config.json" ]; then
    cp /webuis/a1111/config.json /venvs/a1111/config.json
  fi
  cd /webuis/a1111
  rm config.json
  ln -s /venvs/a1111/config.json config.json
fi
if [ ! -L "/webuis/a1111/webui-user.sh" ]; then
  if [ ! -f "/venvs/a1111/webui-user.sh" ]; then
    cp /webuis/a1111/webui-user.sh /venvs/a1111/webui-user.sh
  fi
  cd /webuis/a1111
  rm webui-user.sh
  ln -s /venvs/a1111/webui-user.sh webui-user.sh
fi
echo -e "\033[0;36mReady to start A1111-WebUI...\033[0m"
cd /webuis/a1111 && ./webui.sh