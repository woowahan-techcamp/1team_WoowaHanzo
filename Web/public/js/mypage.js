// 로그인 되어있지 않으면 로그인 화면으로 보냄
firebase.auth().onAuthStateChanged(user => {
  if(!user) {
    window.location.href = 'login.html';
  }
});

document.addEventListener("DOMContentLoaded", function(event) {
  var templatetext = document.querySelector("#post_template").innerHTML;
  var template = Handlebars.compile(templatetext);
  pageObject.postTemplate = template;

  var user = firebase.auth().currentUser;
  var username = "";

  // $(".user_email").html("유저네임: " + user.email);

  var username = firebase.database().ref("users/" + user.uid + "/username");
  username.on('value', function(snapshot) {
    username = snapshot.val();
    $(".mypage_username").html(username);
  });

  var sayhi = firebase.database().ref("users/" + user.uid + "/sayhi");
  sayhi.on('value', function(snapshot) {
    $(".mypage_user_sayhi").html(snapshot.val());
  })

  var rootRef = firebase.database().ref();
  var postRef = rootRef.child("posts");
  postRef.once("value", function(snapshot) {
    snapshot.forEach(function(child) {
      // child.val() 전체 포스트 가져옴
      if(child.val().author === username) {
        loadPosts(child);
      }
    });
  });

  $("#logout").on("click", function() {
    firebase.auth().signOut().then(function() {
      // Sign-out successful.
      alert("로그아웃 하셨습니다.");
    }, function(error) {
      // An error happened.
    });
  });

});
