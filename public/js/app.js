$(document).ready(function () {
    function loadData(url, template, domTarget) {
        $.getJSON(url, function(data) {
            $(template).tmpl(data).appendTo(domTarget);
        });
    }

    loadData("/routes", "#route-template", "#routes ul:first");

    $("#stations").bind("pageAnimationEnd", function (e, info) {
        var route_id
        if ("out" === info.direction) {
            return null;
        }

        route_id = $(this).data("referrer")[0].id;
        loadData("/routes/" + route_id + "/stops", "#station-template", "#stations ul:first");
    });

    $.jQTouch();
});
