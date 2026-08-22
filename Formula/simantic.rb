# frozen_string_literal: true

# Installs the prebuilt `sim` CLI binary from Simantic's public release bucket.
class Simantic < Formula
  desc "MCU/peripheral firmware simulator CLI (mcusim)"
  homepage "https://simantic.dev"
  version "0.5.2"

  # `sim` is a closed-source, prebuilt binary — there is no source to build from,
  # so this formula just fetches and installs it, the same way brew formulae for
  # other closed-source CLIs (1Password's `op`, `flyctl`, `doppler`) work. The
  # url/sha256 below come straight from the public release manifest at
  # https://drjdhqfvrttolueolzif.supabase.co/storage/v1/object/public/releases/cli/latest.json
  # and were verified locally (downloaded, sha256 matched, `sim --help` ran)
  # on 2026-08-21. Bump both blocks together when a new version ships.
  on_macos do
    if Hardware::CPU.arm?
      url "https://drjdhqfvrttolueolzif.supabase.co/storage/v1/object/public/releases/cli/0.5.2/osx-arm64/sim-v0.5.2-osx-arm64.zip"
      sha256 "3d1c3f0e1b6667924ef60bac2b88452ecf3f8fbcba271e122ea0634cc951fc6c"
    else
      odie "simantic has no published build for Intel macOS (Apple Silicon only)"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://drjdhqfvrttolueolzif.supabase.co/storage/v1/object/public/releases/cli/0.5.2/linux-x64/sim-v0.5.2-linux-x64.zip"
      sha256 "4fe0779032b33edfd493ee2fcb8d7a363718331c5b498c84f56b0d470bb6bd46"
    else
      odie "simantic has no published build for this Linux architecture (x86_64 only)"
    end
  end

  def install
    bin.install "sim"
  end

  def caveats
    <<~EOS
      Sign in once to enable `sim update` and account-gated features:

        sim login
    EOS
  end

  test do
    assert_match "mcusim — CLI MCU emulator", shell_output("#{bin}/sim --help")
  end
end
