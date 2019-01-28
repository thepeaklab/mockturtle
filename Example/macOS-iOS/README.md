# Mockturtle Example

## Environment

- OS: macOS
- Platform: iOS

### 1. Install Mockturtle

```shell
brew tap thepeaklab/tap
brew install mockturtle
```

### 2. Configure

```shell
# create mock folder
mkdir Mock
cd Mock

# create basic mock-config.yml
cat <<EOF >mock-config.yml
version: "0.1.0"
routes:
  - url: "v1/auth/login"
    method: POST
  - url: "v1/users/me"
    method: GET
  - directory: "global/error_codes"
EOF
```

### 3. Serve

```shell
# start mockturtle
mockturtle serve
```

`Mockturtle` will start and provide some parsing information. `Mockturtle` had some issues when parsing the config, because we did not create the directories yet.

```shell
> mockturtle serve
Mockturtle started, Log Level: info
WARNING : resolved directory for route `/v1/auth/login` does not exist or is not a directory
WARNING : resolved directory for route `/v1/users/me` does not exist or is not a directory
WARNING : resolved directory for route `global/error_codes` does not exist or is not a directory
Server starting on http://localhost:8080
```

### 4. Finish Configuration

`Mockturtle` will keep printing information about the status of your configuration while you are editing files. So it's helpful to launch a new terminal tab/window to keep an eye on the `mockturtle serve` process while making changes.

```shell
# create directories for routes
mkdir -p v1/auth/login
mkdir -p v1/users/me
mkdir -p global/error_codes
```

```shell
# create valid state for v1/auth/login
cat <<EOF >v1/auth/login/valid.yml
version: "0.1.0"
# Result for valid login

delay:
  from: 0
  to: 1

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
EOF
```

`Mockturtle` will detects your changes and prints

```shell
detected file changes in:
- /v1/auth/login/valid.yml
reload config
INFO    : no state files found in directory `<YOURPATH>/mockturtle/Example/macOS-iOS/Mock/v1/users/me`
INFO    : no state files found in directory `<YOURPATH>/mockturtle/Example/macOS-iOS/Mock/global/error_codes`
```

Add configuration files for all other routes until mockturtle no longer prints warnings.


### 5. Test

```shell
curl -X GET -D - http://localhost:8080/v1/users/me
```
```http
HTTP/1.1 200 OK
Content-Type: application/json
content-length: 90
x-mockturtle-delay-in-ms: 65
date: Mon, 28 Jan 2019 14:29:52 GMT
Connection: keep-alive

[
  {
    "name": "Peter",
    "age": 19
  },
  {
    "name": "Hans",
    "age": 20
  }
]
```