# mCards iOS Auth SDK Demo App
The mCards iOS Auth SDK Demo App shows how to use the mCards iOS Auth SDK, which encapsulates the following functionality:
1. Authenticate via Auth0 by refreshing the users existing session or require entering credentials
2. Collect user profile / address information

# Importing
The SDK can be imported via SPM (Swift Package Manager).

- In XCode, go to: File -> Add Package Dependencies
- In the search bar enter: `https://github.com/Wantsa/sdk-auth-ios-framework`
- Choose a dependency rule (e.g. `Up to Next Major` with `1.0.0`
- Click `Add Package`

The CoreSDK must also be imported for the `Auth SDK` to work. Follow the same steps as above and enter: `https://github.com/Wantsa/sdk-model-ios-framework`
in the search bar.

# Usage
Implementing apps must take additional steps if using the SDK and Auth0 as a token provider. In Xcode:
- Go to the info tab of your app target settings
- In the `URL Types` section, click the `+` button to add a new entry
- Enter `auth0` into the `Identifier` field and `$(PRODUCT_BUNDLE_IDENTIFIER)` in the `URL Schemes` field. Leave other fields blank
