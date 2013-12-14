<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">

<html><head>
    <%@ include file="head.jspf" %>
    <link rel="alternate" type="application/rss+xml" title="Subsonic Podcast" href="podcast.view?suffix=.rss">

    <script type="text/javascript" language="javascript">

        var SRS = ServerRequestService.getInstance();

        SRS.updateDomFromServer('top.view', 'top');
        SRS.updateDomFromServer('left.view', 'left');
        SRS.updateDomFromServer('right.view', 'right');

        /* from albumsHeader.jsp*/
        function toggleAlbum(index) {
            a = '#albart' + index;
            $(a).attr('width', 174 + 87 - $(a).attr('width'));
            $(a).attr('height', 174 + 87 - $(a).attr('height'));

            $('#albcmd' + index).toggle();
            $('#albtit' + index).toggle();
            $('#albson' + index).toggle();

            if ($('#albson' + index).children().size() == 0) {
                $('#albson' + index).load('album.view?view' + musicFiles[index].join('&mf=') <c:if test="${not empty model.trackId}">+ '&trackId=${model.trackId}'</c:if>);
            }
        }

        /* from advancedSettings.jsp*/
        function enableLdapFields() {
            var checkbox = $("ldap");
            var table = $("ldapTable");

            if (checkbox && checkbox.checked) {
                table.show();
            } else {
                table.hide();
            }
        }

        /* from artist.jsp */
        function noop() {}

        /* from artist.jsp */
        function artistInit() {
            dwr.engine.setErrorHandler(null);

            var trackIds = ${model.trackIds};
            var artistId = ${model.artistId};

            $("#selectPlayBut").click(function() {
                var playEnqAdd = $("#playEnqAdd option:selected");
                playMode = (playEnqAdd.text() === 'Add Last') ? 'Add' : playEnqAdd.text();
                var toPlay = $("#playEnqAddOptions option:selected").text();

                switch(toPlay) {
                    case 'All':
                        top.playlist.sendPlaylistCommand(P_CMDS.PLAY.TRACKS, trackIds, playEnqAdd.val());
                        break;
                    case 'Top Tracks':
                        top.playlist.sendPlaylistCommand(P_CMDS.PLAY.TOP_TRACKS, artistId, playEnqAdd.val());
                        break;
                    case 'Artist Radio':
                        top.playlist.sendPlaylistCommand(P_CMDS.PLAY.ARTIST_RADIO, artistId, playEnqAdd.val());
                        break;
                    case 'Random':
                        top.playlist.sendPlaylistCommand(P_CMDS.PLAY.RANDOM, trackIds, playEnqAdd.val());
                        break;
                }
            });

            $("#bio0").children('a').attr("target", "_blank");
        }

        /* from artist.jsp */
        function playMode() {
            return $('#togglePlayAdd').attr('class').substring(0, 1);
        }
        
        /* from artist.jsp */
        function togglePlayAdd() {
            var t = $('#togglePlayAdd');
            if (t.attr('class') == 'Play') {
                t.attr('class', 'Enqueue');
            } else if (t.attr('class') == 'Enqueue') {
                t.attr('class', 'Add');
            } else {
                t.attr('class', 'Play');
            }
            var ids = ['all','top_tracks','artist_radio','random'];
            for (var i=0; i<ids.length; i++) {
                if ($('#'+ids[i])) {
                    $('#'+ids[i]).html(t.attr('class') + ' ' + ids[i].replace(/_/g, ' '));
                }
            }
        }

        /* from artist.jsp */
        function toggleArtist() {
            $('#bioArt').attr('width', 126 + 63 - $('#bioArt').attr('width'));
            $('#bioArt').attr('height', 126 + 63 - $('#bioArt').attr('height'));

            $('#bio0').toggle();
            $('#bio1').toggle();
        }

        /* from artistDetails.jsp */
        function artistDetailsinit() {
            dwr.engine.setErrorHandler(null);
        }

        /* from artistGenres.jsp */
        function artistGenresinit() {
            dwr.engine.setErrorHandler(null);
        }

        /* from artistGenres.jsp */
        function add(name, count) {
            $("#inp").append('<div style="display: block">\
                <img class="dec" src="<spring:theme code="removeImage"/>" alt="Decrease" style="float: left; padding-top: 4px">\
                <div class="popularity" style="float: left"><div class="bar bgcolor3" style="width: ' + count + '%"></div><div class="genre">' + name + '</div></div>\
                <img class="inc" src="<spring:theme code="plusImage"/>" alt="Increase" style="float: left; padding-top: 4px">\
                <div style="clear:both;"></div></div>');
            
            $(".dec:last").click(function() {
                set_width($(this), -25);
            });

            $(".inc:last").click(function() {
                set_width($(this), 25);
            });

        }

        /* from artistGenres.jsp */
        function set_width(element, diff) {
            var bar = element.parent().find(".bar");
            var width = bar.width();
            var genre = element.parent().find(".genre").text();
            width = width + diff;
            if (width > 500) { width = 500 };
            if (width <=  0) {
                element.parent().remove();
                $("#genres").append("<option>" + genre + "</option>");
            } else {
                bar.width(width);
            }
            uiTagService.tagArtist(${model.artistId}, "${model.artistName}", genre, width / 5, diff > 0);
        }

        /* from changeCoverArt.jsp */
        google.load('search', '1');
        var imageSearch;

        /* from changeCoverArt.jsp */
        function setImage(imageUrl) {
            $("wait").show();
            $("result").hide();
            $("success").hide();
            $("error").hide();
            $("errorDetails").hide();
            $("noImagesFound").hide();
            var id = dwr.util.getValue("id");
            coverArtService.setCoverArtImage(id, imageUrl, setImageComplete);
        }

        /* from changeCoverArt.jsp */
        function setImageComplete(errorDetails) {
            $("wait").hide();
            if (errorDetails != null) {
                dwr.util.setValue("errorDetails", "<br/>" + errorDetails, { escapeHtml:false });
                $("error").show();
                $("errorDetails").show();
            } else {
                $("success").show();
            }
        }

        /* from changeCoverArt.jsp */
        function searchComplete() {

            $("wait").hide();

            if (imageSearch.results && imageSearch.results.length > 0) {

                var images = $("images");
                images.innerHTML = "";

                var results = imageSearch.results;
                for (var i = 0; i < results.length; i++) {
                    var result = results[i];
                    var node = $("template").cloneNode(true);

                    var link = node.getElementsByClassName("search-result-link")[0];
                    link.href = "javascript:setImage('" + result.url + "');";

                    var thumbnail = node.getElementsByClassName("search-result-thumbnail")[0];
                    thumbnail.src = result.tbUrl;

                    var title = node.getElementsByClassName("search-result-title")[0];
                    title.innerHTML = result.contentNoFormatting.truncate(30);

                    var dimension = node.getElementsByClassName("search-result-dimension")[0];
                    dimension.innerHTML = result.width + " × " + result.height;

                    var url = node.getElementsByClassName("search-result-url")[0];
                    url.innerHTML = result.visibleUrl;

                    node.show();
                    images.appendChild(node);
                }

                $("result").show();

                addPaginationLinks(imageSearch);

            } else {
                $("noImagesFound").show();
            }
        }

        /* from changeCoverArt.jsp */
        function addPaginationLinks() {

            // To paginate search results, use the cursor function.
            var cursor = imageSearch.cursor;
            var curPage = cursor.currentPageIndex; // check what page the app is on
            var pagesDiv = document.createElement("div");
            for (var i = 0; i < cursor.pages.length; i++) {
                var page = cursor.pages[i];
                var label;
                if (curPage == i) {
                    // If we are on the current page, then don"t make a link.
                    label = document.createElement("b");
                } else {

                    // Create links to other pages using gotoPage() on the searcher.
                    label = document.createElement("a");
                    label.href = "javascript:imageSearch.gotoPage(" + i + ");";
                }
                label.innerHTML = page.label;
                label.style.marginRight = "1em";
                pagesDiv.appendChild(label);
            }

            // Create link to next page.
            if (curPage < cursor.pages.length - 1) {
                var next = document.createElement("a");
                next.href = "javascript:imageSearch.gotoPage(" + (curPage + 1) + ");";
                next.innerHTML = "<fmt:message key="common.next"/>";
                next.style.marginLeft = "1em";
                pagesDiv.appendChild(next);
            }

            var pages = $("pages");
            pages.innerHTML = "";
            pages.appendChild(pagesDiv);
        }

        /* from changeCoverArt.jsp */
        function search() {

            $("wait").show();
            $("result").hide();
            $("success").hide();
            $("error").hide();
            $("errorDetails").hide();
            $("noImagesFound").hide();

            var query = dwr.util.getValue("query");
            imageSearch.execute(query);
        }

        /* from changeCoverArt.jsp */
        function onLoad() {

            imageSearch = new google.search.ImageSearch();
            imageSearch.setSearchCompleteCallback(this, searchComplete, null);
            imageSearch.setNoHtmlGeneration();
            imageSearch.setResultSetSize(8);

            google.search.Search.getBranding("branding");

            $("template").hide();

            search();
        }
        google.setOnLoadCallback(onLoad);

        /* from editTags.jsp */
        var index = 0;
        var fileCount = ${fn:length(model.songs)};

        /* from editTags.jsp */
        function setArtist() {
            var artist = dwr.util.getValue("artistAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("artist" + i, artist);
            }
        }

        /* from editTags.jsp */
        function setAlbumArtist() {
            var albumartist = dwr.util.getValue("albumArtistAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("albumArtist" + i, albumartist);
            }
        }

        /* from editTags.jsp */
        function setComposer() {
            var composer = dwr.util.getValue("composerAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("composer" + i, composer);
            }
        }

        /* from editTags.jsp */
        function setAlbum() {
            var album = dwr.util.getValue("albumAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("album" + i, album);
            }
        }

        /* from editTags.jsp */
        function setYear() {
            var year = dwr.util.getValue("yearAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("year" + i, year);
            }
        }

        /* from editTags.jsp */
        function setGenre() {
            var genre = dwr.util.getValue("genreAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("genre" + i, genre);
            }
        }

        /* from editTags.jsp */
        function suggestTitle() {
            for (i = 0; i < fileCount; i++) {
                var title = dwr.util.getValue("suggestedTitle" + i);
                dwr.util.setValue("title" + i, title);
            }
        }

        /* from editTags.jsp */
        function resetTitle() {
            for (i = 0; i < fileCount; i++) {
                var title = dwr.util.getValue("originalTitle" + i);
                dwr.util.setValue("title" + i, title);
            }
        }

        /* from editTags.jsp */
        function suggestTrack() {
            for (i = 0; i < fileCount; i++) {
                var track = dwr.util.getValue("suggestedTrack" + i);
                dwr.util.setValue("track" + i, track);
            }
        }

        /* from editTags.jsp */
        function resetTrack() {
            for (i = 0; i < fileCount; i++) {
                var track = dwr.util.getValue("originalTrack" + i);
                dwr.util.setValue("track" + i, track);
            }
        }

        /* from editTags.jsp */
        function updateTags() {
            document.getElementById("save").disabled = true;
            index = 0;
            dwr.util.setValue("errors", "");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("status" + i, "");
            }
            updateNextTag();
        }

        /* from editTags.jsp */
        function updateNextTag() {
            var id = dwr.util.getValue("id" + index);
            var artist = dwr.util.getValue("artist" + index);
            var albumartist = dwr.util.getValue("albumArtist" + index);
            var composer = dwr.util.getValue("composer" + index);
            var track = dwr.util.getValue("track" + index);
            var album = dwr.util.getValue("album" + index);
            var title = dwr.util.getValue("title" + index);
            var year = dwr.util.getValue("year" + index);
            var genre = dwr.util.getValue("genre" + index);
            dwr.util.setValue("status" + index, "<fmt:message key="edittags.working"/>");
            tagService.setTags(id, track, artist, albumartist, composer, album, title, year, genre, setTagsCallback);
        }

        /* from editTags.jsp */
        function setTagsCallback(result) {
            var message;
            if (result == "SKIPPED") {
                message = "<fmt:message key="edittags.skipped"/>";
            } else if (result == "UPDATED") {
                message = "<b><fmt:message key="edittags.updated"/></b>";
            } else {
                message = "<div class='warning'><fmt:message key="edittags.error"/></div>"
                var errors = dwr.util.getValue("errors");
                errors += result + "<br/>";
                dwr.util.setValue("errors", errors, { escapeHtml:false });
            }
            dwr.util.setValue("status" + index, message, { escapeHtml:false });
            index++;
            if (index < fileCount) {
                updateNextTag();
            } else {
                document.getElementById("save").disabled = false;
            }
        }

        /* from externalPlayer.jsp */
        function initExternalPlayer() {
            var flashvars = {
                id:"player1",
                screencolor:"000000",
                frontcolor:"<spring:theme code="textColor"/>",
                backcolor:"<spring:theme code="backgroundColor"/>",
                stretching: "fill",
                "playlist.position": "bottom",
                "playlist.size": 200
            };
            var params = {
                allowfullscreen:"true",
                allowscriptaccess:"always"
            };
            var attributes = {
                id:"player1",
                name:"player1"
            };
            swfobject.embedSWF("<c:url value="/flash/jw-player-5.10.swf"/>", "placeholder", "500", "500", "9.0.0", false, flashvars, params, attributes);
        }

        /* from advancedSearch.jsp */
        function search(page) {
            $('#songs').load('advancedSearchResult.view?page=' + page + '&' + $('form').serialize());
            window.scrollTo(0, 0);
        }
        
        /* from advancedSearch.jsp */
        function addOption(id) {
            $('#addOptions').append($('<option></option>').attr('value', id).text(id.replace(/_/g, ' ')));
        }

        /* from userSettings.jsp */
        function enablePasswordChangeFields() {
            var changePasswordCheckbox = $("passwordChange");
            var ldapCheckbox = $("ldapAuthenticated");
            var passwordChangeTable = $("passwordChangeTable");
            var passwordChangeCheckboxTable = $("passwordChangeCheckboxTable");

            if (changePasswordCheckbox && changePasswordCheckbox.checked && (ldapCheckbox == null || !ldapCheckbox.checked)) {
                passwordChangeTable.show();
            } else {
                passwordChangeTable.hide();
            }

            if (changePasswordCheckbox) {
                if (ldapCheckbox && ldapCheckbox.checked) {
                    passwordChangeCheckboxTable.hide();
                } else {
                    passwordChangeCheckboxTable.show();
                }
            }
        }

        /* from generalSettings.jsp */
        function generalSettingsInit() {
            $("#placeholderText-index").css('font-size', '12px');
        }

        /* from mediaFolderSettings.jsp */
        function mediaFolderSettingsInit() {
            $("#missingCount").text($('#missingFiles li span').size());
        }

        /* from related.jsp */
        function relatedInit() {
            $("#artistBio").children('a').attr("target", "_blank");
        }

        /* from radio.jsp */
        function radioInit() {
            $(".radioBut").click(function() {
                var rem = 'on', add = 'off';
                if ($(this).hasClass("off")) {
                    rem = 'off', add='on';
                }
                $(this).removeClass(rem).addClass(add);
            })
        }

        /* from radio.jsp */
        function playGenreRadio() {
            var genres = new Array();
            $('span.on').each(function() {
                genres.push($(this).text());
            });
            top.playlist.sendPlaylistCommand(PLAYLIST_COMMANDS.PLAY.GENRE_RADIO, genres);
        }

        /* from genres.jsp */
        function genresInit() {
            $("#genreDesc a").attr("target", "_blank");
        }

        /* from home.jsp */
        function homeInit() {
            dwr.engine.setErrorHandler(null);
            $(".artistGenre").each(function() {
                var res = toCamelCase($(this).text())
                $(this).text(res);
            });

            $("#topLinks a").each(function() {
                if ($(this).text() === 'Starred') {
                    $(this).css('display', 'none');
                    $(this).next().css('display', 'none');
                }
            })
        }

        /* from home.jsp */
        function toCamelCase(str){
            return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
        };

        /* from home.jsp */
        function selectAll(b) {
            $(".songIndex").attr('checked', b);
        }

        /* from home.jsp */
        function getSelected() {
            var selectedSongs = [];
            $(".songIndex").each(function() {
                if ($(this).prop('checked')) {
                    selectedSongs.push($(this).next().val());
                }
                
            })
            return selectedSongs;
        }

        /* from home.jsp */
        function downloadSelected() {
            location.href = "download.view?id=" + unescape(encodeURIComponent(getSelected()));
        }

        /* from more.jsp */
        function refreshProgress() {
            transferService.getUploadInfo(updateProgress);
        }

        /* from more.jsp */
        function updateProgress(uploadInfo) {

            var progressBar = document.getElementById("progressBar");
            var progressBarContent = document.getElementById("progressBarContent");
            var progressText = document.getElementById("progressText");


            if (uploadInfo.bytesTotal > 0) {
                var percent = Math.ceil((uploadInfo.bytesUploaded / uploadInfo.bytesTotal) * 100);
                var width = parseInt(percent * 3.5) + 'px';
                progressBarContent.style.width = width;
                progressText.innerHTML = percent + "<fmt:message key="more.upload.progress"/>";
                progressBar.style.display = "block";
                progressText.style.display = "block";
                window.setTimeout("refreshProgress()", 1000);
            } else {
                progressBar.style.display = "none";
                progressText.style.display = "none";
                window.setTimeout("refreshProgress()", 5000);
            }
        }

        /* from left.jsp */
        var artistDropdown = 'All';

        /* from left.jsp */
        function leftInit() {
            dwr.engine.setErrorHandler(null);
            dwr.engine.setActiveReverseAjax(true);
            dwr.engine.setNotifyServerOnPageUnload(true);
     
            $('#tag').change(function() {
                window.location = $(this).val() + '&artistFilter=' + artistDropdown;
            });

            $(".playlistName").each(function() {
                var str = $(this).text();
                var dotIndex = str.indexOf('.');
                $(this).text(str.substring(0,dotIndex));
            }).css("display", "block");

            $("#tag option").each(function() {
                if ($(this).text() === '') {
                    $(this).text('None');
                }
            });

            var artistTimeout, 
                setLetter = getUrlVars()['artistFilter'];
                firstCall = setLetter ? true : false;

            setupArtistDropdown(setLetter);

            $("#container").mouseenter(function() {
                if (firstCall) {
                    firstCall = false;
                    return;
                }
                $(this).stop();
                if (artistTimeout) clearTimeout(artistTimeout);
                artistTimeout = setTimeout(function() {
                    $("#innerContainerMessage").css('display', 'none');
                    if ($("#innerContainer").css('display', 'none')) {
                        $("#innerContainer").fadeIn(250);
                    }
                }, 200);

            }).mouseleave(function() {
                $(this).stop();
                if (artistTimeout) clearTimeout(artistTimeout);
                artistTimeout = setTimeout(function() {
                    $("#innerContainer").fadeOut(250, function() {
                        $("#innerContainerMessage").css('display', 'block');
                    });
                }, 200);    
            });

            

            $(window).resize(resizeDiv);
            resizeDiv();
        }

        /* from left.jsp */
        function setupArtistDropdown(setLetter) {
            var alphabet = "ABCDEFGHIJKLMNOPQRSTUVW".split("");
            alphabet.push("X-Z");
            alphabet.push("#");
            var artistHtml = '<select><option>All</option>';
            for (var i = 0; i < alphabet.length; i++) {
                artistHtml += '<option>' + alphabet[i] + '</option>';
            }

            var changeFunction = function(chosen) {
                if (chosen === 'All') {
                    $(".artistLetter").css("display", 'block');
                }
                else {
                    artistDropdown = chosen;
                    $(".artistLetter").css("display", 'none');
                    $(document.getElementById("artistLetter" + chosen)).css("display", "block");
                }
            }

            $("#artistDropdown").html(artistHtml + '</select>').change(function() {
                changeFunction($('option:selected', this).text());
            });

            $("#artistDropdown select").width($("#artistDropdown select").width() + 10);

            if (setLetter) {
                $("#innerContainerMessage").css('display', 'none');
                $("#innerContainer").css('display', 'block');
                $("#artistDropdown option").each(function() {
                    if ($(this).text() === setLetter) {
                        $(this).prop('selected', true);
                        changeFunction(setLetter);

                    }
                });
            }

        }

        /* from left.jsp */
        function getUrlVars() {
            var vars = {};
            var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
                vars[key] = value;
            });
            return vars;
        }

        /* from left.jsp */
        function resizeDiv() {
            var heightDiff = $("#container").height() - $("#innerContainerTop").height();
            $("#innerDivWrapper").height(heightDiff -20);
        }

        /* from gettingStarted.jsp */
        function hideGettingStarted() {
            alert("<fmt:message key="gettingStarted.hidealert"/>");
            location.href = "gettingStarted.view?hide";
        }

        /* from podcastReceiver.jsp */
        var channelCount = ${fn:length(model.channels)};

        /* from podcastReceiver.jsp */
        function downloadSelected() {
            location.href = "podcastReceiverAdmin.view?downloadChannel=" + getSelectedChannels() +
                            "&downloadEpisode=" + getSelectedEpisodes() +
                            "&expandedChannels=" + getExpandedChannels();
        }

        /* from podcastReceiver.jsp */
        function deleteSelected() {
            if (confirm("<fmt:message key="podcastreceiver.confirmdelete"/>")) {
                location.href = "podcastReceiverAdmin.view?deleteChannel=" + getSelectedChannels() +
                "&deleteEpisode=" + getSelectedEpisodes() +
                "&expandedChannels=" + getExpandedChannels();
            }
        }

        /* from podcastReceiver.jsp */
        function refreshChannels() {
            location.href = "podcastReceiverAdmin.view?refresh=" +
                            "&expandedChannels=" + getExpandedChannels();
        }

        /* from podcastReceiver.jsp */
        function refreshPage() {
            location.href = "podcastReceiver.view?expandedChannels=" + getExpandedChannels();
        }

        /* from podcastReceiver.jsp */
        function toggleEpisodes(channelIndex) {
            for (var i = 0; i < episodeCount; i++) {
                var row = $("episodeRow" + i);
                if (row.title == "channel" + channelIndex) {
                    row.toggle();
                    $("channelExpanded" + channelIndex).checked = row.visible() ? "checked" : "";
                }
            }
        }

        /* from podcastReceiver.jsp */
        function toggleAllEpisodes(visible) {
            for (var i = 0; i < episodeCount; i++) {
                var row = $("episodeRow" + i);
                if (visible) {
                    row.show();
                } else {
                    row.hide();
                }
            }
            for (i = 0; i < channelCount; i++) {
                $("channelExpanded" + i).checked = visible ? "checked" : "";
            }
        }

        /* from podcastReceiver.jsp */
        function getExpandedChannels() {
            var result = "";
            for (var i = 0; i < channelCount; i++) {
                var checkbox = $("channelExpanded" + i);
                if (checkbox.checked) {
                    result += (checkbox.value + " ");
                }
            }
            return result;
        }

        /* from podcastReceiver.jsp */
        function getSelectedChannels() {
            var result = "";
            for (var i = 0; i < channelCount; i++) {
                var checkbox = $("channel" + i);
                if (checkbox.checked) {
                    result += (checkbox.value + " ");
                }
            }
            return result;
        }

        /* from podcastReceiver.jsp */
        function getSelectedEpisodes() {
            var result = "";
            for (var i = 0; i < episodeCount; i++) {
                var checkbox = $("episode" + i);
                if (checkbox.checked) {
                    result += (checkbox.value + " ");
                }
            }
            return result;
        }

        /* from groupSetings.jsp */
        function groupSettingsInit() {
            $("#add").click(function() {
                add('');
            });

            <c:forEach items="${model.lastFmGroups}" var="group">
                add('${group.name}');
            </c:forEach>

            add('');

            $("#save").click(function() {
                location.href = '?' + ($(this).parent().serialize());
            });
        }

        /* from groupSetings.jsp */
        function add(group) {
            $("#inp").append('<span style="display: block"><img class="rem" src="<spring:theme code="removeImage"/>" alt="Remove"><input name="group" type="text" value="' + group + '" size="50"></span>');

            $(".rem").click(function() {
                $(this).parent().remove();
            });
        }

        /* from missingAlbums.jsp */
        function search(page) {
            $('#albums').load('missingAlbumsSearch.view?page=' + page + '&' + $('form').serialize());
            window.scrollTo(0, 0);
        }

        /* from rightInit.jsp */
        function rightInit() {
            setupZoom('<c:url value="/"/>');
            dwr.engine.setErrorHandler(null);
            <c:if test="${model.showChat}">
                chatService.addMessage(null);
            </c:if>
        }

        /* from right.jsp */
        startGetNowPlayingTimer();

        /* from right.jsp */
        function startGetNowPlayingTimer() {
            nowPlayingService.getNowPlaying(getNowPlayingCallback);
            setTimeout("startGetNowPlayingTimer()", 10000);
        }

        /* from right.jsp */
        function getNowPlayingCallback(nowPlaying) {
            var html = nowPlaying.length == 0 ? "" : "<h2><fmt:message key="main.nowplaying"/></h2><table>";
            for (var i = 0; i < nowPlaying.length; i++) {
                html += "<tr><td colspan='2' class='detail' style='padding-top:1em;white-space:nowrap'>";

                if (nowPlaying[i].avatarUrl != null) {
                    html += "<img src='" + nowPlaying[i].avatarUrl + "' style='padding-right:5pt'>";
                }
                html += "<b>" + nowPlaying[i].username + "</b></td></tr>"

                html += "<tr><td class='detail' style='padding-right:1em'>" +
                        "<a title='" + nowPlaying[i].tooltip + "' target='main' href='" + nowPlaying[i].albumUrl + "'><em>" +
                        nowPlaying[i].artist + "</em><br/>" + nowPlaying[i].title + "</a>";
                
                if (nowPlaying[i].lyricsUrl != null) {
                    html += "<br/><span class='forward'><a href='" + nowPlaying[i].lyricsUrl + "' onclick=\"return popupSize(this, 'lyrics', 500, 550)\">" +
                            "<fmt:message key="main.lyrics"/>" + "</a></span>";
                }
                html += "</td><td style='padding-top:1em'>";

                if (nowPlaying[i].coverArtUrl != null) {
                    html += "<a rel='zoom' href='" + nowPlaying[i].coverArtZoomUrl + "'>" +
                            "<img src='" + nowPlaying[i].coverArtUrl + "' width='64' height='64'></a>";
                }
                html += "</td></tr>";

                var minutesAgo = nowPlaying[i].minutesAgo;
                if (minutesAgo > 4) {
                    html += "<tr><td class='detail' colspan='2'>" + minutesAgo + " <fmt:message key="main.minutesago"/></td></tr>";
                }
            }
            html += "</table>";
            $('nowPlaying').innerHTML = html;
            prepZooms();
        }

        /* from right.jsp */
        var revision = 0;
        startGetMessagesTimer();

        /* from right.jsp */
        function startGetMessagesTimer() {
            chatService.getMessages(revision, getMessagesCallback);
            setTimeout("startGetMessagesTimer()", 10000);
        }

        /* from right.jsp */
        function addMessage() {
            chatService.addMessage($("message").value);
            dwr.util.setValue("message", null);
            setTimeout("startGetMessagesTimer()", 500);
        }

        /* from right.jsp */
        function clearMessages() {
            chatService.clearMessages();
            setTimeout("startGetMessagesTimer()", 500);
        }

        /* from right.jsp */
        function getMessagesCallback(messages) {

            if (messages == null) {
                return;
            }
            revision = messages.revision;

            // Delete all the rows except for the "pattern" row
            dwr.util.removeAllRows("chatlog", { filter:function(div) {
                return (div.id != "pattern");
            }});

            // Create a new set cloned from the pattern row
            for (var i = 0; i < messages.messages.length; i++) {
                var message = messages.messages[i];
                var id = i + 1;
                dwr.util.cloneNode("pattern", { idSuffix:id });
                dwr.util.setValue("user" + id, message.username);
                dwr.util.setValue("date" + id, " [" + formatDate(message.date) + "]");
                dwr.util.setValue("content" + id, message.content);
                $("pattern" + id).show();
            }

            var clearDiv = $("clearDiv");
            if (clearDiv) {
                if (messages.messages.length == 0) {
                    clearDiv.hide();
                } else {
                    clearDiv.show();
                }
            }
        }

        /* from right.jsp */
        function formatDate(date) {
            var hours = date.getHours();
            var minutes = date.getMinutes();
            var result = hours < 10 ? "0" : "";
            result += hours;
            result += ":";
            if (minutes < 10) {
                result += "0";
            }
            result += minutes;
            return result;
        }

        /* from loadPlaylist.jsp */
        function deletePlaylist(deleteUrl) {
            if (confirm("<fmt:message key="playlist.load.confirm_delete"/>")) {
                location.href = deleteUrl;
            }
        }

        /* from tagSettings.jsp */
        function toggleCheckbox(h) {
            $('tagSettings').getInputs('checkbox').each(function(e) { if (e.name != 'toggle') e.checked = h });
        }

        /* from networkSettings.jsp */
        function initNetworkSettings() {
            enableUrlRedirectionFields();
            refreshStatus();
        }

        /* from networkSettings.jsp */
        function refreshStatus() {
            multiService.getNetworkStatus(updateStatus);
        }

        /* from networkSettings.jsp */
        function updateStatus(networkStatus) {
            dwr.util.setValue("portForwardingStatus", networkStatus.portForwardingStatusText);
            dwr.util.setValue("urlRedirectionStatus", networkStatus.urlRedirectionStatusText);
            window.setTimeout("refreshStatus()", 1000);
        }

        /* from networkSettings.jsp */
        function enableUrlRedirectionFields() {
            var checkbox = $("urlRedirectionEnabled");
            var field = $("urlRedirectFrom");

            if (checkbox && checkbox.checked) {
                field.enable();
            } else {
                field.disable();
            }
        }

        /* from videoPlayer.jsp */
        var player;
        var position;
        var maxBitRate = ${model.maxBitRate};
        var timeOffset = ${model.timeOffset};

        /* from videoPlayer.jsp */
        function videoPlayerInit() {

            var flashvars = {
                id:"player1",
                skin:"<c:url value="/flash/whotube.zip"/>",
                screencolor:"000000",
                controlbar:"over",
                autostart:"false",
                bufferlength:3,
                backcolor:"<spring:theme code="backgroundColor"/>",
                frontcolor:"<spring:theme code="textColor"/>",
                provider:"video"
            };
            var params = {
                allowfullscreen:"true",
                allowscriptaccess:"always"
            };
            var attributes = {
                id:"player1",
                name:"player1"
            };

            var width = "${model.popout ? '100%' : '600'}";
            var height = "${model.popout ? '85%' : '360'}";
            swfobject.embedSWF("<c:url value="/flash/jw-player-5.10.swf"/>", "placeholder1", width, height, "9.0.0", false, flashvars, params, attributes);
        }

        /* from videoPlayer.jsp */
        function playerReady(thePlayer) {
            player = $("player1");
            player.addModelListener("TIME", "timeListener");

            play();
        }

        /* from videoPlayer.jsp */
        function play() {
            var list = new Array();
            list[0] = {
                file:"${streamUrl}&maxBitRate=" + maxBitRate + "&timeOffset=" + timeOffset + "&player=${model.player}",
                duration:${model.duration} - timeOffset,
                provider:"video"
            };
            player.sendEvent("LOAD", list);
            player.sendEvent("PLAY");
        }

        /* from videoPlayer.jsp */
        function timeListener(obj) {
            var newPosition = Math.round(obj.position);
            if (newPosition != position) {
                position = newPosition;
                updatePosition();
            }
        }

        /* from videoPlayer.jsp */
        function updatePosition() {
            var pos = getPosition();

            var minutes = Math.round(pos / 60);
            var seconds = pos % 60;

            var result = minutes + ":";
            if (seconds < 10) {
                result += "0";
            }
            result += seconds;
            $("position").innerHTML = result;
        }

        /* from videoPlayer.jsp */
        function changeTimeOffset() {
            timeOffset = $("timeOffset").getValue();
            play();
        }

        /* from videoPlayer.jsp */
        function changeBitRate() {
            maxBitRate = $("maxBitRate").getValue();
            timeOffset = getPosition();
            play();
        }

        /* from videoPlayer.jsp */
        function popout() {
            var url = "${baseUrl}&maxBitRate=" + maxBitRate + "&timeOffset=" + getPosition() + "&popout=true";
            popupSize(url, "video", 600, 400);
            window.location.href = "${backUrl}";
        }

        /* from videoPlayer.jsp */
        function popin() {
            window.close();
        }

        /* from videoPlayer.jsp */
        function getPosition() {
            return parseInt(timeOffset) + parseInt(position);
        }


    </script>

