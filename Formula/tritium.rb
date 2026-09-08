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
      url "https://github.com/we-be/tritium/releases/download/v0.18.1/tritium-v0.18.1-darwin-arm64.tar.gz"
      sha256 "bcc00b1eaa1ea55bc06fb7e58e4108d6441f37ffdf064f689da99151b6384359"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.1/tritium-v0.18.1-darwin-amd64.tar.gz"
      sha256 "b29d8e010718e0cb6567ae219d6bd3a9597c43285874423461180da59bfce458"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.1/tritium-v0.18.1-linux-arm64.tar.gz"
      sha256 "4c9c07c13c563ebe7963315a2d258c0ff17b6054831d70ed53d4a4d51b9e6ab6"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.1/tritium-v0.18.1-linux-amd64.tar.gz"
      sha256 "291b9d54e2e6aa433a8754a689e544bdff5fa9bdc96ac03f6c25d8b6e106a561"
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
