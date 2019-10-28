document.addEventListener('DOMContentLoaded', function(){
    (function () {
        window._easy_prep_question_number = 0;

        $('#add-question').click(function() {
            $('.ui.modal').modal('show');

            // TODO: after we press "save question," these values are getting wiped; find out why and removed
            // this hack
            var modalContainer = $('.ui.bottom.attached.tab.segment');

            var questionTypes = modalContainer.find('.question_type');
            $(questionTypes[0]).prop('value', 'multiple choice');
            $(questionTypes[1]).prop('value', 'short response');
            $(questionTypes[2]).prop('value', 'extended response');

            var checkboxName = 'question[' + window._easy_prep_question_number + '][correct_answer_options][]';
            var checkboxes = modalContainer.find("input[name='" + checkboxName  + "']");
            $(checkboxes[0]).prop('value', '0');
            $(checkboxes[1]).prop('value', '1');
            $(checkboxes[2]).prop('value', '2');
            $(checkboxes[3]).prop('value', '3');
        });

        $('#save-question').click(function () {
            // copy question to test
            var question = $('.ui.bottom.attached.tab.segment.active').find('.question.ui.container')[0];
            var clone = $.clone(question);
            var questionForm = $(clone).find(".ui.form.small");
            questionForm.prop('style', "padding: 10px");
            $(clone).addClass('segment');
            $(clone).addClass('item');
            $('#questions-container').append(clone);
            $('.ui.modal').modal('hide');

            // increment question count
            window._easy_prep_question_number = window._easy_prep_question_number + 1;

            // set question input names based on number of questions

                // description and type
            var newDescription = 'question[' + window._easy_prep_question_number + '][description]';
            var newType = 'question[' + window._easy_prep_question_number + '][type]';
            var newSkill = 'question[' + window._easy_prep_question_number + '][skill]';
            var modalContainer = $('.ui.bottom.attached.tab.segment');
            modalContainer.find('#question_description').prop('name', newDescription);
            var questionTypes = modalContainer.find('.question_type');
            questionTypes.prop('name', newType);
            modalContainer.find('.prompt').prop('name', newSkill);

                // answer options
            var previousQuestion = window._easy_prep_question_number - 1;
            var a = modalContainer.find("input[name='question[" + previousQuestion + "][answer_option][0]']");
            var b = modalContainer.find("input[name='question[" + previousQuestion + "][answer_option][1]']");
            var c = modalContainer.find("input[name='question[" + previousQuestion + "][answer_option][2]']");
            var d = modalContainer.find("input[name='question[" + previousQuestion + "][answer_option][3]']");
            a.prop('name', 'question[' + window._easy_prep_question_number + '][answer_option][0]');
            b.prop('name', 'question[' + window._easy_prep_question_number + '][answer_option][1]');
            c.prop('name', 'question[' + window._easy_prep_question_number + '][answer_option][2]');
            d.prop('name', 'question[' + window._easy_prep_question_number + '][answer_option][3]');

                // checkboxes
            var oldCheckboxName = 'question[' + previousQuestion + '][correct_answer_options][]';
            var checkboxes = modalContainer.find("input[name='" + oldCheckboxName  + "']");
            var newCheckboxName = 'question[' + window._easy_prep_question_number + '][correct_answer_options][]';
            checkboxes.prop('name', newCheckboxName);

            // clear inputs
            var modalTabs = $('.ui.bottom.attached.tab');
            modalTabs.find('input').val('');
            modalTabs.find('textarea').val('');
            modalTabs.find('.ui.toggle.checkbox.checked').removeClass('checked');
            modalTabs.find('.ui.toggle.checkbox').find('input').prop('checked', false);
            var searchIcon = modalTabs.find('.green.check.icon');
            searchIcon.addClass('search');
            searchIcon.removeClass('check');
            searchIcon.removeClass('green');
        });

        $('.ui.search')
            .search({
                apiSettings: {
                    url: '/api/v1/skills?search_query={query}'
                },
                fields: {
                    title: 'name',
                    description: 'oid'
                },
                minCharacters : 2,
                onSelect: function(result, response) {
                    var searchIcon = $('.search.icon');
                    searchIcon.removeClass('search');
                    searchIcon.addClass('check');
                    searchIcon.addClass('green');
                }
            })
        ;
    }());
}, false);
