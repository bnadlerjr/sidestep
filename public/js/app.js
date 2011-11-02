$(document).ready(function () {
    function loadData(url, template, domTarget) {
        $.getJSON(url, function(data) {
            $(template).tmpl(data).appendTo(domTarget);
        });
    }

    loadData("/routes", "#route-template", "#routes ul:first");

    $("#stations").bind("pageAnimationEnd", function (e, info) {
        var route_id, url;
        if ("out" === info.direction) {
            return null;
        }

        route_id = $(this).data("referrer")[0].id;
        url = "/" + ["routes", route_id, "stops"].join("/");
        loadData(url, "#station-template", "#stations ul:first");
    });

    $("#departures").bind("pageAnimationEnd", function (e, info) {
        var ids, route_id, stop_id, url;
        if ("out" === info.direction) {
            return null;
        }

        ids = $(this).data("referrer")[0].id.split("_");
        route_id = ids[0], stop_id = ids[1];
        url = "/" + ["routes", route_id, "stops", stop_id, "departures"].join("/");

        loadData(url, "#departure-template", "#departures ul:first");
    });

    $.jQTouch();
});
