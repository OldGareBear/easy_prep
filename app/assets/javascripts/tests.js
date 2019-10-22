document.addEventListener('DOMContentLoaded', function(){
    (function () {
        window._easy_prep_number_of_questions = 0;

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

            // increment question count
            window._easy_prep_number_of_questions = window._easy_prep_number_of_questions + 1;

            // set question input names based on number of questions
            var newDescription = 'question[' + window._easy_prep_number_of_questions + '][description]';
            $(question).find('#question_description').prop('name', newDescription);

            // clear inputs
            var modalTabs = $('.ui.bottom.attached.tab');
            modalTabs.find('input').val('');
            modalTabs.find('textarea').val('');
            modalTabs.find('.ui.toggle.checkbox.checked').removeClass('checked');
            $('.ui.toggle.checkbox.checked').find('input').prop('checked', false)
        });
    }());
}, false);
