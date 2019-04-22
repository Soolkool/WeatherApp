/*
    Modified By: Vedanth Srinivasan
    Original Author: https://github.com/sumchat/Weather
    Modification Date: 4/22/2019 16:30pm
*/

import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.1
import QtQml 2.2

Item {

    id:currentWeather
    // represents the current time
    property date time_Now: new Date()
    //individual entities for the dates, day and time
    property string date
    property string day
    property string time
    //color of the rectangle we use
    property color weather_RectColor: "transparent"
    // current temperature in celsius
    property var current_temp
    // range of temperatures and humidity
    property alias low_TempText:mintemptxt.text
    property alias high_TempText:maxtemptxt.text
    property alias humid_Text:humiditytxt.text
    // description of the current weather.
    property alias current_Weather:desc.text


    Grid{
        // grid for the time
        topPadding: 5
        columns: 3
        spacing: 17
        anchors.fill: parent
        Rectangle{
            // aesthetics
            width: 100
            height: 50
            color: weather_RectColor
            Column{
                topPadding: 50
                leftPadding: 25
                spacing: 5
                Text {
                    text:time
                    color: "#303030"
                    font.family: "Helvetica"
                    font.pixelSize: 17
                }
                Text {
                    text:day
                    color: "#303030"
                    font.family: "Helvetica"
                    font.pixelSize: 17
                }
                Text {
                    text:date
                    color: "#303030"
                    font.family: "Helvetica"
                    font.pixelSize: 17
                }
            }
        }

        Rectangle{
            width: 150
            height: 150
            color: weather_RectColor
            border.color: "gray"
            border.width: 4
            radius: width/2.0
            Column{
                topPadding: 15
                leftPadding: 45
                spacing: 10
                Image {
                    source: w_app.currentWeather.icon
                }
                Text {
                    leftPadding: 10
                    id:desc
                    wrapMode: Text.WordWrap
                    text:current_Weather
                    color: "gray"
                    font.family: "Helvetica"
                    font.pixelSize: 10
                }

                Text {
                    width: 100
                    id:iconimg
                    wrapMode: Text.WordWrap
                    text:current_temp + String.fromCharCode(176) + "C"
                    color: "gray"
                    font.family: "Helvetica"
                    font.pixelSize: 17
                }
            }
        }

        Rectangle{
            width: 100
            height: 100
            id:temprow
            color: weather_RectColor
            Column{
                rightPadding: 30
                topPadding: 50
                spacing:0
                Text {
                    id:humiditytxt
                    text:humiditytxt
                    color: "#303030"
                    font.family: "Helvetica"
                    font.pixelSize: 17

                }
                Text {
                    id:mintemptxt
                    text:low_TempText
                    color: "#303030"
                    font.family: "Helvetica"
                    font.pixelSize: 17
                }
                Text {
                    id:maxtemptxt
                    color: "#303030"
                    font.family: "Helvetica"
                    font.pixelSize: 17
                }
            }
        }
    }

    Component.onCompleted: {
        time = time_Now.toLocaleTimeString(locale, Locale.ShortFormat);
        date = Qt.formatDate(time_Now,"dd-MM-yyyy")
        day=  Qt.formatDate(time_Now,"dddd")
    }

}
