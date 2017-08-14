document.addEventListener("DOMContentLoaded", function(event) {
  $("#email").on("keyup keydown blur update input", function() {
    if(!isEmail($("#email").val())) {
      $("#email_error_msg").text("이메일 형식이 올바르지 않습니다.");
    }
    else {
      $("#email_error_msg").text("");
    }
  });

  $("#username").on("keyup keydown blur update input", function() {
    if(!$("#username").val()) {
      $("#username_error_msg").text("필수 입력값입니다.");
    }
    else {
      $("#username_error_msg").text("");
    }
  });

  $(".password").on("keyup keydown blur update input", function() {
    if(!$("#password").val()) {
      $("#password_error_msg").text("필수 입력값입니다.");
    }
    else {
      if($("#password").val().length < 8) {
        $("#password_error_msg").text("비밀번호의 길이를 8자 이상으로 하십시오.");
      }
      else {
        $("#password_error_msg").text("");
      }
    }

    if(!$("#password2").val()) {
      $("#password2_error_msg").text("필수 입력값입니다.");
    }
    else {
      if($("#password").val() != $("#password2").val()) {
        $("#password2_error_msg").text("비밀번호가 동일하지 않습니다.");
      }
      else {
        $("#password2_error_msg").text("");
      }
    }
  });

  $(".signup_btn").on("click", function() {
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

function isEmail(email) {
  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  console.log(regex.test(email));
  return regex.test(email);
}
