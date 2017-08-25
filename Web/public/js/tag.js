document.addEventListener("DOMContentLoaded", function(event) {
  $("#tag").css("color", "#fff");

  var tagList = [];
  var tagNameList = [];
  var tagTimeList = [];
  var promises = [];

  var source = document.getElementById("tag_template").innerHTML;
  var template = Handlebars.compile(source);

  firebase.database().ref("tagCounter/").orderByChild("time").on("child_added", function(snapshot) {
    handleTagSnapshot(snapshot, template);

  });

  firebase.database().ref("tagCounter/").orderByChild("time").on("child_changed", function(snapshot) {
    handleTagSnapshot(snapshot, template);

  });

  setTimeout(function() {
    $(".tag_indicator").css("opacity", 0);
    $(".tag_indicator").css("height", 0);


  }, 600);

});

var futureTime = undefined;
var pastTime = undefined;

function searchAndRemoveTag(container, value) {
  var tags = container.querySelectorAll(".tagger");
  for(var i = 0; i < tags.length; ++i) {
    if(tags[i].innerHTML.trim() == value)
      $(tags[i]).remove();
  }
}

function handleTagSnapshot(snapshot, template) {
  var tag = {};
  tag.tagName = snapshot.key;
  var time = -snapshot.val().time;

  searchAndRemoveTag(document.querySelector(".tags_holder"), tag.tagName);

  if(time > futureTime) {
    $(".tags_holder").prepend(template(tag));
    gradualShow($(".tagger").first());
  } else {
    $(".tags_holder").append(template(tag));
    gradualShow($(".tagger").last());
    $(".tag_box").css("border", "1px solid #CCC");
  }

  if(!futureTime || time > futureTime) {
    futureTime = time;
  }
  if(!pastTime || time < pastTime) {
    pastTime = time;
  }
  addTagListener($(".tagger").last());
}

function addTagListener($tag) {

		$tag.on("mousedown tap", function(evt) {
			evt.preventDefault();
			var tagValue = evt.target.innerHTML.trim();
			var queryKey = firebase.database().ref().child("tagQuery").push().key;

			var update = {};
			update["/tagQuery/" + queryKey + '/tag'] = tagValue;
			update["/tagQuery/" + queryKey + '/queryResult'] = ["1"];
			firebase.database().ref().update(update).then(evt => {
				window.location.href = "./index.html?tagQuery=" + queryKey;
			});
		});
}

function gradualShow($tag) {
  $tag.animate({
    opacity: 1.0
  }, 200);
}
