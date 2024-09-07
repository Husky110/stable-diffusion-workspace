#!/bin/bash
if [ -d "/webuis/forge_legacy" ] ; then
    cd /webuis/forge_legacy
    python3 -m venv venv
    (
        source venv/bin/activate
        if [ -f requirements.txt ]; then
            pip install -r requirements.txt
        fi
        pip install insightface
        pip install albumentations==1.4.3
        pip install pydantic==1.10.15
        pip install xformers==0.0.23.post1
        cd extensions
        for dir in */; do
            if [ -f "$dir/requirements.txt" ]; then
                pip install -r "$dir/requirements.txt";
            fi;
        done
        cd ..
        sed -i -e 's/    start()/    #start()/g' launch.py
        python3 launch.py --skip-torch-cuda-test --reinstall-xformers
        sed -i -e 's/    #start()/    start()/g' launch.py
    )
fi