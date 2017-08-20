import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

CoverBackground {
    id: coverpage
    anchors.fill: parent

    Image {
        id: coverimg
        anchors.fill: parent
        source: coverimageurl
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.highlightBackgroundColor
        gradient: Gradient {
            GradientStop {
                position: 0.6
                color: Qt.rgba(0.0, 0.0, 0.0, 0.0)
            }
            GradientStop {
                position: 0.7
                //color: Qt.rgba(0.0, 0.0, 0.0, 0.3)
                color: Theme.rgba(Theme.highlightColor, 0.2)
            }
            GradientStop {
                position: 1.0
                color: Theme.rgba(Theme.highlightColor, 0.5)
                //color: Qt.rgba(0.0,0.0,0.0, 0.8)
            }
        }
    }
    Image {
        id: logo
        visible: ( (!coverimg.ready) && (mTitle == ""))
        source: "qrc:images/pictogram.png"
        anchors.centerIn: parent
    }

    Label {
        id: textLabel
        anchors.centerIn: coverpage
        width: coverpage.width - (2 * listPadding)
        height: (coverpage.height / 3) * 2
        wrapMode: "WordWrap"
        elide: Text.ElideRight
        font.pixelSize: Theme.fontSizeLarge
        style: Text.Raised
        styleColor: Theme.secondaryColor
        horizontalAlignment: Text.AlignHCenter
        text: (mTitle == "" ? "SMPC" : mTitle)
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: playbuttoniconsourcecover //"image://theme/icon-cover-pause"
            onTriggered: play()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next-song"
            onTriggered: next()
        }
    }
}
