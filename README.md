Simple Web Slideshow
====================

I wanted to show my own family photos on my SDDM login screen, on my Desktop and on my Lock screen. 

This is my solution to those three things, and it is a work in progress. 

There wasn't anything exactly like I wanted so I did what any good Open Source enthusiast does, I forked and modified something to meet my needs. 

Here's what's in this repository: 

* Wallpaper Changer
 - The wallpaper changer is a heavily simplified version of [plasma-wallpaper-wallhaven-reborn from Blacksuan19](https://github.com/Blacksuan19/plasma-wallpaper-wallhaven-reborn). 


Coming soon: 

* SDDM Theme 
 - The SDDM background is a modified version of [Andromeda-KDE from EliverLara](https://github.com/EliverLara/Andromeda-KDE). I have this working but need to clean up the code.

* Photo changing scripts
 - I have one PHP script working which sends a random photo from your digiKam library
 - TODO: One that writes to a local file which can be set up with cron
 - One that pulls a random file from a folder


Installation
------------ 

To install the Wallpaper changer for just your user, run:

    kpackagetool6 --type Plasma/Wallpaper --install package/

To install it globally, run:

    sudo kpackagetool6 --type Plasma/Wallpaper --global --install package/



How it works
------------

You need a source of random photos. Currently I am using a website that sends a different photo every time I request it. 
