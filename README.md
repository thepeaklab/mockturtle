# Mockturtle

[![Build Status](https://travis-ci.com/thepeaklab/mockturtle.svg?branch=master)](https://travis-ci.com/thepeaklab/mockturtle)
![Swift Version](https://img.shields.io/badge/Swift-4.2-brightgreen.svg)
![PackageManager](https://img.shields.io/badge/PackageManager-SPM-brightgreen.svg?style=flat)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://github.com/thepeaklab/mockturtle/blob/master/LICENSE)
[![Twitter: @thepeaklab](https://img.shields.io/badge/contact-@thepeaklab-009fee.svg?style=flat)](https://twitter.com/thepeaklab)

`Mockturtle` is an easy configurable and generic mock server based on [Vapor](https://vapor.codes).

## Available for 

- macOS
- Linux
- Docker

## Basic Configuration File

```yml
version: "0.1.0"
routes:
  - url: "v1/auth/login"  # defines the route
    directory: "login"    # override the default route directory to "login" (optional)
    method: "POST"        # defines the HTTP method (optional)
```

### File Watch

You can modify your `mock-config.yml` while the `Mockturtle` server is running. File changes will be recognized and the server will update instantly.

## Homebrew

WIP

## Start the Server

```shell
CONFIG=/path/tomock-config.yml swift run Run serve --env prod --hostname 0.0.0.0 --port 80
```

## Need Help?

Please [submit an issue](https://github.com/mockturtle-parser/issues) on GitHub.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.