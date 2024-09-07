#!/bin/bash
if [ -d "/webuis/forge_legacy" ]; then
    cd /webuis/forge_legacy
    if [ ! -d "/tech/forge_legacy" ]; then
        mkdir -p /tech/forge_legacy /tech/forge_legacy/repositories
    fi
    
    #Even tho we start Forge once during build-process, I'm leaving this in since I don't know if extensions or whatnot pull stuff in here outside the normal start-process.
    rm -rf repositories
    ln -s /tech/forge_legacy/repositories repositories

    if [ ! -L "/webuis/forge_legacy/config.json" ]; then
        if [ ! -f "/tech/forge_legacy/config.json" ]; then
            cp /webuis/forge_legacy/config.json /tech/forge_legacy/config.json
        fi
        rm config.json
        ln -s /tech/forge_legacy/config.json config.json
    fi

    if [ ! -L "/webuis/forge_legacy/styles.csv" ]; then
        if [ ! -f "/tech/forge_legacy/styles.csv" ]; then
            cp /webuis/forge_legacy/styles.csv /tech/forge_legacy/styles.csv
        fi
        rm styles.csv
        ln -s /tech/forge_legacy/styles.csv styles.csv
    fi

    if [ ! -L "/webuis/forge_legacy/webui-user.sh" ]; then
        if [ ! -f "/tech/forge_legacy/webui-user.sh" ]; then
            cp /webuis/forge_legacy/webui-user.sh /tech/forge_legacy/webui-user.sh
        fi
        rm webui-user.sh
        ln -s /tech/forge_legacy/webui-user.sh webui-user.sh
    fi

    if [ ! -d "/tech/forge_legacy/models" ]; then
        cd models && rm -rf Stable-diffusion && rm -rf VAE && cd ..
        cp -r models /tech/forge_legacy/models
    fi

    rm -rf models
    mkdir models
    sudo mount --bind /tech/forge_legacy/models /webuis/forge_legacy/models

    if [ ! -L "/webuis/forge_legacy/models/Stable-diffusion" ]; then
        cd models && ln -s /models/Checkpoints Stable-diffusion && cd ..
    fi

    if [ ! -L "/webuis/forge_legacy/models/Lora" ]; then
        cd models && ln -s /models/Loras Lora && cd ..
    fi

    if [ ! -L "/webuis/forge_legacy/models/VAE" ]; then
        cd models && ln -s /models/VAEs VAE && cd ..
    fi    

    rm -rf embeddings
    ln -s /models/Embeddings embeddings

    if [ -d "/models/ADetailer" ]; then
        if [ ! -L "/webuis/forge_legacy/models/adetailer" ]; then
            cd models && rm -rf adetailer && ln -s /models/ADetailer adetailer && cd ..
        fi
    fi
    if [ -d "/models/ControlNet" ]; then
        if [ ! -L "/webuis/forge_legacy/models/ControlNet" ]; then
            cd models && rm -rf ControlNet && ln -s /models/ControlNet ControlNet && cd ..
        fi
    fi

fi
