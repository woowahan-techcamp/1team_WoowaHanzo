document.addEventListener("DOMContentLoaded", function(event) {
  var signinBtn = $(".signin");

  signinBtn.click(function() {
    var email = $("#email").val();
    var password = $("#password").val();

    firebase.auth().signInWithEmailAndPassword(email, password)
      .then(function(confirmationResult) {
        window.location.href = "index.html";
      })
      .catch(function(error) {
        // Handle Errors here.
        var errorCode = error.code;
        var errorMessage = error.message;

        alert(errorCode);
      });
  });


});
