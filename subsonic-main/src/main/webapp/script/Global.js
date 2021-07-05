var Singleton = function(constructor) {

    return (function() {

        var instance = null;

        return {
            getInstance: function() {
                if (!instance)
                    instance = constructor();
                return instance;
            }
        };

    })();

};

var SingletonConstructor = function(constructor) {

    return (function() {

        var instance = null;

        return {
            getInstance: function() {
                if (!instance)
                    throw "Singleton not constructed yet";
                return instance;
            },
            constructor: function() {
                if (instance)
                    throw "Singleton already constructed";
                instance = constructor.apply(null, arguments);
                return instance;
            }
        };
    })();

};