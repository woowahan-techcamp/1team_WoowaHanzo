var month = new Array();
month[0] = "1월";
month[1] = "2월";
month[2] = "3월";
month[3] = "4월";
month[4] = "5월";
month[5] = "6월";
month[6] = "7월";
month[7] = "8월";
month[8] = "9월";
month[9] = "10월";
month[10] = "11월";
month[11] = "12월";

function getDatelabel(timestamp) {
	var d = new Date(timestamp);

	var datelabel = (month[d.getMonth()]) + ' ' + d.getDate() + '일, ' + d.getFullYear() + "년";
	return datelabel;
}

function getCurrentTime(time) {
	var timeago;
	if(($.now() - time) > 24 * 3600000) {
		if(parseInt(($.now() - time) / (24 * 3600000)) > 1) {
			timeago = getDatelabel(time);//parseInt(($.now() - time) / (24 * 3600000)).toString() + ' days';

		} else {
			timeago = getDatelabel(time); //parseInt(($.now() - time) / (24 * 3600000)).toString() + ' day';

		}
	} else if (($.now() - time) > 3600000) {
		if(parseInt(($.now() - time) / 3600000) > 1) {
				timeago = parseInt(($.now() - time) / 3600000).toString() + '시간';
		} else{
			timeago = parseInt(($.now() - time) / 3600000).toString() + '시간';
		}
		timeago += " 전";

	} else if (($.now() - time) > 60000) {
		if(parseInt(($.now() - time) / 60000) > 1) {
			timeago = parseInt(($.now() - time) / 60000).toString() + '분';
		} else {
			timeago = parseInt(($.now() - time) / 60000).toString() + '분';
		}
		timeago += " 전";
	} else {
		timeago = parseInt(($.now() - time) / 1000).toString() + '초';
		timeago += " 전";
	}
	return timeago;
}

function isScrolledIntoView(elem) {
    var $elem = $(elem);
    var $window = $(window);

    var docViewTop = $window.scrollTop();
    var docViewBottom = docViewTop + $window.height();

    var elemTop = $elem.offset().top;
    var elemBottom = elemTop + $elem.height();

    return ((( elemTop >= docViewTop) && (elemTop <= docViewBottom)) || ((elemBottom >= docViewTop) && (elemBottom <= docViewBottom)));
}

function prevLoaded($curPost) {
  if($curPost.prev().length == 0) {
    return true;
  } else {
    if($curPost.prev().css("opacity") == 1) {
      return true;
    } else {
      return false;
    }
  }
}

function fadeInPost($curPost) {
	$curPost.css("display", "block");
	resizeThumbnails();
	$curPost.animate({
		opacity: 1.0
	}, 200, function() {
		if(this.next().length != 0) {
			this.next().trigger("postLoaded");
		}
		resizeThumbnails();
	}.bind($curPost));

}

function findParent (elem, cls) {
    while ((elem = elem.parentElement) && !elem.classList.contains(cls));
    return elem;
}

function imagesAllLoaded(curImage) {
	try {
		curImage.classList.add("loaded");
		var imageParent = findParent(curImage, "post");//curImage.parentElement.parentElement.parentElement;
		var allImages = imageParent.querySelectorAll(".loading");

		var allLoaded = true;
		for(var i = 0; i < allImages.length; ++i) {
			if(!$(allImages[i]).hasClass("loaded")) {
				allLoaded = false;
			}
		}
		return allLoaded;

	} catch(err) {
		return false;
	}

}

