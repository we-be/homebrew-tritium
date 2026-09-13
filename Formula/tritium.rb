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
      url "https://github.com/we-be/tritium/releases/download/v0.18.7/tritium-v0.18.7-darwin-arm64.tar.gz"
      sha256 "38c0da5423a1742ea976ed8be3ccc96dfebe4b685ee8c4b69128e45a2836654b"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.7/tritium-v0.18.7-darwin-amd64.tar.gz"
      sha256 "89c6aac0e8fb2f53b4348b6c88d709ac33eb9092c2a9c7d28254771cd401fe80"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.7/tritium-v0.18.7-linux-arm64.tar.gz"
      sha256 "f7b6323e46eda915f9877df5c4a50a5423e59c1fc54193b829b41e41b417fb7f"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.7/tritium-v0.18.7-linux-amd64.tar.gz"
      sha256 "6ded003d1c471b6f6c55f378e96fbf538dc8b558dd384aa6698048bb50d833b4"
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
