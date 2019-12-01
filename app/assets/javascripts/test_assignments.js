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

    // Master checkboxes
    $('.list .master.checkbox')
        .checkbox({
            // check all children
            onChecked: function() {
                var
                    $childCheckbox  = $(this).closest('.checkbox').siblings('.list').find('.checkbox')
                ;
                $childCheckbox.checkbox('check');

                // var pointLevel = $(this).closest('.checkbox').data('point-level');
                // if (pointLevel) {
                //     pointLevel = parseInt(pointLevel);
                //     for (var i = 0; i < pointLevel; i++ ) {
                //         var $inferiorCheckbox = $("[data-point-level='" + i + "']");
                //         $inferiorCheckbox.checkbox('check');
                //     }
                // }

                var pointLevel = parseInt($(this).closest('.checkbox').data('point-level'));
                if (pointLevel || pointLevel === 0) {
                    var currentPoint = 0;
                    var highestPointFound = false;
                    while (!highestPointFound) {
                        var $superiorCheckbox = $("[data-point-level='" + currentPoint + "']");
                        if ($superiorCheckbox.length) {
                            if (!(currentPoint == pointLevel)) {
                                $superiorCheckbox.checkbox('set unchecked');
                            }
                            currentPoint++;
                        } else {
                            highestPointFound = true;
                        }
                    }
                }
            },
            // uncheck all children
            onUnchecked: function() {
                var
                    $childCheckbox  = $(this).closest('.checkbox').siblings('.list').find('.checkbox')
                ;
                $childCheckbox.checkbox('set unchecked');

                // var pointLevel = $(this).closest('.checkbox').data('point-level');
                // if (pointLevel || pointLevel === 0) {
                //     pointLevel = parseInt(pointLevel);
                //     var highestPointFound = false;
                //     while (!highestPointFound) {
                //         var $superiorCheckbox = $("[data-point-level='" + pointLevel + "']");
                //         if ($superiorCheckbox.length) {
                //             $superiorCheckbox.checkbox('set unchecked');
                //             pointLevel++;
                //         } else {
                //             highestPointFound = true;
                //         }
                //     }
                // }
            }
        })
    ;

    // Child checkboxes
    $('.list .child.checkbox')
        .checkbox({
            // Fire on load to set parent value
            fireOnInit : true,
            // Change parent state on each child checkbox change
            onChange   : function() {
                var
                    $listGroup      = $(this).closest('.list'),
                    $parentCheckbox = $listGroup.closest('.item').children('.checkbox'),
                    $checkbox       = $listGroup.find('.checkbox'),
                    allChecked      = true,
                    allUnchecked    = true
                ;
                // check to see if all other siblings are checked or unchecked
                $checkbox.each(function() {
                    if( $(this).checkbox('is checked') ) {
                        allUnchecked = false;
                    }
                    else {
                        allChecked = false;
                    }
                });
                // set parent checkbox state, but dont trigger its onChange callback
                if(allChecked) {
                    $parentCheckbox.checkbox('set checked');
                }
                else if(allUnchecked) {
                    $parentCheckbox.checkbox('set unchecked');
                }
                else {
                    $parentCheckbox.checkbox('set unchecked');
                }
            }//,
            // onUnchecked: function() {
            //     var $listGroup = $(this).closest('.list');
            //     var $parentCheckbox = $listGroup.closest('.item').children('.checkbox');
            //     $parentCheckbox.checkbox('set unchecked');
            //
            //     var pointLevel = $(this).closest('.checkbox').data('point-level');
            //     if (pointLevel || pointLevel === 0) {
            //         pointLevel = parseInt(pointLevel);
            //         var highestPointFound = false;
            //         while (!highestPointFound) {
            //             var $superiorCheckbox = $("[data-point-level='" + pointLevel + "']");
            //             if ($superiorCheckbox.length) {
            //                 $superiorCheckbox.checkbox('set unchecked');
            //                 pointLevel++;
            //             } else {
            //                 highestPointFound = true;
            //             }
            //         }
            //     }
            // }
        })
    ;
}, false);
