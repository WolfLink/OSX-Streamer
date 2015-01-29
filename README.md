# OSX-Streamer
Stream your OSX screen to be viewed by your iOS device.

There are several apps out there that can do this better, but they are costly.  I believe this feature should be free and really should be part of the operating system, so I am releasing this as an open source app.


The app has two parts: the streaming app for OSX and the receiving app for iOS.  You will need to run both parts of the app for it to work.  I will release the iOS part on the app store at some point but right now it is too early in development.  If you are an iOS developer, it should be straightforward to build it for yourself here: https://github.com/WolfLink/iOS-Receiver

<br>

<b>Using the App</b>

-Ensure that both apps are connected to the same Wi-Fi network.

-Build and launch the application

-Set the desired quality and Connection ID in the preferences window that pops up.

-Install and launch the partner iOS app

-Open the settings app and find the ReadStream settings.  Set the Connection ID to match the one you entered on your computer.

-Re-launch the iOS app



<br>
<b>Troubleshooting</b>

-I recommend the Medium quality setting.  It gets about 10-20 FPS and less than a second of latency.

-If you are having connection problems, quit and restart both apps.  If the problem persists, try restarting your computer.


<br>
<b>Current Issues and To-Do</b>

The app currently hogs CPU, especially on the OSX end.  This is really just a proof of concept so that's not surprising.  I want to fix that and also hopefully increase the framerate to at least 30FPS on the Medium setting.  Any improvements after that are a bonus.
