# HTTP loader control for iOS

This library sends HTTP requests and notifies user in case of a network issue.

## Setup with Carthage

Add `github "exchangegroup/FitLoader" ~> 2.0` to your Cartfile and run `carthage update`.


## How it works

There are three types of network issues that this library detects:

1. No Internet connection.
1. Request failure.
1. A known error with HTTP status code 422.

#### 1. No Internet connection

Occurs when device can not reach Internet host. The app displays "No Internet connection" message. When internet connection becomes available this library automatically resends the HTTP request.

<img src='https://raw.githubusercontent.com/exchangegroup/FitLoader/master/Graphics/github_images/fit_loader_no_internet.png' alt='No Internet connection' width='250'>

#### 2. Request failure

This error is shown if device is connected to the Internet but still can not send or receive an HTTP request for various reasons (server error, for example). In this case the app shows "Connection error" message with a refresh button.

<img src='https://raw.githubusercontent.com/exchangegroup/FitLoader/master/Graphics/github_images/fit_loader_connection_error.png' alt='Connection error' width='250'>

#### 3. Known error

The server can send a response with HTTP status 422. If the body text is in the following JSON format it will be presented to the user in a message bar with a close button. If format is different, a 'Connection error' message will be shown.

<img src='https://raw.githubusercontent.com/exchangegroup/FitLoader/master/Graphics/github_images/filt_loader_error_422.png' alt='Custom error 422' width='250'>

##### Known error JSON response format

```JSON
{
  "knownErrorText": "It is error only, and not truth, that shrinks from inquiry."
}
```


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

Instantiate `TegReachabilityLoader` class and call its `startLoading` method to load data from the network.

#### Step 4

Call `reachability.reloadFailedRequestAndUpdateStatusMessage()` when view controller is presented.

This is typically done in `navigationController(...willShowViewController` method of navigation controller delegate.

```
TegReachability.shared.reloadOldFailedRequest()
```

## Methods and properties

### `startLoading`

Start loading data from the network.

### `Cancel`

Cancels the ongoing network request.

### `loading`

Returns true if we are currently loading data from the network.

## Handlers

### `onStarted`

You can assign a closure to `onStarted` property that will be called before the network request is sent. It can be used to show an activity indicator, for example.

```Swift
loader.onStarted = {
  // Has started loading
}
```

### `onFinishedWithSuccessOrError`

This handler is guaranteed to be called when network request finished with success or error. It can be used to hide activity indicator.

```Swift
newLoadder.onFinishedWithSuccessOrError = {
  // Has finished loading
}
```

### `onError`

You can assign a closure to `onError` property of the loader object. If you return `true` from this closure, the error is considered handled and no error message is shown.

```Swift
loader.onError = { error, response, text in
  return true
}
```

### `onUnauthorized`

The handler is called for responses with HTTP status code 401. If you supply a closure it will not call `onError` handler and will not show the error message.

```Swift
loader.onUnauthorized = { error, response, text in
  return true
}
```


## Attribution

[Reachability demo app by Apple](https://developer.apple.com/library/IOs/samplecode/Reachability/Introduction/Intro.html)

## Project home

https://github.com/exchangegroup/reachability-ios