function handleThumbnailNumber($curPost, imagenumber) {
	var thumbnail_cover = $curPost[0].querySelector(".thumbnail_cover");
	if(imagenumber < 4) {
		thumbnail_cover.style.display = "none";
	} else {
		thumbnail_cover.innerHTML = "+" + (imagenumber - 3);
		thumbnail_cover.addEventListener("click", function(evt) {
			var thumbnail = evt.target.parentElement;
			var image = thumbnail.querySelector("img");
			image.click();
		})
	}


}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function fixExifOrientation($img) {

    $img[0].addEventListener("load", function() {


        EXIF.getData($img[0], function() {

            switch(parseInt(EXIF.getTag(this, "Orientation"))) {
                case 2:
                    $img.addClass('flip');
										break;
                case 3:
                    $img.addClass('rotate-180');
										break;
                case 4:
                    $img.addClass('flip-and-rotate-180');
										break;
                case 5:
                    $img.addClass('flip-and-rotate-270');
										$img.parent().css('height', $img.get(0).getBoundingClientRect().height);
										console.log($img.get(0).getBoundingClientRect().height);
										$img.css('margin-top', Math.abs($img.get(0).getBoundingClientRect().height - $img.height()) / 2);
										$img.parent().css('display', 'block');
										break;
                case 6:
                    $img.addClass('rotate-90');
										$img.parent().css('height', $img.get(0).getBoundingClientRect().height);
										console.log($img.get(0).getBoundingClientRect().height);
										$img.css('margin-top', Math.abs($img.get(0).getBoundingClientRect().height - $img.height()) / 2);
										$img.parent().css('display', 'block');
										break;
                case 7:
                    $img.addClass('flip-and-rotate-90');
										$img.parent().css('height', $img.get(0).getBoundingClientRect().height);
										console.log($img.get(0).getBoundingClientRect().height);
										$img.css('margin-top', Math.abs($img.get(0).getBoundingClientRect().height - $img.height()) / 2);
										$img.parent().css('display', 'block');
										break;
                case 8:
                    $img.addClass('rotate-270');
										$img.parent().css('height', $img.get(0).getBoundingClientRect().height);
										console.log($img.get(0).getBoundingClientRect().height);
										$img.css('margin-top', Math.abs($img.get(0).getBoundingClientRect().height - $img.height()) / 2);
										$img.parent().css('display', 'block');
										break;
            }
        });

    });

}


function resizeThumbnails() {
  $(".image_thumbnails td").each(function(index, elem) {"click touchstart"
		var thumbnailHolder = elem.parentElement;
		var td = thumbnailHolder.querySelector("td");
    var bufferWidth = td.offsetWidth;
    elem.style.height = bufferWidth + "px";
		var thumbnail_cover = elem.querySelector(".thumbnail_cover");
    if(thumbnail_cover) {
        thumbnail_cover.style.lineHeight = bufferWidth - 20 + "px";
    }

  });
}

function showGallery(urls, i) {
	$("#justblackbackground").css("display", "block");
	$("#galleryoverlay").css("display", "block");
	$("#actualimage").css("display", "block");
	$("#actualimage").attr("src", urls[i]);
	pageObject.galleryURLs = urls;
	pageObject.galleryIndex = i;
	$(window).resize();
}

function galleryLeft() {
	$(window).resize();
	var curIndex = pageObject.galleryIndex;
	var galleryLength = pageObject.galleryURLs.length;
	if(curIndex == 0) {
		curIndex = galleryLength - 1;
	} else {
		curIndex -= 1;
	}
	pageObject.galleryIndex = curIndex;
	$("#actualimage").attr("src", pageObject.galleryURLs[curIndex]);
	$(window).resize();

}

function galleryRight() {
	var curIndex = pageObject.galleryIndex;
	var galleryLength = pageObject.galleryURLs.length;
	if(curIndex == galleryLength - 1) {
		curIndex = 0;
	} else {
		curIndex += 1;
	}
	pageObject.galleryIndex = curIndex;
	$("#actualimage").attr("src", pageObject.galleryURLs[curIndex]);
	$(window).resize();
}

function addTagListeners(curPost) {
	var tags = curPost.querySelectorAll(".tagger");
	for(var i = 0; i < tags.length; ++i) {
		tags[i].addEventListener("click", function(evt) {
			console.log(evt.target.innerHTML.trim());
			var tagValue = evt.target.innerHTML.trim();
			var queryKey = firebase.database().ref().child("tagQuery").push().key;

			var update = {};
			update["/tagQuery/" + queryKey + '/tag'] = tagValue;
			update["/tagQuery/" + queryKey + '/queryResult'] = [1];
			firebase.database().ref().update(update).then(evt => {
				console.log("Query made!");
				window.location.href = "./index.html?tagQuery=" + queryKey;
			});
		});
	}
}

