#!/bin/bash
FORGE_VENV_PATH="/venvs/forge/venv"
FORGE_EXTENSIONS_DIR="/venvs/forge/extensions"
echo -e "\033[0;36mChecking and Setting up venv...\033[0m"
if [ ! -d /venvs/forge/venv ]; then
  mkdir -p /venvs/forge/venv
  python3.10 -m venv /venvs/forge/venv
fi
echo -e "\033[0;36mChecking and Setting up Repositories-Folder...\033[0m"
if [ ! -d /venvs/forge/repositories ]; then
  mkdir /venvs/forge/repositories
fi
cd /webuis/forge && ln -s /venvs/forge/repositories repositories

echo -e "\033[0;36mChecking and Setting up extensions-folder...\033[0m"
if [ ! -d /venvs/forge/extensions ]; then
  mkdir /venvs/forge/extensions
fi
cd /webuis/forge && rm -rf extensions && ln -s /venvs/forge/extensions extensions

echo -e "\033[0;36mInstalling Adetailer...\033[0m"
cd "$FORGE_EXTENSIONS_DIR"
if [ ! -d /venvs/forge/extensions/adetailer ]; then
  git clone https://github.com/Bing-su/adetailer /venvs/forge/extensions/adetailer
fi
echo -e "\033[0;36mChecking and installing Extension-Requirements...\033[0m"
for dir in */; do

  cd "$dir"
  git pull
  (
    source "$FORGE_VENV_PATH/bin/activate"
    if [ -f requirements.txt ]; then
      pip install -r requirements.txt
    fi
  )
  cd "$EXTENSIONS_DIR"
done
echo -e "\033[0;36mFinalizing Setup...\033[0m"
rm -rf /webuis/forge/models/Stable-diffusion
rm -rf /webuis/forge/models/Lora
rm -rf /webuis/forge/models/VAE
cp -r /webuis/forge/models/. /stablediffusion_data/
rm -rf /webuis/forge/models
cd /stablediffusion_data
if [ ! -L "/stablediffusion_data/Lora" ]; then
  ln -s LORAs Lora
fi
if [ ! -L "/stablediffusion_data/Stable-diffusion" ]; then
  ln -s Checkpoints Stable-diffusion
fi
if [ ! -L "/webuis/forge/config.json" ]; then
  if [ ! -f "/venvs/forge/config.json" ]; then
    cp /webuis/forge/config.json /venvs/forge/config.json
  fi
  cd /webuis/forge
  rm config.json
  ln -s /venvs/forge/config.json config.json
fi

cd /webuis/forge && ln -s /stablediffusion_data/ models
rm -rf /webuis/forge/embeddings
cd /webuis/forge && ln -s /stablediffusion_data/Embeddings embeddings
(
  source "$FORGE_VENV_PATH/bin/activate"
  pip install insightface
  pip install albumentations==1.4.3
  pip install pydantic==1.10.15
)
echo -e "\033[0;36mReady to start FORGE-WebUI...\033[0m"
cd /webuis/forge && ./webui.sh