/*
    Modified By: Vedanth Srinivasan
    Original Author: https://github.com/sumchat/Weather
    Modification Date: 4/22/2019 16:30pm
*/


function request(url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = (function(myxhr) {
        return function() {
            if(myxhr.readyState === 4) {
                callback(myxhr);
            }
        }
    })(xhr);

    xhr.open("GET", url);
    xhr.send();
}
