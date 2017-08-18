// 로그인 되어있지 않으면 로그인 화면으로 보냄
firebase.auth().onAuthStateChanged(user => {
  if(!user) {
    window.location.href = 'login.html';
  }
});

document.addEventListener("DOMContentLoaded", function(event) {
  var templatetext = document.querySelector("#post_template").innerHTML;
  var template = Handlebars.compile(templatetext);
  pageObject.postTemplate = template;
  var currentUserName = "";

  firebase.auth().onAuthStateChanged(user => {
    if(user) {
      var username = firebase.database().ref("users/" + user.uid + "/username");
      username.on('value', function(snapshot) {
        currentUserName = snapshot.val();
        $(".mypage_username").html(currentUserName);
      });

      var sayhi = firebase.database().ref("users/" + user.uid + "/sayhi");
      sayhi.on('value', function(snapshot) {
        $(".mypage_user_sayhi").html(snapshot.val());
      });

      var rootRef = firebase.database().ref();
      var postRef = rootRef.child("posts");
      postRef.once("value", function(snapshot) {
        snapshot.forEach(function(child) {
          // child.val() 전체 포스트 가져옴
          if(child.val().author === currentUserName) {
            loadPosts(child);
          }
        });
        $(".container_box").css("opacity", 1);
      });

      $("#logout").on("click", function() {
        firebase.auth().signOut().then(function() {
          // Sign-out successful.
          alert("로그아웃 하셨습니다.");
        }, function(error) {
          // An error happened.
        });
      });

      $(".mypage_user_image_box img").on("click", function() {
          $("#profile_image_input").trigger("click");
      });

      $("#profile_image_input").on("change", function(evt) {
        profileImageHandle(this);

      });

    }
  });
});


var file = "";

function profileImageHandle(evt) {
  var fileInput = document.getElementById('profile_image_input');
  console.log('evt ', evt.files[0]);
  file = evt.files[0];

  if (evt.files && evt.files[0]) {
    var reader = new FileReader();

    var filename = "";
    reader.onload = function (evt) {
      // 사진 프리뷰
      $(".mypage_user_image_box img").attr('src', evt.target.result);

      var fullPath = fileInput.value;
      console.log('fullPath: ', fullPath);
      if (fullPath) {
        var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
        filename = fullPath.substring(startIndex);
        if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
          filename = filename.substring(1);
          console.log('filename: ', filename);
        }
      }

      var newfilename = (new Date().getTime()).toString() + '.' + filename.split('.')[1];
      console.log('newfilename: ', newfilename);
      //newfilename 프로필 사진이니까... 그냥 유저네임으로 할까..

      var storageRef = firebase.storage().ref();
      var profileRef = storageRef.child(filename);
      var profileImageRef = storageRef.child('profileImages/' + newfilename);

      profileImageRef.put(file).then(function(snapshot) {
        console.log('파일업로드함');
      });

      // database/users에 넣음
      firebase.database().ref('users/' + firebase.auth().currentUser.uid).update({
        profileImg: newfilename
      })
      .then(function() {
        console.log('users/profileImg에 사진이름 넣음');
      })
      .catch(function(error) {})

      // TODO
      // 이전 프로필 사진을 지워야 됨


    }
    reader.readAsDataURL(evt.files[0]);
  }
}
