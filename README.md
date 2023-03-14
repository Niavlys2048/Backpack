#  Backpack

A three-page application that allows you to:
* Get the exchange rate between the dollar and your current currency.
* Translate any supported languages.
* Compare the local weather with all your favorite places.

|Currency|Translate|Weather|
|--|--|--|
|<img src="/Resources/iPhone-14-Pro-Currency-Light.png" width="200">|<img src="/Resources/iPhone-14-Pro-Translate-Light.png" width="200">|<img src="/Resources/iPhone-14-Pro-Weather-Light.png" width="200">|
|<img src="/Resources/iPhone-14-Pro-Currency-Dark.png" width="200">|<img src="/Resources/iPhone-14-Pro-Translate-Dark.png" width="200">|<img src="/Resources/iPhone-14-Pro-Weather-Dark.png" width="200">|

## Requirements

* iOS 14.7+

## Usage

As easy to use as the applications on which it is based.

## Dependency

* This application requires the pod GooglePlaces 7.3.0.
    * To install CocoaPods: https://cocoapods.org/

* OpenWeather API and fixer.io API keys are present, but they may not be active forever.
    * You can create your own keys for free on these websites:
        * https://openweathermap.org/
        * https://apilayer.com/marketplace/fixer-api

* Your own Google API key is required in the Secrets.xconfig file.
    * To create your Google API key, follow these steps: https://support.google.com/googleapi/answer/6158862?hl=en
    * You will need an access to Cloud Translation API and Places API.

## Features

* 1st page: Currency (Exchange rate)
    * UX/UI inspired by the "Currency converter - Money" app (available on App Store).
    * Using a list of the most traded currencies.
    * The list is editable to add or remove currencies.
    * Using the fixer.io API, updated each time the application is opened to be up to date.
    * Real-time currency conversion as you type an amount on the selected currency of your choice.
    * Using svg flags from FlagKit.

* 2nd page: Translate (Google translate)
    * UX/UI inspired by the "Google Translate" app (available on App Store).
    * Write the sentence of your choice in any auto-detected language and get its translation in another language of your choice.
    * The source/target language can be modified by choosing it from a list of supported languages.
    * A searchBar can also be used to make your selection easier. 
    * Using Google Translate API.

* 3rd page: Weather
    * UX/UI inspired by the official Apple weather app.
    * User-friendly search, thanks to Google Places SDK and its autocomplete features (via CocoaPods).
    * The Google Places SDK isn't free, but you can use your own API key or request one through a free trial.
    * Display weather information for any city of your choice, using the OpenWeatherMap API.
    * The list is editable to sort, add or remove loactions and convert Celsius to Fahrenheit.

* Responsive Layout from the iPhone SE (3rd Generation) to the last version.
* Using tab bar to navigate between the pages.

## Structure

* Using MVC architecture pattern.

## Demo

|Currency|Translate|Weather|
|--|--|--|
|<img src="/Resources/Demo-iPhone-14-Pro-Currency.gif" width="250">|<img src="/Resources/Demo-iPhone-14-Pro-Translate.gif" width="250">|<img src="/Resources/Demo-iPhone-14-Pro-Weather.gif" width="250">|

## License
