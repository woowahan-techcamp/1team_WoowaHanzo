document.addEventListener("DOMContentLoaded", function(event) {
  console.log("category.js started!");
  console.log($(".category_picker td").width());
  console.log($(".category_picker td").outerWidth());
  console.log($(".category_picker td").innerWidth());

  $(".category_picker td").each(function(index, elem) {
    console.log($(".category_picker td").width());
    console.log(elem.outerHTML);
    var bufferWidth = $(".category_picker td")[0].offsetWidth;
    elem.style.height = bufferWidth + "px";
  });

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
