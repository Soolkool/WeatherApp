/*
    Modified By: Vedanth Srinivasan
    Original Author: https://github.com/sumchat/Weather
    Modification Date: 4/22/2019 16:30pm
*/


import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.1

// qml file to find the current location.
Item {    
    id:currentLocation
    signal next();
    property color map_RectColor
    property color text_Color
    property var userLocation1:w_app.location_Data
    property alias coordinates_text:coords.text
    property alias location_text:location.text

    Rectangle{
                id: rect
                anchors.fill: parent
                color:map_RectColor
                Layout.alignment: Qt.AlignCenter
                ColumnLayout{
                    spacing: 1
                    anchors.centerIn: rect
                    Rectangle {
                        Layout.alignment: Qt.AlignCenter
                        Layout.preferredHeight: 40
                        Text {
                              id:location
                                anchors.centerIn: parent
                                text:location_text
                                color: text_Color
                                font.family: "Helvetica"
                                font.pixelSize: w_app.default_FontSize
                            }
                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignBottom
                        Layout.preferredHeight: 20
                        Text {
                              id:coords
                                anchors.centerIn: parent
                                text:coordinates_text
                                color: text_Color
                                font.family: "Helvetica"
                                font.pixelSize: 12
                            }
                    }


                }

               Button{
                    Image {
                            anchors.fill: parent
                            source: "./images/map.png"
                            fillMode:Image.PreserveAspectFit
                        }
                    id: btnSignals
                    anchors.left: parent.left
                    width:20
                    height:40
                    onClicked: {
                            next();
                        }

                }


            }


Component.onCompleted: w_app.getUserLocation();
}



