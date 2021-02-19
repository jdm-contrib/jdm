JustDeleteMe
============

A directory of direct links to delete your account from web services.

[![Build Status](https://travis-ci.org/jdm-contrib/jdm.svg?branch=master)](https://travis-ci.org/jdm-contrib/jdm)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/53bbffc9bd3c40459200b33736922c6b)](https://www.codacy.com/app/tupaschoal/justdelete-me)

## Building Locally

JustDeleteMe is built using [Jekyll](https://jekyllrb.com/) and is linted and
validated using a mixture of Ruby and Node.js packages and scripts.

**Dependencies:**

- [Ruby](https://www.ruby-lang.org) (>=2.7.2)
- [Node.js](https://nodejs.org)

**Installation**

- Clone the repository

  ```
  git clone https://github.com/jdm-contrib/jdm.git
  ```

- Install dependencies

  ```
  cd jdm
  gem install bundler
  bundle install
  ```

**Building the site**

Just run `jekyll serve`

**Testing**

Tests are run via the "cibuild" script, and can be run via `./script/cibuild`

## Contributing

If you want to help, do read our [contributing](CONTRIBUTING.md) guidelines.

## Misc

Search functionality modified from [DevCenter.me](https://github.com/stevestreza/DevCenter.me).

## License

Licensed under the MIT License (MIT). See `LICENSE`.

Country Flag Icons Copyright (c) 2017 Go Squared Ltd. http://www.gosquared.com/

DevCenter.me Copyright (c) 2013 Steve Streza

This is a detached fork of the original repo that intends to keep the project
alive, as the original one was abandoned.
