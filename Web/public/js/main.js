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
    buffer["time"] = getCurrentTime(-buffer["time"]);
    console.log(buffer);
    $(".container_box").append(template(buffer));
    var $curPost = $("#post_" + buffer.id);

    // keeping the post invisible while loading
    $curPost.css("display", "none");
    $curPost.children(".post_body").html(buffer["body"]);
    if(buffer["tags"] && buffer["tags"].length == 0) {
      $curPost.children(".tags_holder").css("display", "none");
    }
    $curPost.css("display", "block");

    $(".image_thumbnails td").each(function(index, elem) {
      console.log($(".image_thumbnails td").width());
      console.log(elem.outerHTML);
      var bufferWidth = $(".image_thumbnails td")[0].offsetWidth;
      elem.style.height = bufferWidth + "px";
      $(".thumbnail_cover").last()[0].style.lineHeight = bufferWidth - 20 + "px";
    });
    console.log("GO");
  });

});
