#!/bin/bash
if [ -d "/webuis/forge" ]; then
    cd /webuis/forge
    if [ ! -d "/tech/forge" ]; then
        mkdir -p /tech/forge /tech/forge/repositories
    fi
    
    #Even tho we start Forge once during build-process, I'm leaving this in since I don't know if extensions or whatnot pull stuff in here outside the normal start-process.
    rm -rf repositories
    ln -s /tech/forge/repositories repositories

    if [ ! -L "/webuis/forge/config.json" ]; then
        if [ ! -f "/tech/forge/config.json" ]; then
            cp /webuis/forge/config.json /tech/forge/config.json
        fi
        rm config.json
        ln -s /tech/forge/config.json config.json
    fi

    if [ ! -L "/webuis/forge/styles.csv" ]; then
        if [ ! -f "/tech/forge/styles.csv" ]; then
            cp /webuis/forge/styles.csv /tech/forge/styles.csv
        fi
        rm styles.csv
        ln -s /tech/forge/styles.csv styles.csv
    fi

    if [ ! -L "/webuis/forge/webui-user.sh" ]; then
        if [ ! -f "/tech/forge/webui-user.sh" ]; then
            cp /webuis/forge/webui-user.sh /tech/forge/webui-user.sh
        fi
        rm webui-user.sh
        ln -s /tech/forge/webui-user.sh webui-user.sh
    fi

    if [ ! -d "/tech/forge/models" ]; then
        cd models && rm -rf Stable-diffusion && rm -rf VAE && cd ..
        cp -r models /tech/forge/models
    fi

    rm -rf models
    mkdir models
    sudo mount --bind /tech/forge/models /webuis/forge/models

    if [ ! -L "/webuis/forge/models/Stable-diffusion" ]; then
        cd models && ln -s /models/Checkpoints Stable-diffusion && cd ..
    fi

    if [ ! -L "/webuis/forge/models/Lora" ]; then
        cd models && ln -s /models/Loras Lora && cd ..
    fi

    if [ ! -L "/webuis/forge/models/VAE" ]; then
        cd models && ln -s /models/VAEs VAE && cd ..
    fi    

    rm -rf embeddings
    ln -s /models/Embeddings embeddings

    if [ -d "/models/ADetailer" ]; then
        if [ ! -L "/webuis/forge/models/adetailer" ]; then
            cd models && rm -rf adetailer && ln -s /models/ADetailer adetailer && cd ..
        fi
    fi
    if [ -d "/models/ControlNet" ]; then
        if [ ! -L "/webuis/forge/models/ControlNet" ]; then
            cd models && rm -rf ControlNet && ln -s /models/ControlNet ControlNet && cd ..
        fi
    fi
fi
