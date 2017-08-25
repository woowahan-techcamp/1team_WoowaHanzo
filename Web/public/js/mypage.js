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

  var url = window.location.href;

  firebase.auth().onAuthStateChanged(user => {
    var queryUid;
    var promises = [];
    if(getParameterByName("userQuery", url)) {
      var queryKey = getParameterByName("userQuery", url);

      promises.push(firebase.database().ref("/userQuery/" + queryKey).once("value", function(snapshot) {
        queryUid = snapshot.val().uid;
        var postIdList = snapshot.val().queryResult.slice(1,snapshot.val().length);
        var promises = postIdList.map(function(key) {
          return firebase.database().ref("/posts/").child(key).once("value");
        });

        return Promise.all(promises).then(function(snapshots) {
          snapshots.forEach(function(snapshot) {
            loadPosts(snapshot, false);
          });
        });
      }));

    } else if(user) {
      queryUid = user.uid;
      $(".mypage_setting").on("click", function() {

        firebase.auth().signOut().then(function() {
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

      var postRef = firebase.database().ref("/posts");
      promises.push(
        postRef.orderByChild("time").on("child_added", function(snapshot) {
          if(snapshot.val().author === currentUserName) {
            loadPosts(snapshot, false);
          }
        })
      );
    }

    Promise.all(promises).then(function() {
      var username = firebase.database().ref("users/" + queryUid + "/username");
      username.on('value', function(snapshot) {
        currentUserName = snapshot.val();
        $(".mypage_username").html(currentUserName);
      });

      var sayhi = firebase.database().ref("users/" + queryUid + "/sayhi");
      sayhi.on('value', function(snapshot) {
        var tmp = snapshot.val() ?'"' + snapshot.val() + '"' : "자기소개가 없습니다.";
        $(".mypage_user_sayhi").html(tmp);
        $(".container_box").css("opacity", 1);
      });

      var title = firebase.database().ref("users/" + queryUid + "/rankName");
      title.on('value', function(snapshot) {
        if(snapshot.val()) {
          $(".mypage_user_title").html(getTitleIcon(snapshot.val()) + snapshot.val());
        }
        else {
          $(".mypage_user_title").html(getTitleIcon(snapshot.val()) + "평민");
        }
      });


      if(queryUid != user.uid) {
        $(".mypage_setting").css("display", "none");
      }


      var curObject= {};
      var curPost = document.querySelector(".mypage_user_box");
      curObject.curPost = curPost;

      curObject.uid = queryUid;
      curObject.queryClass = "mypage_user_profilePic";
      loadUserProfile.bind(curObject, queryUid)();
    });
  });

});

function changeProfileRelatedImages(src) {
  $(".profilePic").attr("src", src);
  $(".nav_user_img").attr("src", src);
}


var file = "";

function profileImageHandle(evt) {
  var fileInput = document.getElementById('profile_image_input');
  file = evt.files[0];

  if (evt.files && evt.files[0]) {
    var reader = new FileReader();

    var filename = "";
    reader.onload = function (evt) {
      // 사진 프리뷰
      $(".mypage_user_image_box img").attr('src', evt.target.result);
      $(".mypage_user_image_box img").on("load", function(evt) {
        if(!imageDimensions(evt.target)) {
          evt.target.classList.add("circularLongImage");
        } else {
          evt.target.classList.remove("circularLongImage");
        }
        changeProfileRelatedImages($(evt.target).attr("src"));
      });



      var fullPath = fileInput.value;
      if (fullPath) {
        var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
        filename = fullPath.substring(startIndex);
        if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
          filename = filename.substring(1);
        }
      }

      var newfilename = firebase.auth().currentUser.uid + '.' + filename.split('.')[1];
      //newfilename 프로필 사진이니까... 그냥 유저네임으로 할까..

      var storageRef = firebase.storage().ref();
      var profileRef = storageRef.child(filename);
      var profileImageRef = storageRef.child('profileImages/' + newfilename);

      profileImageRef.put(file).then(function(snapshot) {
      });

      // database/users에 넣음
      firebase.database().ref('users/' + firebase.auth().currentUser.uid).update({
        profileImg: newfilename
      })
      .then(function() {
      })
      .catch(function(error) {})

      // TODO
      // 이전 프로필 사진을 지워야 됨


    }
    reader.readAsDataURL(evt.files[0]);
  }
}
