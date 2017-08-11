document.addEventListener("DOMContentLoaded", function(event) {
  console.log("DOM fully loaded and parsed");

  autosize($("textarea"));

  $(".textbox").focus();

  $(".tags_holder").append('<span class="tagger tag_holder">' +
                '<span class="starting_sharp">#</span>' +
                '<input type="text" class="tagger_input" placeholder="" spellcheck="false" />' +
              '</span>');

  $(".tagger_input").val("태그");
  $(".tagger_input").autoGrowInput({minWidth:1,comfortZone:3});
  $(".tagger_input").trigger("input");
  $(".tagger_input").last().on("keyup", function(evt) {
    taggerKeyup(evt);
  });

  $(".tagger_input").last().on("keydown", function(evt) {
    taggerKeyDown(evt);
  });

  $(".tagger_input").last().on("focus", function(evt){
    $(".tagger_input").last().off("focus");
    $(".tagger_input").last().val("");
    $(".tagger_input").trigger("update");
  });

  $(".tag_holder").on("click", function(evt) {
    $(this).children(".tagger_input").focus();
  });

  $(".post_submit").on("click", function(evt) {
    uploadPost();
  });

  var imageInput = document.getElementById("image_input");

  imageInput.addEventListener('change', function(evt) {
    imageHandle(evt);

    resizeThumbnails();
  });

  $(".add_photos").on("click", function() {
    $(imageInput).click();
  });

});

var keyCodes = [13, 32];

function taggerKeyup(evt) {
  var $curElem = $(evt.target);

  var buffer = $curElem.val().trim(" ");
  var actual = $curElem.last().val();

  if(evt.target.text != undefined) {
    if(evt.target.text.length == 0 && evt.keyCode == 8 && actual.length == 0 && $(".tagger_input").length > 1) {
      if($(evt.target.parentElement).prev()) {
        $(evt.target.parentElement).prev().children(".tagger_input").focus();
      } else {
        $(evt.target.parentElement).next().children(".tagger_input").focus();
      }
      $(evt.target.parentElement).remove();
      return;
    }
  }



  if(buffer.length == 0) {
    $curElem.last().val(buffer);
  }

  if((buffer.length > 0 && (buffer.length < actual.length || keyCodes.indexOf(evt.keyCode) >= 0))) {

    buffer = buffer.split(" ").join("");
    $curElem.val(buffer);

    if(!isLastTaggerEmpty()) {
      $curElem.parent().addClass("tagger_complete");
      //$(".tagger_input").last().prop("readonly", true);
      $(".tags_holder").append('<span class="tagger tag_holder">' +
                    '<span class="starting_sharp">#</span>' +
                    '<input type="text" class="tagger_input" placeholder="" spellcheck="false" />' +
                  '</span>');
      $(".tagger_input").last().autoGrowInput({minWidth:1,comfortZone:3});
      $(".tagger_input").last().trigger("update");
      $(".tagger_input").last().focus();

      $(".tagger_input").last().on("keyup", function(evt) {
        taggerKeyup(evt);
      });

      $(".tagger_input").last().on("keydown", function(evt) {
        taggerKeyDown(evt);
      });
    }
  }
}

function taggerKeyDown(evt) {
  var $curElem = $(evt.target);


  var buffer = $curElem.val().trim(" ");
  var actual = $curElem.last().val();

  evt.target.text = buffer;
}

function isLastTaggerEmpty() {
  var buffer = $(".tagger_input").last().val().trim(" ");
  if(buffer.length == 0) {
    return true;
  }
  return false;
}

function refineText(text) {
  var ret = text.trim();
  return ret;
}

var imageList = [];

function imageHandle(evt) {

  // resetting imageList
  imageList = [];

  var templatetext = document.querySelector("#image_preview").innerHTML;
  var template = Handlebars.compile(templatetext);

  var fileInput = document.getElementById('image_input');

  var files = evt.target.files;
  var i = 0;
  var f;
  console.log("FILEINPUT: "+fileInput.files.length);
  for(i = 0, f; f = files[i]; i++) {

    if (!f.type.match('image.*')) {
      continue;
    }

    var reader = new FileReader();
    reader.id = i;

    $(".container_box").append(template(reader));

    if($(".image_thumbnails tr").last().children("td").length < 3) {
      $(".image_thumbnails tr").last().append(template(reader));
    } else {
      $(".image_thumbnails").append("<tr></tr>");
      $(".image_thumbnails tr").last().append(template(reader));
    }

    var filename = "";
    reader.onload = function(e) {

      var fileDisplayArea = document.getElementById(this.id.toString());

      fileDisplayArea.innerHTML = "";
      // Create a new image.
      var img = new Image();
      // Set the img src property using the data URL.
      img.src = this.result;

      // hide image until rotation is figured out
      $('#' + this.id).attr('display', 'none');

      $('#' + this.id).attr('src', img.src);


      fixExifOrientation($(img));
      // Add the image to the page.

      var fullPath = fileInput.value;
      if (fullPath) {
        var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
        filename = fullPath.substring(startIndex);
        if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
          filename = filename.substring(1);
        }
      }

      fileDisplayArea.appendChild(img);

      var newfilename = (new Date().getTime()).toString() + '.' + filename.split('.')[1];

      img.filename = filename;

      var newImage = {};
      newImage.filename = newfilename;
      newImage.image = files[this.id];

      imageList.push(newImage);


      // what to do during image load
      img.addEventListener("load", function() {
        resizeThumbnails();
        console.log(imageList);
      });

    }
    reader.readAsDataURL(f);

  }

}

function uploadPost() {
  var postText = refineText($(".textbox").first().val());
  var postTags = [];
  $(".tagger_input").each(function(index) {
    var tagValue = refineText($(this).val());
    if(tagValue.length > 0) {
      postTags.push(refineText(tagValue));
    }
  });

  var promise = writeNewPost("아무거나", "jhyang12345", postText, postTags);
  promise.then(function() {
     window.location="./index.html";
  });
}

function writeNewPost(uid, username, body, tags) {
  var promises = [];

  // A post entry.
  var postData = {
    author: username,
    uid: uid,
    body: body,
    tags: tags,
    time: -Date.now(),
    images: [],
    starCount: 0
  };

  var storageRef = firebase.storage().ref();

  for(var i = 0; i < imageList.length; ++i) {
    var image = imageList[i].image;
    var filename = imageList[i].filename;
    postData.images.push(filename);
    var imageRef = storageRef.child('images/' + filename);
    promises.push(imageRef.put(image));
  }

  console.log(postData);
  // Get a key for a new Post.
  var newPostKey = firebase.database().ref().child('posts').push().key;

  // Write the new post's data simultaneously in the posts list and the user's post list.
  var updates = {};
  updates['/posts/' + newPostKey] = postData;
  //updates['/user-posts/' + uid + '/' + newPostKey] = postData;

  promises.push(firebase.database().ref().update(updates));
  return Promise.all(promises);
}
