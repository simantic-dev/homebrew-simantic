# homebrew-simantic

Homebrew tap for the [Simantic](https://simantic.dev) CLI (`sim`).

```bash
brew tap simantic-dev/simantic
brew install simantic
```

Then sign in:

```bash
sim login   # opens a browser
```

## What this tap installs

`Formula/simantic.rb` fetches the prebuilt `sim` binary directly from the
public release manifest and installs it into `$(brew --prefix)/bin` — no
build step, since `sim` is closed-source. This is the same pattern other
closed-source CLIs use on Homebrew (1Password's `op`, `flyctl`, `doppler`):
a self-hosted tap that just downloads and installs a signed artifact.

This is also why it's not in `homebrew-core` — that tap requires publicly
buildable source. A self-hosted tap has no such requirement and needs no
Apple Developer Program membership or code-signing work.

Published platforms today: `osx-arm64` (Apple Silicon) and `linux-x64`.
Intel Mac and other Linux architectures have no published build yet.

## Status

Live. The formula's `url`/`sha256` are pinned to the real `0.5.2` artifacts
from `releases/cli/latest.json`, verified by downloading and running `sim
--help` locally before publishing this tap.

## Bumping the version

The release manifest is public and unauthenticated:

```bash
curl -s https://drjdhqfvrttolueolzif.supabase.co/storage/v1/object/public/releases/cli/latest.json
```

Update `version`, both `url`s, and both `sha256`s in `Formula/simantic.rb`
from that manifest, then:

```bash
brew audit --strict simantic
brew install --build-from-source simantic  # sanity check locally
brew test simantic
```
