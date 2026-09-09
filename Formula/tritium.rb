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
      url "https://github.com/we-be/tritium/releases/download/v0.18.2/tritium-v0.18.2-darwin-arm64.tar.gz"
      sha256 "210639f404dbeb9f9b075519e0d8162a5caabbd4096031c04f485454ce3d4bf4"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.2/tritium-v0.18.2-darwin-amd64.tar.gz"
      sha256 "62d5c5e4912e5fad55f2cb067907d55626bae7b0b71f422bd832c591679f369e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.2/tritium-v0.18.2-linux-arm64.tar.gz"
      sha256 "d84435d8b2a1697d3231bb9f012a288755d52fdf8d43811e29f7cb78ab1863d3"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.2/tritium-v0.18.2-linux-amd64.tar.gz"
      sha256 "1dbdb145542af8c04f4ffcfe2ebd82d655c2424fe1f846826a0cfbe4cbea276d"
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
