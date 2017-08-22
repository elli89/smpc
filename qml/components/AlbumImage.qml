import QtQuick 2.0
import Sailfish.Silica 1.0

Image {
    source: coverimageurl
    cache: false
    fillMode: Image.PreserveAspectFit
    Image {
        anchors.fill: parent
        visible: landscapeAlbumImage.status != Image.Ready
        source: "qrc:images/pictogram.svg"
        sourceSize.width: Screen.width / 2
        sourceSize.height: Screen.width / 2
    }
}
