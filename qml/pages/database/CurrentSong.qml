import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: currentsong_page
    property string title:mTitle
    property string album:mAlbum
    property string artist:mArtist
    //property int lengthtextcurrent:lengthTextcurrent.text;
    property bool shuffle
    property bool repeat
    property bool playing
    property int fontsize: Theme.fontSizeMedium
    property int fontsizegrey: Theme.fontSizeSmall
    property bool detailsvisible: true

    Component.onDestruction: {
        mCurrentSongPage = null;
    }

    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: infoFlickable
        anchors.fill: parent
        clip: true

        Column {
            id: backgroundColumn
            anchors.fill: parent

            Image
            {
                id: coverImage
                source: coverimageurl
                height: width
                width : parent.width
                cache: false
                fillMode: Image.PreserveAspectCrop
                Image {
                    anchors.fill: parent
                    visible: coverImage.status != Image.Ready
                    source: "qrc:images/pictogram.svg"
                    sourceSize.width: Screen.width / 2
                    sourceSize.height: Screen.width / 2
                }
            }

            Column {
                id: controlColumn
                width: parent.width

                Slider {
                    id: volumeSlider
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

                Slider {
                    id: positionSlider
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
                        font.pixelSize: Theme.fontSizeSmall
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
                
                Row {
                    id: buttonRow
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
            }
        }

            // ScrollLabel {
            //     id: titleText
            //     text: title
            //     color: Theme.primaryColor
            //     font.pixelSize: fontsize
            //     anchors {
            //         left: parent.left
            //         right: parent.right
            //     }
            // }
            // ScrollLabel {
            //     id: albumText
            //     text: album
            //     color: Theme.primaryColor
            //     font.pixelSize: fontsize
            //     anchors {
            //         left: parent.left
            //         right: parent.right
            //     }
            // }
            // ScrollLabel {
            //     id: artistText
            //     text: artist
            //     color: Theme.primaryColor
            //     font.pixelSize: fontsize
            //     anchors {
            //         left: parent.left
            //         right: parent.right
            //     }
            // }
        // }
    }
}