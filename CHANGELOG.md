## 0.8.1
 - Changed default error value to 1.

## 0.8.0
 - Fixed `getCurrencyConverted` function errors.
 - Added `getRunNotifier`: get the ValueNotifier of the currency list update, to listen when the function starts/stops downloading data.
 - Added `getRunStatus`: get the current status of the currency list update. `true` if it's still donwloading data.
 - Added `getErrorNotifier`: get the ValueNotifier of the currency list update result, to listen if the function ended or not in an error.
 - Added `getRunError`: check if the latest call to the currency list update function ended in an error. `null` if everything went ok.

## 0.7.1
 - Added `blockIfUpdateError` parameter to functions to avoid refreshing currencies if there was a previous error. Default = `false`

## 0.7.0
 - Improve docs
 - Added `updateError` getter to help checking if there was an error when trying to get the currencies.
 - Added `initializeOnCreation` to let the user initialize the class already searching for the updated prices.

## 0.6.5+1
 - Readme update.

## 0.6.5
 - Partial error handling to stop cors related problems on web.
 - Package rename.

## 0.6.0
 - Allow the user to initialize the class with default maximum value of decimal places for the currencies.

## 0.5.0
 - Allow the user to initialize the class with default values for source and destination currencies.

## 0.4.0
 - Allow the user to update the currencies.

## 0.3.0
 - Added default conversion + mini improvements.

## 0.2.0
 - Removed repetitive code and added sample app.

## 0.1.0
- Updated dependencies and removed repetitive code.

## 0.0.3
 - Reformatted forex_conversion.dart.

## 0.0.2
 - Fixed installing instructions in Readme.md.
 - Added documentation for public methods.
 - Formatted all Dart files.

## 0.0.1
 - Released initial version with features for lisiting all currency prices and converting money between different currencies.