//= require ./lib/_energize
//= require ./app/_toc
//= require ./app/_lang

$(function() {
  loadToc($('#toc'), '.toc-link', '.toc-list-h2', 10);
  setupLanguages($('body').data('languages'));
  $('.content').imagesLoaded( function() {
    window.recacheHeights();
    window.refreshToc();
  });

  window.tito =
    window.tito ||
    function() {
      (tito.q = tito.q || []).push(arguments);
    };

  // For example:
  tito('on:widget:loaded', function(data){
    console.log("Heights have changed FFS");
    window.recacheHeights();
    window.refreshToc();
  })

});

window.onpopstate = function() {
  activateLanguage(getLanguageFromQueryString());
};
