document.addEventListener("DOMContentLoaded", function(event) {
  $("#ranking").css("color", "#fff");

  sortedUserList().then(function(userList) {
    var itemList = [];
    var storageRef = firebase.storage().ref();
    var promises = [];

    userList.forEach(function(item) {
      var itemObject = new Object();

      var downloadUrl = storageRef.child("profileImages/" + item.val().profileImg).getDownloadURL();

      promises.push(downloadUrl.then(function(url) {
        itemObject.userProfileImg = url;
        // console.log('????');
        itemObject.uid = this.key;
        itemObject.titlePic = getTitleIcon(this.val().rankName);
        itemObject.titleText = this.val().rankName ? this.val().rankName : "평민";
        itemObject.username = this.val().username;
        itemObject.like = this.val().likes ? this.val().likes : 0;

        itemList.push(itemObject);
      }.bind(item)).catch(function(err) {
        itemObject.userProfileImg = "./pictures/profile.png";
        itemObject.uid = this.key;
        itemObject.titlePic = getTitleIcon(this.val().rankName);
        if(this.val().rankName) {
          itemObject.titleText = this.val().rankName;
        } else {
          itemObject.titleText = "평민";
          itemObject.titleBlank = true;
        }
        itemObject.username = this.val().username;
        itemObject.like = this.val().likes ? this.val().likes : 0;

        itemList.push(itemObject);
      }.bind(item)));

    });

    Promise.all(promises).then(() => {
      itemList.sort(function (a, b) {
        if (a.like > b.like) return -1;
        if (a.like < b.like) return 1;
        return 0;
      });

      var likesToName = {};
      var likesToIcon = {};
      for(var i = 0; i < itemList.length; ++i) {
        var item = itemList[i];
        if(!item.titleBlank) {
          likesToName[item.likes] = item.titleText;
          likesToIcon[item.likes] = item.titlePic;
        }
      }
      for(var i = 0; i < itemList.length; ++i) {
        var item = itemList[i];
        if(item.titleBlank) {
          item.titleText = likesToName[item.likes];
          item.titlePic = likesToIcon[item.likes];
        }
      }

      var source = document.getElementById("ranking_template").innerHTML;
      var template = Handlebars.compile(source);
      document.querySelector(".ranking_box").innerHTML += template(itemList);

      $(".ranking_indicator").css("opacity", 0);
      $(".ranking_indicator").css("height", 0);

      $(".ranking_indicator").on("transitionend", function() {
        $(".ranking_indicator").css("display", "none");
      });

      var rankingArea = document.querySelectorAll(".ranking_item");
      addUserListener(rankingArea);

      var pics = document.querySelectorAll(".ranking_profile_pic");

      pics.forEach(function(item) {
        item.addEventListener("load", function(evt) {
          if(!imageDimensions(evt.target)) {
            evt.target.classList.add("circularLongImage");
          } else {
            evt.target.classList.remove("circularLongImage");
          }
        });
      });

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

    return userList;
  });
}

function addUserListener(item) {
	$(".ranking_box").delegate(item, "mousedown tap", function(evt){
    evt.preventDefault();

    if(!$(evt.target).hasClass("ranking_item")) {
      $(evt.target).parent().trigger("mousedown");
      return;
    }

    var target = $(evt.target)
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
