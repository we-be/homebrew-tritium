# homebrew-tritium

The Homebrew tap for [tritium](https://github.com/we-be/tritium), a RAM-only,
zero-dependency key-value store that speaks the Redis protocol.

    brew trust we-be/tritium      # Homebrew 6 asks before it loads a third-party tap
    brew install we-be/tritium/tritium

(Without the trust step, `brew tap we-be/tritium` answers "invalid syntax in
tap", which is Homebrew's refusal to read an untrusted tap, not a syntax error.)

`Formula/tritium.rb` is the `tritium.rb` the latest tritium release attaches
(its release workflow renders the version and checksums into it). The `update`
workflow here copies that file over every hour, and right away when tritium's
release workflow asks, after checking that it installs — so nothing in this
repo is edited by hand. To pull a release in now: `gh workflow run update`.
