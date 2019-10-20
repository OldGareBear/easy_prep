document.addEventListener('DOMContentLoaded', function(){
    (function () {
        $('.menu .item').tab();

        $('#add-question').click(function() {
            $('.ui.modal').modal('show');
        });
    }());
}, false);
