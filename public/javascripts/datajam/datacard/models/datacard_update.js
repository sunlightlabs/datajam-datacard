/*jshint laxcomma:true, expr:true, evil:true */
(function(define, require, $, window, undefined){
  define(['datacard/init'], function(){

    var App = window.Datajam.Datacard;

    App.models.DatacardUpdate = Backbone.Model.extend({
      // Content Updates post to a non-resourceful url
      save: function() {
        return $.post('/onair/update.json', {
          event_id: Datajam.event.model.id,
          content_area_id: this.get('contentArea').id,
          data: this.get('data')
        });
      }
    });

  });

})(define, require, jQuery, window);
