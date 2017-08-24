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
	}, 300, function() {
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
		$(thumbnail_cover).on("mousedown tap", function(evt) {
			evt.preventDefault();
			var thumbnail = evt.target.parentElement;
			var image = thumbnail.querySelector("img");
			$(image).trigger("mousedown");
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
										$img.css('margin-top', Math.abs($img.get(0).getBoundingClientRect().height - $img.height()) / 2);
										$img.parent().css('display', 'block');
										break;
                case 6:
                    $img.addClass('rotate-90');
										$img.parent().css('height', $img.get(0).getBoundingClientRect().height);
										$img.css('margin-top', Math.abs($img.get(0).getBoundingClientRect().height - $img.height()) / 2);
										$img.parent().css('display', 'block');
										break;
                case 7:
                    $img.addClass('flip-and-rotate-90');
										$img.parent().css('height', $img.get(0).getBoundingClientRect().height);
										$img.css('margin-top', Math.abs($img.get(0).getBoundingClientRect().height - $img.height()) / 2);
										$img.parent().css('display', 'block');
										break;
                case 8:
                    $img.addClass('rotate-270');
										$img.parent().css('height', $img.get(0).getBoundingClientRect().height);
										$img.css('margin-top', Math.abs($img.get(0).getBoundingClientRect().height - $img.height()) / 2);
										$img.parent().css('display', 'block');
										break;
            }
        });

    });

}


