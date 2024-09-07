FROM kasmweb/core-ubuntu-jammy:1.15.0
USER root

ENV HOME /home/kasm-default-profile
##### Building up the basics #####
RUN echo 'deb http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Jammy/ /' | sudo tee /etc/apt/sources.list.d/home:ungoogled_chromium.list
RUN curl -fsSL https://download.opensuse.org/repositories/home:ungoogled_chromium/Ubuntu_Jammy/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_ungoogled_chromium.gpg > /dev/null
RUN apt-add-repository ppa:unit193/encryption && apt-get update
RUN apt-get update && apt-get install gedit ristretto git python3.10-venv python-is-python3 python3-pip google-perftools sudo unzip veracrypt build-essential python3-opencv libopencv-dev vlc imagemagick zip krita ungoogled-chromium -y

### DO NOT CHANGE THOSE VARIABLES! I JUST NEED THEM IN PLACE! ###
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
ENV INVOKEAI_ROOT /webuis/invokeai
#ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4 <--- might be problematic! Destroys upload-capabilities...
WORKDIR $HOME

# Copy the start-scripts...
COPY --chown=1000:1000 /assets/start_scripts/ /start_scripts/

# Now we need some folders...
RUN mkdir -p /tech
VOLUME /tech

RUN mkdir /host
RUN chown -R 1000:1000 /host
VOLUME /host

RUN mkdir /models
RUN chown -R 1000:1000 /models
VOLUME /models

RUN mkdir /output
RUN chown -R 1000:1000 /output

# Now we import all the cloned webuis and what they have...
COPY --chown=1000:1000 /webuis /webuis

# And their according install-scripts
COPY --chown=1000:1000 /assets/sysinstall/install_webuis /install_webuis

# Let's make sudo available...
RUN echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Now for the user-stuff...

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME
USER 1000
SHELL ["/bin/bash", "-c"]
# Setup-Folderlinks:
RUN mkdir Desktop
RUN ln -s /tech $HOME/Desktop/host_tech
RUN ln -s /models $HOME/Desktop/host_models
RUN ln -s /host $HOME/Desktop/host_data
RUN ln -s /output/ $HOME/Desktop/Output
# Setup Mimetypes, VLC & VeraCrypt
RUN mkdir -p $HOME/.config/VeraCrypt
COPY --chown=1000:1000 /assets/configfiles/veracrypt/Configuration.xml $HOME/.config/VeraCrypt/Configuration.xml
COPY --chown=1000:1000 /assets/sysinstall/veracrypt.desktop $HOME/Desktop/VeraCrypt.desktop
RUN mkdir -p $HOME/.config/vlc
COPY --chown=1000:1000 /assets/configfiles/vlc/vlcrc $HOME/.config/vlc/vlcrc
COPY --chown=1000:1000 /assets/sysinstall/mimeapps.list $HOME/.config/mimeapps.list
RUN cd /install_webuis
# Installations for A1111
RUN /install_webuis/install_a1111.sh
RUN cd $WORKDIR
COPY --chown=1000:1000 /assets/sysinstall/styles.csv /webuis/a1111/styles.csv
COPY --chown=1000:1000 /assets/configfiles/a1111/a1111.json /webuis/a1111/config.json
RUN ln -s /webuis/a1111/ $HOME/Desktop/A1111_WebUI
COPY --chown=1000:1000 /assets/sysinstall/A1111_WebUI.desktop $HOME/Desktop/A1111_WebUI.desktop

# Installations for Forge
RUN /install_webuis/install_forge.sh
RUN cd $WORKDIR
COPY --chown=1000:1000 /assets/sysinstall/styles.csv /webuis/forge/styles.csv
COPY --chown=1000:1000 /assets/configfiles/forge/forge.json /webuis/forge/config.json
RUN ln -s /webuis/forge/ $HOME/Desktop/Forge
COPY --chown=1000:1000 /assets/sysinstall/Forge_WebUI.desktop $HOME/Desktop/Forge.desktop

# Installations for Forge_Legacy
RUN /install_webuis/install_forge_legacy.sh
RUN cd $WORKDIR
COPY --chown=1000:1000 /assets/sysinstall/styles.csv /webuis/forge_legacy/styles.csv
COPY --chown=1000:1000 /assets/configfiles/forge/forge.json /webuis/forge_legacy/config.json
RUN ln -s /webuis/forge_legacy/ $HOME/Desktop/Forge_Legacy
COPY --chown=1000:1000 /assets/sysinstall/Forge_WebUI_Legacy.desktop $HOME/Desktop/Forge_Legacy.desktop

# Importing Custom-StartupScript
COPY --chown=1000:1000 /assets/custom_startup.sh $STARTUPDIR/custom_startup_DEBUG.sh