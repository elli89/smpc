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
        anchors {
            fill: parent
        }
        // gradient: Gradient {
        //     GradientStop {
        //         position: 0.0
        //         color: Theme.rgba(Theme.highlightBackgroundColor, 0.0)
        //     }
        //     GradientStop {
        //         position: 1.0
        //         //color: Theme.rgba(Theme.highlightBackgroundColor, 0.6)
        //         color: Theme.rgba(Theme.highlightBackgroundColor, 0.3)
        //     }
        // }
    }
    Row {
        anchors {
            right: parent.right
            rightMargin: listPadding
        }
        layoutDirection: Qt.RightToLeft
        height: parent.heigth

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
                // height: Theme.itemSizeSmall
                text: album
                anchors {
                //     left: parent.left
                //     leftMargin: listPadding
                    right: parent.right
                    rightMargin: Theme.paddingSmall
                }

                font.pixelSize: Theme.fontSizeLarge
                // verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                maximumLineCount: 1
                elide: Text.ElideRight
            }
            Label {
                id: artistLabel
                // height: Theme.itemSizeSmall
                text: artist
                anchors {
                //     left: parent.left
                //     leftMargin: listPadding
                    right: parent.right
                    rightMargin: Theme.paddingSmall
                }
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall

                // font.pixelSize: Theme.fontSizeLarge
                // verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                maximumLineCount: 1
                elide: Text.ElideRight
            }
        }

        // OpacityRampEffect {
        //     sourceItem: sectionImage
        //     direction: OpacityRamp.BottomToTop
        // }
    }
}
