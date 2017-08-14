document.addEventListener("DOMContentLoaded", function(event) {
  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();

});

function resizeThumbnails() {
  $(".image_thumbnails td").each(function(index, elem) {

    var bufferWidth = $(".image_thumbnails td")[0].offsetWidth;
    elem.style.height = bufferWidth + "px";
    if($(".thumbnail_cover").last().length > 0) {
        $(".thumbnail_cover").last()[0].style.lineHeight = bufferWidth - 20 + "px";
    }

  });
}
