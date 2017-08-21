import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    Rectangle {
        anchors.fill: parent
        color: Theme.rgba(Theme.highlightBackgroundColor, 0.2)
        visible: opacity != 0.0
        opacity: playing ? 1.0 : 0.0
        Behavior on opacity { PropertyAnimation {duration: 750} }
    }
    Item {
        anchors.fill: parent
        Label {
            id: nameLabel
            clip: true
            elide: Text.ElideRight
            text: (title === "" ? filename : title)
            maximumLineCount: 1
            anchors {
                right: parent.right
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: listPadding
                rightMargin: listPadding
            }
        }
        OpacityRampEffect {
            sourceItem: nameLabel//titleRow
            slope: 3
            offset: 0.65
        }
        Label {
            text: (length === 0 ? "" : " (" + lengthformated + ")")
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: listPadding
            }
        }
    }
}