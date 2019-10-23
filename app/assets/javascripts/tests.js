document.addEventListener('DOMContentLoaded', function(){
    (function () {
        window._easy_prep_question_number = 0;

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
            window._easy_prep_question_number = window._easy_prep_question_number + 1;

            // set question input names based on number of questions
            var newDescription = 'question[' + window._easy_prep_question_number + '][description]';
            var modalContainer = $('ui.bottom.attached.tab.segment');
            modalContainer.find('#question_description').prop('name', newDescription);
            var previousQuestion = window._easy_prep_question_number - 1;
            var a = modalContainer.find("input[name='question[" + previousQuestion + "][answer_option][0]']");
            var b = modalContainer.find("input[name='question[" + previousQuestion + "][answer_option][1]']");
            var c = modalContainer.find("input[name='question[" + previousQuestion + "][answer_option][2]']");
            var d = modalContainer.find("input[name='question[" + previousQuestion + "][answer_option][3]']");
            a.prop('name', 'question[' + window._easy_prep_question_number + '][answer_option][0]');
            b.prop('name', 'question[' + window._easy_prep_question_number + '][answer_option][1]');
            c.prop('name', 'question[' + window._easy_prep_question_number + '][answer_option][2]');
            d.prop('name', 'question[' + window._easy_prep_question_number + '][answer_option][3]');

            // clear inputs
            var modalTabs = $('.ui.bottom.attached.tab');
            modalTabs.find('input').val('');
            modalTabs.find('textarea').val('');
            modalTabs.find('.ui.toggle.checkbox.checked').removeClass('checked');
            $('.ui.toggle.checkbox').find('input').prop('checked', false)
        });
    }());
}, false);
