var ServerRequestService = (function() {
    var instance = null;

    var constructor = function() {

        var updateDomFromServer = function(url, domID, successCallback, errorCallback) {
            var deferred = Q.defer();

            $.ajax({
                url: url,
                success: function(data) {
                    $("#" + domID).html(data);
                    deferred.resolve();
                },
                error: function(error) {
                    deferred.reject();
                }
            });

            return deferred.promise;
        };

        return {
            updateDomFromServer: updateDomFromServer
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