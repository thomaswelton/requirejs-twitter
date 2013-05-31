define ['EventEmitter', 'module', 'mootools'], (EventEmitter, module) ->
	class Twitter extends EventEmitter
		constructor: (@config) ->
			super()

			## Used as a default for functions 
			## That accept a callback
			@cb = () ->

			console.log 'Twitter Class', @config

			$(document.body).addEvent 'click', (event) =>
				if event.target.hasClass 'twitter-share-button'
					event.stop()
					window.open event.target.href, '_blank', 'height = 250, width = 450'


			@onReady (twttr) =>
				console.log 'Twitter SDK Fully loaded', twttr
				
				@renderPlugins()
				twttr.events.bind 'tweet', @onTweet

			@injectTwitter()
				

		injectTwitter: (cb) =>
			return if document.getElementById 'twitter-wjs'

			requirejs ['https://platform.twitter.com/widgets.js'], () =>
				twttr.ready (twttr) =>
					@fireEvent 'twttrInit', twttr
					cb twttr if typeof cb is 'function'

		onReady: (callback = @cb) =>
			if twttr?
				callback twttr
			else
				@once 'twttrInit', () => callback twttr

		renderPlugins: () =>
			@onReady (twttr) =>
				twttr.widgets.load()
				$$('.twitter-share-button').setStyle 'visibility','visible'

		onTweet: (event) =>
			console.log 'On Tweet event fired', event

		tweetPopup: (url = '', text = '') =>
			tweetUrl = "http://twitter.com/share?url=" + encodeURIComponent(url) + "&text=" + encodeURIComponent(text) + "&count=none/"
			window.open tweetUrl, "tweet", "height=300,width=550,resizable=1"


	## Create and return a new instance of Twitter
	## module.config() returns a JSON object as defined in requirejs.config.Twitter
	new Twitter module.config()	