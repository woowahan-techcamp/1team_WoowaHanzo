class PageObject {
  constructor() {
    this.imageUrls = {};
    this.postTimes = {};
    this.postInView = {};
    this.postState = {};

    this.init();

    //custom event for constant jquery event update
    var recurseUpdateEvent = jQuery.Event();
    this.timerUpdate();

  }

  init() {
    $(window).scroll(function() {
    	var postIds = Object.keys(this.postTimes);
      console.log(postIds);
      for(var i = 0; i < postIds.length; ++i) {
        var curId = postIds[i];
        var postElem = document.querySelector("post_" + curId);
        if(isScrolledIntoView(postElem) && postState[curId] != true) {
          console.log("Scrolled into View!");
        } else if(!isScrolledIntoView(postElem)) {
          postState[curId] = false;
        }
      }
    }.bind(this));

    $(document).on("recurseUpdateEvent", function(evt) {
      var postIds = Object.keys(this.postTimes);

      for(var i = 0; i < postIds.length; ++i) {
        var curId = postIds[i];
        var postElem = document.querySelector("#post_" + curId);
        var footer = postElem.querySelector(".post_footer");
        var time = footer.querySelector(".post_time");
        time.innerHTML = getCurrentTime(this.postTimes[curId]);
      }
    }.bind(this));

  }

  timerUpdate() {
    $(document).trigger('recurseUpdateEvent');
    console.log("Event fired");
    setTimeout(this.timerUpdate.bind(this), 5000);
  }

}
