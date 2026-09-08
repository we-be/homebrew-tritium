# homebrew-tritium

The Homebrew tap for [tritium](https://github.com/we-be/tritium), a RAM-only,
zero-dependency key-value store that speaks the Redis protocol.

    brew install we-be/tritium/tritium

`Formula/tritium.rb` is the `tritium.rb` the latest tritium release attaches
(its release workflow renders the version and checksums into it). The `update`
workflow here copies that file over every hour, and right away when tritium's
release workflow asks, after checking that it installs — so nothing in this
repo is edited by hand. To pull a release in now: `gh workflow run update`.
