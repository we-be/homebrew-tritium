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
      url "https://github.com/we-be/tritium/releases/download/v0.18.6/tritium-v0.18.6-darwin-arm64.tar.gz"
      sha256 "266e5aa893f6bcb3e208ac469e077b78301e146af6a83562aa81242c7f5774c8"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.6/tritium-v0.18.6-darwin-amd64.tar.gz"
      sha256 "3171b95ebb2d903944f7b597da8e6c2969eca9c9e36b568863b9892b9e2a46b5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.6/tritium-v0.18.6-linux-arm64.tar.gz"
      sha256 "2460a25154d7ca7d6a318294e0191383de920f214064296abf5456f4e70e590c"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.6/tritium-v0.18.6-linux-amd64.tar.gz"
      sha256 "b845687bdcbac8aa82f94ab163958057c4153e5db18aff2642cfb782ef59a3f8"
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
