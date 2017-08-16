document.addEventListener("DOMContentLoaded", function(event) {
  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();

  $(".nav_signin_btn").on("click", function() {
    if(firebase.auth().currentUser !== null) {
      firebase.auth().signOut().then(function() {
        $(".nav_signin_btn").html("Sign in");
      }, function(error) {

      });
    }
    else {
      window.location.href="login.html";
    }
  });

  firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
      // User is signed in.
      $(".nav_signin_btn").css("display", "none");
      $(".nav_username").html(firebase.auth().currentUser.email);
    } else {
      // No user is signed in.
      $(".nav_signin_btn").css("display", "block");
      $(".nav_signin_btn").html("Sign in");
    }
  });

});

var pageObject = new PageObject();

// listings of all custom events
var recurseUpdateEvent = jQuery.Event();
var postLoaded = jQuery.Event();

function resizeThumbnails() {
  $(".image_thumbnails td").each(function(index, elem) {

    var bufferWidth = $(".image_thumbnails td")[0].offsetWidth;
    elem.style.height = bufferWidth + "px";
    if($(".thumbnail_cover").last().length > 0) {
        $(".thumbnail_cover").last()[0].style.lineHeight = bufferWidth - 20 + "px";
    }

  });
}
