document.addEventListener("DOMContentLoaded", function(event) {
  var signinBtn = $(".signin");

  signinBtn.click(function() {
    console.log('clicked...');
    var email = $("#email").val();
    var password = $("#password").val();

    firebase.auth().signInWithEmailAndPassword(email, password).catch(function(error) {
      // Handle Errors here.
      var errorCode = error.code;
      var errorMessage = error.message;
      // ...
      console.log(errorMessage);

    });

    // console.log(firebase.auth().currentUser.email);

  });


});
