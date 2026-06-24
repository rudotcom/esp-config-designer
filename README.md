# ESP Config Designer (Dockerized)

A standalone Docker deployment of [ESPConfig-Designer](https://github.com/sokolsok/ESPConfig-Designer) — a web UI for visually building ESPHome YAML configurations.

## Why Dockerized?

Docker-based Home Assistant installations (e.g. `homeassistant/home-assistant` image) lack the **App** section in their configuration, so ESPConfig-Designer cannot run as a Home Assistant add-on. This project packages the designer as an independent service that runs alongside your containerized Home Assistant — same network, separate container, full functionality.

## Quick Start

```bash
docker compose up -d
```

The designer UI is available at **http://localhost:8099**.

## Configuration

| Env variable | Default | Description |
|---|---|---|
| `PORT` | `8099` | HTTP port |
| `USE_ESPHOME_SHARED_PATH` | `0` | Set to `1` to share ESPHome directory with HA |
| `TZ` | `Asia/Bangkok` | Timezone |

### Volumes

| Path | Purpose |
|---|---|
| `./config` | Persistent config — projects, YAML, assets, secrets |
| `./data` | Runtime data — jobs, devices, ESPHome cache |
| `./build` (optional) | ESPHome build cache for faster compiles |

## Architecture

- **Base image:** `ghcr.io/esphome/esphome-hassio` (includes ESPHome CLI for compiling)
- **Backend:** Python Flask API on port 8099
- **Frontend:** Static SPA served from `/web`
- **Storage:** Independent by default (`/config/ecd`); can share ESPHome dir with HA container via `USE_ESPHOME_SHARED_PATH=1`

## Credits

All UI, schema, and designer logic: [sokolsok/ESPConfig-Designer](https://github.com/sokolsok/ESPConfig-Designer).  
This repo only adds the Docker packaging and standalone server layer.
