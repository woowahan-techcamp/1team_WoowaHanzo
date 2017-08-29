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

    this.initialPostLoads = 8;

    this.likeRequestStack = {};
    this.frontLoadStack = [];
    this.bottomLoadStack = [];
    this.bottomSeen = false;

    this.init();

    this.timerUpdate();
    this.likeNumberRequest();

  }

  init() {
    $(window).scroll(function() {
    	var postIds = Object.keys(this.postTimes);
      for(var i = 0; i < postIds.length; ++i) {
        var curId = postIds[i];
        var postElem = document.querySelector("#post_" + curId);
      }
    }.bind(this));

    $(window).scroll(function() {
       if($(window).scrollTop() < 10) {
        while(this.frontLoadStack.length) {
          var snapshot = this.frontLoadStack[0];
          this.frontLoadStack.splice(0, 1);
          loadPosts(snapshot, true);
        }
      }
      if(!this.bottomSeen && document.querySelector(".loading-indicator-box") &&
          isScrolledIntoView(document.querySelector(".loading-indicator-box"))) {
        if(document.querySelector(".loading-indicator-box") && !this.bottomLoadStack.length) {
          document.querySelector(".loading-indicator-box").style.display = "none";
        } else if(document.querySelector(".loading-indicator-box") && this.bottomLoadStack.length) {
          document.querySelector(".loading-indicator-box").style.display = "block";
        }
        console.log("bottom reached");
        this.bottomSeen = true;
        var i = 5;
        while(this.bottomLoadStack.length && i > 0) {
          var snapshot = this.bottomLoadStack[0];
          this.bottomLoadStack.splice(0, 1);
          // this.initialPostLoads = i;
          console.log("loading");
          loadPosts(snapshot);
          i -= 1;
        }
      } else if (document.querySelector(".loading-indicator-box") &&
          !isScrolledIntoView(document.querySelector(".loading-indicator-box"))) {
        this.bottomSeen = false;
      }
    }.bind(this));


    $(document).on("recurseUpdateEvent", function(evt) {
      this.updatePostTime.bind(this)();
      if(!this.frontLoadStack.length && this.initialPostLoads > 0 && this.initialPostLoads < 8) {

        if(document.querySelector(".loading-indicator-box")) {
          document.querySelector(".loading-indicator-box").style.display = "none";
        }
      }
    }.bind(this));

    $(document).on("likeNumberRequestEvent", function(evt) {
      this.updateLikeNumber.bind(this)();
    }.bind(this));

  }

  timerUpdate() {
    $(document).trigger('recurseUpdateEvent');
    setTimeout(this.timerUpdate.bind(this), 5000);
  }

  likeNumberRequest() {
    $(document).trigger("likeNumberRequestEvent");
    setTimeout(this.likeNumberRequest.bind(this), 5000);
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

  updateLikeNumber() {
    var postIds = Object.keys(this.postTimes);
    for(var i = 0; i < postIds.length; ++i) {
      var curId = postIds[i];
      var postElem = document.querySelector("#post_" + curId);
      if(postElem) {
        console.log(curId);
      }
    }
  }

}
