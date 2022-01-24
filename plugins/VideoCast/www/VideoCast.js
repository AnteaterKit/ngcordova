var exec = require('cordova/exec');

var VideoCast = {
    startCast: function (success, error) {
        exec(success, error, "VideoCast", "startCast");
    },
}

module.exports = VideoCast;