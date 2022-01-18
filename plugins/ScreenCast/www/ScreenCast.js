var exec = require('cordova/exec');

var ScreenCast = {
    startBroadcast: function (success, error) {
        exec(success, error, "ScreenCast", "startBroadcast");
    },
}

module.exports = ScreenCast;