function loadUserProfile(uid) {
	var storageRef = firebase.storage().ref();
	var ref = firebase.database().ref("/users/" + uid);

	ref.once('value').then(function(snapshot) {
		if(snapshot.val().profileImg) {
			pageObject.userProfileImage[this.uid] = snapshot.val().profileImg;
			var downloadUrl = storageRef.child("profileImages/" + pageObject.userProfileImage[this.uid]).getDownloadURL();
			downloadUrl.then(function(url) {
				var curPost = this.curPost;
				var profilePic = curPost.querySelector("." + this.queryClass);
				profilePic.classList.add("loading");
				profilePic.src = url;
				profilePic.onload = function(evt) {

					if(prevLoaded(this) && imagesAllLoaded(evt.target)) {
						$(".buttons_holder").css("display", "block");
					 	fadeInPost(this);
					}
				}.bind($(curPost));
			}.bind(this));
		} else {
			pageObject.userProfileImage[this.uid] = "pictures/profile.png";
			var curPost = this.curPost;
			var profilePic = curPost.querySelector("." + this.queryClass);
			profilePic.classList.add("loading");
			profilePic.src = pageObject.userProfileImage[this.uid];
			profilePic.onload = function(evt) {

				if(prevLoaded(this) && imagesAllLoaded(evt.target)) {
				 	console.log("fadeIn through profile");
					// if($(".buttons_holder")) {
					// 	$(".buttons_holder").css("display", "block");
					// }
					// if($(".nav_user_info")) {
					// 	$(".nav_user_info").css("display", "block");
					// }
				 	fadeInPost(this);
				}
			}.bind($(curPost));
		}

	}.bind(this));
}

var count = 0;

function loadPosts(snapshot) {
  var storageRef = firebase.storage().ref();

  var buffer = snapshot.val();
  buffer.id = snapshot.key;	//post의 id

  pageObject.postTimes[buffer.id] = -buffer["time"];
  pageObject.postState[buffer.id] = false;
	if(buffer.images) {
		pageObject.imageUrls[buffer.id] = new Array(buffer.images.length);
	} else {
		pageObject.imageUrls[buffer.id] = [];
	}

  // replacing new lines with line breaks
  buffer["body"] = buffer["body"].replace(/\n/g, "<br>");
  buffer["time"] = getCurrentTime(-buffer["time"]);

	if(!$("#post_" + buffer.id).length) {
		$(".container_box").append(pageObject.postTemplate(buffer));
	}
	else {
		$(".loading-indicator-box").css("display", "none");
	}

  var $curPost = $("#post_" + buffer.id);

	var curPost = document.querySelector("#post_" + buffer.id);
	var curObject = {};
	curObject.curPost = curPost;
	curObject.uid = buffer.uid;
	curObject.queryClass = "profilePic";
	loadUserProfile.bind(curObject, buffer.uid)();

	// add functionality to like button
	var like_button = curPost.querySelector(".like_btn");
	like_button.addEventListener("click", function(evt) {
		var id = evt.target.parentElement.parentElement.id;
		console.log(evt.target.parentElement.parentElement.id);

	});

  if(buffer.images) {
    // only three images are loaded at a time
    for(var i = 0; i < buffer.images.length || i < 3; ++i) {

      var $curObject = {};
      $curObject.$curPost = $curPost;
			$curObject.id = buffer.id;
      $curObject.i = i;
      var filename = buffer.images[i];
      if(i < buffer.images.length) {
        if(!filename) continue;
        var downloadUrl = storageRef.child('images/' + filename).getDownloadURL();
				downloadUrl.then(function(url) {
          pageObject.imageUrls[this.id][this.i] = url;

          var imageParent = this.$curPost.children("table").children("tbody").children("tr");

          imageParent = imageParent.children("td").get(this.i);
          imageParent = $(imageParent).children("div").children("img");
          imageParent.addClass("loading");

          imageParent.attr("src", url);

          imageParent.on("load", function(evt) {
            var curImage = evt.target;
            var allLoaded = imagesAllLoaded(curImage);

            if(prevLoaded(this.$curPost) && allLoaded) {
              fadeInPost(this.$curPost);
            }

          }.bind(this));

					imageParent.on("click touchstart", function(evt) {
						var curImage = evt.target;

						showGallery(pageObject.imageUrls[this.id], this.i);
					}.bind(this));

        }.bind($curObject)).catch(function(err) {
          console.log(err);
          console.log("File load unsuccessful");
        });

      } else if(i >= buffer.images.length) {
        var imageParent = $curPost.children("table").children("tbody").children("tr");

        imageParent = imageParent.children("td").get(i);
				imageParent.style.display = "none";

      } else {
        storageRef.child('images/' + filename).getDownloadURL().then(function(url) {
          pageObject.imageUrls[this.id][this.i] = url;

        }.bind($curObject)).catch(function(err) {
          console.log(err);
          console.log("File load unsuccessful");
        });
      }

    }

    $curPost.on("postLoaded", function(evt) {
      var currentPost = evt.target;
      var anyImage = currentPost.querySelector(".loading");

      if(prevLoaded($(currentPost)) && imagesAllLoaded(anyImage)) {
        fadeInPost($(evt.target));
      }

    });

    // handling the thumbnail cover along with the thumbnail number
    handleThumbnailNumber($curPost, buffer.images.length);

  } else {
    $curPost.on("postLoaded", function(evt) {
      var currentPost = evt.target;
			var anyImage = currentPost.querySelector(".loading");
			if(prevLoaded($(currentPost)) && imagesAllLoaded(anyImage)) {
				fadeInPost($(evt.target));
			}
    });

    $curPost.trigger("postLoaded");
    $curPost.children("table").remove();
    $curPost.addClass("ready");
  }
  // keeping the post invisible while loading
  $curPost.children(".post_body").html(buffer["body"]);
  if(buffer["tags"] && buffer["tags"].length == 0) {
    $curPost.children(".tags_holder").css("display", "none");
  }

	addTagListeners(curPost);

  resizeThumbnails();
}

