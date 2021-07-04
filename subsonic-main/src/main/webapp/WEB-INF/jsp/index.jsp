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


        function setupToolTip(id) {
            if ($("#toolTipImage-" + id)) {
                $("#toolTipImage-" + id).popover({
                    html: true,
                    content: $("#placeholderText-" + id),
                    title: $("#placeholderTitle-" + id),
                    trigger: 'hover'
                })
            }
        }

        function noop() {
        }

        function popup(mylink, windowname) {
            return popupSize(mylink, windowname, 400, 200);
        }

        function popupSize(mylink, windowname, width, height) {
            var href;
            if (typeof(mylink) == "string") {
                href = mylink;
            } else {
                href = mylink.href;
            }

            var w = window.open(href, windowname, "width=" + width + ",height=" + height + ",scrollbars=yes,resizable=yes");
            w.focus();
            w.moveTo(300, 200);
            return false;
        }

        var url = 'top.view',
            domId = 'topMain';


        var handleUpdate = function(url, tab) {
            $.ajax({
              url: url,
              success: function(data) {
                $("#" + domId).html(data);
                debugger;
              },
              error: function(error) {
                throw 'Top Controller could not be reloaded ' + error;
              }
            });
        };



        /* from related.jsp */
        function relatedInit() {
            $("#artistBio").children('a').attr("target", "_blank");
        }

        /* from genres.jsp */
        function genresInit() {
            $("#genreDesc a").attr("target", "_blank");
        }


        /* from missingAlbums.jsp */
        function search(page) {
            $('#albums').load('missingAlbumsSearch.view?page=' + page + '&' + $('form').serialize());
            window.scrollTo(0, 0);
        }

        /* from loadPlaylist.jsp */
        function deletePlaylist(deleteUrl) {
            if (confirm("<fmt:message key="playlist.load.confirm_delete"/>")) {
                location.href = deleteUrl;
            }
        }


    </script>

</head>

<body>

<div id="top"></div>
<div id="left"></div>

<div id="main">
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