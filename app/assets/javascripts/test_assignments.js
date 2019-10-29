document.addEventListener('DOMContentLoaded', function(){
    (function () {
        // Enabled tabs
        $('.menu .item').tab();

        // Enabled cool checkboxes;
        $('.ui.checkbox').checkbox();
    }());

    $('.message .close')
        .on('click', function() {
            $(this)
                .closest('.message')
                .transition('fade')
            ;
        })
    ;
}, false);
