// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require bootstrap
//= require bootstrap-modal
//= require bootstrap-modalmanager
//= require bootstrap-datepicker
//= require locales/bootstrap-datepicker.it
//= require select2/select2


(function($) {
  window.TellMe = function() {
    this.init_everything($(document));
    //this.addFields = $.proxy(this.expandField, this);
    //this.removeFields = $.proxy(this.collapseField, this);
  };

  TellMe.prototype = {
    init_everything: function(context) {
      this.init_datepicker(context);
    },
    init_datepicker: function(context) {
      var opts = {
        autoclose: true,
        language: 'it'
      }
      $('input.date', context).each(function(){
        var $this = $(this);
        var type = $this.data('date-type') || 'day';
        switch(type){
          case 'day': $this.datepicker(
                          $.extend(opts, {
                            format: 'dd.mm.yyyy'
                          })
                       ); return;
          case 'month': $this.datepicker(
                          $.extend(opts, {
                            format: 'MM yyyy',
                            minViewMode: 1,
                            startView: 1
                          })
                        ); return;
        }
      });
    },
    expandField: function(e) {
      var $this = $(this);
      var eh = $this.data('expanded-height') || '60px';
      $this.stop().animate({
        height: eh
      });
    },
    collapseField: function(e) {
      var $this = $(this);
      var eh = $this.data('collapsed-height') || '30px';
      $this.stop().animate({
        height: eh
      });
    }
  };

  window.tellMe = new TellMe();
  $(document)
    .delegate('textarea.note', 'focus', tellMe.expandField)
    .delegate('textarea.note', 'blur', tellMe.collapseField);
})(jQuery);



$(function() {

  $('.remove').on('click', function(e){
    $(this).prev().val(null);
    e.preventDefault();
    return false;
  });

  /*$(document).on('focus.tellme', 'textarea.note', function(e){
    var $this = $(this);
    var eh = $this.data('expanded-height') || '60px';
    $this.stop().animate({
      height: eh
    });
  }).on('blur.tellme', 'textarea.note', function(e){
    var $this = $(this);
    var eh = $this.data('collapsed-height') || '30px';
    $this.stop().animate({
      height: eh
    });
  }).on('nested:fieldAdded', function(event){
    // this field was just inserted into your form
    var field = event.field;
    // it's a jQuery object already! Now you can find date input
    var dateField = field.find('.month-year');
    // and activate datepicker on it
    dateField.datepicker({
      format: 'MM yyyy',
      autoclose: true,
      language: 'it',
      minViewMode: 1,
      startView: 1
    });
  });*/

});