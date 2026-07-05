source "https://rubygems.org"

gem "jekyll", ">= 4.4.1"
# logger used to be loaded from the standard library, but isn't since Ruby 4.0.0
# jekyll doesn't want to add it, see https://github.com/jekyll/jekyll/issues/9763
gem "logger", ">= 1.7.0"
gem "html-proofer", ">= 5.2.1"

gem "wdm", ">= 0.1.0" if Gem.win_platform?

eval_gemfile "script/Gemfile"
