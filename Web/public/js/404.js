document.addEventListener("DOMContentLoaded", function(event) {
  var posX = "";
  var posY = "";

  document.addEventListener("mousemove", function(evt) {
    getCursorPosition(evt);
  });




});

function getCursorPosition(e) {
  var eObj = window.event? window.event : e;
  posX = eObj.clientX;
  posY = eObj.clientY + document.documentElement.scrollTop;

  // console.log(posX + ", " + posY );
}
