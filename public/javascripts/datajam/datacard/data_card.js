Datajam.DataCardUpdate = Backbone.Model.extend({
  save: function() {
    var contentArea = this.get('contentArea');
    var payload = { event_id: Datajam.event.get('_id'),
                    content_area_id: contentArea.get('_id'),
                    data: { current_card_id: $('#select-' + contentArea.get('_id') + ' option:selected').val() } };
    $.post('/onair/update', payload, function(response) {
      $('#modal-' + contentArea.get('_id')).modal('hide');
    }, 'json');
  }
});

Datajam.DataCardModal = Datajam.Modal.extend({
  template: function() {
    return Handlebars.compile($("script#data_card_modal_template").html());
  },
});

Datajam.modalRenderers['data_card_area'] = function(contentArea) {
  var dataCardUpdate = new Datajam.DataCardUpdate({contentArea: contentArea});
  var modal = new Datajam.DataCardModal({ model: dataCardUpdate,
                                          id: contentArea.get('_id') });
  modal.render();
}
