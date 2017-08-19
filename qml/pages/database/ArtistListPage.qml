import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: artistlistPage
    property int lastIndex
    property int lastOrientation
    allowedOrientations: Orientation.All


    Loader {
        id: gridViewLoader
        anchors.fill: parent
        //        anchors.bottomMargin: quickControlPanel.visibleSize
        active: false

        sourceComponent: Component {
            SilicaGridView {
                id: artistGridView
                // quickScrollEnabled: jollaQuickscroll
                model: artistsModel
                cellWidth: Screen.sizeCategory >= Screen.Large ? ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted)
                                                                  ? (width / 6) : width / 4) :
                                                                 ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted) ? (width/4) : (width / 2))
                cellHeight: cellWidth
                cacheBuffer:0
                property bool scrolling: sectionScroller.scrolling
                // populate: Transition {
                //     NumberAnimation {
                //         properties: "x"
                //         from: artistGridView.width * 2
                //         duration: populateDuration
                //     }
                // }

                // SectionScroller {
                //     id: sectionScroller
                //     gridView: artistGridView
                //     landscape: false
                //     sectionPropertyName: "sectionprop"
                // }
                ScrollDecorator {
                }

                header: PageHeader {
                    title: qsTr("artists")
                    width: parent.width
                    height: Theme.itemSizeMedium
                }

                delegate: ArtistDelegate {
                }
            }
        }
    }

    Loader {
        id: listViewLoader
        anchors.fill: parent
        //        anchors.bottomMargin: quickControlPanel.visibleSize
        active: false

        sourceComponent: Component {
            SilicaListView {
                id: artistListView
                // quickScrollEnabled: jollaQuickscroll
                model: artistsModel
                clip: true
                // populate: Transition {
                //     NumberAnimation {
                //         properties: "x"
                //         from: artistListView.width * 2
                //         duration: populateDuration
                //     }
                // }

                // SectionScroller {
                //     listview: artistListView
                //     landscape: false
                //     sectionPropertyName: "sectionprop"
                // }
                // ScrollDecorator {
                // }

                header: PageHeader {
                    title: qsTr("artists")
                    width: parent.width
                    height: Theme.itemSizeMedium
                }

                delegate: ArtistListDelegate {
                }

                section {
                    property: 'sectionprop'
                    delegate: SectionHeader {
                        text: section
                    }
                }
            }
        }
    }

    Loader {
        id: showViewLoader
        active: false
        anchors.fill: parent
        //        anchors.rightMargin: quickControlPanel.visibleSize
        sourceComponent: Component {
            PathView {
                id: showView
                property int itemHeight: height / (1.3)
                property int itemWidth: itemHeight
                model: artistsModel

                SectionScroller {
                    pathview: showView
                    sectionPropertyName: "sectionprop"
                    landscape: true
                    z: 120
                    interactive: showView.interactive
                }

                cacheItemCount: pathItemCount + 2
                pathItemCount: 12 // width/itemWidth
                delegate: ArtistShowDelegate {
                }
                snapMode: PathView.NoSnap
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                clip: true
                path: Path {
                    startX: 0
                    startY: showView.height / 2
                    // Left out
                    PathAttribute {
                        name: "z"
                        value: 0
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: 80
                    }

                    // Left flip (bottom)
                    PathLine {
                        x: (showView.width / 2) - (showView.itemWidth / 2)
                        y: showView.height - showView.itemHeight / 2
                    }
                    PathAttribute {
                        name: "z"
                        value: 50
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: 70
                    }
                    PathPercent {
                        value: 0.45
                    }

                    // Center (bottom)
                    PathLine {
                        x: (showView.width / 2)
                        y: showView.height - showView.itemHeight / 2
                    }
                    PathAttribute {
                        name: "z"
                        value: 100
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: 0
                    }
                    PathPercent {
                        value: 0.5
                    }

                    // Right Flip (bottom)
                    PathLine {
                        x: (showView.width / 2) + (showView.itemWidth / 2)
                        y: showView.height - showView.itemHeight / 2
                    }
                    PathAttribute {
                        name: "z"
                        value: 50
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: -70
                    }
                    PathPercent {
                        value: 0.55
                    }

                    // Right out
                    PathLine {
                        x: showView.width
                        y: showView.height / 2
                    }
                    PathAttribute {
                        name: "z"
                        value: 0
                    }
                    PathAttribute {
                        name: "delegateRotation"
                        value: -80
                    }
                    PathPercent {
                        value: 1.0
                    }
                }
            }
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (!orientationTransitionRunning
                    && orientation != lastOrientation) {
                gridViewLoader.active = false
                showViewLoader.active = false
                if ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted)) {
                    if (artistView === 0) {
                        gridViewLoader.active = true
                    } else if (artistView === 1) {
                        listViewLoader.active = true
                    }
                } else if ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted)) {
                    if ( useShowView) {
                        showViewLoader.active = true
                    } else {
                        gridViewLoader.active = true
                    }
                }
            }
        }
        if (status === PageStatus.Deactivating) {
            if (typeof (gridViewLoader.item) != undefined
                    && gridViewLoader.item) {
                lastIndex = gridViewLoader.item.currentIndex
            }
            lastOrientation = orientation
        } else if (status === PageStatus.Activating
                   && typeof (gridViewLoader.item) != undefined
                   && gridViewLoader.item) {
            gridViewLoader.item.positionViewAtIndex(lastIndex, GridView.Center)
        }
    }

    onOrientationTransitionRunningChanged: {
        if (!orientationTransitionRunning) {
            if ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted)) {
                if (artistView === 0) {
                    gridViewLoader.active = true
                } else if (artistView === 1) {
                    listViewLoader.active = true
                }
            } else if ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted)) {
                if ( useShowView) {
                    showViewLoader.active = true
                } else {
                    gridViewLoader.active = true
                }
            }
        } else {
            gridViewLoader.active = false
            showViewLoader.active = false
            listViewLoader.active = false
            // Deactivating components
        }
    }

    Component.onDestruction: {
        clearArtistList()
    }
}
