var Tabs = function(domId) {

    var el = $('#' + domId),
        loading = false,
        currentTab = null,
        spinner = new Spinner();

    var _startLoading = function() {
        spinner.spin(el);
    };

    var _stopLoading = function() {
        spinner.stop(el);
    };


    var loadTab = (function() {
        var tabLoadingDeferred = {};
        var tabLoading;

        return function(tab, tabLoader) {
            if (tab && tab === tabLoading) {
                return tabLoadingDeferred.promise;
            }

            tabLoadingDeferred = Q.defer();
            tabLoading = tab;

            if (typeof tabLoader === 'function') {
                var result = tabLoader();
                startLoading();

                if (result.then) {
                    result.then(function() {
                        if (tab === tabLoading) {
                            var index = TABS.keys.indexOf(tab);
                            if (index < 0) throw 'no index for tab';

                            el.tabs({ active: tabNumber });
                            currentTab = tab;
                            stopLoading();
                        }
                    });
                }
            }

            return tabLoadingDeferred.promise;
        };

    })();


    //Initialization Code
    el.tabs();

    return {
        setCurrentTab: setCurrentTab,
        loadTab: loadTab,
        setTabByIndex: setTabByIndex
    };
};


var MainTabs = Singleton(function() {

    var domId = '#mainTabs';
    return Tabs(domId);
});


var HomeTabs = Singleton(function() {

    var domId = '#homeTabs';
    return Tabs(domId);
});


var SettingsTabs = Singleton(function() {

    var domId = '#settingsTabs';
    return Tabs(domId);
});
