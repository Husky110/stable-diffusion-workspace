# Warning: This repo is still WIP! Do NOT use it until further notice!

# Purpose

Every WebUI has it's Pros and Cons. I found myself in a position where I had to select a specific UI to get a specific job done. Either it was a feature I liked or a ui implemented something the others didn't have yet. Or I just wanted to play around.  
Since I'm already using Kasm Workspaces to have some clean distinction between "What do I need installed on my machine?" vs. "What do I need to get this specfic tool to run?", I think this workspace is a good solution.  
All you need it some docker-knowledge and you should be good to go to leverage several uis and tools. Plus having them in a centralized spot that is easy to maintain, leaving the learning-curve to the uis themselfs.

So here it is - a Workspace-Image that runs on Docker and that (hopefully) will be your Swiss Army Knife for StableDiffusion.

But - Such versatility comes with a price! I had to make some design-decisions which some might find not "newbie-friendly". I try to conquer that by documenting this container as much as possible. So please - for the love of whoever - read this docs carefully and act on them!

## Features

For the referenced folders read "How do I install this?"

Installable UIs and tools are:

- A1111-WebUI
  - Preinstalled styles-cheatsheet with over 800 styles from [https://github.com/SupaGruen/StableDiffusion-CheatSheet](https://github.com/SupaGruen/StableDiffusion-CheatSheet)
    - Those styles are meant for StableDiffusion 1.5 and SDXL - I don't know how well they perform on Pony, Flux and AmberFlow
- Forge-WebUI (to be done)
  - legacy (State at 2024-07-24 - some people seem to have liked it until then...)
  - current
- ComfyUI (to be done)
- InvokeAI (to be done)
- Kohya_SS (to be done)
- ICLight (to be done)
- an ImageViewer (preinstalled inside the container)
- Krita (to be done)
- VLC (to be done)
- VeraCrypt (preinstalled - for your spicy content)
  - **Attention**: I do **NOT** endorse you to create anything illegal! What you do with this repo and it's tools is completely up to you and **YOU ALONE ARE RESPONSIBLE FOR ANYTHING YOU DO!** However - I see that there might be a need for this, since some people might be into stuff that their social environment do not know about and they might want to keep it that way. Use at your own discretion.

## What do I need?

Well - your OS does not matter here. But you need the following:

- Required:
  - A machine with an Nvidia-GPU (sorry - I don't know anything about AMD- and Intel-GPUs... If anyone want's to contribute on that - please do!)
    - The container expects to run on a GPU! CPU-modes are NOT supported! If you want to use them, it's possible, but you will have to make certain adjustments to the repo.
  - Current Nvidia-drivers installed
    - Be carefull with "current"... On Linux there are some problems with bleeding-edge drivers! I don't know how severe they are on Windows.
  - Nvidia-CUDA installed
  - Docker installed
  - Nvidia-container-toolkit installed
- Depending on your needs:
  - Diffusion: You need at least 8 GB of VRAM  
    The more, the better. On 8 GB you can run SD1.5-based models and you *should* be able to run some SDXL-based models (I recommend Forge- or Forge-Legacy for this). 
    - If you want to run Flux, AmberFlow or use multiple LoRAs on SDXL I would recommend either having at least 16GB of VRAM or run this repo on a hosting-service.
  - Training:
    - Depending on WHAT you train you will need at least 8 GBs of VRAM
      - SD1.5: Available on 8 GB
      - SDXL: 8 GB might not be enough here
      - Flux: You need at least 16 GB of VRAM to attempt training some LoRAs, but you can only use 512x512-images. 24 GB are recommended.
- Optional:
  - KasmWorkspaces installed and running

Attention: I can't test any environment and such. The repo was built on Linux, with the 555-driver and CUDA 12.5 in place.

## How do I install this? How do I use this?

**Attention:** If you already use one of the UIs featured in this workspace, please do NOT start to copy everything over blindly and expect everything to run! The container and every UI come with a custom startscript that does some installations and initial setup for you. Please follow the setup and move your neccesary accordingly.

### Setup

- First create 3 folders. Where you create and how you name them is up to you, but remember their paths!
  *Migration: Please create those folders in a new location. The workspace does some automations that might break your current setup!*
  - tech
    - This folder will hold some model-caches and such, so they are not beeing downloaded every time you start up.
    - Path inside container: /tech
    - Additionally all unmapped folders that are beeing used in your webui will land here aswell. Just check out the folder once you've run the container and one of the uis - you will see what I mean then.
  - models
    - This folder will hold you checkpoints, loras, and whatnot.
    - Path inside container: /models
    - Inside the folder, create 3 new folders:
      - Checkpoints (to hold all your checkpoints)
      - Embeddings (to hold all your embeddings)
      - Loras (to hold all your LoRAs)
      - VAEs (for all the VAEs and CLIPs)
    - I recommend structuring the sub-folders as well - like /Checkpoints/sd15; /Checkpoints/SDXL; /Checkpoints/Flux_Unet; and so on
  - data
    - This folder is to persist anything you want to share between your computer and the container.
    - Path inside container: /host
- Clone all the webuis in their respective folder:  
*Note: Details on quirks and maintenance are available later in this readme-file.*
  - Enter the webuis-folder and run the following commands (you don't need all of them - just install the ones you want, but make sure to copy the whole command!):
  - A1111: `git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git a1111`
  - Forge:
    - Current: `git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git forge`
    - Legacy (older, but stable-version that is primarily usefull for SD1.5 and SDXL - can load SDXL-based models on 8GB-GPUs): 
     -`git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git forge_legacy`
     - enter the forge_legacy folder and run `git checkout a9e0c38` - then go back to the webuis-folder
  - InvokeAI: `git clone https://github.com/invoke-ai/InvokeAI.git invokeai`
  - ICLight - Relighting-Tool: `git clone https://github.com/lllyasviel/IC-Light.git ICLight`
  - Kohya_SS - Training: `git clone --recursive https://github.com/bmaltais/kohya_ss.git kohya`
- Run the following command inside the repo-directory: `docker build -t localhost/stablediffusion_workspace:latest .` and wait for it to finish.

### Running via docker-compose


## Quirks and some Tech-Background

### General
#### Maintenance:
  - Maintenance is done by running `git pull` inside the according webuis-folder.

### A1111
- Extensions can't be installed persistently via the WebUI itself anymore. It's a bit of a good news - bad news-situation:
  - Since we build the python-venv with the container you have to install extensions via `git clone` inside the extensions-directory, you have to rebuild the container once the extionsions were beeing cloned and you have to activate them inside the container after it's first start.
  - Good news: you can test extensions before you install them permanently into your system. Just add them via the webui - but when you restart the container they are gone again!
  - Bad news: If one extension requires additional downloads inside it's folder you have to send those to your host. I would recommend using the host-directory for that. Just run A1111 with your desired extension active to let it download everything and then copy the extension-directory to your host-directory.
  - Reasoning: Extensions are a cool thing, but some might break your setup. Having the ability to test them without ruining your established setup justifies the slightly harder installation-process.
  - Remember to run `git pull` inside every extension-folder when you update your A1111-instance.
- The models-folder in A1111 is included via a hack:
  - I'm doing some dark magic linking the Checkpoints, LoRAs and such to A1111. (See your modelsfolder...) But I can't link everything there, since I don't know what you will add there. So everything in your /models-folder will be linked accordingly, but everything else will be found in /tech/a1111/models and the according host-directory.
  - That requires that you **DO NOT DELETE ANYTHING** inside the /tech/a1111/models-directory and the according host-directory, except you are 100% sure what you are doing. That applies to the symlinks in there aswell!
- On first start A1111 might download a default sd-model. This is a new one, since SD1.5 got deleted. Just let it load.
- Since we are on Linux within the container, the relevant file for start-parameters and such is the webui_user.sh-file.
  - I recommend the following start-parameters:
    - `--xformers` (enable xformers for speed-improvements)
    - `--enable-insecure-extension-access` (required for some extensions)
    - `--listen --port 7860` (To set the port to 7860 - you can open A1111 then via http://localhost:7860 - I know it's the standard-port, but having it explicitly set makes it easier to change it later if required. :) )
  - You can either edit the webui_user.sh-file inside the repository folder, or inside the tech-folder. Changes inside the container are beeing persited in the tech-folder.

### Ungoogled Chromium
- There are two known bugs  
  - Ungoogled Chromium spits some errors when loading up via the A1111-starter
  - The images on the Lora- and TextualInversion-Tab do not work

### Veracrypt
- There is a known "bug" of sorts that causes loading an encrypted file to fail with "could not setup /dev/tmp"-whatnot. I have no idea what is happening there, but you can avoid it by starting the container and the first thing you do it to startup veracrypt and load your encrypted volume. If it fails again, restart and retry - eventually it should work. Once the volume is loaded you can fire up your webuis normally.

### VLC
- Normally VLC asks you to allow network-access for media-data. This has been disabled via a given config.

