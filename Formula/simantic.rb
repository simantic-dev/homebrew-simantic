class Simantic < Formula
  include Language::Python::Virtualenv

  desc "Python SDK and CLI for the Simantic circuit and firmware simulators"
  homepage "https://simantic.dev"

  # UNPUBLISHED: as of writing, `simantic` is not on PyPI (pypi.org/pypi/simantic/json
  # returns 404, and so does test.pypi.org). Both the url and the sha256 below are
  # therefore placeholders and this formula CANNOT install until the package ships.
  #
  # The url uses PyPI's stable /packages/source/ redirect form, which stays correct
  # across versions; the hashed /packages/<a>/<b>/... form `brew` normally writes is
  # equivalent. The sha256 is the hash of the sdist built locally from
  # simantic-py/dist/simantic-0.1.0.tar.gz and will NOT match the published artifact —
  # sdists are not byte-reproducible across build hosts.
  #
  # Once `simantic` is published, regenerate both with:
  #   brew bump-formula-pr --url=<pypi sdist url> simantic
  # or by hand from `curl -s https://pypi.org/pypi/simantic/json`.
  url "https://files.pythonhosted.org/packages/source/s/simantic/simantic-0.1.0.tar.gz"
  sha256 "c5b1b22e0cde0b5347fc93ddbcc808119221fc71049ed331f424f4f2f587b485" # PLACEHOLDER
  license "MIT"

  # pyyaml builds its C extension against libyaml.
  depends_on "libyaml"
  # requires-python = ">=3.11". Pinning a specific Homebrew python keeps the venv
  # from being rebuilt out from under the user on every python minor bump.
  depends_on "python@3.13"

  # simantic's only runtime dependency. Verified against
  # https://pypi.org/pypi/pyyaml/json on 2026-08-15: version 6.0.3, sdist.
  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      The simulators themselves (sim, pyrite, analog-cli) are not installed by this
      formula. They are closed-source, account-gated downloads. Fetch them with:

        simantic auth      # sign in (opens a browser); stores a token in ~/.sim_id
        simantic install   # downloads the binaries into ~/.simantic/bin

      Add ~/.simantic/bin to your PATH to call `sim` and friends directly.
    EOS
  end

  test do
    # The CLI has no --version flag (subcommands are auth/install/status), so the
    # version is asserted through the package it installed. `status` is avoided
    # here: it emits telemetry and touches the user's home directory.
    assert_match "Simantic SDK", shell_output("#{bin}/simantic --help")
    assert_match "Simantic SDK", shell_output("#{bin}/smtc --help")
    assert_equal version.to_s,
                 shell_output("#{libexec}/bin/python -c 'import simantic; print(simantic.__version__)'").strip

    # With no credentials, an install must fail closed rather than fetch anything.
    ENV["HOME"] = testpath
    output = shell_output("#{bin}/simantic install sim 2>&1", 1)
    assert_match "run `simantic auth`", output
  end
end
