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
        delegate: trackDelegate
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
            id: trackDelegate
            ListItem {
                contentHeight: mainColumn. height
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

                Rectangle {
                    anchors.fill: parent
                    color: Theme.rgba(Theme.highlightBackgroundColor, 0.2)
                    visible: opacity != 0.0
                    // scale: 0.8
                    opacity: playing ? 1.0 : 0.0
                    Behavior on opacity { PropertyAnimation {duration: 750} }

                }
                Column {
                    id: mainColumn
                    clip: true
                    height: (trackRow
                             >= Theme.itemSizeSmall ? trackRow : Theme.itemSizeSmall)
                    anchors {
                        right: parent.right
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: listPadding
                        rightMargin: listPadding
                    }
                    Item {
                        id: trackRow
                        height: Theme.itemSizeMedium
                        width: parent.width
                        // Label {
                        //     text: (index + 1) + ". "
                        //     anchors {
                        //         verticalCenter: parent.verticalCenter
                        //     }
                        // }
                        Label {
                            clip: true
                            wrapMode: Text.WrapAnywhere
                            elide: Text.ElideRight
                            text: (title === "" ? filename : title)
                            font.italic: (playing) ? true : false
                            anchors {
                                left: parent.left
                                right: timeLabel.right
                                verticalCenter: parent.verticalCenter
                            }
                        }
                        Label {
                            id: timeLabel
                            text: (length === 0 ? "" : " (" + lengthformated + ")")
                            anchors {
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    // Label {
                    //     id: artistLabel
                    //     text: (artist !== "" ? artist + " - " : "") + (album !== "" ? album : "")
                    //     color: Theme.secondaryColor
                    //     font.pixelSize: Theme.fontSizeSmall
                    // }
                }
                // OpacityRampEffect {
                //     sourceItem: mainColumn
                //     slope: 3
                //     offset: 0.65
                // }
//                 Disabled until offically supported
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
