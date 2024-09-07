#!/bin/bash
if [ -d "/webuis/forge" ] ; then
    cd /webuis/forge
    python3 -m venv venv
    (
        source venv/bin/activate
        if [ -f requirements.txt ]; then
            pip install -r requirements.txt
        fi
        pip install insightface
        pip install xformers==0.0.27
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