# The formula template. `make formula` fills in the version and the sha256 of
# each tarball from what `make dist` built, and the release workflow attaches
# the result to the GitHub release as `tritium.rb`. The tap at
# github.com/we-be/homebrew-tritium copies the latest one within the hour, so
#   brew trust we-be/tritium && brew install we-be/tritium/tritium
# installs the current release. (Homebrew no longer installs a formula from a
# bare file, so the attached one is the tap's source and a record of the
# checksums, not something to install directly.)
#
# Installs the five binaries (`tritium`, `tritium-cli`, `tritium-monitor`,
# `tritium-msg`, `tritium-load`) from the release tarballs — no compiler needed
# on the machine installing this, matching a zero-dependency project that ships
# as static binaries. (linux-arm, the GOARM=6 build for a Pi Zero, isn't
# packaged here — not a Homebrew target.)
class Tritium < Formula
  desc "RAM-only, zero-dependency key-value store that speaks the Redis protocol"
  homepage "https://github.com/we-be/tritium"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.8/tritium-v0.18.8-darwin-arm64.tar.gz"
      sha256 "8cfe9f41b2b25b3829094e384bca528f5eb66374b31fea0a44473d3bea5c0858"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.8/tritium-v0.18.8-darwin-amd64.tar.gz"
      sha256 "4f6fab20f8eee982edbdca2fcc95bc750e905a91a59f6c51ab24d0aa77d20d06"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.8/tritium-v0.18.8-linux-arm64.tar.gz"
      sha256 "087c2a33f63640fc225fc12e7f07649fc0cc90f396bcb497a775042f75ab256d"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.8/tritium-v0.18.8-linux-amd64.tar.gz"
      sha256 "02a7e841f948d81cfd04e632cfdb52ca7f6f6f36fc2d7d45bc4b6ca0381403af"
    end
  end

  def install
    bin.install "tritium", "tritium-cli", "tritium-monitor", "tritium-msg", "tritium-load"
  end

  test do
    # No live node needed: run with no subcommand and tritium-cli prints its
    # usage and exits 2, which is enough to prove the binary is the real one.
    output = shell_output("#{bin}/tritium-cli 2>&1", 2)
    assert_match "usage: tritium-cli", output
  end
end
