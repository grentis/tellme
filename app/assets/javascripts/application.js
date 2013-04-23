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
//= require bootstrap
//= require bootstrap-datepicker
//= require locales/bootstrap-datepicker.it
//= require jquery.numeric
//= require select2/select2
//= require bootstrap-modal.js
//= require bootstrap-modalmanager.js



$(function() {
  $('#invoice_date').datepicker({
    format: 'dd.mm.yyyy',
    autoclose: true,
    language: 'it'
  });

  $('input.month-year').datepicker({
    format: 'MM yyyy',
    autoclose: true,
    language: 'it',
    minViewMode: 1,
    startView: 1
  });

  $('.remove').on('click', function(e){
    $(this).prev().val(null);
    e.preventDefault();
    return false;
  });

});