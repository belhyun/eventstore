var getParamByName = function(name){
  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
      results = regex.exec(location.search);
  return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
};

var isEmpty = function(str){
  return (!str || 0 === str.length);
}

$(document).on('click','.top', function(){
  $("html, body").animate({ scrollTop: 0 }, "slow");
    return false;
});

