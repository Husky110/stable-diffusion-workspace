#!/bin/bash
echo -e "\033[0;36mChecking and Setting up venv...\033[0m"
if [ ! -d /venvs/comfy ]; then
  mkdir -p /venvs/comfy
  python3 -m venv /venvs/comfy/venv
fi
cd /webuis/comfy
if [ ! -L /webuis/comfy/custom_nodes ]; then
  cp -rf custom_nodes /venvs/comfy
  rm -rf custom_nodes
  ln -s /venvs/comfy/custom_nodes custom_nodes
fi
(
  source "/venvs/comfy/venv/bin/activate"
  pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121
  pip install -r requirements.txt
)
if [ ! -L /webuis/comfy/output ]; then
  rm -rf output
  ln -s /output output
fi
echo -e "\033[0;36mInstalling NodeManager...\033[0m"
cd /venvs/comfy/custom_nodes
if [ ! -d /webuis/comfy/custom_nodes/ComfyUI-Manager ]; then
  git clone https://github.com/ltdrdata/ComfyUI-Manager
fi
cd ComfyUI-Manager
git pull
(
  source "/venvs/comfy/venv/bin/activate"
  pip install -r requirements.txt
)

echo -e "\033[0;36mStarting ComfyUI...\033[0m"
(
  source "/venvs/comfy/venv/bin/activate"
  cd /webuis/comfy && python main.py
)