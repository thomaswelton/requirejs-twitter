(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['EventEmitter', 'module', 'mootools'], function(EventEmitter, module) {
    var Twitter;

    Twitter = (function(_super) {
      __extends(Twitter, _super);

      function Twitter(config) {
        var _this = this;

        this.config = config;
        this.onTweet = __bind(this.onTweet, this);
        this.injectTwitter = __bind(this.injectTwitter, this);
        Twitter.__super__.constructor.call(this);
        console.log('Twitter Class', this.config);
        document.body.addEvent('click', function(event) {
          if (event.target.hasClass('twitter-share-button')) {
            event.stop();
            return window.open(event.target.href, '_blank', 'height = 250, width = 450');
          }
        });
        this.addEvent('onReady', function(twttr) {
          var tweetButtons;

          console.log('Twitter SDK Fully loaded', twttr);
          tweetButtons = $$('.twitter-share-button');
          tweetButtons.setStyle('visibility', 'visible');
          return twttr.events.bind('tweet', _this.onTweet);
        });
        this.injectTwitter();
      }

      Twitter.prototype.injectTwitter = function(cb) {
        var _this = this;

        if (document.getElementById('twitter-wjs')) {
          return;
        }
        return requirejs(['https://platform.twitter.com/widgets.js'], function() {
          return twttr.ready(function(twttr) {
            _this.fireEvent('onReady', twttr);
            if (typeof cb === 'function') {
              return cb(twttr);
            }
          });
        });
      };

      Twitter.prototype.onTweet = function(event) {
        return console.log('On Tweet event fired', event);
      };

      return Twitter;

    })(EventEmitter);
    return new Twitter(module.config());
  });

}).call(this);
