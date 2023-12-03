
# NimbleTest

Survey App is a simple iOS application developed using Swift 5 and Nimble BE. 
The application leverages the factory pattern to create dynamic Login and Forgot Password screens. 

This way, we are able to create UI flexible and remote control UI as well.

## Features

`Pull to Refresh integration.`

`Simple local cache to save response to file.`

`Auto-refresh token based on expiration time and backend invalid code response.`

`Forgot password integration.`

## Dependencies

The project utilizes the following dependencies:

`Moya`: Networking layer and API request mocking.

`Keychain Swift`: Simplifying keychain operations.

`Kingfisher`: To simplifying display image. 

`SnapKit`: To auto layout and ui development.


## Environment Setup

Follow these steps to set up the development environment for the project.

### Prerequisites

- Xcode 14.3 installed on your machine.
- CocoaPods installed. If not, install it using:

```bash
sudo gem install cocoapods
```

### Installation
Clone the repository to your local machine:
```
git@github.com:congtung10t2/NimbleTest.git
```

Navigate to the project directory:
```
cd NimbleTest
```

Pod install:
```
pod install
```

Open the project workspace in Xcode:
```
SurveyApp.xcworkspace
```
Finally, click on run and test it.

We can tap on the avatar to logout during testing.
