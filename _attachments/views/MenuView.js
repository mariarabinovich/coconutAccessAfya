// Generated by CoffeeScript 1.8.0
var MenuView,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MenuView = (function(_super) {
  __extends(MenuView, _super);

  function MenuView() {
    this.checkReplicationStatus = __bind(this.checkReplicationStatus, this);
    this.render = __bind(this.render, this);
    return MenuView.__super__.constructor.apply(this, arguments);
  }

  MenuView.prototype.el = '.main_header';

  MenuView.prototype.events = {
    "change": "render",
    "click .menuburger": "openOrCloseMenu"
  };

  MenuView.prototype.openOrCloseMenu = function() {
    var menu, theheader, thisbutton;
    menu = $('.main-nav');
    thisbutton = $('.menuburger');
    theheader = $('.aa-header');
    menu.toggleClass("open");
    menu.slideToggle("slow");
    return thisbutton.toggleClass("menuisopen", "slow");
  };

  MenuView.prototype.render = function() {
    var adminButtons, syncButton;
    if (atServer()) {
      adminButtons = "<a href='#login'>Login</a> <a href='#logout'>Logout</a> <a id='reports' href='#reports'>Reports</a> <a id='manage-button' href='#manage'>Manage</a> &nbsp;";
    }
    if ("mobile" === Coconut.config.local.get("mode")) {
      syncButton = "<a href='#sync/send_and_get'>Sync <span class='tinyfont'>(last done: <span class='sync-sent-and-get-status'></span>)</span></a>";
    }
    this.$el.html("<button class='menuburger'></button> <nav class='main-nav closed'> <a href='#'><span>Find/Add Client</span></a> <a href='#'><span>Healthy Schools Intake</span></a> <a href='#'><span>Reports</span></a> <a href='#'><span>Feedback</span></a> <a href='index.html#logout'><span id='user'>Username / </span><span> logout</span></a> " + (syncButton || '') + " " + (adminButtons || '') + " </nav>");
    this.updateVersion();
    this.checkReplicationStatus();
    return Coconut.questions.fetch;
  };

  MenuView.prototype.updateVersion = function() {
    return $.ajax("version", {
      success: function(result) {
        return $("#version").html(result);
      },
      error: $("#version").html("-")
    });
  };

  MenuView.prototype.update = function() {
    Coconut.questions.each((function(_this) {
      return function(question, index) {
        var results;
        results = new ResultCollection();
        return results.fetch({
          include_docs: false,
          question: question.id,
          isComplete: true,
          success: function(results) {
            return $("#menu-" + index + " #menu-partial-amount").html(results.length);
          }
        });
      };
    })(this));
    return this.updateVersion();
  };

  MenuView.prototype.checkReplicationStatus = function() {
    return $.couch.login({
      name: Coconut.config.get("local_couchdb_admin_username"),
      password: Coconut.config.get("local_couchdb_admin_password"),
      error: (function(_this) {
        return function() {
          return console.log("Could not login");
        };
      })(this),
      complete: (function(_this) {
        return function() {
          return $.ajax({
            url: "/_active_tasks",
            dataType: 'json',
            success: function(response) {
              var progress, _ref;
              progress = response != null ? (_ref = response[0]) != null ? _ref.progress : void 0 : void 0;
              if (progress) {
                $("#databaseStatus").html("" + progress + "% Complete");
                return _.delay(_this.checkReplicationStatus, 1000);
              } else {
                console.log("No database status update");
                $("#databaseStatus").html("");
                return _.delay(_this.checkReplicationStatus, 60000);
              }
            },
            error: function(error) {
              console.log("Could not check active_tasks: " + (JSON.stringify(error)));
              return _.delay(_this.checkReplicationStatus, 60000);
            }
          });
        };
      })(this)
    });
  };

  return MenuView;

})(Backbone.View);

//# sourceMappingURL=MenuView.js.map
