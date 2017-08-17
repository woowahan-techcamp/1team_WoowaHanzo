document.addEventListener("DOMContentLoaded", function(event) {
  var emailFlag = false;
  var usernameFlag = false;
  var passwordFlag = false;
  var password2Flag = false;

  $("#email").on("keyup keydown blur update input", function() {
    if($("#email").val()!=="" && !isEmail($("#email").val())) {
      $("#email_error_msg").text("이메일 형식이 올바르지 않습니다.");
      emailFlag = false;
    }
    else {
      $("#email_error_msg").text("");
      emailFlag = true;
    }
    buttonEnable(emailFlag, usernameFlag, passwordFlag, password2Flag);
  });

  $("#username").on("keyup keydown blur update input", function() {
    if(!$("#username").val()) {
      $("#username_error_msg").text("필수 입력값입니다.");
      usernameFlag = false;
    }
    else {
      $("#username_error_msg").text("");
      usernameFlag = true;
    }
    buttonEnable(emailFlag, usernameFlag, passwordFlag, password2Flag);
  });

  $(".password").on("keyup keydown blur update input", function() {
    if(!$("#password").val()) {
      $("#password_error_msg").text("");
      passwordFlag = false;
    }
    else {
      if($("#password").val().length < 8) {
        $("#password_error_msg").text("비밀번호의 길이를 8자 이상으로 하십시오.");
        password2Flag = false;
      }
      else {
        $("#password_error_msg").text("");
        passwordFlag = true;
      }
    }

    if(!$("#password2").val()) {
      $("#password2_error_msg").text("");
      password2Flag = false;
    }
    else {
      if($("#password").val() != $("#password2").val()) {
        $("#password2_error_msg").text("비밀번호가 동일하지 않습니다.");
        password2Flag = false;
      }
      else {
        $("#password2_error_msg").text("");
        password2Flag = true;
      }
    }
    buttonEnable(emailFlag, usernameFlag, passwordFlag, password2Flag);
  });

  $("#sayhi").on("keyup keydown blur update input", function() {
    $(this).val($(this).val().substr(0, $(this).attr('maxlength')));
    $("#sayhi_length").text($("#sayhi").val().length + "/100");
  });

  $(".signup_btn").on("click", function() {
    var userEmail = $("#email").val();
    var userName = $("#username").val();
    var userPassword = $("#password").val();
    var userPassword2 = $("#password2").val();
    var userSayhi = $("#sayhi").val();

    firebase.auth().createUserWithEmailAndPassword(userEmail, userPassword)
    .then(function() {
      // firebase DB에 사용자의 한 마다(userSayhi)를 넣어줘야 함
      firebase.database().ref('users/' + firebase.auth().currentUser.uid).set({
        username: userName,
        email: userEmail,
        sayhi: userSayhi
      })
      .then(function() {
        console.log('user created.....');
        window.location.href="index.html"
      })
      .catch(function(error) {})
    })
    .catch(function(error) {
      // Handle Errors here.
      var errorCode = error.code;
      var errorMessage = error.message;
      // ...
      console.log(errorCode);
    });
  });
});

function isEmail(email) {
  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return regex.test(email);
}

function buttonEnable(ef, uf, pf, p2f) {
  if(ef && uf && pf && p2f) {
    $(".signup").css("background-color", "#70b6e5");
    $(".signup").removeAttr("disabled");
  }
  else {
    $(".signup").css("background-color", "#CCC");
    $(".signup").attr("disabled", "true");
  }
}
