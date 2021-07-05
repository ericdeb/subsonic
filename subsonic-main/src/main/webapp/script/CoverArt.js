
var MainController = (function() {

    var instance = null;

    var constructor = function() {

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