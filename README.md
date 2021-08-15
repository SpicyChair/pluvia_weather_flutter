# Pluvia Weather 🌦️

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
\
A weather app with beautiful animations, built with Flutter, with data from the OpenWeatherMap API and Mapbox API.

## Download

<a href='https://play.google.com/store/apps/details?id=com.spicychair.weather&hl=en&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_gb/badges/static/images/badges/en_badge_web_generic.png' width="256"/></a>\
...or [download APK releases from Github](https://github.com/SpicyChair/pluvia_weather_flutter/releases)

## Features

* Beautiful animations which change throughout the day and according to weather conditions
* View weather and forecasts in your geolocation
* Weather Radar
* 44 supported langauges
* Dark mode
* Preference persistance (eg. dark mode) with shared_preferences
* Location searching and saving with MapBox API and SQFLite Database
* Hourly forecast
* Forecast for the next seven days

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

## Building it yourself

1) Get a free API key from the [OpenWeatherMap One Call API](https://openweathermap.org/full-price#current)
2) Replace the value of OPENWEATHER_API_KEY in **.env**:

To use MapBox search:
1) Get a free API key from [MapBox API](https://account.mapbox.com/auth/signup/)
2) Replace the value of MAPBOX_API_KEY in **.env**:

Then in terminal,
> flutter build apk

## License

Pluvia Weather is licensed under [GDPLv3](https://github.com/SpicyChair/pluvia_weather_flutter/blob/master/LICENSE).
\
Weather animation code and corresponding assets are modified from [SpriteWidget](https://github.com/spritewidget/spritewidget/tree/master/examples/weather): the license is located [here](https://github.com/spritewidget/spritewidget/blob/master/LICENSE).
