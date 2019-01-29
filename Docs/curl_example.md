# curl example

## Simple

- Basic call without defining the state identifier.
- If there is only one state for a specific route, you dont need to set the identifier

```shell
curl -X POST -D - http://localhost:8080/v1/auth/login
```

```http
HTTP/1.1 200 OK
Content-Type: application/json
content-length: 90
x-mockturtle-delay-in-ms: 684
date: Tue, 29 Jan 2019 07:36:23 GMT
Connection: keep-alive

{
  "user": {
    "name": "Peter",
    "age": 19
  }
}
```

## State Identifier

You can set the Header `x-mockturtle-state-identifier: <STATE-IDENTIFIER>` to get the specific state for the route.

```shell
curl -X GET -H "x-mockturtle-state-identifier: default" -D - http://localhost:8080/v1/users
```

```http
HTTP/1.1 200 OK
Content-Type: application/json
content-length: 90
x-mockturtle-delay-in-ms: 904
date: Tue, 29 Jan 2019 07:43:04 GMT
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

### Multiple States

When multiple states are defined for one route, you have to set the state identifier in the header, so that `Mockturtle` knows what to return. When no state is set you will get the following error.

```shell
curl -X GET -D - http://localhost:8080/v1/users
```

```http
HTTP/1.1 404 Not Found
content-length: 124
content-type: application/json; charset=utf-8
date: Tue, 29 Jan 2019 07:43:14 GMT
Connection: keep-alive

{"error":true,"reason":"x-mockturtle-state-identifier not set and no or too states many found for route `GET: \/v1\/users`"}% 
```