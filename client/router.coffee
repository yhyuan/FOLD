
ReadController = RouteController.extend


Router.route "home",
    path: "/"
    template: "home"
    onRun: ->
        $('html, body').scrollTop(0)
        @next()
    waitOn: ->
        @subscribe('exploreStoriesPub', '', '', '').wait()
    action: -> if @ready() then @render()
    data: ->
        Session.set "page", "explore"

# Router.route "profile",
#     path: "profile/:userId"
#     template: "profile"
#     data: ->
#       Session.set "page", "profile"
#       Session.set "userId", @.params.userId


Router.route "read",
    path: "read/:storyDashTitle"
    template: "read"
    waitOn: ->
        [
            Meteor.subscribe 'readStoryPub', @.params.storyDashTitle
            Meteor.subscribe 'narrativeBlocksPub'
            Meteor.subscribe 'contextBlocksPub'
        ]
    action: -> if @ready() then @render()
    data: ->
        # Get rid of these
        story = Stories.findOne()
        Session.set "newStory", false
        Session.set "read", true
        Session.set "page", "read"

        if story
            Session.set "backgroundImage", story.backgroundImage
            Session.set "horizontalSectionsMap", _.map _.pluck(story.verticalSections, "contextBlocks"), (cBlocks, i) ->
                verticalIndex: i
                horizontal: _.map cBlocks, (block, i) ->
                    horizontalIndex: i

            return story

Router.route "create",
    path: "create"
    template: "create"
    onRun: ->
        $('html, body').scrollTop(0)
        @next()
    data: ->
        Session.set "newStory", true
        Session.set "read", false
        Session.set "page", "create"

        # Proper way to initiate blank template?
        Session.set 'storyTitle', 'New Story'
        Session.set 'verticalSections', []
        Session.set 'horizontalSections', []
        return Stories.findOne()

Router.route "edit",
    path: "create/:storyDashTitle"
    template: "create"
    onRun: ->
        $('html, body').scrollTop(0)
        @next()
    waitOn: ->
        @subscribe('createStoryPub', @.params.storyDashTitle).wait()
    action: -> if @ready() then @render()
    data: ->
        story = Stories.findOne()
        Session.set "newStory", false
        Session.set "read", false
        Session.set "page", "create"
        Session.set "storyDashTitle", @.params.storyDashTitle
        if story
            Session.set "verticalSections", story.verticalSections
            Session.set "horizontalSections", story.horizontalSections
            Session.set "backgroundImage", story.backgroundImage
            Session.set "storyId", story._id
        return story
