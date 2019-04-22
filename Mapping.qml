/*
    Modified By: Vedanth Srinivasan
    Original Author: https://github.com/sumchat/Weather
    Modification Date: 4/22/2019 16:30pm
*/


import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.3

Item {
    signal back();
    //signal maploaded();
    property string status_Text
    property var map_Point
    // App Page
    Page{
        anchors.fill: parent
        // Adding App Page Header Section
        header: ToolBar{
            contentHeight: 56 * w_app.scaleFactor
            Material.primary: "white"

            RowLayout{
                anchors.fill: parent
                Item{
                    Layout.preferredWidth: 4*w_app.scaleFactor
                    Layout.fillHeight: true
                }
                ToolButton {
                    indicator: Image{
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent
                        source: "./images/arrow.png"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }
                    onClicked:{
                        back();
                    }
                }
                Item{
                    Layout.preferredWidth: 20*w_app.scaleFactor
                }
                Label {
                    Layout.fillWidth: true
                    text: qsTr("Current Location")
                    font.styleName: "Helvetica"
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: w_app.default_FontSize
                    color: "gray"
                }
            }
        }
        MapView {

            id:mapView
            anchors.fill: parent
            Map {
                id: map
                // geographic reference from map.
                spatialReference: SpatialReference {wkid: 4326}

                // Set up signal handler to determine load status
                // Load status should be loaded once the basemap successfully loads
                onLoadStatusChanged: {
                    if (loadStatus == Enums.LoadStatusLoaded) {
                        status_Text = "Loaded";
                        mapView. setViewpointCenterAndScale(map_Point,2e7)
                        // create graphics overlay and add it to the map view
                        var graphicsOverlay = ArcGISRuntimeEnvironment.createObject("GraphicsOverlay");
                        mapView.graphicsOverlays.append(graphicsOverlay);
                        // create a graphic
                        var pinpoint_Position = ArcGISRuntimeEnvironment.createObject("SimpleMarkerSymbol", {color: "black", size: 12, style: Enums.SimpleMarkerSymbolStyleX });
                        var graphic = ArcGISRuntimeEnvironment.createObject("Graphic", {symbol: pinpoint_Position, geometry: map_Point});
                        // add the graphic to the graphics overlay
                        graphicsOverlay.graphics.append(graphic);
                    }
                    else
                        status_Text = "Loading Error";
                }
            }

        }
        ViewpointCenter {
            id: initialViewpoint
            center: Point {
                x: -84.302
                y: 34.1124
                spatialReference: SpatialReference {wkid: 4326}
            }
            targetScale: 2e7
        }
        Basemap {
            id: basemap
            ArcGISMapImageLayer {
                url: "https://sampleserver6.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer"
            }
        }

        Component.onCompleted: {
            map.basemap = basemap;
        }
    }


}

