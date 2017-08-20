import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    height: Theme.itemSizeMedium
    width: parent.width
    property string album: section.split('|')[1]
    property string artist: section.split('|')[0]

    Rectangle {
        id: sectionFillRect
        color: Theme.rgba(Theme.highlightBackgroundColor, 0.3)
        anchors.fill: parent
    }

    Row {
        anchors {
            fill: parent
            rightMargin: Theme.paddingMedium
            leftMargin: Theme.paddingMedium
        }
        layoutDirection: Qt.RightToLeft

        Image {
            id: sectionImage
            height: parent.height
            width: height
            cache: true
            asynchronous: true
            sourceSize.height: height
            sourceSize.width: width
            fillMode: Image.PreserveAspectFit
            source: "image://imagedbprovider/album/" + artist + "/" + album
            Image {
                id: dummyImage
                anchors.fill: parent
                visible: (parent.status !== Image.Ready)
                source: "image://theme/icon-l-music"
            }
        }

        Column {
            id: textColumn
            Label {
                id: albumLabel
                text: album
                anchors {
                    right: parent.right
                    rightMargin: Theme.paddingSmall
                }

                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.AlignRight
                maximumLineCount: 1
                elide: Text.ElideRight
            }
            Label {
                id: artistLabel
                text: artist
                anchors {
                    right: parent.right
                    rightMargin: Theme.paddingSmall
                }
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall

                horizontalAlignment: Text.AlignRight
                maximumLineCount: 1
                elide: Text.ElideRight
            }
        }
    }
}
