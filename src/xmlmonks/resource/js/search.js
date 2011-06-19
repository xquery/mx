$(document).ready(function(){
 $(".slidingDiv").hide();
 $('form input#search').autocomplete({source:'/search/suggest'});
})


