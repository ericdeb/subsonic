var Ajax = Singleton(function() {


    var updateDomFromServer = function(url, domId) {

        var deferred = Q.defer();

        $.ajax({
            url: url,
            success: function(data) {
                $("#" + domId).html(data);
                deferred.resolve();
            },
            error: function(error) {
                throw 'Top Controller could not be reloaded ' + error;
            }
        });

        return deferred.promise;
    };


    return {
        updateDomFromServer: updateDomFromServer
    };
});
