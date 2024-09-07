#!/bin/bash

# First we set the desktop straight... Kasm has a tendancy to randomize things and I don't want that.
xfdesktop -A
# Let's setup the model-cache
if [ ! -L "/home/kasm-user/.cache/huggingface" ]; then
  if [ ! -d "/tech/huggingface_cache" ]; then
    mkdir -p /tech/huggingface_cache
  fi
  cd /home/kasm-user/.cache && ln -s /tech/huggingface_cache huggingface
fi

# Now we need to setup A1111 if it is installed...
/start_scripts/boot/a1111.sh

# Now we need to setup Forge if it is installed...
/start_scripts/boot/forge.sh

# Now we need to setup Forge_Legacy if it is installed...
/start_scripts/boot/forge_legacy.sh

