var SubsonicWebSlider = (function() {

    var instance = null;

    var constructor = function(sliderNode, sliderInputNode) {

        var updateGainTimeoutId = 0,
            slider = new Slider(sliderNode, sliderInputNode);

        var _updateGain = function() {
            var gain = slider.getValue() / 100.0;
            PlaylistController.getInstance().sendPlaylistCommand(PLAYLIST_COMMANDS.GAIN, [gain]);
        }

        var setValue = function(val) {
            slider.setValue(val);
        }

        slider.onchange = function () {
            clearTimeout(updateGainTimeoutId);
            updateGainTimeoutId = setTimeout(_updateGain, 250);
        };
    

        return {
            setValue: setValue
        };

    };

    return {
        getInstance: function() {
            if (!instance)
                throw "SubsonicWebSlider not constructed yet";
            return instance;
        },
        constructor: function() {
            if (instance)
                throw "SubsonicWebSlider already constructed";
            instance = constructor.apply(null, arguments);
            return instance;
        }
    };

})();