function resizeThumbnails() {
  $(".image_thumbnails td").each(function(index, elem) {
		var thumbnailHolder = elem.parentElement;
		var td = thumbnailHolder.querySelector("td");
    var bufferWidth = td.offsetWidth;
    elem.style.height = bufferWidth + "px";
		var thumbnail_cover = elem.querySelector(".thumbnail_cover");
    if(thumbnail_cover) {
				var paddingValue = window.getComputedStyle(td, null).getPropertyValue('padding-left');
				paddingValue = parseInt(paddingValue.substring(0, paddingValue.length - 2));
				paddingValue *= 2;
        thumbnail_cover.style.lineHeight = bufferWidth - paddingValue + "px";
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

function getIdFromPostId(id) {
	return id.substring(5, id.length);
}

function getUIDFromPostHeader(id) {
	return id.substring(5, id.length);
}

function addTagListeners(curPost) {
	var tags = curPost.querySelectorAll(".tagger");
	for(var i = 0; i < tags.length; ++i) {
		$(tags[i]).on("mousedown tap", function(evt) {
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
}

function addUserListener(curPost) {
	var user = curPost.querySelector(".post-header");
	var id = getUIDFromPostHeader($(user).attr("id"));
	$(user).on("mousedown tap", evt => {
		evt.preventDefault();
		var queryKey = firebase.database().ref().child("userQuery").push().key;
		var update = {};
		update["/userQuery/" + queryKey + "/uid"] = id;
		update["/userQuery/" + queryKey + "/queryResult"] = ["1"];
		firebase.database().ref().update(update).then(evt => {
			window.location.href = "./mypage.html?userQuery=" + queryKey;
		});
	});
}

function addLikeButtonToggle(like_button) {
	$(like_button).on("mouseover", function(evt) {
		$(evt.target).removeClass("fa-heart-o");
		$(evt.target).addClass("fa-heart");
	});
	$(like_button).on("mouseout", function(evt) {
		$(evt.target).removeClass("fa-heart");
		$(evt.target).addClass("fa-heart-o");
	});
}

function removeLikeButtonToggle(like_button) {
	$(like_button).off("mouseover");
	$(like_button).off("mouseout");
}



// if true landscape non jquery
function imageDimensions(img) {
	if(img.height > img.width) {
		return false;
	} else {
		return true;
	}
}

function loadUserProfile(uid) {
	var storageRef = firebase.storage().ref();
	var ref = firebase.database().ref("/users/" + uid);

	ref.once('value').then(function(snapshot) {
		if(snapshot.val().rankName) {
			var curPost = this.curPost;
			var title = curPost.querySelector(".Title");
			if(title) {
				title.innerHTML = snapshot.val().rankName;
			}
		} else {
			var curPost = this.curPost;
			var title = curPost.querySelector(".Title");
			if(title) {
				title.innerHTML = "오랑캐";
			}

		}

		if(snapshot.val().profileImg) {
			pageObject.userProfileImage[this.uid] = snapshot.val().profileImg;
			var downloadUrl = storageRef.child("profileImages/" + pageObject.userProfileImage[this.uid]).getDownloadURL();
			downloadUrl.then(function(url) {
				var curPost = this.curPost;
				var profilePic = curPost.querySelector("." + this.queryClass);
				profilePic.classList.add("loading");
				profilePic.src = url;
				profilePic.addEventListener("load", function(evt) {
					if(!imageDimensions(evt.target)) {
						evt.target.classList.add("circularLongImage");
					} else {
						evt.target.classList.remove("circularLongImage");
					}

					if(prevLoaded(this) && imagesAllLoaded(evt.target)) {
						$(".buttons_holder").css("display", "block");
					 	fadeInPost(this);
					}
				}.bind($(curPost)));
			}.bind(this));
		} else {
			pageObject.userProfileImage[this.uid] = "pictures/profile.png";
			var curPost = this.curPost;
			var profilePic = curPost.querySelector("." + this.queryClass);
			profilePic.classList.add("loading");
			profilePic.src = pageObject.userProfileImage[this.uid];
			profilePic.addEventListener("load", function(evt) {


				if(prevLoaded(this) && imagesAllLoaded(evt.target)) {
				 	fadeInPost(this);
				}
			}.bind($(curPost)));
		}

	}.bind(this));
}

var count = 0;

function loadActualPost(snapshot, likeObject, fromScrollTop) {
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

	buffer["checkTime"] = - buffer["time"];

  // replacing new lines with line breaks
  buffer["body"] = buffer["body"].replace(/\n/g, "<br>");
  buffer["time"] = getCurrentTime(-buffer["time"]);
	if(likeObject.val()) {
		buffer["likes"] = likeObject.val().likes ? likeObject.val().likes + "명" : "";
	} else {
		buffer["likes"] = "";
	}

	// update current track of load time
	if(pageObject.pastTime == undefined || pageObject.pastTime > buffer["checkTime"]) {
		pageObject.pastTime = buffer["checkTime"];

		if(!$("#post_" + buffer.id).length && pageObject.initialPostLoads > 0) {

			$(".container_box").append(pageObject.postTemplate(buffer));
			pageObject.initialPostLoads -= 1;
		} else {
			pageObject.bottomLoadStack.push(snapshot);
			return;
		}
	}
	if(pageObject.futureTime == undefined || pageObject.futureTime < buffer["checkTime"]) {
		pageObject.futureTime = buffer["checkTime"];

		if(!$("#post_" + buffer.id).length) {
			pageObject.frontLoadStack.push(snapshot);
			return;
			// $(".container_box").prepend(pageObject.postTemplate(buffer));
		}
	}

	// prepend on scroll Top
	if(fromScrollTop) {
		$(".container_box").prepend(pageObject.postTemplate(buffer));
	}

	if(!$("#post_" + buffer.id).length) {

		$(".container_box").append(pageObject.postTemplate(buffer));
		pageObject.initialPostLoads -= 1;
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
	$(like_button).on("mousedown tap", function(event) {
		event.preventDefault();

		var id = event.target.parentElement.parentElement.id;
		var requestKey = firebase.database().ref().child("likeRequest").push().key;
		var bufferObject = {};
		bufferObject.requestKey = requestKey;
		bufferObject.target = event.target;
		var update = {};
		update["/likeRequest/" + requestKey + "/postId"] = getIdFromPostId(id);
		update["/likeRequest/" + requestKey + "/uid"] = firebase.auth().currentUser.uid;
		update["/likeRequest/" + requestKey + "/result/count"] = 0;
		update["/likeRequest/" + requestKey + "/result/state"] = "default";
		firebase.database().ref().update(update).then(function(evt) {
			firebase.database().ref("/likeRequest/" + this.requestKey + "/result").on("value", function(snapshot) {
				if(!snapshot.val()) return;
				if(snapshot.val().state == "default") return;
				console.log(snapshot.val());
				if(snapshot.val().count > 0) {
					$(this.target).parent().children(".like_number").html(snapshot.val().count + "명");
				} else {
					$(this.target).parent().children(".like_number").html("");
				}

				if(snapshot.val().state == "true") {
					$(this.target).parent().children(".like_btn").addClass("fa-heart");
					$(this.target).parent().children(".like_btn").removeClass("fa-heart-o");
					removeLikeButtonToggle(this.target);
				} else {
					$(this.target).parent().children(".like_btn").removeClass("fa-heart");
					$(this.target).parent().children(".like_btn").addClass("fa-heart=o");
					addLikeButtonToggle(this.target);
				}
				firebase.database().ref("/likeRequest/" + this.requestKey).off("value");
				firebase.database().ref("/likeRequest/" + this.requestKey).remove();
			}.bind(this));

		}.bind(bufferObject));
	});

	if(firebase.auth().currentUser) {
		if(likeObject.val() && likeObject.val().userList.indexOf(firebase.auth().currentUser.uid) >= 0) {
			like_button.classList.add("fa-heart");
			like_button.classList.remove("fa-heart-o");
			removeLikeButtonToggle(like_button);
		}
	}


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

					imageParent.on("mousedown tap", function(evt) {
						evt.preventDefault();
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
	addUserListener(curPost);
	addLikeButtonToggle(like_button);

  resizeThumbnails();
}

function loadPosts(snapshot, fromScrollTop) {
	firebase.database().ref("/postLikes/" + snapshot.key).once("value").then((likeObject) => {
		loadActualPost(snapshot, likeObject, fromScrollTop);
	});
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

	$("#galleryoverlay").on("mousedown tap", function(evt) {
		evt.preventDefault();
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


	$("#actualimage").on("mousedown tap", function(evt) {
		evt.preventDefault();
		evt.stopPropagation();
		var mouseX = evt.clientX;
		var actualimage = document.querySelector("#actualimage");
		mouseX -= actualimage.getBoundingClientRect().left;
		var width = actualimage.offsetWidth;
		if(mouseX < width / 2) {
			$("#navleft").trigger("mousedown");
		} else {
			$("#navright").trigger("mousedown");
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
			$('#navleft').trigger("mousedown");
		} else if (e.keyCode == 39) {
			$('#navright').trigger("mousedown");
		}
	});


	$("#navleft").on("mousedown tap", function(evt) {
		evt.preventDefault();
		evt.stopPropagation();
		galleryLeft();
	});

	$("#navright").on("mousedown tap", function(evt) {
		evt.preventDefault();
		evt.stopPropagation();
		galleryRight();
	});

});
