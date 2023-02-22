#  Backpack (Baluchon)

General description:
Backpack (Baluchon) is a three-page application:
* Get the exchange rate between the dollar and your current currency.
* Translate from your favorite language to English.
* Compare the local weather and the one of your good old home.

Main features:
This application as been designed from scratch thanks to Figma.
Some images (png and svg) are homemade, others are available for free on the Internet.

- 1st page: Currency (Exchange rate)
    - UX/UI inspired by the "Currency converter - Money" app (available on App Store).
    - Get a conversion from a currency of your choice to a list of pre-selected currencies, thanks to a UITableView.
    - Using a list of the most traded currencies.
    - The list is editable to add or remove currencies.
    - Using the fixer.io API, updated each time the application is opened to be up to date.
    - Real-time currency conversion as you type an amount on the selected currency of your choice.
    - Using svg flags from FlagKit.

- 2nd page: Translate (Google translate)
    - UX/UI inspired by the "Google Translate" app (available on App Store).
    - Write the sentence of your choice in any auto-detected language and get its translation in another language of your choice.
    - Just as the official application, you can modify the source and/or target language by choosing it from a list of supported languages.
    - You can also use a searchBar to make your selection easier. 
    - Using Google Translate API.

- 3rd page: Weather
    - UX/UI inspired by the official Apple weather app.
    - User-friendly search, thanks to Google Places SDK and its autocomplete features (via CocoaPods).
    - The Google Places SDK isn't free, but you can use your own API key or request one through a free trial.
    - Display weather information for any city of your choice, using the OpenWeatherMap API.
    - Using UITableView to show the weather for as many location as you wish. 
    - The list is editable to sort, add or remove loactions and convert Celsius to Fahrenheit.

Technical constraints:
- Using MVC architectural pattern.
- Using tab bar to navigate between the pages (each tab corresponding to one of the three pages described above).
- Network errors handled through a popup using the UIAlertController class through a UIViewController extension.
- Implementing UITableView, custom UITableViewCell, Segues, custom protocols, delegates, various extensions.
- Each API call displays an activity indicator to handle slow connections.
- Responsive display on all iPhone screen sizes (Portrait mode only).
- Supporting iOS 14.7 and above.
- Using unit tests.
- All API Keys are stored in a configuration file named Secrets.xcconfig
