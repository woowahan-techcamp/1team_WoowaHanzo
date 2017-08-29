document.addEventListener("DOMContentLoaded", function(event) {
  var templatetext = document.querySelector("#post_template").innerHTML;
  var template = Handlebars.compile(templatetext);
  pageObject.postTemplate = template;

  var storage = firebase.storage();
  // Create a storage reference from our storage service
  var storageRef = storage.ref();
  var database = firebase.database();

  var url = window.location.href;

  var ref = database.ref("/posts");

  var tagQuery = getParameterByName("tagQuery", url)

  if(tagQuery) {
    database.ref("/tagQuery/" + tagQuery + "/queryResult").on("value", function(snapshot) {
      console.log(snapshot.val());

      if(snapshot.val()) {
        var postIdList = snapshot.val().slice(1,snapshot.val().length);
        console.log(postIdList);
        var promises = postIdList.map(function(key) {
          console.log(key);
          return firebase.database().ref("/posts/").child(key).once("value");
        });

        Promise.all(promises).then(function(snapshots) {
          console.log(snapshots);
          snapshots.forEach(function(snapshot) {
            loadPosts(snapshot, false);
          });
        });
      }
      else {
        window.location.href = "./404.html";
      }
    });
  } else {
    ref.orderByChild("time").on("child_added", function(snapshot) {
      loadPosts(snapshot, false);
    });
  }


});
