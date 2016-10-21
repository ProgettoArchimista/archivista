/* PJAX bindings */
$(document).pjax('a.load-fond', '#fonds-wrapper');
$(document).pjax('a.load-units', '#units-tree');
$(document).pjax('a.load-unit', '#units-wrapper');

$(document).ready(function() {
/* Upgrade 2.2.0 inizio */
/*
  $('form').on("click", "#search-button, #global-button", function(event){
    if ($('input[name="q"]').val() === "") {
      event.preventDefault();
      $("#empty-query").modal('show');
    }
  });
*/
/* Upgrade 2.2.0 fine */

/* Upgrade 2.2.0 inizio */
// cambiato 3000 in 6000
	$('.carousel').carousel({
		 interval: 6000
	});
/* Upgrade 2.2.0 fine */

});