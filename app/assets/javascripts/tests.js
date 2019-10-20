document.addEventListener('DOMContentLoaded', function(){
    (function () {
        // Enabled tabs
        $('.menu .item').tab();

        // Enabled cool checkboxes;
        $('.ui.checkbox').checkbox();

        $('#add-question').click(function() {
            $('.ui.modal').modal('show');
        });
    }());
}, false);
