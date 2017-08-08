document.addEventListener("DOMContentLoaded", function(event) {
  console.log("category.js started!");
  console.log($(".category_picker td").width());
  $(".category_picker td").height($(".category_picker td").width());

  var database = firebase.database();
  var ref = database.ref("/categories");

  var data = {};

  ref.on("child_added", function(snapshot) {
    console.log(snapshot.key);
    data[snapshot.key] = snapshot.val();
    var tableBuilder = new TableBuilder(snapshot.key, snapshot.val());
  });

});
