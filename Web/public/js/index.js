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

    pageObject.postTimes[buffer.id] = -buffer["time"];
    pageObject.postState[buffer.id] = false;
    pageObject.imageUrls[buffer.id] = [];

    // replacing new lines with line breaks
    buffer["body"] = buffer["body"].replace(/\n/g, "<br>");
    buffer["time"] = getCurrentTime(-buffer["time"]);

    $(".container_box").append(template(buffer));

    var $curPost = $("#post_" + buffer.id);
    prevLoaded($curPost);

    if(buffer.images) {
      // only three images are loaded at a time
      for(var i = 0; i < buffer.images.length || i < 3; ++i) {

        var $curObject = {};
        $curObject.$curPost = $curPost;
        $curObject.i = i;
        var filename = buffer.images[i];
        if(i < 3) {
          if(!filename) continue;
          storageRef.child('images/' + filename).getDownloadURL().then(function(url) {
            pageObject.imageUrls[buffer.id].push(url);

            var imageParent = $curObject.$curPost.children("table").children("tbody").children("tr");

            imageParent = imageParent.children("td").get(this.i);
            imageParent = $(imageParent).children("div").children("img");
            imageParent.addClass("loading");

            imageParent.attr("src", url);
            imageParent.on("load", function(evt) {
              var curImage = evt.target;
              curImage.classList.add("loaded");
              var imageParent = curImage.parentElement.parentElement.parentElement;
              var allImages = imageParent.querySelectorAll("loading");

              var allLoaded = true;
              for(var i = 0; i < allImages.length; ++i) {
                if(!$(allImages[i]).hasClass("loaded")) {
                  allLoaded = false;
                }
              }

              if(allLoaded) {
                console.log("Images all loaded");
              }

            });

          }.bind($curObject)).catch(function(err) {
            console.log(err);
            console.log("File load unsuccessful");
          });

        } else if(i >= buffer.images.length) {
          var imageParent = $curPost.children("table").children("tbody").children("tr");

          imageParent = imageParent.children("td").get(i);
          imageParent = $(imageParent).children("div").children("img");
          imageParent.classList.add("loaded");

        } else {
          storageRef.child('images/' + filename).getDownloadURL().then(function(url) {
            pageObject.imageUrls[buffer.id].push(url);

          }.bind(i)).catch(function(err) {
            console.log(err);
            console.log("File load unsuccessful");
          });
        }

      }

    } else {
      $curPost.trigger("postLoaded");
      $curPost.children("table").remove();
    }
    // keeping the post invisible while loading
    $curPost.css("display", "none");
    $curPost.children(".post_body").html(buffer["body"]);
    if(buffer["tags"] && buffer["tags"].length == 0) {
      $curPost.children(".tags_holder").css("display", "none");
    }
    $curPost.css("display", "block");

    resizeThumbnails();
  });

});

function prevLoaded($curPost) {
  console.log($curPost.prev());
}
