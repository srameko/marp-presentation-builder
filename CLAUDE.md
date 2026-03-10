# marp-presentation-builder

Docker base image for building Marp presentations with Czech and English language support.

## Structure

- `Dockerfile` — image definition (Alpine, Chromium, Node.js, fonts)
- `local.conf` — fontconfig configuration (DejaVu + Liberation as primary fonts)
- `.github/workflows/docker-image.yml` — CI/CD pipeline

## CI/CD

Workflow triggers on push to `main` or manually. It automatically:
1. Extracts Alpine version from the `FROM` line in Dockerfile
2. Builds and pushes the image to Docker Hub with two tags: `:latest` and `:alpine<version>`

Required GitHub secrets: `DOCKER_USERNAME`, `DOCKER_PASSWORD`

## Updating Alpine / base image

When changing the version in `FROM dhi.io/alpine-base:<tag>`, the Docker Hub image tag updates automatically from the Dockerfile.

## Fonts

Installed: `font-dejavu`, `font-liberation`, `font-noto-emoji`

Priority order (see `local.conf`):
- sans-serif: DejaVu Sans → Liberation Sans
- serif: DejaVu Serif → Liberation Serif
- monospace: DejaVu Sans Mono → Liberation Mono

## Security

- Always run Chromium as the non-privileged `chrome` user, never as root
- Never remove `--no-sandbox`, `--disable-dev-shm-usage` and other Chromium hardening flags from `CHROMIUM_FLAGS`
- Do not install unnecessary packages — keep the image minimal
- Do not expose any ports in the Dockerfile
- Use `tini` as the entrypoint init process to ensure proper signal handling and zombie reaping
- Keep the base image (`dhi.io/alpine-base`) up to date — run `apk upgrade --no-cache --available` is already part of the build
- Do not store secrets or credentials in the Dockerfile or any committed file — use GitHub secrets
- Do not push to Docker Hub manually — always go through the CI/CD workflow
