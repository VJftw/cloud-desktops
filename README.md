# Cloud Desktops

This repository presents various cloud virtual desktops suitable for shared or single use in [Google Cloud Platform](https://cloud.google.com/) via [OS Login](https://cloud.google.com/compute/docs/oslogin) and [Chrome Remote Desktop](https://remotedesktop.google.com/).

![Release](https://github.com/VJftw/cloud-desktops/workflows/Release/badge.svg)


## Quick Start

If you'd like to try this out without building your own Packer images and you **trust** me, feel free to use my public images in the `vjp-cloud-desktops` project and skip to step 3. e.g.

### Debian Linux w/ XFCE4

```bash
DEBIAN_IMAGE="debian-xfce4-2023-09-29-3fe73f5"
gcloud compute instances create debian-ws \
    --machine-type=e2-standard-2 \
    --boot-disk-size=50GB \
    --boot-disk-type=pd-ssd \
    --metadata enable-oslogin=true \
    --no-service-account \
    --no-scopes \
    --image-project vjp-cloud-desktops \
    --image "$DEBIAN_IMAGE"
```

### Kali Linux w/ XFCE4

```bash
KALI_IMAGE="kali-xfce4-2023-09-22-198bf62"
gcloud compute instances create kali-ws \
    --machine-type=e2-standard-2 \
    --boot-disk-size=50GB \
    --boot-disk-type=pd-ssd \
    --metadata enable-oslogin=true \
    --no-service-account \
    --no-scopes \
    --image-project vjp-cloud-desktops \
    --image "$KALI_IMAGE"
```

### Arch Linux w/ XFCE4

```bash
ARCH_IMAGE="arch-xfce4-2023-07-14-9270dfd"
gcloud compute instances create arch-ws \
    --machine-type=e2-standard-2 \
    --boot-disk-size=50GB \
    --boot-disk-type=pd-ssd \
    --metadata enable-oslogin=true \
    --no-service-account \
    --no-scopes \
    --image-project vjp-cloud-desktops \
    --image "$ARCH_IMAGE"

```

## Getting Started

1. Build your desired flavour by running its Please target (see below).
2. Boot your new image in Google Compute Engine.
3. SSH into your new instance via OS Login.
4. Go to https://remotedesktop.google.com/headless and skip to through authorise to get the command to run on your new instance. Run the command and follow the instructions.
5. The new instance will appear in https://remotedesktop.google.com/access.

## Flavours

### Debian

```bash
GCP_PROJECT_ID="my-project" ./pleasew run //flavours/debian:xfce4_build
```

### Kali Linux

```bash
GCP_PROJECT_ID="my-project" ./pleasew run //flavours/debian/kali:xfce4_build
```

Kali Linux takes some time to build as it is based off Debian and replaces the Debian's sources with Kali's sources and thus replaces a lot of the existing packages.
