document.addEventListener("DOMContentLoaded", function(event) {
  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();

  if(firebase.auth().currentUser !== null) {
    $(".nav_signin_btn").html("Sign out");
  }
  else {
    $(".nav_signin_btn").html("Sign in");
  }

  $(".nav_signin_btn").on("click", function() {
    console.log('clicked..');

    if(firebase.auth().currentUser !== null) {
      console.log('로그인 되어있으니까 로그아웃 ㄱ');

      firebase.auth().signOut().then(function() {
        console.log('로그아웃');
      }, function(error) {
        console.log('로그아웃 에러: ', error);
      });
    }
    else {
      console.log('로그인된거 없음 로그인으로 ㄱ');
      window.location.href="login.html";
    }
  });

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
