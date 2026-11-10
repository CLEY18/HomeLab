# HomeLab

## Directory Conventions (APP_PATH / DATA_PATH)

Every service exposes its state through env variables, and the location follows
**ownership**:

- `*_APP_PATH` → `./docker/<service>/` — **service-owned** files: configuration, generated keys/credentials, logs, indexes and other runtime state. Required for the service to run, but not user data.
- `*_DATA_PATH` → `./data/db/<service>/` (or `./data/storage/...` for large user files) — **user content**: uploads, content generated for the user, database data.

Both trees are gitignored. Only committed config templates live in the repo, in a service-named folder next to the compose file (e.g. ` /librechat/librechat.yaml`, values via `${VAR}` from `.env` only).

Splitting a new service:

1. Find where the image keeps its state.
2. Classify each directory by owner — user content → `DATA_PATH`; service-owned (config, keys, logs, derived indexes) → `APP_PATH`.
3. If the product keeps all state in one storage directory with no config/data split, declare only `*_DATA_PATH` — an empty `APP_PATH` is structure theater, not structure.
4. Never put secrets in the repo, and never user data into `docker/`.

---

## Configuring Services 

### PostgreSQL

```bash
mkdir -p ./data/db
sudo chown -R 999:999 ./data/db
sudo chmod 700 ./data/db
```

### Nextcloud

#### Folder access

```bash
mkdir -p ./data/storage
sudo chown -R 33:33 ./data/storage
sudo chmod -R 750 ./data/storage
```

#### Scanning files downloaded from external sources

```bash
docker exec -u www-data <CONTAINER_NAME> php occ files:scan <USER_NAME>
```

### Wealthfolio

```bash
sudo chown -R 1000:1000 ./data/db/wealthfolio
sudo chmod -R 700 ./data/db/wealthfolio
```

### Jupyter

#### Integration with WSL

1. The NVIDIA Container Toolkit is included in the WSL distribution:
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
```

2. For Docker Desktop (with WSL2 integration), you need to restart Docker Desktop and enable the following in its settings:
`Settings → Resources → WSL Integration` → make sure integration is enabled for your distribution.

For native Docker inside WSL (without Docker Desktop), you need to register the runtime:
```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

3. Final check
```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

---

## Post-Deployment Support 

### PostgreSQL

Adding new databases after running `init.sql`:
```bash
docker compose exec postgres bash -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE DATABASE {db_name};"'
```

---

## Launching Services

Launching services with configurations for different environments:
```bash
docker compose -f docker-compose.yaml -f docker-compose.{ENV}.yaml --env-file .env --env-file .env.{ENV} up -d {SERVICE_NAME}
```

---
