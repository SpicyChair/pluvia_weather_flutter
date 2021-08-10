// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';
import 'weather_type.dart';

// The image map hold all of our image assets.
ImageMap _images;

// The sprite sheet contains an image and a set of rectangles defining the
// individual sprites.
SpriteSheet _sprites;

// The weather world is our sprite tree that handles the weather
// animations.

/*
void setWeatherType(WeatherType weatherType) {
  weatherWorld.weatherType = weatherType;
}
*/

class WeatherAnimation extends StatefulWidget {
  WeatherType initialWeather;

  WeatherAnimationState state;
  WeatherAnimation();

  @override
  WeatherAnimationState createState() {
    this.state = WeatherAnimationState();
    return this.state;
  }
}

class WeatherAnimationState extends State<WeatherAnimation> {
  // This method loads all assets that are needed for the demo.
  Future<Null> _loadAssets(AssetBundle bundle) async {
    // Load images using an ImageMap
    _images = ImageMap(bundle);
    await _images.load(<String>[
      'assets/clouds-0.png',
      'assets/clouds-1.png',
      'assets/weathersprites.png',
    ]);

    // Load the sprite sheet, which contains snowflakes and rain drops.
    String json = await DefaultAssetBundle.of(context)
        .loadString('assets/weathersprites.json');
    _sprites = SpriteSheet(_images['assets/weathersprites.png'], json);
  }

  @override
  void initState() {
    super.initState();
    AssetBundle bundle = rootBundle;

    // Load all graphics, then set the state to assetsLoaded and create the
    // WeatherWorld sprite tree
    _loadAssets(bundle).then((_) {
      setState(() {
        assetsLoaded = true;
        weatherWorld = new WeatherWorld();
        weatherWorld.weatherType = widget.initialWeather;
      });
    });
  }


  bool assetsLoaded = false;

  // The weather world is our sprite tree that handles the weather
  // animations.
  WeatherWorld weatherWorld;

  @override
  Widget build(BuildContext context) {
    // Until assets are loaded we are just displaying a blue screen.
    // If we were to load many more images, we might want to do some
    // loading animation here.
    if (!assetsLoaded) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
      );
    }

    return Material(
      child: SpriteWidget(weatherWorld),
    );
  }
}

// For the different weathers we are displaying different gradient backgrounds,
// these are the colors for top and bottom.

//top colors are lighter
const List<Color> _kBackgroundColorsTop = const <Color>[
  const Color(0xffb87dbb), //sunrise
  const Color(0xff5ebbd5), //clear day
  const Color(0xFFe5383b), //clear afternoon
  const Color(0xFFe5383b), //clear evening
  const Color(0xFF023e7d), //clear night
  const Color(0xff0b2734), //rain
  const Color(0xffcbced7) //snow
];

//bottom colors are darker
const List<Color> _kBackgroundColorsBottom = const <Color>[
  const Color(0xffdd5040), //sunrise
  const Color(0xff4aaafb), //clear day
  const Color(0xfffbbe00), //clear afternoon
  const Color(0xFF041f32), //clear evening
  const Color(0xFF000000), //clear night
  const Color(0xff4c5471), //rain
  const Color(0xffe0e3ec) //snow
];

class WeatherWorld extends NodeWithSize {
  GradientNode _background;
  CloudLayer _cloudsSharp;
  CloudLayer _cloudsSoft;
  CloudLayer _cloudsDark;
  Rain _rain;
  Snow _snow;
  Stars _stars;
  WeatherWorld weatherWorld;

  WeatherType get weatherType => _weatherType;

  WeatherType _weatherType;

  set weatherType(WeatherType weatherType) {

    if (weatherType == _weatherType) return;

    // Handle changes between weather types.
    _weatherType = weatherType;

    // Fade the background
    _background.motions.stopAll();

    // Fade the background from one gradient to another.
    _background.motions.run(MotionTween<Color>((a) => _background.colorTop = a,
        _background.colorTop, _kBackgroundColorsTop[weatherType.index], 1.0));

    _background.motions.run(MotionTween<Color>(
        (a) => _background.colorBottom = a,
        _background.colorBottom,
        _kBackgroundColorsBottom[weatherType.index],
        1.0));

    // Activate/deactivate clear, rain, snow, and dark clouds.
    _cloudsDark.active =
        (weatherType == WeatherType.rain || weatherType == WeatherType.snow);
    _cloudsSharp.active = !(weatherType == WeatherType.clearNight);
    _cloudsSoft.active = !(weatherType == WeatherType.clearEvening ||
        weatherType == WeatherType.clearNight);
    _rain.active = weatherType == WeatherType.rain;
    _snow.active = weatherType == WeatherType.snow;
  }

  WeatherWorld() : super(const Size(2048.0, 2048.0)) {
    // Start by adding a background.
    _background = GradientNode(
      this.size,
      _kBackgroundColorsTop[0],
      _kBackgroundColorsBottom[0],
    );
    addChild(_background);

    // Then three layers of clouds, that will be scrolled in parallax.
    _cloudsSharp = CloudLayer(
        image: _images['assets/clouds-0.png'],
        rotated: false,
        dark: false,
        loopTime: 90.0);
    addChild(_cloudsSharp);

    _cloudsDark = CloudLayer(
        image: _images['assets/clouds-1.png'],
        rotated: true,
        dark: true,
        loopTime: 120.0);
    addChild(_cloudsDark);

    _cloudsSoft = CloudLayer(
        image: _images['assets/clouds-1.png'],
        rotated: false,
        dark: false,
        loopTime: 150.0);
    addChild(_cloudsSoft);

    // Add the rain and snow
    _rain = Rain();
    addChild(_rain);

    _snow = Snow();
    addChild(_snow);
  }
}

