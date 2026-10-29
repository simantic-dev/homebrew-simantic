# frozen_string_literal: true

# `sim` comes with the Developer plan and downloads only through an
# authenticated, license-checked endpoint, which a public Homebrew formula
# cannot call. This formula stays so `brew install simantic` says where to go
# instead of failing on a dead URL.
class Simantic < Formula
  desc "Firmware simulator CLI (sim), available with the Simantic Developer plan"
  homepage "https://simantic.com"
  url "https://simantic.com/install"
  version "0.0.0"
  sha256 :no_check

  def install
    odie <<~EOS
      Homebrew installs of sim are retired. sim comes with the Developer plan:
      subscribe at https://simantic.com/dashboard/billing, then follow the
      install steps on https://simantic.com/dashboard/releases.
    EOS
  end
end
