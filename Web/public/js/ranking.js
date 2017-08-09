document.addEventListener("DOMContentLoaded", function(event) {
  console.log('랭킹페이지');

  var rankingList = [];
  var item = new Object();
  item.titlePic = '<i class="fa fa-bolt" aria-hidden="true"></i>'
  item.titleText = "오늘의 신";
  item.username = "hyesun03";
  item.like = 1499;

  var item2 = new Object();
  item2.titlePic = '<i class="fa fa-car" aria-hidden="true"></i>'
  item2.titleText = "내일의 신";
  item2.username = "samsung_note_book";
  item2.like = 1200;

  var item3 = new Object();
  item3.titlePic = '<i class="fa fa-flask" aria-hidden="true"></i>'
  item3.titleText = "모레의 신";
  item3.username = "xxx_sorry_tree";
  item3.like = 904;

  var item4 = new Object();
  item4.titlePic = '<i class="fa fa-camera-retro" aria-hidden="true"></i>'
  item4.titleText = "언젠가의 신";
  item4.username = "choihyeseon__ii";
  item4.like = 564;

  rankingList.push(item);
  rankingList.push(item2);
  rankingList.push(item3);
  rankingList.push(item4);

  console.log(rankingList);


  var source = document.getElementById("ranking_template").innerHTML;
	var template = Handlebars.compile(source);
	document.querySelector(".container_box").innerHTML += template(rankingList);





});
