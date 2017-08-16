document.addEventListener("DOMContentLoaded", function(event) {
  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();

  // 로그인 되어있지 않으면 로그인 화면으로 보냄
  firebase.auth().onAuthStateChanged(user => {
    if(!user) {
      window.location.href = 'login.html';
    }
    else {
      var user = firebase.auth().currentUser;

      $("#user_email").html("유저네임: " + user.email);

      var username = firebase.database().ref("users/" + user.uid + "/username");
      username.on('value', function(snapshot) {
        $("#user_username").html("유저네임: " + snapshot.val());
      });

      var sayhi = firebase.database().ref("users/" + user.uid + "/sayhi");
      sayhi.on('value', function(snapshot) {
        $("#user_sayhi").html("자기소개: " + snapshot.val());
      });

      $("#logout").on("click", function() {
        firebase.auth().signOut().then(function() {
          // Sign-out successful.
          alert("로그아웃 하셨습니다.");
        }, function(error) {
          // An error happened.
        });
      });
    }
  });

});
