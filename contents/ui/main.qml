/*
    SPDX-FileCopyrightText: 2013 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2014 Sebastian Kügler <sebas@kde.org>
    SPDX-FileCopyrightText: 2014 Kai Uwe Broulik <kde@privat.broulik.de>
    SPDX-FileCopyrightText: 2022 Link Dupont <link@sub-pop.net>
    SPDX-FileCopyrightText: 2024 Abubakar Yagoub <plasma@blacksuan19.dev>
    SPDX-FileCopyrightText: 2025 Michael Moore <stuporglue@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Window
import org.kde.kirigami 2.20 as Kirigami
import org.kde.notification 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid

WallpaperItem {
    id: main

	// Is wallpaper # 1 hidden right now? 
    property bool wallone_hidden: false

	// This timer tries to toggle images every interval
	Timer {
		id: refreshTimer
		interval: main.configuration.RefreshDelay * 60 * 1000
		repeat: true
		triggeredOnStart: false
		onTriggered: {
			photolog("refreshTimer triggered");
			refreshImage()
		}
	}

	// Start the timer
	Component.onCompleted: {
		photolog("Component completed");
		photolog("(Config at Startup - RefresDelay) " + main.configuration.RefreshDelay);
		photolog("(Config at Startup - CrossfadeTime) " + main.configuration.CrossfadeTime);
		photolog("(Config at Startup - LogMessages) " + main.configuration.LogMessages);
		photolog("(Config at Startup - ImageURL) " + main.configuration.ImageURL);
		photolog("(Config at Startup - FillMode) " + main.configuration.FillMode);
		refreshTimer.start();
	}


	// Every time the Timer trips, we start a transition
	// That is, the timer controls the fade in and out, it does not directly control the image changing
	function refreshImage() {
		photolog("Running refreshImage");

		if ( onefadeout.running || onefadeout.running ) {
			photolog("A fade is running, skipping this time");
		} else {

			if ( wallone_hidden ) {
				onefadein.start();
			} else {
				onefadeout.start();
			}
		}
	}

	// Configuragble logging
	function photolog(msg){
		if ( main.configuration.LogMessages ) {
			console.log("Photo Log: " + msg);
		}	
	}

	// An animation that fades to 0 opacity. When the Image is hidden it replaces the img source
	SequentialAnimation {
		id: onefadeout
		running: false
		alwaysRunToEnd: true
		NumberAnimation {
			target: wallpaper
			property: "opacity"
			to: 0
			duration: main.configuration.CrossfadeTime * 1000 
		}
		onFinished: function(){
			// When the top photo fades out, we change its source
			photolog("onefadeout is finished");
			wallone_hidden = true;
			wallpaper.source = 'https://convenienturl.com/sddm/background.php?height=' + root.height + '&width=' + root.width + '&img=2&ts=' + Date.now();
		}
	}

	// An animation that fades to 1 opacity. When the Image is hidden it replaces the other img source
	SequentialAnimation {
		id: onefadein
		running: false
		alwaysRunToEnd: true
		NumberAnimation {
			target: wallpaper
			property: "opacity"
			to: 1
			duration: main.configuration.CrossfadeTime * 1000 
		}
		onFinished: function(){
			// When the top photo fades in, we change the other photo's source
			photolog("onefadein is finished");
			wallone_hidden = false;
			wallpapertwo.source = 'https://convenienturl.com/sddm/background.php?height=' + root.height + '&width=' + root.width + '&img=2&ts=' + Date.now();
		}
	}


	// Just a simple view with two photos. 
	// The photos are stacked, and the top one is faded in and out (opacity 1 to 0 and back).
	// When the top one is visible the bottom one gets its picture changed
	// When the top one is invisible, it gets its picture changed.
    StackView {
        id: root
        anchors.fill: parent

		// fillMode: Image.PreserveAspectCrop
		Image {
			anchors.fill: parent
			id: wallpapertwo
			fillMode: main.configuration.FillMode
			source: main.configuration.ImageURL + '?height=' + root.height + '&width=' + root.width + '&img=2&ts=' + Date.now();
			asynchronous: true
			opacity: 1

		}

		// 2nd image is on top
		Image {
			anchors.fill: parent
			id: wallpaper
			fillMode: main.configuration.FillMode
			source: main.configuration.ImageURL + '?height=' + root.height + '&width=' + root.width + '&img=1&ts=' + Date.now();
			asynchronous: true
			opacity: 1

		}
    }
}
