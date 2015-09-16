// jQuery extension function
// Retrieve request query value
$.queryParam = function(name) {
    var url = window.location.href;

    var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(url);
    if (!results) {
        return undefined;
    }
    return results[1] || undefined;
};
