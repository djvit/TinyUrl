// TinyUrl class definition
function TinyUrl(){
};

// Public Namespace
TinyUrl.prototype = {

    logged_in: false,
    access_token: '',

    // Initialize component
    // Login - session functions, very simple but not very secure.
    // Additional server-side validations are present to ensure security
    init: function() {
        var access_token = $.queryParam('at');
        if ((access_token) && (access_token.length > 0)) {
            this.access_token = access_token;
            this.logged_in = true;
        }

        this.updateState();
    },

    updateState: function() {
        var _this = this;
        if (this.logged_in) {
            $('.lnk_noauth').hide();
            $('.lnk_auth').show();

            $('.lnk_auth').each(function() {
                var el = $(this);
                if ((el.attr('href') != '#') && (el.attr('href').length > 0)) {
                    el.attr("href", el.attr("href") + '?at=' + _this.access_token);
                }
            });
        }
        else {
            $('.lnk_noauth').show();
            $('.lnk_auth').hide();
        }
    },

    // Methods
    signUp: function(form) {
        var _this = this;
        $.ajax({
            url: '/users',
            type: 'POST',
            dataType: 'json',
            data: $(form).serializeObject(),
            success: function(data, status, response) {
                // Notify user
                _this.show_result("Created account for " + data.email + " with ID: " + data.id);

                // Redirect to signup
                window.location.href = '/sessions'
            },
            error: function(response, status, error) {
                // Notify user about error
                return _this.show_result(response.responseJSON.message);
            }
        });
    },

    signIn: function(form) {
        var _this = this;
        $.ajax({
            url: '/sessions',
            type: 'POST',
            dataType: 'json',
            data: $(form).serializeObject(),
            success: function(data, status, response) {
                // Notify user
                _this.show_result("User " + data.email + " successfully signed in");

                if ((data.access_token) && (data.access_token.length > 0)) {
                    // Save sessions info
                    _this.access_token = data.access_token;
                    _this.logged_in = true;

                    // Redirect to URL Shortener
                    window.location.href = '/urls?at=' + _this.access_token;
                }
                else {
                    _this.show_result("Login failed, please try again later");
                }
            },
            error: function(response, status, error) {
                // Notify user about error
                return _this.show_result(response.responseJSON.message);
            }
        });
    },

    signOut: function() {
        var _this = this;
        $.ajax({
            url: '/sessions',
            type: 'DELETE',
            dataType: 'json',
            headers: {
                'Access-Token': _this.access_token
            },
            success: function(data, status, response) {
                // Log user out
                _this.access_token = null;
                _this.logged_in = false;

                _this.show_result('You were successfully signed out');

                // Redirect to URL Shortener
                window.location.href = '/sessions';
            },
            error: function(response, status, error) {
                // Notify user about error
                return _this.show_result(response.responseJSON.message);
            }
        });
    },

    addUrl: function(form) {
        var _this = this;
        $.ajax({
            url: '/urls',
            type: 'POST',
            dataType: 'json',
            data: $(form).serializeObject(),
            headers: {
                'Access-Token': _this.access_token
            },
            success: function(data, status, response) {
                var host = 'http://' + window.location.hostname + ':' + window.location.port;
                var path = host + $(form).find('input#url').val();
                var tiny_path = host + '/' + data.tiny_path;
                $(form).find('input#url').val('');

                // Notify user
                _this.show_result('Shortened ' + path + ' into ' + tiny_path);
                $('#btn_add_url').text('Add new URL');
                $('#tiny_url_result').removeClass('hidden');
                $('#lnk_url_result').text(tiny_path);
                $('#lnk_url_result').attr('href', tiny_path);

            },
            error: function(response, status, error) {
                // Notify user about error
                return _this.show_result(response.responseJSON.message);
            }
        });
    },

    // Sesialize form data into JSON
    serializeObject: function(frm) {
        var arrayData, objectData;
        arrayData = frm.serializeArray();
        objectData = {};
        $.each(arrayData, function() {
            var value;
            if (this.value != null) {
                value = this.value;
            } else {
                value = '';
            }
            if (objectData[this.name] != null) {
                if (!objectData[this.name].push) {
                    objectData[this.name] = [objectData[this.name]];
                }
                return objectData[this.name].push(value);
            } else {
                return objectData[this.name] = value;
            }
        });
        return objectData;
    },

    show_result: function(message) {
        alert(message);
    }
}
