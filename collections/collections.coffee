@Stories = new Meteor.Collection "stories"

# Add user confirmation / security here
@Stories.allow
	insert: -> true
	update: -> true
	remove: -> true

class ContextBlock
	constructor : (doc) ->
		_.extend this, doc

class VideoBlock extends ContextBlock
	url: ->
		if @service is 'youtube'
			'//www.youtube.com/embed/' + @videoId
		else if @service is 'vimeo'
			'//player.vimeo.com/video/' + @videoId
	previewUrl: ->
		if @service is 'youtube'
			'//img.youtube.com/vi/' + @videoId + '/0.jpg'


@ContextBlocks = new Meteor.Collection "context_blocks",
	transform: (doc) ->
		if doc.type is 'video'
			new VideoBlock doc
		else
			new ContextBlock doc

# Add user confirmation / security here
@ContextBlocks.allow
	insert: -> true
	update: -> true
	remove: -> true
