// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('DOMContentLoaded', function(){
    (function () {
        $('#add-student').click(function() {
            // clone the previous student input box in the form
            var newStudent = $.clone($("#new-student-container").last()[0]);
            // increment its position in the student list and clear the name from the input
            $(newStudent).data('position', $(newStudent).data('position') + 1);
            $(newStudent).find("input").val('');

            // set the name of the input fields so Rails knows which students the names belong to
            $($(newStudent).find("input")[0]).attr("name", "students[" + $(newStudent).data('position') + "][first_name]");
            $($(newStudent).find("input")[1]).attr("name", "students[" + $(newStudent).data('position') + "][last_name]");

            // ensure new student fields aren't disabled
            $(newStudent).find(".disabled.input").removeClass('disabled');

            // append the new student field to the form
            $("#new-students-container").append(newStudent);
        });
    }());
}, false);
