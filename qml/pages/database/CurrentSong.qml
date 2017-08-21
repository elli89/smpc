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

        // Column {
        //     id: backgroundColumn
        //     anchors {
        //         fill: parent
        //         // rightMargin: Theme.paddingMedium
        //         // leftMargin: Theme.paddingMedium
        //     }

        //     CurrentSongCover
        //     {
        //         anchors {
        //             bottom: controlColumn.top
        //             top: parent.top
        //             left: parent.left
        //             right: parent.right
        //             margins: Theme.paddingLarge
        //         }
        //     }

        //     ControlColumn {
        //         id: controlColumn
        //         anchors {
        //             bottom: parent.bottom
        //             left: parent.left
        //             right: parent.right
        //         }
        //     }
        // }

        Row {
            id: backgroundRow
            anchors.fill: parent

            CurrentSongCover
            {
                id: cover
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    // right: controlColumn.left
                    margins: Theme.paddingLarge
                }
            }

            ControlColumn {
                id: controlColumn
                anchors {
                    right: parent.right
                    left: cover.right
                    top: parent.top
                    bottom: parent.bottom
                }
            }
        }
    }
}