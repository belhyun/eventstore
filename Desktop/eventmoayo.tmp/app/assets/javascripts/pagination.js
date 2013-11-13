$(function(){
  $(".pagination").on("click", "a", (function(){
    $.get(this.href, null, null, "script");
    return false;
  }));
});
