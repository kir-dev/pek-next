var listing = (function() {
    var module = {};

    module.init = function() {
        $('.list').on('click', function () {
            $('#active_users > .uk-width-1-1').removeClass('uk-width-medium-1-3');
            $('#inactive_users > .uk-width-1-1').removeClass('uk-width-medium-1-3');
            $('#archived_users > .uk-width-1-1').removeClass('uk-width-medium-1-3');
            UIkit.grid('#inactive_users').init();
            UIkit.grid('#active_users').init();
            UIkit.grid('#archived_users').init();
        });

        $('.grid').on('click', function () {
            $('#active_users > .uk-width-1-1').addClass('uk-width-medium-1-3');
            $('#inactive_users > .uk-width-1-1').addClass('uk-width-medium-1-3');
            $('#archived_users > .uk-width-1-1').addClass('uk-width-medium-1-3');
            UIkit.grid('#inactive_users').init();
            UIkit.grid('#active_users').init();
            UIkit.grid('#archived_users').init();
        });

        $('#membership-tab').on('click', function () {
            UIkit.grid('#inactive_users').init();
            UIkit.grid('#active_users').init();
            UIkit.grid('#archived_users').init();
        });
    };

    return module;
}(Helpers, Rx, jQuery));
$(document).ready(listing.init);
