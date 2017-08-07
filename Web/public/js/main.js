
document.addEventListener("DOMContentLoaded", function(event) {
  console.log("DOM fully loaded and parsed");

  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();


  var database = firebase.database();

  var templatetext = document.querySelector("#post_template").innerHTML;
  var template = Handlebars.compile(templatetext);

  var ref = database.ref("/posts");
  ref.orderByChild("time").on("child_added", function(snapshot) {
    console.log(snapshot.val().time);
    $(".container_box").append(template(snapshot.val()));
    console.log("GO");
  });

});
