# Pluvia Weather 🌦️

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
\
A weather app with beautiful animations, built with Flutter. Powered by weather data from the OpenWeatherMap API and location search from the Mapbox API.

## Features

• 🌦 Slick and dynamic animations based on the weather condition and time of day

• 🌙 Beautiful dark mode

• 📅 Accurate 24 hour and 7 day forecast - be prepared for anything

• 🌍 View weather in millions of locations with MapBox Search and Weather Radar

• 🛑 Secure and private with no adverts, trackers, or data collection

• 🌐 Translated into 44 langauges

## Download

<a href='https://play.google.com/store/apps/details?id=com.spicychair.weather'><img alt='Get it on Google Play' src='https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/assets/badges/get-it-on-google-play.png' width="256"/></a>
<a href='https://github.com/SpicyChair/pluvia_weather_flutter/releases'><img alt='Get it on Github' src='https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/assets/badges/get-it-on-github.png' width="256"/></a>

## Screenshots

<p align="center">
  <img src="https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/screenshots/Google Pixel 3 5.5-inch Display (1080 x 2160) Screenshot 5.png" width="230">
  <img src="https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/screenshots/Google Pixel 3 5.5-inch Display (1080 x 2160) Screenshot 1.png" width="230">
  <img src="https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/screenshots/Google Pixel 3 5.5-inch Display (1080 x 2160) Screenshot 0.png" width="230">
  <img src="https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/screenshots/Google Pixel 3 5.5-inch Display (1080 x 2160) Screenshot 4.png" width="230">
  <img src="https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/screenshots/Google Pixel 3 5.5-inch Display (1080 x 2160) Screenshot 2.png" width="230">
  <img src="https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/screenshots/Google Pixel 3 5.5-inch Display (1080 x 2160) Screenshot 3.png" width="230">
  <img src="https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/screenshots/Google Pixel 3 5.5-inch Display (1080 x 2160) Screenshot 6.png" width="230">
</p>

## Supported Languages

🌍 Pluvia Weather now supports over 40 languages:

Afrikaans, Arabic, Azerbaijani, Bulgarian, Catalan, Czech, Danish, German, Modern Greek, English, Spanish, Basque, Persian, Finnish, French, Galician, Hebrew, Hindi, Croatian, Hungarian, Indonesian, Italian, Japanese, Korean, Lithuanian, Latvian, Macedonian, Dutch Flemish, Norwegian, Polish, Portuguese, Romanian, Russian, Slovak, Slovenian, Albanian, Serbian, Swedish, Thai, Turkish, Ukrainian, Vietnamese, Chinese and Zulu.

## Build

1) Get a free API key from the [OpenWeatherMap One Call API](https://openweathermap.org/full-price#current)
2) Replace the value of OPENWEATHER_API_KEY in **.env**:

To use MapBox search:
1) Get a free API key from [MapBox API](https://account.mapbox.com/auth/signup/)
2) Replace the value of MAPBOX_API_KEY in **.env**:

Then in terminal,
> flutter build apk

Persistence is handled by SharedPreferences (for user options eg. dark mode) and an SQFLite Database (for saved location data).

## License

Pluvia Weather is licensed under [GDPLv3](https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/LICENSE).
\
Weather animation code and corresponding assets are modified from [SpriteWidget](https://github.com/spritewidget/spritewidget/tree/master/examples/weather): the license is located [here](https://github.com/spritewidget/spritewidget/blob/master/LICENSE).

## Privacy
[Privacy Policy](https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/privacy_policy.md)
