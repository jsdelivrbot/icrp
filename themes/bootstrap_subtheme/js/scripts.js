(function ($) {
    Drupal.behaviors.myModuleBehavior = {
        attach: function (context, settings) {
        	//$('h2').css('color', 'red');
        	$("#edit-keys").attr("placeholder", "Search Website");
        }
    }
})(jQuery);