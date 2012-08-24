var NewDataCard = { fn: {} };

NewDataCard.OwnDataFormView = Backbone.View.extend({
    el: "#new_data_card_form",

    events: {
        'click .submit': 'submit',
        'click .preview': 'preview'
    },

    render: function() {
        var self = this;
        $.get("/admin/cards/tpl/from_own_data_form", function(data) {
            self.$el.html(data);
        });
    },

    submit: function(e) {
        e.preventDefault();
    },

    preview: function(e) {
        e.preventDefault();
    }
});

NewDataCard.TypeChoiceView = Backbone.View.extend({
    el: "#yield",

    events: {
        'click #do_datacard_from_own_data': 'renderOwnDataForm',
        'click #do_datacard_from_csv_file': 'renderCsvUploadForm',
        'click #do_datacard_from_api_mapping': 'renderApiMappingForm',
        'click #do_datacard_from_own_html': 'renderCsvUploadForm'
    },
    
    initialize: function() {
        this.template = $('#datacard_type_choice_tpl').html();
    },

    render: function() {
        this.$el.html(this.template);
    },

    renderOwnDataForm: function(e) {
        e.preventDefault();
        (new NewDataCard.OwnDataFormView()).render();
    },

    renderCsvUploadForm: function(e) {
        e.preventDefault();
    },

    renderApiMappingForm: function(e) {
        e.preventDefault();
    },

    renderCsvUploadForm: function(e) {
        e.preventDefault();
    }
});

NewDataCard.Router = Backbone.Router.extend({
    routes: {
        'admin/cards/new': 'home'
    },
    
    home: function() {
        (new NewDataCard.TypeChoiceView()).render();
    }
});

$(function() {
    NewDataCard.router = new NewDataCard.Router();
});
