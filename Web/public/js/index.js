document.addEventListener("DOMContentLoaded", function(event) {
  var templatetext = document.querySelector("#post_template").innerHTML;
  var template = Handlebars.compile(templatetext);

  var storage = firebase.storage();
  // Create a storage reference from our storage service
  var storageRef = storage.ref();
  var database = firebase.database();

  var ref = database.ref("/posts");
  ref.orderByChild("time").on("child_added", function(snapshot) {

    var storageRef = firebase.storage().ref();

    var buffer = snapshot.val();
    buffer.id = snapshot.key;

    // replacing new lines with line breaks
    buffer["body"] = buffer["body"].replace(/\n/g, "<br>");
    buffer["time"] = getCurrentTime(-buffer["time"]);
    console.log(buffer);
    $(".container_box").append(template(buffer));

    var $curPost = $("#post_" + buffer.id);

    if(buffer.images) {

      for(var i = 0; i < buffer.images.length && i < 3; ++i) {

        var filename = buffer.images[i];

        storageRef.child('images/' + filename).getDownloadURL().then(function(url) {
          var imageParent = $curPost.children("table").children("tbody").children("tr");
          console.log(imageParent.html());
          imageParent = imageParent.children("td").get(this);
          imageParent = $(imageParent).children("div").children("img");

          imageParent.attr("src", url);

          console.log(url);
        }.bind(i)).catch(function(err) {
          console.log(err);
          console.log("File load unsuccessful");
        });
      }

    } else {
      $curPost.children("table").remove();
    }
    // keeping the post invisible while loading
    $curPost.css("display", "none");
    $curPost.children(".post_body").html(buffer["body"]);
    if(buffer["tags"] && buffer["tags"].length == 0) {
      $curPost.children(".tags_holder").css("display", "none");
    }
    $curPost.css("display", "block");

    console.log("GO");
    resizeThumbnails();
  });

});
