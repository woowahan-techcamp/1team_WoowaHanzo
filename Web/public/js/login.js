document.addEventListener("DOMContentLoaded", function(event) {
  var signinBtn = $(".signin");

  // firebase.auth().signOut().then(function() {
  //   // Sign-out successful.
  // }, function(error) {
  //   // An error happened.
  // });

  signinBtn.click(function() {
    console.log('clicked...');
    var email = $("#email").val();
    var password = $("#password").val();

    firebase.auth().signInWithEmailAndPassword(email, password).catch(function(error) {
      // Handle Errors here.
      var errorCode = error.code;
      var errorMessage = error.message;

      validate(errorMessage);


    });
    console.log(firebase.auth().currentUser.email);

  });


  function validate(error) {
    if(error) {
      alert(error);
      return false;
    }
    else {
      alert(firebase.auth().currentUser.email);
      return true;
    }
  }

});
