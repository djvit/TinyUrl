// Document ready
jQuery(document).ready(function($) {
    // Initialize component
    var tiny_url = new TinyUrl();
    tiny_url.init();

    // Bind events
    $('#btn_sign_up').click(function(evt) {
        tiny_url.signUp($('form'));
        return false;
    }),

    $('#btn_sign_in').click(function(evt) {
        tiny_url.signIn($('form'));
        return false;
    }),

    $('#btn_sign_out').click(function(evt) {
        tiny_url.signOut($('form'));
        return false;
    }),

    $('#btn_add_url').click(function(evt) {
        tiny_url.addUrl($('form'));
        return false;
    })
})