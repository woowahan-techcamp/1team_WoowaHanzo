document.addEventListener("DOMContentLoaded", function(event) {
  console.log('랭킹페이지');
  $("#ranking").css("color", "#fff");

  sortedUserList().then(function(userList) {
    var itemList = [];
    var storageRef = firebase.storage().ref();
    var promises = [];

    userList.forEach(function(item) {
      var itemObject = new Object();
      var downloadUrl = storageRef.child("profileImages/" + item.val().profileImg).getDownloadURL();

      var uid = item.val().uid;

      promises.push(downloadUrl.then(function(url) {
        itemObject.userProfileImg = url;
        itemObject.uid = item.key;
        itemObject.titlePic = getTitleIcon(item.val().rankName);
        itemObject.titleText = item.val().rankName ? item.val().rankName : "평민";
        itemObject.username = item.val().username;
        itemObject.like = item.val().likes ? item.val().likes : 0;

        itemList.push(itemObject);
      }.bind(uid)));

    });

    Promise.all(promises).then(() => {
      // console.log(itemList);

      itemList.sort(function (a, b) {
        if (a.like > b.like) return -1;
        if (a.like < b.like) return 1;
        return 0;
      });

      var source = document.getElementById("ranking_template").innerHTML;
      var template = Handlebars.compile(source);
      document.querySelector(".ranking_box").innerHTML += template(itemList);

      console.log('랭킹 다 불러짐..');
      $(".ranking_indicator").css("opacity", 0);
      $(".ranking_indicator").css("height", 0);

      var rankingArea = document.querySelectorAll(".ranking_item");
      addUserListener(rankingArea);
    });
  });

  Handlebars.registerHelper("counter", function (index){
    return index + 1;
  });

});

function sortedUserList() {
  return firebase.database().ref("users/").orderByChild("likes").once("value").then(function(snapshots) {
    var userList = [];
    snapshots.forEach(function(child) {
      userList.push(child);
    });
    userList.reverse();
    userList.forEach(function(child) {
      // console.log(child.val().username);
    });
    return userList;
  });
}

function addUserListener(item) {
	$(".ranking_box").delegate(item, "mousedown tap", function(evt){
    evt.preventDefault();
    // console.log('evt', $(evt.target).parent());
    var target = $(evt.target).parent()

    var id = getUIDFromPostHeader(target.attr("id"));

		var queryKey = firebase.database().ref().child("userQuery").push().key;
		var update = {};
		update["/userQuery/" + queryKey + "/uid"] = id;
		update["/userQuery/" + queryKey + "/queryResult"] = ["1"];
		firebase.database().ref().update(update).then(evt => {
			window.location.href = "./mypage.html?userQuery=" + queryKey;
		});
	});
}
