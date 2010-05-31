/* Custom scripts for forge.typo3.org */

/* "Join" button */
var projectJoinBox = {
    showDisplayTextbox : function() {
        $('joinProjectLink').style.visibility = 'hidden';
        Effect.SlideDown('want-to-help', {duration: 0.2});
    },
    submitMembershipRequest : function() {
        var textbox = $('team-membership-request-comment');
        var projectId = $('project-id');
        new Ajax.Request('../membershiprequest/' + projectId.value, {
            method: 'post',
            parameters: {
                description: textbox.value
            },
            onSuccess: function(transport) {
                var wantToHelp = $('want-to-help');
                Element.replace(wantToHelp, '<p class="clearer"><b>We have received your request and will review it soon!</b></p>');
        }
        });

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
        
        var submitTeamMembershipRequest = $('submit-team-membership-request');
        if (submitTeamMembershipRequest) {
            submitTeamMembershipRequest.observe('click', projectJoinBox.submitMembershipRequest);
        }
    }
}

Event.observe(window, 'load', eventHandler.init);



