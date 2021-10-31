# JustDeleteMe

A directory of direct links to delete your account from web services.

![Build Status](https://github.com/jdm-contrib/jdm/actions/workflows/workflow.yml/badge.svg)

## Building Locally

JustDeleteMe is built using [Jekyll](https://jekyllrb.com/) and is linted and
validated using a mixture of Ruby and Node.js packages and scripts.

### Dependencies

- [Ruby](https://www.ruby-lang.org) (>=2.7.2)
- [Node.js](https://nodejs.org)

### Installation

- Clone the repository

  ```sh
  git clone https://github.com/jdm-contrib/jdm.git
  ```

- Install dependencies

  ```sh
  cd jdm
  gem install bundler
  bundle install
  ```

### Building the site

Just run `jekyll serve`

### Testing

Tests are run via the "cibuild" script, and can be run via `./script/cibuild`

## Contributing

If you want to help, do read our [contributing](CONTRIBUTING.md) guidelines.
To help with translating, also see our [translation](TRANSLATION_REFERENCE.md)
guidelines.

## License

Project licensed under the [MIT License](LICENSE) (MIT). This is a detached
fork of the [original repo](https://github.com/justdeleteme/justdelete.me)
that intends to keep the project alive, as the original one was abandoned.

Language icon from [Font Awesome](https://github.com/FortAwesome/Font-Awesome)
released under the [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)
license. Minor alignment changes made to optimize for the display size.

Search functionality modified from [DevCenter.me](https://github.com/stevestreza/DevCenter.me),
MIT licensed, Copyright (c) 2013 Steve Streza.
