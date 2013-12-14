var LeftController = Singleton(function() {

    var view = LeftView.getInstance();

    var domId = 'Left',
        urlBase = 'left.view',
        selectedArtistLetter,
        selectedGenre;


    //Private Methods
    var _getUrlVars = function() {
        var vars = {};
        var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
            vars[key] = value;
        });
        return vars;
    };

    var _buildUrl = function() {
        throw 'Not sure how to build URL';
        return urlBase + selectedGenre + '&artistFilter=' + selectedArtistLetter;
    };


    //Public Methods
    var setSelectedArtistLetter = function(artistLetter) {
        selectedArtistLetter = artistLetter;
    };

    var setSelectedGenre = function(genre) {
        selectedGenre = genre;
    };

    var load = function() {

        var fullUrl = _buildUrl(),
            result = Ajax.getInstance().updateDomFromServer(fullUrl, domId);

        result.then(function() {
            selectedArtistLetter = getUrlVars().artistFilter;
            view.build();
            view.bind();
            view.setArtistDropdownLetter(selectedArtistLetter);
        });

    };

    return {
        load: load,
        setSelectedArtistLetter: setSelectedArtistLetter,
        setSelectedGenre: setSelectedGenre
    };
});


var LeftView = Singleton(function() {

    var controller = LeftController.getInstance(),
        containerTimeout;


    //Private Methods
    var _bindTagDropdown = function() {
        $('#tag').change(function() {
            controller.setSelectedGenre($(this).val());
            controller.load();
        });

        $("#tag option").each(function() {
            if ($(this).text() === '') {
                $(this).text('None');
            }
        });
    };

    var _bindArtistDropdown = function() {
        $("#artistDropdown").change(function() {
            onArtistDropdownChange($('option:selected', this).text());
        });
    };

    var _buildArtistDropdown = function() {

        var artistHtml = '<select><option>All</option>',
            alphabet = "ABCDEFGHIJKLMNOPQRSTUVW".split("");

        alphabet.push("X-Z");
        alphabet.push("#");

        for (var i = 0; i < alphabet.length; i++) {
            artistHtml += '<option>' + alphabet[i] + '</option>';
        }

        $("#artistDropdown").html(artistHtml + '</select>');
        $("#artistDropdown select").width($("#artistDropdown select").width() + 10);

    };

    var _bindContainerMouseEnter = (function() {
        var _firstCall = true;

        return function(firstCall) {
            _firstCall = firstCall || _firstCall;

            $("#container").mouseenter(function() {
                if (_firstCall) {
                    _firstCall = false;
                    return;
                }
                $(this).stop();
                if (containerTimeout) clearTimeout(containerTimeout);
                containerTimeout = setTimeout(function() {
                    $("#innerContainerMessage").css('display', 'none');
                    if ($("#innerContainer").css('display', 'none')) {
                        $("#innerContainer").fadeIn(250);
                    }
                }, 200);
            });
        };
    })();

    var _bindContainerMouseLeave = function() {
        $("#container").mouseleave(function() {
            $(this).stop();
            if (containerTimeout) clearTimeout(containerTimeout);
            containerTimeout = setTimeout(function() {
                $("#innerContainer").fadeOut(250, function() {
                    $("#innerContainerMessage").css('display', 'block');
                });
            }, 200);
        });
    };

    var _bindContainerResize = function() {
        $(window).resize(function() {
            var heightDiff = $("#container").height() - $("#innerContainerTop").height();
            $("#innerDivWrapper").height(heightDiff -20);
        });
    };

    var _removePlaylistFileExtensions = function() {
        $(".playlistName").each(function() {
            var str = $(this).text();
            var dotIndex = str.indexOf('.');
            $(this).text(str.substring(0,dotIndex));
        }).css("display", "block");
    };

    var _onArtistDropdownChange = function(chosen) {
        if (chosen === 'All') {
            $(".artistLetter").css("display", 'block');
        } else {
            controller.setSelectedArtistLetter(chosen);
            $(".artistLetter").css("display", 'none');
            $("artistLetter" + chosen).css("display", "block");
        }
    };


    //Public Methods
    var build = function() {
        _buildArtistDropdown();
        _removePlaylistFileExtensions();
    };

    var bind = function() {
        _bindTagDropdown();
        _bindArtistDropdown();
        _bindContainerMouseEnter();
        _bindContainerMouseLeave();
        _bindContainerResize();
    };

    var setArtistDropdownLetter = function(setLetter) {
        setLetter = setLetter || 'All';

        if (setLetter) {
            $("#innerContainerMessage").css('display', 'none');
            $("#innerContainer").css('display', 'block');
            $("#artistDropdown option").each(function() {
                if ($(this).text() === setLetter) {
                    $(this).prop('selected', true);
                    _onArtistDropdownChange(setLetter);
                }
            });
        }
    };

    return {
        build: build,
        bind: bind,
        setArtistDropdownLetter: setArtistDropdownLetter
    };
});


