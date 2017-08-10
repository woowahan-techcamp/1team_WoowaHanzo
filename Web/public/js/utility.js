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
