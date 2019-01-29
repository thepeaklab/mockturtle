# Folder Structure

```
mock-config.yml            # main config file
├── login/                 # folder for each route
│   ├── valid.yml          # - state 1 for login route, default identifier: valid
│   └── invalid.yml        # - state 2 for login route, default identifier: invalid
├── global/
│   └── error_codes/
│       ├── 404.yml
│       └── 500.yml
└── scenarios              # scenarios folder
    ├── all_valid.yml      # scenario file, default identifier: all_valid
    ├── valid_login.yml    # scenario file, default identifier: valid_login
    └── invalid_login.yml  # scenario file, default identifier: invalid_login
```