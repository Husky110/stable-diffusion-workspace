#!/bin/bash
if [ -d "/webuis/a1111" ] ; then
    cd /webuis/a1111
    python3 -m venv venv
    (
        source venv/bin/activate
        pip install -r requirements.txt
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