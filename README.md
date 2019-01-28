# Mockturtle

[![Build Status](https://travis-ci.com/thepeaklab/mockturtle.svg?branch=master)](https://travis-ci.com/thepeaklab/mockturtle)
![Swift Version](https://img.shields.io/badge/Swift-4.2-brightgreen.svg)
![PackageManager](https://img.shields.io/badge/PackageManager-SPM-brightgreen.svg?style=flat)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://github.com/thepeaklab/mockturtle/blob/master/LICENSE)
[![Twitter: @thepeaklab](https://img.shields.io/badge/contact-@thepeaklab-009fee.svg?style=flat)](https://twitter.com/thepeaklab)

`Mockturtle` is an easy configurable and generic mock server based on [Vapor](https://vapor.codes). The goal of `Mockturtle` is to mock server results whereas the necessity for making source code changes (just because of the mock server) is kept to an absolute minimum.

The only difference between production and test code will be the `base url` of your request (`https://api.example.com/...` vs. `http://localhost:8080/`) which may already vary for different environments (`production, staging, testing`) and one (optional) additional HTTP Header `x-mockturtle-state-identifier` to specify the state you want to mock.

## Available for 

- macOS
- Linux
- Docker

## Mock Configuration File

```yaml
version: "0.1.0"
routes:

# basic route
  - url: "v1/auth/login"  # defines the route
    directory: "login"    # override the default route directory to "login" (optional)
    method: "POST"        # defines the HTTP method (optional)

# short example
# when directory is not set: url will be the default directory (see folder structure)
# when method is not set: all HTTP methods will be routed
  - url: "v1/users"

# short example 2
# you don't have to define a route to mock responses
# its also possible to just define one directory, which can be useful for generic error codes
- directory: "global/error_codes"
```

### Folder Structure

```
mock-config.yml
├── login/
│   ├── valid.yml
│   └── invalid.yml
└── global/
    └── error_codes/
        ├── 404.yml
        └── 500.yml
```

### State Configuration File

**login/valid.yml**

```yaml
version: "0.1.0"
# Result for valid login

# optional: you can override the state identifier
# default value: file name without the suffix (in this example: valid)
identifier: override_valid

# optional: simulate a response delay
# from - to will generate a random delay from 0 to 1 seconds
delay:
  from: 0
  to: 1

# the mock response
response:
  code: 200
  header:
    Content-Type: "application/json"
  body: >
    {
      "user": {
        "name": "Peter",
        "age": 19
      }
    }
```

### File Watch

You can modify your `mock-config.yml` while the `Mockturtle` server is running. File changes will be recognized and the server will update instantly.

## Homebrew

```shell
brew tap thepeaklab/tap
brew install mockturtle
```

## Start the Server

```shell
# in the folder where your mock-config.yml lives
mockturtle serve
```

## Need Help?

Please [submit an issue](https://github.com/mockturtle-parser/issues) on GitHub.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.