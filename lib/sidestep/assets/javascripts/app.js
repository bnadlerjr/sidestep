//= require jquery-1.4.2.min
//= require jqtouch
//= require jquery.tmpl.min
$(document).ready(function () {
    var urlMap = {
        "stations": function (routeId) {
            return "/routes/".concat(routeId, "/stops");
        },
        "departures": function (routeAndStopIds) {
            var ids = routeAndStopIds.split("_");
            return "/routes/".concat(ids[0], "/stops/", ids[1], "/departures");
        },
        "stops": function (tripAndStopIds) {
            var ids = tripAndStopIds.split("_");
            return "/trips/".concat(ids[0], "/stops/", ids[1], "/remaining");
        }
    };

    function loadData(url, target) {
        var template  = "#" + target + "-template",
            domTarget = "#" + target + " ul li";

        $.getJSON(url, function(data) {
            $(domTarget).replaceWith($(template).tmpl(data));
        });
    }

    function loadPanel(e, info) {
        if ("out" === info.direction) { return null; }
        var url = urlMap[this.id]($(this).data("referrer")[0].id);
        loadData(url, this.id);
    }

    loadData("/routes", "routes");
    $("#stations").bind("pageAnimationEnd", loadPanel);
    $("#departures").bind("pageAnimationEnd", loadPanel);
    $("#stops").bind("pageAnimationEnd", loadPanel);
    $.jQTouch();
});
