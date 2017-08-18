document.addEventListener("DOMContentLoaded", function(event) {
  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();

  firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
      // User is signed in.
      $(".nav_signin_btn").css("display", "none");
      $(".nav_user_info").css("display", "block");
      // 여기에 사용자 사진불러오기 추가해야함
      var uid = firebase.auth().currentUser.uid;
      var currentUsername = firebase.database().ref("users/" + uid + "/username");
      currentUsername.on('value', function(snapshot) {
        $(".nav_username").html(snapshot.val());
        $(".like_btn").on("click", function(evt) {
          var icon = evt.target;
          icon.style.color = icon.style.color == "rgb(42, 193, 188)" ? "#000" : "rgb(42, 193, 188)";
        });
      });

    } else {
      // No user is signed in.
      $(".nav_signin_btn").css("display", "block");
      $(".nav_user_info").css("display", "none");
      $(".nav_signin_btn").html("Sign in");
    }
  });

});

var pageObject = new PageObject();

// listings of all custom events
var recurseUpdateEvent = jQuery.Event();
var postLoaded = jQuery.Event();
