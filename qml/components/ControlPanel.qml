import QtQuick 2.0
import Sailfish.Silica 1.0


DockedPanel {
    id: controlPanel

    open: !hideControl && !Qt.inputMethod.visible
    width: parent.width
    height: textColumn.height + Theme.paddingMedium
    contentHeight: height

    property bool hideControl: false

    flickableDirection: Flickable.VerticalFlick

    Label {
        id: notPlayingLabel
        visible: (mTitle=="" && mArtist=="")
        text: qsTr("not playing")
        anchors.centerIn: parent
        color: Theme.primaryColor
        font.pixelSize: Theme.fontSizeLarge
        font.bold: false
        font.family: Theme.fontFamily
    }

    Column {
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }

        id: textColumn
        ScrollLabel {
            id: titleText
            text: mTitle
            color: Theme.primaryColor
            font.pixelSize: Theme.fontSizeSmall
            font.bold: false
            font.family: Theme.fontFamily
            anchors {
                left: parent.left
                right: parent.right
            }
             active: controlPanel.open && Qt.application.active
        }
        ScrollLabel {
            id: artistText
            text: mArtist
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
            font.bold: false
            font.family: Theme.fontFamily
            anchors {
                left: parent.left
                right: parent.right
            }
            active: controlPanel.open && Qt.application.active
        }
    }

    PushUpMenu {
        id: pushUp
        
        ControlColumn {
            width: parent.width
        }
    }
}
