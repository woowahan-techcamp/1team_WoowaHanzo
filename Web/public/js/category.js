document.addEventListener("DOMContentLoaded", function(event) {
  console.log("category.js started!");
  console.log($(".category_picker td").width());
  $(".category_picker td").outerHeight($(".category_picker td").width());
  $(".fa-check-circle").width($(".category_picker td").width());

  $(".image_holder").on("mouseover", function(evt) {
    console.log("hovering!");
    $(this).children(".cover").css("visibility", "visible");
  });

  $(".image_holder").on("mouseout", function(evt) {
    $(this).children(".cover").css("visibility", "hidden");
  });

  var database = firebase.database();
  var ref = database.ref("/categories");

  var data = {};

  ref.on("child_added", function(snapshot) {
    console.log(snapshot.key);
    data[snapshot.key] = snapshot.val();
    var tableBuilder = new TableBuilder(snapshot.key, snapshot.val());
  });
});
