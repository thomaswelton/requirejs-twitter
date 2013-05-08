define ['EventEmitter', 'module', 'mootools'], (EventEmitter, module) ->
	class Twitter extends EventEmitter
		constructor: (@config) ->
			super()

			console.log 'Twitter Class', @config

			document.body.addEvent 'click', (event) =>
				if event.target.hasClass 'twitter-share-button'
					event.stop()
					window.open event.target.href, '_blank', 'height = 250, width = 450'


			@addEvent 'onReady', (twttr) =>
				console.log 'Twitter SDK Fully loaded', twttr
				
				tweetButtons = $$ '.twitter-share-button'
				tweetButtons.setStyle 'visibility', 'visible'

				twttr.events.bind 'tweet', @onTweet

			@injectTwitter()
				

		injectTwitter: (cb) =>
			return if document.getElementById 'twitter-wjs'

			requirejs ['https://platform.twitter.com/widgets.js'], () =>
				twttr.ready (twttr) =>
					@fireEvent 'onReady', twttr
					cb twttr if typeof cb is 'function'

		onTweet: (event) =>
			console.log 'On Tweet event fired', event


	## Create and return a new instance of Twitter
	## module.config() returns a JSON object as defined in requirejs.config.Twitter
	new Twitter module.config()	