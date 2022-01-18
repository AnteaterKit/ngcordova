var exec = require('cordova/exec');

var ScreenCast = {
    startBroadcast: function (success, error, bufferHandler) {
        exec(success, error, bufferHandler, "ScreenCast", "startBroadcast");
    },
}

module.exports = Replay;