</head>

<body>

<div id="top">
    <jsp:include page="top.jsp"/>
</div>
<div id="left"></div>

<div id="mainTabs">
<!--     <ul style="display: none">
        <li><a href="#mainTabs-1"></a></li>
        <li><a href="#mainTabs-2"></a></li>
        <li><a href="#mainTabs-3"></a></li>
        <li><a href="#mainTabs-4"></a></li>
        <li><a href="#mainTabs-5"></a></li>
        <li><a href="#mainTabs-6"></a></li>
        <li><a href="#mainTabs-7"></a></li>
        <li><a href="#mainTabs-8"></a></li>
    </ul>
    <div id="mainTabs-1">
        
    </div>
    <div id="mainTabs-2">
        <div id="findFriends">
            <div id="friendsSearchTabs">
                <ul id="friendsSearchTabsHeading" class="hiddenTabs">
                    <li><a href="#friendsSearchTabs-1"></a></li>
                    <li><a href="#friendsSearchTabs-2"></a></li>
                    <li><a href="#friendsSearchTabs-3"></a></li>
                    <li><a href="#friendsSearchTabs-4"></a></li>
                </ul>
                <div id="friendsSearchTabs-1"></div>
                <div id="friendsSearchTabs-2"></div>
                <div id="friendsSearchTabs-3">
                    <div id="facebookFriendsSuccess"></div>
                    <div id="facebookFriendSelector">
                        <fb:serverfbml>  
                            <script type="text/fbml">
                                <fb:fbml>  
                                    <fb:request-form action="http://hangchillparty.com/index.php?fb=1" method="post" invite="true" type="Hangchillparty" content="Hangchillparty is cool.  I&#039;m using it.  Check it out.  &amp;lt;fb:req-choice url=&amp;quot;http://hangchillparty.com/index&amp;quot; label=&amp;quot;Check out the site&amp;quot; /&amp;gt;" >  
                                        <fb:multi-friend-selector actiontext="Let other cool people know about Hangchillparty." showborder="true" rows="5" cols="3" email_invite="false" bypass="false" />
                                    </fb:request-form>  
                                </fb:fbml>  
                            </script>  
                        </fb:serverfbml>
                    </div>
                </div>
                <div id="friendsSearchTabs-4"></div>
             </div>
        </div>
    </div>
    <div id="mainTabs-3"></div>
    <div id="mainTabs-4"></div>
    <div id="mainTabs-5"></div>
    <div id="mainTabs-6"></div>
    <div id="mainTabs-7"></div>
    <div id="mainTabs-8"></div> -->
</div> 

<div id="right"></div>

<!-- <frameset rows="70,*,0" border="0" framespacing="0" frameborder="0">
    <frame name="upper" src="top.view?">
    <frameset cols="250,100%" border="0" framespacing="0" frameborder="0">
        <frame name="left" src="left.view?" marginwidth="0" marginheight="0">

        <frameset rows="70%,30%" border="0" framespacing="0" frameborder="0">
            <frameset cols="*,${model.showRight ? 250 : 0}" border="0" framespacing="0" frameborder="0">
                <frame name="main" src="nowPlaying.view?" marginwidth="0" marginheight="0">
                <frame name="right" src="right.view?">
            </frameset>
            <frame name="playlist" src="playlist.view?">
        </frameset>
    </frameset>
    <frame name="hidden" frameborder="0" noresize="noresize">

</frameset> -->

</body></html>