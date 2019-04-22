/*
    Modified By: Vedanth Srinivasan
    Original Author: https://github.com/sumchat/Weather
    Modification Date: 4/22/2019 16:30pm
*/



/* Copyright 2018 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.7
import QtQuick.Controls 2.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.3

import "WebRetrieval.js" as MyWebApi
import "GetData.js" as MyUtility

App {
    id: w_app
    width: 400 * AppFramework.displayScaleFactor
    height: 640 * AppFramework.displayScaleFactor

    property real scaleFactor: AppFramework.displayScaleFactor
    readonly property real default_FontSize: w_app.width < 450*w_app.scaleFactor? 21 * scaleFactor:23 * scaleFactor
    property alias stackView: sV
    property ListModel items: ListModel {}//holds the forecast details for each day
    property var weather_Data:[]
    property var temp_WeatherData:[]
    property var  location_Data:{"latitude":"-","longitude":"-","city":"-",
                                 "state":"-","country":"_",}
    property var currentWeather:{"temp":"-", "pressure":"-", "humidity":"-",
                                 "temp_min":"-", "temp_max":"-", "description":"-",
                                 "icon":".//images//empty.jpg" }

    function setLocation(Location){
        if(Location.city !== null)
        {
            var userLocation_new = {"latitude":Location.latitude, "longitude":Location.longitude,
                "city":Location.city, "state":Location.region_code,
                "country":Location.country_name}

            w_app.location_Data=userLocation_new;
            w_app.getCurrentWeather();
            w_app.getWeatherForecast();
        }
        else
            w_app.getUserLocationReverseGeocode(Location)
    }


    function setCurrentWeather(Weather){
        var weather_Sprites = Weather.weather[0].icon;
        var weather_Icons = "http://openweathermap.org/img/w/"+ weather_Sprites + ".png"
        var current_Weather = Weather.weather[0].main;
        var  currentWeather_Update = {"temp":Weather.main.temp, "pressure":Weather.main.pressure,
            "humidity":Weather.main.humidity, "temp_min":Weather.main.temp_min,
            "temp_max":Weather.main.temp_max, "icon":weather_Icons, "description":current_Weather }
        w_app.currentWeather=currentWeather_Update;

    }

    function getUserLocationReverseGeocode(Location){
        MyWebApi.request("http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?f=pjson&featureTypes=&location="+Location.longitude+","+Location.latitude,function (o) {
            if (o.status === 200)
            {
                var locationData = JSON.parse(o.responseText);
                Location.city = locationData.address.City;
                Location.region_code = locationData.address.Region;

                w_app.setLocation(Location);


            }
        });

    }

    /* In certain cases the webservice does not return the city and state information. For those cases the address is obtained from
     * reverse geocoding */
    function getUserLocation() {
        MyWebApi.request("http://api.ipstack.com/check?access_key=a2c8846d3a2e1365093b159c7e2eef44",function (o) {
            if (o.status === 200)
            {
                var locationData = JSON.parse(o.responseText);

                w_app.setLocation(locationData);


            }
        });
    }

    function getCurrentWeather() {
        var currentweatherUrl = "http://api.openweathermap.org/data/2.5/weather?lat="+ w_app.location_Data.latitude + "&lon=" + w_app.location_Data.longitude + "&units=imperial&APPID=41888af36985de89d93d74f2245eb654";
        MyWebApi.request(currentweatherUrl,function (o) {
            if (o.status === 200)
            {
                var weatherData = JSON.parse(o.responseText);
                w_app.setCurrentWeather(weatherData);
            }
        });
    }

    function getWeatherForecast() {
        var weatherUrl = "http://api.openweathermap.org/data/2.5/forecast?lat=" + w_app.location_Data.latitude + "&lon=" + w_app.location_Data.longitude + "&units=imperial&APPID=41888af36985de89d93d74f2245eb654";
        MyWebApi.request(weatherUrl,function (o) {
            if (o.status === 200)
            {
                var weatherData = JSON.parse(o.responseText);
                w_app.setForecast(weatherData);
            }
        });
    }

    //extracts some of the raw data into a custom object
    function setForecast(weatherData){
        var forecasts = weatherData.list.map(function(obj){

            var weatherObj = {};
            weatherObj["temp_min"]= obj.main.temp_min;
            weatherObj["temp_max"]= obj.main.temp_max;
            weatherObj["humidity"]= Math.round(obj.main.humidity * 100) / 100;
            console.log("humidity is "+  weatherObj["humidity"] )
            weatherObj["description"]= obj.weather[0].description;
            var weathericon1 = obj.weather[0].icon;
            var iconimg = "http://openweathermap.org/img/w/"+ weathericon1 + ".png";
            weatherObj["icon"] = iconimg;
            var datestr = obj.dt_txt.split(" ");
            weatherObj["date"]  = datestr[0];
            weatherObj["time"] = datestr[1];
            return weatherObj;
        })
        w_app.temp_WeatherData = forecasts;
        w_app.weather_Data = MyUtility.getReducedForecasts(forecasts);//app.getReducedForecasts(forecasts);
        w_app.addListItems(w_app.weather_Data);

    }


    function addListItems(forecasts){
        forecasts.forEach(function(fcast) {
            //console.log("ihumidity add:"+ fcast.humidity.toString());
            items.append({
                             "description":fcast.description,
                             "temp_min":fcast.temp_min.toString(),
                             "temp_max":fcast.temp_max.toString(),
                             "icon":fcast.icon,
                             "day":fcast.dayofWeek,
                             "humidity":fcast.humidity.toString()

                         })
        })
    }


    StackView {
        id: sV
        anchors.fill: parent
        initialItem: startPage
    }


    Component {
        id: startPage
        WeatherDash{
            onGomap: {
                sV.push(mapPage);
            }
        }

    }

    Component{
        id: mapPage
        Mapping{
            map_Point:ArcGISRuntimeEnvironment.createObject("Point",{x:w_app.location_Data.longitude,y:w_app.location_Data.latitude,SpatialReference:SpatialReference.createWgs84()});
            onBack: {
                sV.pop();
            }

        }
    }


}
