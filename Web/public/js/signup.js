document.addEventListener("DOMContentLoaded", function(event) {
  var signupBtn = $(".signup_btn");

  signupBtn.click(function() {
    var userEmail = $("#email").val();
    var userName = $("#username").val();
    var userPassword = $("#password").val();
    var userPassword2 = $("#password2").val();
    var userSayhi = $("#sayhi").val();
    
    firebase.auth().createUserWithEmailAndPassword(userEmail, userPassword).catch(function(error) {
      // Handle Errors here.
      var errorCode = error.code;
      var errorMessage = error.message;
      // ...
      console.log(errorCode);
    });
  });

  console.log(firebase.auth().currentUser);
});
