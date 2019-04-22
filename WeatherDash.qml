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
    property var new_low: Math.round((w_app.currentWeather.temp_min -32) * 5/9 * 100)/100
    property var new_high: Math.round((w_app.currentWeather.temp_max -32) * 5/9*100)/100
    property var new_temp: Math.round((w_app.currentWeather.temp -32) * 5/9*100)/100
    signal gomap();
    Page{
        anchors.fill: parent
        Image {
            height: w_app.height
            width: w_app.width

            source: "./images/mist.jpg"
        }

        Column{
            // current location control
            anchors.fill: parent
            CurrentLocationFinder{
                width: parent.width
                height: 60
                map_RectColor: "transparent"
                text_Color: "gray"
                Layout.alignment: Qt.AlignCenter
                //print the latitude and longitude of the current location
                coordinates_text:w_app.location_Data.latitude + "," + w_app.location_Data.longitude
                location_text: w_app.location_Data.city + "," + w_app.location_Data.state
                onNext: {
                    gomap();
                }
            }
            // current weather scenarios
            CurrentWeatherCalc{
                width: parent.width
                height: 180
                weather_RectColor: "transparent"
                Layout.alignment: Qt.AlignCenter
                current_temp: new_temp
                low_TempText:"Low: " + new_low  +  String.fromCharCode(176) + "C"
                high_TempText:"High: "+new_high + String.fromCharCode(176) + "C"
                humid_Text: "Hum: " + w_app.currentWeather.humidity + " %"
                current_Weather:w_app.currentWeather.description

            }

            //weather forecast control scroll
            WeekForecast{
                width: parent.width
                height: 190
            }

        }
    }
}


