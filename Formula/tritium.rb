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
      url "https://github.com/we-be/tritium/releases/download/v0.18.3/tritium-v0.18.3-darwin-arm64.tar.gz"
      sha256 "78b3350de93290338b73ecf7795a36412eba2cc96e4e960e01fe6b2f8ce5140c"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.3/tritium-v0.18.3-darwin-amd64.tar.gz"
      sha256 "a670a70c99e77c7729df9dbe0f2fa6a62b357f1b58713c28c6ef5e6d30e6f291"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.3/tritium-v0.18.3-linux-arm64.tar.gz"
      sha256 "6ae6becc73bf01b040acd685f224658ff398ea846555261714828787ee2c43e0"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.3/tritium-v0.18.3-linux-amd64.tar.gz"
      sha256 "dbe94449575b9c4ec01265bc7218966ed29322fb3b7197b6f21ae57e08878e01"
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
