# HTTP loader control for iOS

This is an iOS library and a demo app. The library is made for sending HTTP requests that can handle network connection problems.

There are three types of connection problem that this library detects:

1. No Internet connection.
1. Request failure.
1. A known error with HTTP status code 422.

### 1. No Internet connection

Occurs when device can not reach Internet host. The app displays "No Internet connection" message at the bottom of the screen. When internet connection becomes available this library automatically resends the HTTP request.

<img src='https://dl.dropboxusercontent.com/u/11143285/bikeexchange/reachability_notification/reachability-notification.png' alt='reachability ios' width='320'>

### 2. Request failure

This error is shown if device is connected to the Internet but still can not send or receive an HTTP request for various reasons (server error, for example). In this case the app shows "Connection error" message with a refresh button.

<img src='https://dl.dropboxusercontent.com/u/11143285/bikeexchange/reachability_notification/reachability-notification-2.png' alt='reachability ios' width='320'>

### 3. Known error

The server can send a response with HTTP status 422. The body test of the response will be presented to the
user in a message bar with a close button.

## Handling custom errors

This demo app has an example of using custom error handler in `TegAuthenticatedLoader` class.
This example shows how to present login screen if there is a 401 response from server.

## Usage

Steps to make your view controller 'reachable':

#### Step 1

Start listening for network status updates in your app delegate.

```
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

  TegReachability.shared.startListeningForNetworkStatusChanges("www.altavista.com")

  return true
}
```

#### Step 2

Adopt `TegReachableViewController` protocol in your view controllers.

```
class MyViewController: UIViewController, TegReachableViewController {
   weak var failedLoader: TegReachabilityLoader?
   ...
}
```

#### Step 3

Use `TegReachabilityLoader` to load data from server.

#### Step 4

Call `reachability.reloadFailedRequestAndUpdateStatusMessage()` when view controller is presented.

This is typically done in `navigationController(...willShowViewController` method of navigation controller delegate.

```
TegReachability.shared.reloadOldFailedRequest()
```

## Attribution

[Reachability demo app by Apple](https://developer.apple.com/library/IOs/samplecode/Reachability/Introduction/Intro.html)

## Project home

https://github.com/exchangegroup/reachability-ios
