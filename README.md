# Cloud Desktops

This repository presents various cloud virtual desktops suitable for shared or single use in [Google Cloud Platform](https://cloud.google.com/) via [OS Login](https://cloud.google.com/compute/docs/oslogin) and [Chrome Remote Desktop](https://remotedesktop.google.com/).

![Release](https://github.com/VJftw/cloud-desktops/workflows/Release/badge.svg)


## Quick Start

If you'd like to try this out without building your own Packer images and you **trust** me, feel free to use my public images in the `vjftw-images` project and skip to step 3. e.g.

```
gcloud compute instances create debian-ws \
    --machine-type=e2-standard-2 \
    --boot-disk-size=50GB \
    --boot-disk-type=pd-ssd \
    --metadata enable-oslogin=true \
    --no-service-account \
    --no-scopes \
    --image debian-xfce4-20200327 --image-project vjftw-images
```

### Pre-requisites

 * [Packer](https://packer.io/)

## Getting Started

1. Build your desired flavour by changing into its directory and running `packer build -var 'gcp_project_id=my-project' <desktop-env>.json`.
2. Boot your new image in Google Compute Engine.
3. SSH into your new instance via OS Login.
4. Go to https://remotedesktop.google.com/headless and skip to through authorise to get the command to run on your new instance. Run the command and follow the instructions.
5. The new instance will appear in https://remotedesktop.google.com/access.

## Flavours

### Debian

```bash
cd flavours/debian
packer build -var 'gcp_project_id=my-project' xfce4.json
```

### Kali Linux

```bash
cd flavours/debian/kali
packer build -var 'gcp_project_id=my-project' xfce4.json
```

Kali Linux takes some time to build as it is based off Debian and replaces the Debian's sources with Kali's sources and thus replaces a lot of the existing packages.
