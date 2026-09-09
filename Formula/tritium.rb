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
      url "https://github.com/we-be/tritium/releases/download/v0.18.5/tritium-v0.18.5-darwin-arm64.tar.gz"
      sha256 "aa3f98aa7f5368ac0549546e8c1fc391c43d03e206b051253100a525e86e5894"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.5/tritium-v0.18.5-darwin-amd64.tar.gz"
      sha256 "1c5131a16b90d62f3eef878d155f0b3b7852d367bb8674a1381d4d11212ea667"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.5/tritium-v0.18.5-linux-arm64.tar.gz"
      sha256 "86f7ec713482b16adfc768e6a8a039d5cd0fb915b89c5fe212bb4aa8ba9c6708"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.5/tritium-v0.18.5-linux-amd64.tar.gz"
      sha256 "cc693620818b9e1768f8f3de0c82902f9657e808ec63df42b2a8d802bf72631f"
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