// The GradientNode performs custom drawing to draw a gradient background.
class GradientNode extends NodeWithSize {
  GradientNode(Size size, this.colorTop, this.colorBottom) : super(size);

  Color colorTop;
  Color colorBottom;

  @override
  void paint(Canvas canvas) {
    applyTransformForPivot(canvas);

    Rect rect = Offset.zero & size;
    Paint gradientPaint = Paint()
      ..shader = LinearGradient(
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomLeft,
          colors: <Color>[colorTop, colorBottom],
          stops: <double>[0.0, 0.7]).createShader(rect);

    canvas.drawRect(rect, gradientPaint);
  }
}

// Draws and animates a cloud layer using two sprites.
class CloudLayer extends Node {
  CloudLayer({ui.Image image, bool dark, bool rotated, double loopTime}) {
    // Creates and positions the two cloud sprites.
    _sprites.add(_createSprite(image, dark, rotated));
    _sprites[0].position = const Offset(1024.0, 1024.0);
    addChild(_sprites[0]);

    _sprites.add(_createSprite(image, dark, rotated));
    _sprites[1].position = const Offset(3072.0, 1024.0);
    addChild(_sprites[1]);

    // Animates the clouds across the screen.
    motions.run(MotionRepeatForever(MotionTween<Offset>((a) => position = a,
        Offset.zero, const Offset(-2048.0, 0.0), loopTime)));
  }

  List<Sprite> _sprites = <Sprite>[];

  Sprite _createSprite(ui.Image image, bool dark, bool rotated) {
    Sprite sprite = Sprite.fromImage(image);

    if (rotated) sprite.scaleX = -1.0;

    if (dark) {
      sprite.colorOverlay = const Color(0xff000000);
      sprite.opacity = 0.0;
    }

    return sprite;
  }

  set active(bool active) {
    // Toggle visibility of the cloud layer
    double opacity;
    if (active)
      opacity = 1.0;
    else
      opacity = 0.0;

    for (Sprite sprite in _sprites) {
      sprite.motions.stopAll();
      sprite.motions.run(MotionTween<double>(
          (a) => sprite.opacity = a, sprite.opacity, opacity, 1.0));
    }
  }
}

// Rain layer. Uses three layers of particle systems, to create a parallax
// rain effect.
class Rain extends Node {
  Rain() {
    _addParticles(1.0);
    _addParticles(1.5);
    _addParticles(2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(double distance) {
    ParticleSystem particles = ParticleSystem(_sprites['raindrop.png'],
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 1.0,
        speed: 720.0 / distance,
        speedVar: 72.0 / distance,
        startSize: 1.2 / distance,
        startSizeVar: 0.1 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 3 * distance,
        lifeVar: 1.0 * distance);
    particles.position = const Offset(1024.0, -200.0);
    particles.rotation = 10.0;
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 1.0, 2.0));
      } else {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 0.0, 0.5));
      }
    }
  }
}

// Snow. Uses 9 particle systems to create a parallax effect of snow at
// different distances.
class Snow extends Node {
  Snow() {
    _addParticles(_sprites['flake-0.png'], 1.0);
    _addParticles(_sprites['flake-1.png'], 1.0);
    _addParticles(_sprites['flake-2.png'], 1.0);

    _addParticles(_sprites['flake-3.png'], 1.5);
    _addParticles(_sprites['flake-4.png'], 1.5);
    _addParticles(_sprites['flake-5.png'], 1.5);

    _addParticles(_sprites['flake-6.png'], 2.0);
    _addParticles(_sprites['flake-7.png'], 2.0);
    _addParticles(_sprites['flake-8.png'], 2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(SpriteTexture texture, double distance) {
    ParticleSystem particles = ParticleSystem(texture,
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 150.0 / distance,
        speedVar: 50.0 / distance,
        startSize: 1.0 / distance,
        startSizeVar: 0.3 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 20.0 * distance,
        lifeVar: 10.0 * distance,
        emissionRate: 2.0,
        startRotationVar: 360.0,
        endRotationVar: 360.0,
        radialAccelerationVar: 10.0 / distance,
        tangentialAccelerationVar: 10.0 / distance);
    particles.position = const Offset(1024.0, -50.0);
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 1.0, 2.0));
      } else {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 0.0, 0.5));
      }
    }
  }
}

class Stars extends Node {
  Stars() {
    _addParticles(1.0);
    _addParticles(1.5);
    _addParticles(2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(double distance) {
    ParticleSystem particles = ParticleSystem(_sprites['raindrop.png'],
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 1.0,
        speed: 720.0 / distance,
        speedVar: 72.0 / distance,
        startSize: 1.2 / distance,
        startSizeVar: 0.1 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 3 * distance,
        lifeVar: 1.0 * distance);
    particles.position = const Offset(1024.0, -200.0);
    particles.rotation = 10.0;
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 1.0, 2.0));
      } else {
        motions.run(MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 0.0, 0.5));
      }
    }
  }
}
