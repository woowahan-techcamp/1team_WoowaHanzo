document.addEventListener("DOMContentLoaded", function(event) {
  var templatetext = document.querySelector("#post_template").innerHTML;
  var template = Handlebars.compile(templatetext);
  pageObject.postTemplate = template;
  
  var storage = firebase.storage();
  // Create a storage reference from our storage service
  var storageRef = storage.ref();
  var database = firebase.database();

  var ref = database.ref("/posts");
  ref.orderByChild("time").on("child_added", function(snapshot) {
    loadPosts(snapshot);
  });

});
