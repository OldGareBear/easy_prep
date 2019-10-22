document.addEventListener('DOMContentLoaded', function(){
    (function () {
        $('#add-question').click(function() {
            $('.ui.modal').modal('show');
        });

        $('#save-question').click(function () {
            // copy question to test
            var question = $('.ui.bottom.attached.tab.segment.active').find('.question.ui.container')[0];
            var clone = $.clone(question);
            $(clone).addClass('segment');
            $(clone).addClass('item');
            $('#questions-container').append(clone);
            $('.ui.modal').modal('hide');

            // clear inputs
            var modalTabs = $('.ui.bottom.attached.tab');
            modalTabs.find('input').val('');
            modalTabs.find('textarea').val('');
        });
    }());
}, false);
