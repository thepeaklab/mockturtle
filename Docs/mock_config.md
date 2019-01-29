# Mock Configuration File

```yaml
version: "0.1.0"
routes:

# basic route
  - url: v1/auth/login    # defines the route
    directory: login      # override the default route directory to "login" (optional)
    method: POST          # defines the HTTP method (optional)

# short example
# when directory is not set: url will be the default directory (see folder structure)
# when method is not set: all HTTP methods will be routed
  - url: v1/users

# short example 2
# you don't have to define a route to mock responses
# its also possible to just define one directory, which can be useful for generic error codes
- directory: global/error_codes
```