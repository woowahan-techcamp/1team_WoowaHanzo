document.addEventListener("DOMContentLoaded", function(event) {
  console.log('랭킹페이지');

  sortedUserList().then(function(userList) {
    var itemList = [];
    var storageRef = firebase.storage().ref();
    var promises = [];
    console.log('user... ', userList[0].val());

    userList.forEach(function(item) {
      var itemObject = new Object();
      var downloadUrl = storageRef.child("profileImages/" + item.val().profileImg).getDownloadURL();

      promises.push(downloadUrl.then(function(url) {
        itemObject.userProfileImg = url;
        itemObject.titlePic = '<i class="fa fa-car" aria-hidden="true"></i>';
        itemObject.titleText = item.val().rankName ? item.val().rankName : "평민";
        itemObject.username = item.val().username;
        itemObject.like = item.val().likes ? item.val().likes : 0;

        itemList.push(itemObject);
      }));

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
      document.querySelector(".container_box").innerHTML += template(itemList);
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
