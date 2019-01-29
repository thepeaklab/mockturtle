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

You can nest other sceneario files, to prevent the need of always redeclaring the same routes/states, for example a valid login.

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

WIP