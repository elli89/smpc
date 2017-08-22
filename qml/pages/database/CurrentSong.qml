import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: currentsongPage
    property string title:mTitle
    property string album:mAlbum
    property string artist:mArtist
    //property int lengthtextcurrent:lengthTextcurrent.text;
    property bool shuffle
    property bool repeat
    property bool playing

    Component.onDestruction: {
        mCurrentSongPage = null;
    }

    allowedOrientations: Orientation.All

    Item {
        id: portraitLayout
        visible: (orientation === Orientation.Portrait || orientation === Orientation.PortraitInverted)
        anchors.fill: parent

        AlbumImage {
            id: portraitAlbumImage
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: portraitControlColumn.top
            }
        }

        ControlColumn {
            id: portraitControlColumn
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
        }
    }

    Item {
        id: landscapeLayout
        visible: (orientation === Orientation.Landscape || orientation === Orientation.LandscapeInverted)
        anchors.fill: parent

        AlbumImage {
            id: landscapeAlbumImage
            anchors {
                left: parent.left
                right: landscapeControlColumn.left
                top: parent.top
                bottom: parent.bottom
            }
        }

        ControlColumn {
            id: landscapeControlColumn
            width: parent.width / 2
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
        }
    }
}
