# The formula template. `make formula` fills in the version and the sha256 of
# each tarball from what `make dist` built, and the release workflow attaches
# the result to the GitHub release as `tritium.rb`. The tap at
# github.com/we-be/homebrew-tritium copies the latest one within the hour, so
#   brew install we-be/tritium/tritium
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
      url "https://github.com/we-be/tritium/releases/download/v0.18.0/tritium-v0.18.0-darwin-arm64.tar.gz"
      sha256 "60f53d4667c0dc7812303258133a5a71b7616efaa442c34e0eae39bc1a15c37b"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.0/tritium-v0.18.0-darwin-amd64.tar.gz"
      sha256 "3927aa01cffa0419bed64ef2200732c00b9c460a62052f88df85c82a3029f17b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/we-be/tritium/releases/download/v0.18.0/tritium-v0.18.0-linux-arm64.tar.gz"
      sha256 "8d0177a54a93728421aac14ac80cdb1d1638af8697080aa31fc3216d082a5659"
    else
      url "https://github.com/we-be/tritium/releases/download/v0.18.0/tritium-v0.18.0-linux-amd64.tar.gz"
      sha256 "781b4a61630b5523973d77e80b5c7a922d1f8c4b8d0c5acd9b7824b545529954"
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
