document.addEventListener("DOMContentLoaded", function(event) {
  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();

  // 로그인 되어있지 않으면 로그인 화면으로 보냄
  firebase.auth().onAuthStateChanged(user => {
    if(!user) {
      window.location.href = 'login.html';
    }
  });

  var user = firebase.auth().currentUser;

  $("#user_email").html("이메일: " + user.email);

  

  $("#user_username").html("유저네임: ");
  $("#user_sayhi").html("자기소개: ");


});
