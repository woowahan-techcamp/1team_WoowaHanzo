document.addEventListener("DOMContentLoaded", function(event) {

  var tagList;
  var promises = [];
  promises.push(firebase.database().ref("tagCounter/").once("value").then(function(snapshots) {
    tagList = Object.keys(snapshots.val());
  }));

  Promise.all(promises).then(() => {
    console.log("tags: ", tagList);
    var source = document.getElementById("tag_template").innerHTML;
    var template = Handlebars.compile(source);
    document.querySelector(".tags_holder").innerHTML += template(tagList);
  });





});
