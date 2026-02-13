GitHub Container Registry (GHCR) secret setup

This short guide shows how to create a Personal Access Token (PAT) and configure the repository secret used by the `build-proxy.yml` workflow to push the `analytics-proxy` image to GHCR.

Recommended token permissions

- Best practice: create a fine-grained PAT scoped to the repository if possible.
- Minimum scopes for pushing packages to GHCR:
  - `write:packages` (or `packages:write` for fine-grained tokens)
  - `delete:packages` (optional, only if you need to delete published packages)

Create a PAT (classic)

1. Go to https://github.com/settings/tokens (or GitHub profile → Settings → Developer settings → Personal access tokens).
2. Click "Generate new token" → "classic".
3. Give it a descriptive name (e.g. `matsjekk-ghcr-push`), expiry (choose according to your policy).
4. Under `Select scopes`, enable `write:packages` (and `delete:packages` if desired).
5. Generate the token and copy it — you will not be able to see it again.

Create a fine-grained token (preferred)

1. Go to https://github.com/settings/tokens (Fine-grained)
2. Create a new token, select the repository, and allow `Packages` write permissions.
3. Set an expiration and generate the token.

Add the token as a repository secret

1. Go to the repository on GitHub.
2. Settings → Secrets and variables → Actions → New repository secret.
3. Name: `GHCR_PAT`
4. Value: paste the token you copied earlier.
5. Save secret.

Notes

- The workflow `.github/workflows/build-proxy.yml` will detect `GHCR_PAT` and push the built image as `ghcr.io/<owner>/matsjekk-analytics-proxy:latest`.
- For organization-wide or long-lived automation, consider using GitHub Apps or OIDC-based workflows instead of a personal token.
- Keep the PAT secret and rotate it regularly according to your security policy.
