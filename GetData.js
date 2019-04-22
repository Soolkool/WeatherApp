/*
    Modified By: Vedanth Srinivasan
    Original Author: https://github.com/sumchat/Weather
    Modification Date: 4/22/2019 16:30pm
*/


//finds the min and max temperature from 3-hour interval data for each of the 5 days
function getReducedForecasts(forecasts){
    var today = new Date();
    var weekday = new Array(7);
    weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday","Saturday"];
    var reducedForecasts = [];
    if(forecasts){
        for (var i=1;i<=5;i++){
            var singleForecast = {};
            today.setDate(today.getDate() + 1);
            var day = fixDigit(today.getDate());
            var month = fixDigit(today.getMonth() + 1);
            var year = today.getFullYear();
            var dateToFilter = year + '-'+ month + '-'+ day;

            var dayForecasts = forecasts.filter(function(obj){

                return obj["date"] === dateToFilter;
            });
            var avgdata = getminMaxTemp(dayForecasts);

            var mintemp = avgdata.min_temp;
            var maxtemp = avgdata.max_temp;
            var sumHumidity = avgdata.sumHumidity;
            if(sumHumidity > 0)
            {
                singleForecast["humidity"]=Math.round(sumHumidity/dayForecasts.length * 100) / 100;
            }
            else
            {
                singleForecast["humidity"]= 0;
            }

            singleForecast["temp_min"]= mintemp;
            singleForecast["temp_max"] = maxtemp;

            singleForecast["description"]= dayForecasts[0].description;
            singleForecast["icon"]= dayForecasts[0].icon;
            if(i==1)
            {
                singleForecast["dayofWeek"] = "Tomorrow";
            }
            else
            {
                singleForecast["dayofWeek"] = weekday[today.getDay()];
            }
            reducedForecasts.push(singleForecast);

        }
    }

    return reducedForecasts;

}

function fixDigit(val){
    return val.toString().length === 1 ? "0" + val : val;
}

//calculate the min_temp and max_temp over all the hours in that day
function getminMaxTemp(dayForecasts) {
    var mintemp = null;
    var maxtemp = null;
    var sumHumidity = 0;
    dayForecasts.forEach(function(fcast) {
        var humidity = fcast["humidity"];
        sumHumidity += humidity;
        var temp = fcast["temp_min"]
        if(mintemp){
            if(mintemp > temp)
                mintemp = temp;
        }
        else
            mintemp = temp;
        if(maxtemp){
            if(maxtemp < temp)
                maxtemp = temp;
        }
        else
            maxtemp = temp;


    });
    return ({"min_temp":mintemp,"max_temp":maxtemp,"sumHumidity":sumHumidity})
}