document.addEventListener("DOMContentLoaded", function(evt) {
	var galleryoverlay = document.querySelector("#galleryoverlay");
	var holder = document.querySelector(".holder");
	var navleft = document.querySelector("#navleft");
	if($(".holder").length) {
		$('.holder').css('margin-top', galleryoverlay.offsetHeight / 2 - navleft.offsetHeight / 2 + 'px');
		$(window).resize(function() {
			$('.holder').css('margin-top', galleryoverlay.offsetHeight / 2 - navleft.offsetHeight / 2 + 'px');
		});

	}

	$(window).resize(function() {
		resizeThumbnails();
	});

	$("#galleryoverlay").on("click touchstart", function(evt) {
		$('#galleryoverlay').css('display', 'none');
		$('#justblackbackground').css('display', 'none');
		$('#actualimage').css('display', 'none');
		$("#navleft").css("opacity", 0.0);
		$("#navright").css("opacity", 0.0);
	});

	$("#actualimage").on("mousemove", function(evt) {
		var mouseX = evt.clientX;
		var actualimage = document.querySelector("#actualimage");
		mouseX -= actualimage.getBoundingClientRect().left;
		var width = actualimage.offsetWidth;
		if(mouseX < width / 2) {
			$("#navright").css("opacity", 0.0);
			$("#navleft").css("opacity", 1.0);
		} else {
			$("#navleft").css("opacity", 0.0);
			$("#navright").css("opacity", 1.0);
		}
	});

	$("#actualimage").on("mouseout", function(evt) {
		$("#navright").css("opacity", 0.0);
		$("#navleft").css("opacity", 0.0);
	});

	$("#navleft, #navright").on("mouseover", function(evt) {
		evt.target.style.opacity = 1.0;
	});

	$("#navleft, #navright").on("mouseout", function(evt) {
		evt.target.style.opacity = 0.0;
	});


	$("#actualimage").on("click touchstart", function(evt) {
		evt.stopPropagation();
		var mouseX = evt.clientX;
		var actualimage = document.querySelector("#actualimage");
		mouseX -= actualimage.getBoundingClientRect().left;
		var width = actualimage.offsetWidth;
		if(mouseX < width / 2) {
			$("#navleft").click();
		} else {
			$("#navright").click();
		}
	});

	$("#actualimage").on("load", function(evt) {
		$(window).resize();
	});

	$(window).resize(function() {
		$('#actualimage').css('top', $(window).height() / 2 - $('#actualimage').height() / 2  + 25 + 'px');
		$('#actualimage').css('left', $(window).width() / 2 - $('#actualimage').width() / 2  + 'px');
		$('#actualimage').css('max-height', $(window).height() - 50);
	});

	$(window).keydown(function(e) {
		if(e.keyCode == 37) {
			$('#navleft').click();
		} else if (e.keyCode == 39) {
			$('#navright').click();
		}
	});


	$("#navleft").on("click touchstart", function(evt) {
		evt.stopPropagation();
		galleryLeft();
	});

	$("#navright").on("click touchstart", function(evt) {
		evt.stopPropagation();
		galleryRight();
	});

});
