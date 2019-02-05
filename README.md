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

## Homebrew

```shell
brew tap thepeaklab/tap
brew install mockturtle
```

## Docker

```shell
# generate scenario json
docker run -i -v `pwd`:/folder -e FOLDER=/folder -e OUTPUT_FILE=/folder/output.json mockturtle:0.1.0

# serve
docker run -i -v `pwd`:/folder -e CONFIG=/folder/mock-config.yml --entrypoint="entrypoint-serve.sh" -p 8080:8080 mockturtle:0.1.0
```

## Mock Configuration File

For more information about `mock-config.yml` see [Docs/mock_config.md](Docs/mock_config.md)

```yaml
version: "0.1.0"
routes:
  - url: v1/auth/login
    directory: login
    method: POST
  - url: v1/users
- directory: global/error_codes
```

### State Configuration

For more information about state configurations see [Docs/state_configuration.md](Docs/state_configuration.md)

```yaml
version: "0.1.0"
# Result for valid login

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

## Serve

```shell
# in the folder where your mock-config.yml lives
> mockturtle serve
Server starting on http://localhost:8080
```

### File Watch

You can modify your `mock-config.yml` while the `Mockturtle` server is running. File changes will be recognized and the server will update instantly.

## Need Help?

Please [submit an issue](https://github.com/mockturtle/issues) on GitHub.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.