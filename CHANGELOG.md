#v1.1.2
## Feature

- Added pagination & filters optional params for `getFCMNotifications`

## Fix

- Success return fix for `markFCMNotificationsAsSeen`
- Handle errors for `getFCMNotifications`

# v1.1.1
## Fix

- Login when not using cookies 

# v1.1.0
## Feature

- Check for `renovation_core` if installed for methods using custom cmds.
- Throw an error `AppNotInstalled` when using a method of an app not installed in the backend.
- Handle methods that have frappe cmd, but overriden in the backend (For example: login)
   
## Chore

- Linting for pub.dev score improvement

# v1.0.8
## Fix
  - Downgrade rxdart for compatibility with `flutter_google_places`

# v1.0.7

## Chore
  - Upgraded rxdart to **0.24.0**
  - Downgraded pedantic to **1.8.0** for Flutter compatibility

# v1.0.6

## Fixes:
  - DBFilter validation for multiple types in a single Map

# v1.0.5

## Fixes:
  - Fixed casting issue in getDocMeta
  - Fixed registerFCMToken response
  - Fixed some imports referencing package
  - Removed unused imports

## Modifications:
  - Add CI configuration
  - Added TagLink model
  - Modified getTags to use getList if frappe version >=12
  - Add BlockModule child doctype to User
  - Minor modification in documentation
  - Exclude .g files in test folder (analysis_options.yaml)

## Tests:
  - Variables are now fetched from System environment variables (Platform.environment)
  - Added some tests
  - Changed doctypes used in tests
  - Added Setup/Teardown for some test groups
  - Minor refactoring

# v1.0.2

## Fix: 
  - logging response type & unknown classes

# v1.0.1

## Fix: 
  - description parameter on assignDoc should be optional

# v1.0.0
