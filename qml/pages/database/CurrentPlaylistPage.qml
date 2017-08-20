import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: currentPlaylistPage
    //property alias listmodel: playlistView.model
    allowedOrientations: Orientation.All
    property int lastIndex: lastsongid
    property bool mDeleteRemorseRunning: false

    Component.onDestruction: {
        mPlaylistPage = null;
    }

    SilicaListView {
        id: playlistView
        clip: true
        delegate: playlistTrackDelegate
        currentIndex: lastsongid
        cacheBuffer: 0
        anchors {
            fill: parent
//            bottomMargin: quickControlPanel.visibleSize
        }

        model: playlistModel
        ListModel {
            id: dummyModel
        }

//        Connections {
//            target: playlistModel
//            onClearModel: {
//                console.debug("Clear model requested");
//                playlistView.currentIndex = -1;
//                playlistView.model = dummyModel
//                playlistView.forceLayout();
//            }
//            onModelReset: {
//                playlistView.model = Qt.binding(function() { return playlistModel;})
//                playlistView.currentIndex = -1
//                playlistView.currentIndex = lastsongid
//            }
//        }

        // quickScrollEnabled: jollaQuickscroll
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0
        header: PageHeader {
            title: qsTr("playlist")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("add url")
                onClicked: {
                    pageStack.push(urlInputDialog)
                }
            }
            MenuItem {
                text: qsTr("delete playlist")
                onClicked: {
                    pageStack.push(deleteQuestionDialog)
                }
            }
            MenuItem {
                text: qsTr("save playlist")
                onClicked: {
                    pageStack.push(saveplaylistDialog)
                }
            }
            MenuItem {
                text: qsTr("open playlist")
                onClicked: {
                    requestSavedPlaylists()
                    pageStack.push(Qt.resolvedUrl("SavedPlaylistsPage.qml"))
                }
            }
            MenuItem {
                text: qsTr("jump to playing song")
                onClicked: {
                    playlistView.currentIndex = -1
                    playlistView.currentIndex = lastsongid
                }
            }
        }

        // SpeedScroller {
        //     listview: playlistView
        // }
        // ScrollDecorator {
        // }
        Component {
            id: playlistTrackDelegate
            TrackDelegate {
                contentHeight: Theme.itemSizeSmall
                menu: contextMenu
                Component {
                    id: contextMenu
                    ContextMenu {
//                        MenuItem {
//                            visible: !playing
//                            text: qsTr("play song")
//                            onClicked: playPlaylistTrack(index)
//                        }
                        MenuItem {
                            text: qsTr("remove song")
                            visible: !mDeleteRemorseRunning
                            enabled: !mDeleteRemorseRunning
                            onClicked: {
                                mDeleteRemorseRunning = true;
                                remove()
                            }
                        }

                        MenuItem {
                            text: qsTr("show artist")
                            onClicked: {
                                artistClicked(artist)
                                pageStack.push(Qt.resolvedUrl("AlbumListPage.qml"),{artistname:artist});
                            }
                        }

                        MenuItem {
                            text: qsTr("show album")
                            onClicked: {
                                    albumClicked("", album)
                                    pageStack.push(Qt.resolvedUrl("AlbumTracksPage.qml"),{artistname:"",albumname:album});
                            }
                        }
                        MenuItem {
                            visible: !playing
                            text: qsTr("play as next")
                            onClicked: {
                                /* Workaround for to fast model change, seems to segfault */
                                playNextWOTimer.windUp(index);
                            }
                        }

                        MenuItem {
                            visible: playing
                            text: qsTr("show information")
                            onClicked: pageStack.navigateForward(PageStackAction.Animated)
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
                onClicked: {
                    playlistView.currentIndex = index
                    if (!playing) {
                        parseClickedPlaylist(index)
                    } else {
                        pageStack.navigateForward(PageStackAction.Animated)
                    }
                }

                function remove() {
                    remorseAction(qsTr("Deleting"), function () {
                        deletePlaylistTrack(index);
                        mDeleteRemorseRunning = false;
                    }, 3000)
                }
            }
        }

        section {
            delegate: Loader {
                active:  sectionsInPlaylist && visible
                height: sectionsInPlaylist ? Theme.itemSizeMedium : 0
                width: parent.width
                sourceComponent: PlaylistSectionDelegate{
                    width:undefined
                }
            }
            property: "section"
        }
    }

    // Delete question
    DeletePlaylistDialog {
        id: deleteQuestionDialog

    }

    SavePlaylistDialog {
        id: saveplaylistDialog
    }

    URLInputDialog {
        id: urlInputDialog
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            playlistView.positionViewAtIndex(lastsongid, ListView.Center)
        } else if (status === PageStatus.Active) {
//            pageStack.pushAttached(Qt.resolvedUrl("CurrentSong.qml"));
            if ( mCurrentSongPage == undefined) {
                var currentSongComponent = Qt.createComponent(Qt.resolvedUrl("CurrentSong.qml"));
                mCurrentSongPage = currentSongComponent.createObject(mainWindow);
            }
            pageStack.pushAttached(mCurrentSongPage);
        }
    }

    function parseClickedPlaylist(index) {
        playPlaylistTrack(index)
    }
    onOrientationTransitionRunningChanged: {
        if ( !orientationTransitionRunning ) {
            playlistView.currentIndex = -1
            playlistView.currentIndex = lastsongid
        }
    }
    onLastIndexChanged: {
        playlistView.currentIndex = -1
        playlistView.currentIndex = lastIndex
    }

    /* FIXME really bad workaround for segmentation fault.
       Otherwise QML/Qt seems to crash if model changes significantly on contextmenu actions*/
    Timer {
        id: playNextWOTimer
        property int index;
        interval: 250
        repeat: false
        onTriggered: {
            console.debug("send signal: " + index);
            playPlaylistSongNext(index);
        }

        function windUp(pIndex) {
            console.debug("Workaround timer windup");
            index = pIndex;
            start();
        }
    }
}
