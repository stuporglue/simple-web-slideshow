/*
 *  Copyright 2013 Marco Martin <mart@kde.org>
 *  Copyright 2014 Kai Uwe Broulik <kde@privat.broulik.de>
 *  Copyright 2022 Kyle Paulsen <kyle.a.paulsen@gmail.com>
 *  Copyright 2022 Link Dupont <link@sub-pop.net>
 *  Copyright 2024 Abubakar Yagoub <plasma@blacksuan19.dev>
 *  Copyright 2025 Michael Moore <stuporglue@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root

	// This is the current values from the config file
    property var wallpaperConfiguration: wallpaper.configuration

	// Here are our variables we're going to set
	// Some are set programatically using "onCurrentIndexChange" or "onValueChagned" others take a property from a control
    property int cfg_RefreshDelay: 10
    property int cfg_CrossfadeTime: 1000
    property int cfg_FillMode
    property alias cfg_LogMessages: logMessagesBox.checked
    property alias cfg_ImageURL: imageURLInput.text


	// Including this makes the labels line up with the parent labels on the settings page
    twinFormLayouts: parentLayout


	// Show a sample mini image
	// In order to get this to lay out nicely, we put the ColumnLayout on the outside and assign the Kirigami label there
	ColumnLayout {
		Kirigami.FormData.label: "Current Wallpaper:"

		// Next we make a Rectangle, otherwise the image will overflow, even
		// thoug the Image has height and width eset
		Rectangle {
			height: 200
			width: 300
			color: "#000000"
			border.color: "black"
			border.width: 1

			// Finally we put the image here
			Image {
				id: currentWallpaper
				height: 200
				width: 300
				source: cfg_ImageURL
				fillMode: Image.PreserveAspectFit
				clip: true
				visible: true
			}
		}
	}


	// The combo box has several possible values. We store this as an int in the config, since it is an enum.
	// Default value is 2, or Image.PreserveAspectCrop which zooms in on the image until the whole screen is filled, cropping the given image as needed
    ComboBox {
        id: resizeComboBox

        Kirigami.FormData.label: "Image Fill Mode:"

        function setMethod() {
            for (var i = 0; i < model.length; i++) {
                if (model[i]["fillMode"] === wallpaperConfiguration.FillMode) {
                    resizeComboBox.currentIndex = i;
                    var tl = model[i]["label"].length;
                }
            }
        }

		model: [
			{ "label": "Stretch", "fillMode": Image.Stretch }, 
			{ "label": "Preserve Apsect Fit", "fillMode": Image.PreserveAspectFit }, 
			{ "label": "Preserve Aspect Crop", "fillMode": Image.PreserveAspectCrop }, 
			{ "label": "Tile", "fillMode": Image.Tile },
			{ "label": "Tile Vertically", "fillMode": Image.TileVertically},
			{ "label": "Tile Horzontally", "fillMode": Image.TileHorizontally},
			{ "label": "Pad", "fillMode": Image.Pad }
		]
        textRole: "label"
        onCurrentIndexChanged: cfg_FillMode = model[currentIndex]["fillMode"]
        Component.onCompleted: setMethod()
    }


	// Here is the URL of a service that returns an image
	// When the value of the field changes, the onTextChanged is triggered
    TextField {
        id: imageURLInput 

        text: root.cfg_ImageURL
        placeholderText: "Image Service URL"
        Kirigami.FormData.label: "Image Service URL:"
        leftPadding: 12
        onTextChanged: cfg_ImageURL = text
    }


	// If this is enabled, you can see some debug messages by running: 
	// journalctl -f | grep -i --line-buffered 'Photo Log'
	CheckBox {
		id: logMessagesBox
        Kirigami.FormData.label: "Log Debug Messages:"
		text: "Check to log messages"
		checked: cfg_LogMessages
		onToggled: {
			cfg_LogMessages = checked;
		}
	}


	// How long betwween changing photos
	SpinBox {
		id: delaySpinBox
		Kirigami.FormData.label: "Refresh Delay"

		value: cfg_RefreshDelay
		onValueChanged: cfg_RefreshDelay = value
		stepSize: 1
		from: 1
		to: 50000
		editable: true
		textFromValue: function(value, locale) {
			return " " + value + " minutes";
		}
		valueFromText: function(text, locale) {
			return text.replace(/ minutes/, '');
		}
	}

	// How long should the crossfade take?
	SpinBox {
		id: fadeDelaySpinBox
		Kirigami.FormData.label: "Crossfade time"

		value: cfg_CrossfadeTime
		onValueChanged: cfg_CrossfadeTime = value
		stepSize: 1
		from: 1
		to: 10000
		editable: true
		textFromValue: function(value, locale) {
			return " " + value + " seconds";
		}
		valueFromText: function(text, locale) {
			return text.replace(/ seconds/, '');
		}
	}
}
