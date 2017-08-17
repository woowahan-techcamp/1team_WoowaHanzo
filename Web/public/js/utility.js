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

	$curPost.animate({
		opacity: 1.0
	}, 200, function() {
		if(this.next().length != 0) {
			this.next().trigger("postLoaded");
		}
		resizeThumbnails();
	}.bind($curPost));

}

function imagesAllLoaded(curImage) {
	try {
		curImage.classList.add("loaded");
		var imageParent = curImage.parentElement.parentElement.parentElement;
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
	}

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
  $(".image_thumbnails td").each(function(index, elem) {

    var bufferWidth = $(".image_thumbnails td")[0].offsetWidth;
    elem.style.height = bufferWidth + "px";
    if($(".thumbnail_cover").last().length > 0) {
        $(".thumbnail_cover").last()[0].style.lineHeight = bufferWidth - 20 + "px";
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

function loadPosts(snapshot) {
  var storageRef = firebase.storage().ref();

  var buffer = snapshot.val();
  buffer.id = snapshot.key;

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

  $(".container_box").append(pageObject.postTemplate(buffer));

  var $curPost = $("#post_" + buffer.id);
  //fadeInPost($curPost);

  if(buffer.images) {
    // only three images are loaded at a time
    for(var i = 0; i < buffer.images.length || i < 3; ++i) {

      var $curObject = {};
      $curObject.$curPost = $curPost;
			$curObject.id = buffer.id;
      $curObject.i = i;
      var filename = buffer.images[i];
      if(i < 3) {
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

					imageParent.on("click", function(evt) {
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
        imageParent = $(imageParent).children("div").children("img");
        imageParent.classList.add("loaded");

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
      if(prevLoaded($(currentPost))) {
        fadeInPost($(currentPost));
      }
      if($(currentPost).next().length != 0) {
        $(currentPost).next().trigger("postLoaded");
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
  //$curPost.css("display", "block");

  resizeThumbnails();
}

document.addEventListener("DOMContentLoaded", function(evt) {
	var galleryoverlay = document.querySelector("#galleryoverlay");
	var holder = document.querySelector(".holder");
	var navleft = document.querySelector("#navleft");
	if($(".holder").length) {
		console.log($("#navleft").height());

		$('.holder').css('margin-top', galleryoverlay.offsetHeight / 2 - navleft.offsetHeight / 2 + 'px');
		$(window).resize(function() {
			$('.holder').css('margin-top', galleryoverlay.offsetHeight / 2 - navleft.offsetHeight / 2 + 'px');
		});

	}

	$("#galleryoverlay").on("click", function(evt) {
		$('#galleryoverlay').css('display', 'none');
		$('#justblackbackground').css('display', 'none');
		$('#actualimage').css('display', 'none');
	});

	$(window).resize(function() {
		$('#actualimage').css('top', $(window).height() / 2 - $('#actualimage').height() / 2  + 25 + 'px');
		$('#actualimage').css('left', $(window).width() / 2 - $('#actualimage').width() / 2  + 'px');
		$('#actualimage').css('max-height', $(window).height() - 50);
	});

	$("#navleft").on("click", function(evt) {
		evt.stopPropagation();
		galleryLeft();
	});

	$("#navright").on("click", function(evt) {
		evt.stopPropagation();
		galleryRight();
	});

});
