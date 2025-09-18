# Address Picker Setup

## Current Implementation

The address picker now works **without requiring a Google Maps API key** for basic functionality. It includes:

- Manual address input with search button
- Pre-populated common locations (BYU-Idaho, Salt Lake City Airport, etc.)
- Interactive Google Maps for precise location selection
- Tap-to-select functionality on the map

## Optional: Google Places API for Enhanced Autocomplete

For advanced autocomplete functionality, you can optionally add a Google Maps API key:

### API Key Configuration

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS  
   - Places API
   - Geocoding API

4. Create an API key and restrict it to your app

### If you want to add Google Places Autocomplete:

You would need to modify the `address_picker_screen.dart` to re-implement the GooglePlaceAutoCompleteTextField widget and add your API key.

## Android Configuration (for Maps display)

Add your API key to `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
</application>
```

## iOS Configuration (for Maps display)

Add your API key to `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Features (Working Now)

- **Text Input:** Type any address and press search
- **Common Locations:** Pre-loaded suggestions for popular destinations
- **Interactive Map:** Tap anywhere on the map to select that location
- **Geocoding:** Automatically converts coordinates to addresses
- **Search Filtering:** Common locations filter as you type

## Usage

1. Tap the "FROM:" input field in the Post Ride screen
2. Either:
   - Type an address and tap "Search Address"
   - Select from common locations suggestions
   - Tap directly on the map
3. Confirm your selection to return to the Post Ride screen

The app works fully without any API key setup required!
