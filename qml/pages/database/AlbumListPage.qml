import QtQuick 2.0
import Sailfish.Silica 1.0
//import harbour.smpc.components 1.0
import "../../components"

Page {
    id: albumslistPage
    allowedOrientations: Orientation.All
    property string artistname
    
    Loader {
        id: listviewLoader
        active: true
        anchors.fill: parent

        //        anchors.bottomMargin: quickControlPanel.visibleSize
        sourceComponent: Component {
            SilicaListView {
                id: listView
                clip: true
                model: albumsModel
                quickScrollEnabled: jollaQuickscroll
                SectionScroller {
                    listview: listView
                    landscape: false
                    sectionPropertyName: "sectionprop"
                }
                ScrollDecorator {
                }

                header: PageHeader {
                    title: artistname !== "" ? artistname : qsTr("albums")
                    width: parent.width
                    height: Theme.itemSizeMedium
                }
                PullDownMenu {
                    enabled: artistname !== ""
                    MenuItem {
                        text: qsTr("add albums")
                        onClicked: {
                            addArtist(artistname)
                        }
                    }
                    MenuItem {
                        text: qsTr("play albums")
                        onClicked: {
                            playArtist(artistname)
                        }
                    }
                }
                delegate: AlbumListDelegate {
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

    Component.onDestruction: {
        clearAlbumList()
    }
}
