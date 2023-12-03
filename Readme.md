# NimbleTest

Survey app is simple app develop by Swift 5 and Nimble BE. Application is using factory pattern
to create Login/Forgot password screen. 

This one is inspiration by Server Driven UI to dynamic create UI Components.
For demo purpose, we do not have server yet so I use a configuration inside app to make it.

App integrated pull to refresh and simple local cache as well.

Currently, App integrate auto refresh token by expiration time. We can also base on the backend code to refresh it during fetching survey but I didn't implement it yet.

For testing purpose, we can tap on avatar in home screen to logout.

This Project is using Moya for mocking networking layer and api request. 
https://github.com/Moya/Moya

Keychain for add/remove keychain easier.
https://github.com/evgenyneu/keychain-swift


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
