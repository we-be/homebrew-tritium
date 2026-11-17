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
      url "https://github.com/we-be/tritium/releases/download/v0.18.9/tritium-v0.18.9-darwin-arm64.tar.gz"
      sha256 "01839a5e90f405c32d2f6d9c21600abc7492ff86dea9da6b82ec4de75910ee13"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.9/tritium-v0.18.9-darwin-amd64.tar.gz"
      sha256 "6e185b04aca42dc593c34095c1bce62b6b114b3b4b50c5db79ef27ddfff9bf75"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.9/tritium-v0.18.9-linux-arm64.tar.gz"
      sha256 "f433ef2201869bfae3159c9c30e134ae82ac18d53df0331b5b4be03726cd72ee"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.9/tritium-v0.18.9-linux-amd64.tar.gz"
      sha256 "623be73a50b93e652f3486febf8f014c63886ba5ef368fd78aa905e2f51d2dbc"
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
