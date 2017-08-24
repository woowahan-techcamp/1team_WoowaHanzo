document.addEventListener("DOMContentLoaded", function(event) {
  var tagList = [];
  var tagNameList = [];
  var tagTimeList = [];

  firebase.database().ref("tagCounter/").orderByChild("time").once("value").then(function(snapshots) {
    snapshots.forEach(function(child) {
      tagNameList.push(child.key);
      tagTimeList.push(getCurrentTime(child.val().time));
    });

    tagNameList.reverse();
    tagTimeList.reverse();

    tagList = new Array(tagNameList.length);

    for(var i = 0; i < tagNameList.length; i++) {
      var tmpObject = {};
      tmpObject.tagTime = tagTimeList[i];
      tmpObject.tagName = tagNameList[i];
      tagList[i] = tmpObject;
    }

    var source = document.getElementById("tag_template").innerHTML;
    var template = Handlebars.compile(source);
    document.querySelector(".tags_holder").innerHTML += template(tagList);

    var curPost = document.querySelector(".container_box");
    addTagListeners(curPost);
  });

});
