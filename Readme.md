# Purpose

Every WebUI has it's Pros and Cons. I found myself in a position where I had to select a specific UI to get a specific job done. Either it was a feature I liked or a ui implemented something the others didn't have yet. Or I just wanted to play around.  
Since I'm already using Kasm Workspaces to have some clean distinction between "What do I need installed on my machine?" vs. "What do I need to get this specfic tool to run?", I think this workspace is a good solution.  
All you need it some docker-knowledge and you should be good to go to leverage several uis and tools. Plus having them in a centralized spot that is easy to maintain, leaving the learning-curve to the uis themselfs.

So here it is - a Workspace-Image that runs on Docker and that (hopefully) will be your Swiss Army Knife for StableDiffusion.

## Features

For the referenced folders read "How do I install this?"

Included UIs and tools are:

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
- an ImageViewer
- Krita (to be done)
- VLC (to be done)
- VeraCrypt (for your spicy content)
  - **Attention**: I do **NOT** endorse you to create anything illegal! What you do with this repo and it's tools is completely up to you and **YOU ALONE ARE RESPONSIBLE FOR ANYTHING YOU DO!** However - I see that there might be a need for this, since some people might be into stuff that their social environment do not know about and they might want to keep it that way. Use at your own discretion.

## What do I need?

Well - your OS does not matter here. But you need the following:

- Required:
  - A machine with an Nvidia-gpu (sorry - I don't know anything about AMD- and Intel-GPUs... If anyone want's to contribute on that - please do!)
  - Current Nvidia-drivers installed
    - Be carefull with "current"... On Linux there are some problems with bleeding-edge drivers! I don't know how severe they are on Windows.
  - Nvidia-CUDA installed
  - Docker installed
  - Nvidia-container-toolkit installed
- Depending on your needs:
  - Diffusion: You need at least 8 GBs of VRAM!  
    The more, the better. On 8 GB you can run SD1.5-based models and you *should* be able to run some SDXL-based models (I recommend Forge- or Forge-Legacy for this). 
    - If you want to run Flux, AmberFlow or use multiple LoRAs on SDXL I would recommend either having at least 16GB of VRAM or run this repo on a hosting-service.
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
      - LoRAs (to hold all your LoRAs)
      - VAEs (for all the VAEs and CLIPs)
    - I recommend structuring the sub-folders as well - like /Checkpoints/sd15; /Checkpoints/SDXL; /Checkpoints/Flux_Unet; and so on
  - data
    - This folder is to persist anything you want to share between your computer and the container.
    - Path inside container: /host
- Clone all the webuis in their respective folder:
  - 
- Run the following command inside the repo-directory: `docker build -t localhost/stablediffusion_workspace:latest .` and wait for it to finish.

### Running via docker-compose


## Quirks and some Tech-Background


