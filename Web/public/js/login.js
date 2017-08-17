document.addEventListener("DOMContentLoaded", function(event) {
  var signinBtn = $(".signin");

  signinBtn.click(function() {
    login();
  });

  $("body").on("keypress", function(evt) {
    var keycode = evt.keyCode || evt.which;
    if(keycode == 13) {
      login();
    }
  });
});

function login() {
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
}
