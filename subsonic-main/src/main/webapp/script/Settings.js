
var MainController = (function() {

    var instance = null;

    var constructor = function() {



        return {
        };
    };

    return {
        getInstance: function() {
            if (!instance)
                instance = constructor();
            return instance;
        }
    };

})();