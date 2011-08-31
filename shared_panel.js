(function() {
  var self;
  $.SharedPanel = self = {
    html: function(html) {
      return $("#shared_panel").html(html);
    },
    empty: function() {
      return $("#shared_panel").empty();
    }
  };
}).call(this);
