#Kumite Stop Watch

The Kumite Stop Watch is a purpose built, 2 minute stop watch, with a 1 minute 30 second "alert", which can be used to time kumite (sparing) bouts

The stop watch supports pause/resume/reset functionality, allowing flexibility in it's over all use.

The "base" design is based around the tournament specifications for the Go Kan Ryu Karate-Do club with the intention to provide customisation features in later releases, allowing the user to define multiple different stop watches, each with their own configuration.

The project is a personal project used to test ideas and designs, the intention is to have a base line repository with multiple branches supporting different ideas and designs, used to demonstrate my understanding the iOS API.

This project is based on an earlier project, written in Objective-C that used Core Graphics to render the primary stop watch. This project suffered from some performance issues, which this project is designed to address

The project makes use of code from [paiv/AngleGradientLayer](https://github.com/paiv/AngleGradientLayer) and [pavanpodila/PieChart](https://github.com/pavanpodila/PieChart/blob/master/PieChart/PieSliceLayer.m)

Conceptually the idea is relativly simply and could be accomplished using `CALayer` almost exclusivly, but where's the fun in that.

Instead, the intention is to require a flexible time line, which allows different colors to be defined around the core progress indiciator in a conical form, providing a more visiually appealing effect.

![Initial Start Screen](https://cloud.githubusercontent.com/assets/10276932/13943958/4f097bae-f055-11e5-82f6-38fb52de91a1.png) ![Completed Run Screen](https://cloud.githubusercontent.com/assets/10276932/13943962/5380480c-f055-11e5-9330-d5ead5352387.png)

#Updated

Updated with "dark side of the moon" interface

Written entirly with `CALayer`s (except the main view obviously and controls)

Supports alerts, including:

- UI flashing (x3 times, 2 before the event and 1 at the event). In place support for (future) audio alert
- Vibrate aleart x3, 2 before the event and 1 at the event

![Initial start screen](https://cloud.githubusercontent.com/assets/10276932/14239158/46dba7c8-fa7c-11e5-8b89-46d6628201d2.png)![Completed](https://cloud.githubusercontent.com/assets/10276932/14239160/4c8d79da-fa7c-11e5-95da-dd578ee84ee9.png)![Flash alert](https://cloud.githubusercontent.com/assets/10276932/14239161/5047e696-fa7c-11e5-84f3-bf5db4e992cd.png)