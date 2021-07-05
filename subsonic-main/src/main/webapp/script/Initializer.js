
var ServerRequestService = (function() {

    var instance = null;

    var constructor = function() {

        var updateDomFromServer = function(url, domID) {
            $.ajax({
              url: url,
              success: function(data) {
                $("#" + domID).html(data);
              },
              error: function(error) {
                throw 'Error making ajax request' + error;
              }
            });
        }
        
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