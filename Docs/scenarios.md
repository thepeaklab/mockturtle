# Scenarios

Scenario files are optional which can help you to manage multiple states routes in one scenario.

## Example 1

Let's say you want to test the result of `v1/users`, but your server logic says: `v1/users` is only accessible when your are logged in.

You need to mock:
- `v1/auth/login`: state for a valid login
- `v1/users`     : state for the result you want to test

```yaml
version: "0.1.0"
routes:
  - path: v1/auth/login       # 
    method: POST              # POST v1/auth/login should be send with state valid_login
    state: valid_login        # 
  
  - path: v1/users            #
    method: GET               # GET v1/users should be send with state default
    state: default            #
```

## Nested Scenarios

You can nest other scenario files, to prevent the need of always redeclaring the same routes/states, for example a valid login.

```yaml
version: "0.1.0"
routes:
  - path: v1/users
    method: GET
    state: default
includes:
  - login/valid_login.yml
```

## Flat

```shell
# cd in the directory with all your scenario files
cd Example/macOS-iOS/Mock/scenarios
# generate one output.json
mockturtle generate --folder Example/ --output-file output.json
```

`mockturtle generate` will generate the following content in `output.json`, which is easy to parse in your http client, for route/state mapping (see [Docs/ios.md](ios.md)).

```json
{
  "scenarios": {
    "all_valid": {
      "routes": [
        {
          "path": "v1/auth/login",
          "method": "POST",
          "state": "valid"
        },
        {
          "path": "v1/users",
          "method": "GET",
          "state": "default"
        }
      ]
    }
  }
}
```
