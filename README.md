# homebrew-simantic

Homebrew tap for the [Simantic](https://simantic.dev) CLI.

```bash
brew tap simantic-dev/simantic
brew install simantic
```

Then authenticate and fetch the simulators:

```bash
simantic auth      # opens a browser; stores a token in ~/.sim_id
simantic install   # downloads sim, pyrite, and analog-cli into ~/.simantic/bin
```

## What this tap installs

`Formula/simantic.rb` is a Python virtualenv formula. It creates an isolated
venv against Homebrew's own managed Python, installs the `simantic` PyPI
package into it, and symlinks the `simantic` and `smtc` entry points into
`$(brew --prefix)/bin`.

It deliberately does **not** ship the simulators themselves. `sim`, `pyrite`,
and `analog-cli` are closed-source, account-gated downloads; they are fetched
by `simantic install`, which is the same authenticated flow the `pip` install
path uses. Nothing about that flow is reimplemented in Ruby.

This is also why the formula is not in `homebrew-core`: that tap requires
publicly buildable source. A self-hosted tap has no such requirement, and
needs no Apple Developer Program membership or code-signing work, because
Homebrew is installing Python code rather than a downloaded Mach-O binary.

## Status — not usable yet

The `simantic` package is **not published to PyPI**. `pypi.org/pypi/simantic/json`
and the TestPyPI equivalent both return 404. The formula's `url` and `sha256`
are placeholders and `brew install` will fail until the package ships. See the
comment at the top of `Formula/simantic.rb`, and `simantic-py/PUBLISHING.md`
for the publishing steps.

## Who has to do what

These steps need a human with the accounts; they are deliberately not
automated and were not performed by whoever scaffolded this directory:

1. Publish `simantic` to PyPI (see `simantic-py/PUBLISHING.md`).
2. Update `Formula/simantic.rb` with the real sdist url and sha256 — the
   version, the url, and the hash all change together.
3. Create the GitHub repository **`simantic-dev/homebrew-simantic`** (the
   `homebrew-` prefix is what makes `brew tap simantic-dev/simantic` resolve)
   and push this directory to it as the repository root, so the formula lands
   at `Formula/simantic.rb`.
4. Verify on a clean machine: `brew tap simantic-dev/simantic && brew install simantic && brew test simantic`.

## Maintaining the formula

The `pyyaml` dependency is pinned as a `resource` block, which is how Homebrew
vendors Python dependencies. Regenerate it after any dependency change:

```bash
brew update-python-resources Formula/simantic.rb
```

Bump the package version with:

```bash
brew bump-formula-pr --url=<new pypi sdist url> simantic
```
