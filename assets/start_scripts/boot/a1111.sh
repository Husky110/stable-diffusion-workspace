#!/bin/bash
if [ -d "/webuis/a1111" ]; then
    cd /webuis/a1111
    if [ ! -d "/tech/a1111" ]; then
        mkdir -p /tech/a1111 /tech/a1111/repositories
    fi
    
    #Even tho we start A1111 once during build-process, I'm leaving this in since I don't know if extensions or whatnot pull stuff in here outside the normal start-process.
    rm -rf repositories
    ln -s /tech/a1111/repositories repositories

    if [ ! -L "/webuis/a1111/config.json" ]; then
        if [ ! -f "/tech/a1111/config.json" ]; then
            cp /webuis/a1111/config.json /tech/a1111/config.json
        fi
        rm config.json
        ln -s /tech/a1111/config.json config.json
    fi

    if [ ! -L "/webuis/a1111/styles.csv" ]; then
        if [ ! -f "/tech/a1111/styles.csv" ]; then
            cp /webuis/a1111/styles.csv /tech/a1111/styles.csv
        fi
        rm styles.csv
        ln -s /tech/a1111/styles.csv styles.csv
    fi

    if [ ! -L "/webuis/a1111/webui-user.sh" ]; then
        if [ ! -f "/tech/a1111/webui-user.sh" ]; then
            cp /webuis/a1111/webui-user.sh /tech/a1111/webui-user.sh
        fi
        rm webui-user.sh
        ln -s /tech/a1111/webui-user.sh webui-user.sh
    fi

    if [ ! -d "/tech/a1111/models" ]; then
        cd models && rm -rf Stable-diffusion && rm -rf VAE && cd ..
        cp -r models /tech/a1111/models
    fi

    rm -rf models
    mkdir models
    sudo mount --bind /tech/a1111/models /webuis/a1111/models

    if [ ! -L "/webuis/a1111/models/Stable-diffusion" ]; then
        cd models && ln -s /models/Checkpoints Stable-diffusion && cd ..
    fi

    if [ ! -L "/webuis/a1111/models/Lora" ]; then
        cd models && ln -s /models/Loras Lora && cd ..
    fi

    if [ ! -L "/webuis/a1111/models/VAE" ]; then
        cd models && ln -s /models/VAEs VAE && cd ..
    fi    

    rm -rf embeddings
    ln -s /models/Embeddings embeddings

    if [ -d "/models/ADetailer" ]; then
        if [ ! -L "/webuis/a1111/models/adetailer" ]; then
            cd models && rm -rf adetailer && ln -s /models/ADetailer adetailer && cd ..
        fi
    fi
    if [ -d "/models/ControlNet" ]; then
        if [ ! -L "/webuis/a1111/models/ControlNet" ]; then
            cd models && rm -rf ControlNet && ln -s /models/ControlNet ControlNet && cd ..
        fi
    fi
    
fi
