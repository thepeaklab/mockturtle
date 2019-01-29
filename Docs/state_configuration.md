# State Configuration

```yaml
version: "0.1.0"
# Result for valid login

# optional: you can override the state identifier
# default value: file name without the suffix (in this example: valid)
identifier: override_identifier

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