# iOS

You can find an iOS implementation of Mockturtle including Unit- and UI-Tests in [Example/macOS-iOS/MockturtleExample](https://github.com/thepeaklab/mockturtle/tree/master/Example/macOS-iOS)

## Alamofire

You can almost let Alamofire do the job of mapping state identifiers for specific routes.


### 1. Define Scenarios + Build Output

- Define your scenarios as shown in [Docs/scenarios.md](scenarios.md)
- Run `mockturtle generate` to generate the `output.json`

### 2. Make Mapping Available

Drag and Drop `output.json` into your Xcode project or go to File > Add Files to "Your Project" and select your `output.json`.

You **don't** have to check `Copy items if needed`. When you let this checkbox unselected, you can update your `output.json` all the time and it stays fresh in your Xcode project aswell.

From now on your can access your `output.json` via

```swift
Bundle.main.url(forResource: "output", withExtension: "json")
```

### 3. Add Alamofire and Mockturtle iOS Helper

Cartfile
```
github "Alamofire/Alamofire" ~> 4.8.1
github "thepeaklab/mockturtle-ios" ~> 0.1.0
```

### 4. Add Mockturtle Alamofire Request Adapter

```swift
let sessionManager = SessionManager.default
sessionManager.adapter = MockturtleRequestAdapter("the_scenario_you_want_to_mock")
sessionManager.request("<your url>").responseData { response in
    // to something
}
```

## App Transport Security

```plist
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsLocalNetworking</key>
	<true/>
</dict>
```

see [Apple Documentation - CocoaKeys](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html)

If set to `YES`, allows loading of local resources without disabling ATS for the rest of your app. Default value is NO.