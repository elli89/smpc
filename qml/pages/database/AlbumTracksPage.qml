import QtQuick 2.1

import Sailfish.Silica 1.0
import "../../components"

Page {
    id: albumTracksPage
    allowedOrientations: Orientation.All
    property string albumname
    property string artistname
    property int lastIndex: 0

    Loader {
        id: portraitLoader
        anchors.fill: parent
//        anchors.bottomMargin: quickControlPanel.visibleSize
        sourceComponent: Component {

            SilicaListView {
                id: albumTracksListView
                quickScrollEnabled: jollaQuickscroll
                contentWidth: width
                model: tracksModel
                clip: true

                section {
                    delegate: Loader {
                        active: visible
                        height: Theme.itemSizeMedium
                        width: parent.width
                        sourceComponent: PlaylistSectionDelegate{
                            width:undefined
                        }
                    }
                    property: "section"
                }

                PullDownMenu {
                    MenuItem {
                        enabled: (artistname!=="")
                        visible: enabled
                        text: qsTr("show all tracks")
                        onClicked: {
                            albumClicked("", albumname);
                            artistname = "";
                        }
                    }
                    MenuItem {
                        text: qsTr("add album")
                        onClicked: {
                            addAlbum([artistname, albumname])
                        }
                    }
                    MenuItem {
                        text: qsTr("play album")
                        onClicked: {
                            playAlbum([artistname, albumname])
                        }
                    }
                }
                delegate: albumTrackDelegate
            }
        }
    }

    Component.onDestruction: {
        clearTrackList();
    }

    Component {
        id: albumTrackDelegate
        TrackDelegate {
            menu: contextMenu

            onClicked: {
                playTrackRemorse()
                // albumTracksListView.currentIndex = index
                // albumTrackClicked(title, album, artist, lengthformated, path,
                //                   year, tracknr,trackmbid,artistmbid,albummbid);
            }
            function playTrackRemorse() {
                remorseAction(qsTr("playing track"), function () {
                    playSong(path)
                }, 3000)
            }
            function addTrackRemorse() {
                remorseAction(qsTr("adding track"), function () {
                    addSong(path)
                }, 3000)
            }
            function addTrackAfterCurrentRemorse() {
                remorseAction(qsTr("adding track"), function () {
                    addSongAfterCurrent(path)
                }, 3000)
            }
            Component {
                id: contextMenu
                ContextMenu {
                    anchors{
                        right: (parent != null ) ? parent.right : undefined
                        left: (parent != null ) ? parent.left : undefined
                    }
                    MenuItem {
                        text: qsTr("play track")
                        onClicked: {
                            playTrackRemorse()
                        }
                    }

                    MenuItem {
                        text: qsTr("add track to list")
                        onClicked: {
                            addTrackRemorse()
                        }
                    }
                    MenuItem {
                        text: qsTr("play after current")
                        onClicked: {
                            addTrackAfterCurrentRemorse();
                        }
                    }
                    MenuItem {
                        text: qsTr("add to saved list")
                        onClicked: {
                            requestSavedPlaylists()
                            pageStack.push(Qt.resolvedUrl("AddToPlaylistDialog.qml"),{url:path});
                        }
                    }
                }
            }
        }
    }
}
