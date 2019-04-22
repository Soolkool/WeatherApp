/*
    Modified By: Vedanth Srinivasan
    Original Author: https://github.com/sumchat/Weather
    Modification Date: 4/22/2019 16:30pm
*/


import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.1



Item {
    property int spacing:2
    property int itemwidth:w_app.width/6
    Rectangle {
        Component {
            id: forecast_Scroll
            Item {
                width: w_app.width - 10
                height: 65
                GridLayout {
                    anchors.centerIn: parent
                    columnSpacing: spacing
                    rowSpacing: spacing
                    columns: 4
                    rows :7
                    Rectangle{
                        border.color: "transparent"
                        border.width: 2
                        height:60
                        width:itemwidth
                        color: index % 2 == 0 ? "#f0ffff" : "#f5f5dc"

                        Text {
                            text: day
                            Layout.fillWidth:true
                            anchors.centerIn: parent

                        }
                    }

                    Rectangle{
                        border.color: "transparent"
                        border.width: 2
                        height:60
                        width:itemwidth * 2
                        color: index % 2 == 0 ? "#f0ffff" : "#f5f5dc"
                        Image {
                            source: icon
                            anchors.centerIn: parent
                        }
                        Rectangle{
                            width:itemwidth * 2
                            color:"transparent"
                            height:15
                            anchors.bottom: parent.bottom
                            Text {
                                text:description
                                anchors.centerIn: parent
                            }
                        }
                    }

                    Rectangle{
                        border.color: "transparent"
                        border.width: 2
                        height:60
                        width:itemwidth*2
                        color: index % 2 == 0 ? "#f0ffff" : "#f5f5dc"
                        Text {
                            text:humidity + "%  Hum." + "\n"+ temp_min + String.fromCharCode(176) + " to "
                                 + temp_max + String.fromCharCode(176) + "C"
                            Layout.fillWidth:true
                            anchors.centerIn: parent
                        }
                    }
                }

            }
        }
        ScrollView{

            width: w_app.width
            height: w_app.height - 280
            clip: false
            ListView {
                anchors.top: parent.top
                model: w_app.items
                delegate: forecast_Scroll
                header:headerComponent
            }
        }
    }



}
