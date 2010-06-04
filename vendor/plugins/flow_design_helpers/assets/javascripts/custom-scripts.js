/* Custom scripts for forge.typo3.org */

/* "Join" button */
var projectJoinBox = {
    showDisplayTextbox : function() {
        $('joinProjectLink').style.visibility = 'hidden';
        Effect.SlideDown('want-to-help', {duration: 0.2});
   } 
}


var eventHandler = {
    init: function() {
        eventHandler.initProjectJoinBox();
    },
    initProjectJoinBox : function() {
        var joinProjectLink = $('joinProjectLink');
        if (joinProjectLink) {
            joinProjectLink.observe('click', projectJoinBox.showDisplayTextbox);
        }
    }
}

Event.observe(window, 'load', eventHandler.init);



