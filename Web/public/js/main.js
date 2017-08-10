document.addEventListener("DOMContentLoaded", function(event) {
  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();


  var database = firebase.database();

  var templatetext = document.querySelector("#post_template").innerHTML;
  var template = Handlebars.compile(templatetext);

  var ref = database.ref("/posts");
  ref.orderByChild("time").on("child_added", function(snapshot) {

    var buffer = snapshot.val();
    buffer.id = snapshot.key;

    // replacing new lines with line breaks
    buffer["body"] = buffer["body"].replace(/\n/g, "<br>");
    console.log(buffer);
    $(".container_box").append(template(buffer));
    var $curPost = $("#post_" + buffer.id);
    $curPost.css("display", "none");
    $curPost.children(".tags_holder");
    $curPost.children(".post_body").html(buffer["body"]);
    for(var i = 0; i < buffer["tags"].length; ++i) {

    }
    $curPost.css("display", "block");
    console.log("GO");
  });

});
