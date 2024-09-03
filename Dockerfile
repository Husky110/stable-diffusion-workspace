FROM kasmweb/core-ubuntu-jammy:1.15.0
USER root

ENV HOME /home/kasm-default-profile
##### Building up the basics #####
RUN echo 'deb http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Jammy/ /' | sudo tee /etc/apt/sources.list.d/home:ungoogled_chromium.list
RUN curl -fsSL https://download.opensuse.org/repositories/home:ungoogled_chromium/Ubuntu_Jammy/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_ungoogled_chromium.gpg > /dev/null
RUN apt-add-repository ppa:unit193/encryption && apt-get update
RUN apt-get update && apt-get install ristretto git python3.10-venv python-is-python3 python3-pip google-perftools sudo unzip veracrypt build-essential python3-opencv libopencv-dev vlc imagemagick zip ungoogled-chromium -y

### DO NOT CHANGE THOSE VARIABLES! I JUST NEED THEM IN PLACE! ###
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
ENV INVOKEAI_ROOT /webuis/invoke
#ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4 <--- might be problematic! Destroys upload-capabilities...
WORKDIR $HOME

# Copy the start-scripts...
COPY --chown=1000:1000 /assets/start_scripts/ /start_scripts/

# Now we need some folders...
RUN mkdir -p /tech
VOLUME /tech

RUN mkdir -p /webuis
RUN chown -R 1000:1000 /webuis

RUN mkdir /host
RUN chown -R 1000:1000 /host
VOLUME /host

RUN mkdir /models
RUN chown -R 1000:1000 /models
VOLUME /models

RUN chown -R 1000:1000 /models

RUN mkdir /output
RUN chown -R 1000:1000 /output

# Let's make sudo available...
RUN echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Now for the user-stuff...

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME
USER 1000
RUN mkdir Desktop
# Setup-Folderlinks:
RUN ln -s /tech $HOME/Desktop/tech
RUN ln -s /models $HOME/Desktop/host_models
RUN ln -s /host $HOME/Desktop/host_data
# Let's install A1111-WebUI
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /webuis/a1111
RUN sed -i 's|#venv_dir="venv"|venv_dir="/venvs/a1111/venv"|g' /webuis/a1111/webui-user.sh
RUN sed -i 's|#export COMMANDLINE_ARGS=""|export COMMANDLINE_ARGS="--listen --port 7860 --xformers --enable-insecure-extension-access"|g' /webuis/a1111/webui-user.sh
COPY --chown=1000:1000 /assets/configfiles/a1111/a1111.json /webuis/a1111/config.json
COPY --chown=1000:1000 /assets/sysinstall/styles.csv /webuis/a1111/styles.csv
RUN ln -s /webuis/a1111/ $HOME/Desktop/A1111_WebUI
COPY --chown=1000:1000 /assets/sysinstall/A1111_WebUI.desktop $HOME/Desktop/A1111_WebUI.desktop
RUN cd /webuis/a1111/models && rm -rf Stable-diffusion VAE VAE-approx && \
    ln -s /models/Checkpoints Stable-diffusion && \
    ln -s /models/Loras Lora && \
    ln -s /models/VAE VAE && \
    ln -s /models/VAE-approx VAE-approx && \
    ln -s /models/Hypernetworks hypernetworks && \
    ln -s /models/ControlNet ControlNet && \
    ln -s /models/ADetailer adetailer
RUN cd /webuis/a1111/ && rm -rf embeddings && ln -s /models/Embeddings embeddings
### TODO A1111 ###
# - ADetailer saves it's standardmodels to /home/kasm-user/.cache/huggingface/hub/ - that might have to be persisted...