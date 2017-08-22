class PageObject {
  constructor() {
    this.imageUrls = {};
    this.postTimes = {};
    this.postInView = {};
    this.postState = {};
    this.userProfileImage = {};
    this.postTemplate;
    this.galleryURLs = [];
    this.galleryIndex = 0;
    this.pastTime = undefined;
    this.futureTime = undefined;

    this.init();

    this.timerUpdate();

  }

  init() {
    $(window).scroll(function() {
    	var postIds = Object.keys(this.postTimes);
      for(var i = 0; i < postIds.length; ++i) {
        var curId = postIds[i];
        var postElem = document.querySelector("#post_" + curId);
        if(isScrolledIntoView(postElem) && this.postState[curId] != true) {
          this.postState[curId] = true;
        } else if(!isScrolledIntoView(postElem)) {
          this.postState[curId] = false;
        }
      }
    }.bind(this));

    $(document).on("recurseUpdateEvent", function(evt) {
      this.updatePostTime.bind(this)();
    }.bind(this));

  }

  timerUpdate() {
    $(document).trigger('recurseUpdateEvent');
    setTimeout(this.timerUpdate.bind(this), 5000);
  }

  updatePostTime() {
  	var postIds = Object.keys(this.postTimes);
  	for(var i = 0; i < postIds.length; ++i) {
  		var curId = postIds[i];
  		var postElem = document.querySelector("#post_" + curId);
      if(postElem) {
        var footer = postElem.querySelector(".post_footer");
        var time = footer.querySelector(".post_time");
        time.innerHTML = getCurrentTime(this.postTimes[curId]);
      }
  	}
  }

}
