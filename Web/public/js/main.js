document.addEventListener("DOMContentLoaded", function(event) {
  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();

  $(".nav_signin_btn").on("mousedown tap", function(evt) {
    evt.preventDefault();
    if(firebase.auth().currentUser !== null) {
      firebase.auth().signOut().then(function() {
        $(".nav_signin_btn").html("로그인");
      }, function(error) {});
    }
    else {
      window.location.href = "login.html";
    }
  });

  $("#post").on("mousedown tap", function(evt) {
    evt.preventDefault();
    window.location.href = "post.html";
  });

  $("#ranking").on("mousedown tap", function(evt) {
    evt.preventDefault();
    window.location.href = "ranking.html";
  });

  $("#tag").on("mousedown tap", function(evt) {
    evt.preventDefault();
    window.location.href = "tag.html";
  });

  firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
      // User is signed in.
      //signin버튼 display none
      $(".nav_signin_btn").css("display", "none");

      var currentUsername = firebase.database().ref("users/" + user.uid);
      currentUsername.on('value', function(snapshot) {
        $(".nav_username").html(snapshot.val().username);
        $(".nav_user_info").on("mousedown tap", function(evt) {
          evt.preventDefault();
          window.location.href = 'mypage.html';
        });
        $(".nav_user_info").css("visibility", "visible");
      });

      var curObject= {};
      var curPost = document.querySelector(".nav_user_info");
      curObject.curPost = curPost;

      curObject.uid = user.uid;
      curObject.queryClass = "nav_user_img";
      loadUserProfile.bind(curObject, user.uid)();

    }
    else {
      // No user is signed in.
      $(".nav_signin_btn").css("display", "block");
      $(".nav_user_info").css("display", "none");
      $(".nav_signin_btn").html("로그인");
      $(".nav_signin_btn").on("mousedown tap", function(evt) {
        evt.preventDefault();
        window.location.href = "./login.html";
      });
    }
  });

});

var pageObject = new PageObject();

// listings of all custom events
var recurseUpdateEvent = jQuery.Event();
var postLoaded = jQuery.Event();
var likeNumberRequestEvent = jQuery.Event();
