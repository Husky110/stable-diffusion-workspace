#!/bin/bash
echo -e "\033[0;36mChecking and Setting up venv...\033[0m"
if [ ! -d /venvs/invoke ]; then
  mkdir -p /venvs/invoke
  python3 -m venv /venvs/invoke/venv --prompt InvokeAI
  mkdir -p /venvs/invoke/databases
  mkdir -p /venvs/invoke/configs
  mkdir -p /venvs/invoke/nodes
fi
cd $INVOKEAI_ROOT
ln -s /venvs/invoke/configs configs
ln -s /venvs/invoke/databases databases
ln -s /venvs/invoke/nodes nodes
ln -s /stablediffusion_data/Checkpoints models
mkdir -p /output/invokeai
if [ ! -L $INVOKEAI_ROOT/output ]; then
  ln -s /output/invokeai outputs
fi

if [ ! -f /venvs/invoke/invokeai.yaml ]; then
  echo "IyBJbnRlcm5hbCBtZXRhZGF0YSAtIGRvIG5vdCBlZGl0OgpzY2hlbWFfdmVyc2lvbjogNC4wLjEKCiMgUHV0IHVzZXIgc2V0dGluZ3MgaGVyZSAtIHNlZSBodHRwczovL2ludm9rZS1haS5naXRodWIuaW8vSW52b2tlQUkvZmVhdHVyZXMvQ09ORklHVVJBVElPTi86Cg==" | base64 --decode > /venvs/invoke/invokeai.yaml
fi

echo -e "\033[0;36mInstalling InvokeAI...\033[0m"
(
  source "/venvs/invoke/venv/bin/activate"
  python3 -m pip install --upgrade pip
  pip install pypatchmatch
)
echo -e "\033[0;36mInstalling PyPatchMatch...\033[0m"
(
  source "/venvs/invoke/venv/bin/activate"
  python3 -m pip install --upgrade pip
  pip install InvokeAI --use-pep517
)
echo -e "\033[0;36mStarting InvokeAI...\033[0m"
(
  source "/venvs/invoke/venv/bin/activate"
  invokeai-web --config /venvs/invoke/invokeai.yaml
)