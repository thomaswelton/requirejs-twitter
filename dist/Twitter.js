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
        this.tweetPopup = __bind(this.tweetPopup, this);
        this.onTweet = __bind(this.onTweet, this);
        this.renderPlugins = __bind(this.renderPlugins, this);
        this.onReady = __bind(this.onReady, this);
        this.injectTwitter = __bind(this.injectTwitter, this);
        Twitter.__super__.constructor.call(this);
        this.cb = function() {};
        console.log('Twitter Class', this.config);
        $(document.body).addEvent('click', function(event) {
          if (event.target.hasClass('twitter-share-button')) {
            event.stop();
            return window.open(event.target.href, '_blank', 'height = 250, width = 450');
          }
        });
        this.onReady(function(twttr) {
          _this.renderPlugins();
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
            _this.fireEvent('twttrInit', twttr);
            if (typeof cb === 'function') {
              return cb(twttr);
            }
          });
        });
      };

      Twitter.prototype.onReady = function(callback) {
        var _this = this;

        if (callback == null) {
          callback = this.cb;
        }
        if (typeof twttr !== "undefined" && twttr !== null) {
          return callback(twttr);
        } else {
          return this.once('twttrInit', function() {
            return callback(twttr);
          });
        }
      };

      Twitter.prototype.renderPlugins = function() {
        var _this = this;

        return this.onReady(function(twttr) {
          twttr.widgets.load();
          return $$('.twitter-share-button').setStyle('visibility', 'visible');
        });
      };

      Twitter.prototype.onTweet = function(event) {
        return this.fireEvent('onTweet', event);
      };

      Twitter.prototype.tweetPopup = function(url, text) {
        var tweetUrl;

        if (url == null) {
          url = '';
        }
        if (text == null) {
          text = '';
        }
        tweetUrl = "http://twitter.com/share?url=" + encodeURIComponent(url) + "&text=" + encodeURIComponent(text) + "&count=none/";
        return window.open(tweetUrl, "tweet", "height=300,width=550,resizable=1");
      };

      return Twitter;

    })(EventEmitter);
    return new Twitter(module.config());
  });

}).call(this);
