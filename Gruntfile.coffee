module.exports = (grunt) =>
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'

		## Compile coffeescript
		coffee:
			compile:
				files: [
					{
						expand: true
						cwd: 'src'
						src: ['Twitter.coffee']
						dest: 'src'
						ext: '.js'
					},
					{
						expand: true
						cwd: 'src'
						src: ['main.coffee']
						dest: 'demo'
						ext: '.js'
					}
				]

		removelogging:
			files:
				expand: true
				cwd: 'dist'
				src: ['Twitter.min.js']
				dest: 'dist'
				ext: '.js'

		uglify:
			options:
				mangle: false
				compress: true
				banner: """/*!
						<%= pkg.name %> v<%= pkg.version %> 
						<%= pkg.description %>
						Build time: #{(new Date()).toString('dddd, MMMM ,yyyy')}
						*/\n\n"""
					
			javascript:
				files: {
					'dist/Twitter.min.js': 'dist/Twitter.js'
				}

		markdown:
			readmes:
				files: [
					{
						expand: true
						src: 'README.md'
						dest: 'dist'
						ext: '.html'
					}
				]

		regarde:
			markdown:
				files: 'README.html'
				tasks: 'markdown'
			
			coffee:
				files: ['src/**/*.coffee']
				tasks: ['coffee']

		connect:
			server:
				options:
					keepalive: true
					port: 9001
					base: ''

		exec:
			server:
				command: 'grunt connect &'

			open:
				command: 'open http://localhost:9001/'

		requirejs:
			compile:
				options:
					optimizeCss: false
					optimize: 'none'
					logLevel: 1
					name: "Twitter"
					out: "dist/Twitter.js"
					baseUrl: "src"
					exclude: ['EventEmitter', 'mootools']
					paths:{
						'domReady' : '../components/requirejs-domready/domReady'
						'Twitter': '../src/Twitter'
						'EventEmitter': '../components/EventEmitter/dist/EventEmitter'
						'mootools' : '../demo/mootools'
					}

		shell:
			bower_cache:
				command: 'bower cache-clean'
				options:
					stdout: true

			bower:
				command: 'bower install'
				options:
					stdout: true

		
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-remove-logging'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-markdown'
	grunt.loadNpmTasks 'grunt-regarde'
	grunt.loadNpmTasks 'grunt-contrib-connect'
	grunt.loadNpmTasks 'grunt-contrib-requirejs'
	grunt.loadNpmTasks 'grunt-exec'
	grunt.loadNpmTasks 'grunt-shell'
	
	grunt.registerTask 'default', ['shell:bower', 'compile', 'requirejs', 'uglify']

	grunt.registerTask 'server', ['exec:server', 'exec:open', 'watch']

	grunt.registerTask 'commit', ['default', 'git']
	
	grunt.registerTask 'compile', 'Compile coffeescript and markdown', ['coffee', 'markdown']
	grunt.registerTask 'watch', 'Watch coffee and markdown files for changes and recompile', () ->
		## always use force when watching
		grunt.option 'force', true
		grunt.task.run ['regarde']
