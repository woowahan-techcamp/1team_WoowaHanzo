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
      // console.log('itmem', item.val());

      promises.push(downloadUrl.then(function(url) {
        itemObject.userProfileImg = url;
        itemObject.uid = item.key;
        console.log(itemObject.uid);
        if(item.val().rankName && item.val().rankName === "신선") {
          itemObject.titlePic = '<i class="fa fa-trophy" aria-hidden="true" style="color: gold"></i>';
        }
        else if(item.val().rankName && item.val().rankName === "왕족") {
          itemObject.titlePic = '<i class="fa fa-trophy" aria-hidden="true" style="color: silver"></i>';
        }
        else if(item.val().rankName && item.val().rankName === "양반") {
          itemObject.titlePic = '<i class="fa fa-trophy"  aria-hidden="true" style="color: Sienna"></i>';
        }
        else {
          itemObject.titlePic = '<i class="fa fa-trophy" aria-hidden="true"></i>';
        }
        itemObject.titleText = item.val().rankName ? item.val().rankName : "평민";
        itemObject.username = item.val().username;
        itemObject.like = item.val().likes ? item.val().likes : 0;

        itemList.push(itemObject);
        // console.log('itemObject', itemObject);
      }.bind(uid)));

    });

    Promise.all(promises).then(() => {
      console.log("continue");
      console.log(itemList);

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
