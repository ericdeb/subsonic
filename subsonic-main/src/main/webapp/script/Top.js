
var TopController = Singleton(function() {

    var view;

    var load = function() {
        //Initialization Code
        ServerRequestService.getInstance().updateDomFromServer('top.view', 'top').then(function() {
            view = TopView.getInstance();
            view.bind();
        });
    };

    return {
        load: load

    };
});


var TopView = Singleton(function() {

    var bind = function() {
        $("#topPlaylistLink").click(function() {

        });  
    };
    

    return {
        bind: bind

    };

})