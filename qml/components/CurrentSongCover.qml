import QtQuick 2.0
import Sailfish.Silica 1.0

Image
{
    id: coverImage
    source: coverimageurl
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