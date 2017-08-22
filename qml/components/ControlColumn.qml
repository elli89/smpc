import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    Slider {
        width: parent.width
        stepSize: 1
        maximumValue: 100
        minimumValue: 0
        value: mVolume
        valueText: value + "%"
        label: qsTr("volume")
        onPressedChanged: {
            if (!pressed) {
                setVolume(value)
                value  = Qt.binding(function() {return mVolume;});
            }
        }
        onValueChanged: {
            if(pressed)
                setVolume(value)
            // valueText = value+"%";
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        IconButton {
            id: prevButton
            icon.source: "image://theme/icon-m-previous"
            onClicked: prev()
        }
        IconButton {
            id: stopButton
            icon.source: "qrc:images/icon-m-stop.png"
            onClicked: stop()
        }
        IconButton {
            id: playButton
            icon.source: playbuttoniconsource
            onClicked: play()
        }
        IconButton {
            id: nextButton
            icon.source: "image://theme/icon-m-next"
            onClicked: next()
        }
    }

    Slider {
        width: parent.width
        stepSize: 1.0
        maximumValue: ( mLength > 0 ) ? mLength : 1.0
        minimumValue: 0.0
        value: mPosition
        valueText: formatLength(value)
        label: qsTr("position")
        Label {
            id: lengthTextcomplete
            text: mLengthText
            color: Theme.primaryColor
            font.pixelSize: Theme.fontSizeLarge
            wrapMode: "WordWrap"
            anchors {
                right: parent.right
                rightMargin: Theme.paddingLarge
                bottom: parent.bottom
            }
        }
        onPressedChanged: {
            mPositionSliderActive = pressed
            if (!pressed) {
                seek(value)
                value  = Qt.binding(function() {return mPosition;});
            }
        }
    }
}
