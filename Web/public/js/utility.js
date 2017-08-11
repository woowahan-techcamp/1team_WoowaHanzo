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

function getDatelabel(d) {
	var datelabel = (month[d.getMonth()]) + ' ' + d.getDate() + ', ' + d.getFullYear();
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

	} else if (($.now() - time) > 60000) {
		if(parseInt(($.now() - time) / 60000) > 1) {
			timeago = parseInt(($.now() - time) / 60000).toString() + '분';
		} else {
			timeago = parseInt(($.now() - time) / 60000).toString() + '분';
		}
	} else {
		timeago = parseInt(($.now() - time) / 1000).toString() + '초';
	}
	return timeago + " 전";
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
