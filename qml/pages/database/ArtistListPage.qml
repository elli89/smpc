import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: artistlistPage
    property int lastIndex
    property int lastOrientation
    allowedOrientations: Orientation.All

    Loader {
        id: listViewLoader
        anchors.fill: parent
        //        anchors.bottomMargin: quickControlPanel.visibleSize
        active: true

        sourceComponent: Component {
            SilicaListView {
                id: artistListView
                quickScrollEnabled: jollaQuickscroll
                model: artistsModel
                clip: true

                SectionScroller {
                    listview: artistListView
                    landscape: false
                    sectionPropertyName: "sectionprop"
                }
                ScrollDecorator {
                }

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

    Component.onDestruction: {
        clearArtistList()
    }
}
