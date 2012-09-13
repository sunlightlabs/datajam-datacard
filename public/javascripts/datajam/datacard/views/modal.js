/*jshint laxcomma:true, expr:true, evil:true */
(function($, require, define){
  define([ 'text!datacard/templates/modal.html',
           'datacard/init',
           'datacard/models/datacard_update'
         ], function(tmpl){

    var App = window.Datajam.Datacard;

    App.views.Modal = Datajam.views.Modal.extend({

      initialize: function(options){
        options || (options = {});
        Datajam.views.Modal.prototype.initialize.call(this, options);

        Datajam.templates['datacard_modal'] || (Datajam.templates['datacard_modal'] = Handlebars.compile(tmpl));
        this.template = Datajam.templates.datacard_modal;

        return this;
      },

      save: function(evt){
        try{
          evt.preventDefault();
          evt.stopPropagation();
        }catch(e){}

        new App.models.DatacardUpdate({
          contentArea: this.model,
          data: { current_card_id: $('#select-' + this.model.get('_id') + ' option:selected').val() }
        }).save()
          .then(_.bind(function(){
            this.hide();
          }, this))
          .fail(_.bind(function(){

          }, this));

        return this;
      }

    });

  });
})(jQuery, require, define);