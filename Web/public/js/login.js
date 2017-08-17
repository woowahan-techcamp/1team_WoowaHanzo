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

  $(".modal_close").on("click", function() {
    $(".error_modal").css("display", "none");
  });
});

function login() {
  var email = $("#email").val();
  var password = $("#password").val();

  if(email && password) {
    firebase.auth().signInWithEmailAndPassword(email, password)
    .then(function(confirmationResult) {
      window.location.href = "index.html";
    })
    .catch(function(error) {
      // Handle Errors here.
      var errorCode = error.code;
      var errorMessage = error.message;

      showLoginErrorModal(errorCode);
    });
  }
  else {
    showLoginErrorModal("이메일과 비밀번호를 입력해주십시오.");
  }
}

function showLoginErrorModal(errorCode) {
  $(".error_modal").css("display", "block");
  $(".modal_content").html(returnCustomLoginErrorMessage(errorCode));
}

function returnCustomLoginErrorMessage(errorCode) {
  if(errorCode == "auth/invalid-email") {
    return "이메일 형식이 맞지 않습니다."
  }
  else if(errorCode == "auth/user-disabled") {
    return "사용이 불가능 한 계정입니다."
  }
  else if(errorCode == "auth/user-not-found") {
    return "해당 계정이 존재하지 않습니다."
  }
  else if(errorCode == "auth/wrong-password") {
    return "비밀번호를 확인해 주십시오."
  }
  else {
    return errorCode
  }
}
