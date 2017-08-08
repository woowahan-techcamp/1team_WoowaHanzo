document.addEventListener("DOMContentLoaded", function(event) {
  console.log("category.js started!");
  console.log($(".category_picker td").width());
  $(".category_picker td").height($(".category_picker td").width());
});
