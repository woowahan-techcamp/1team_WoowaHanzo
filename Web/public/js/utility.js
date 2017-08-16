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

});
