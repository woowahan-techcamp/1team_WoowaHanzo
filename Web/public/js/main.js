document.addEventListener("DOMContentLoaded", function(event) {
  var storage = firebase.storage();

  // Create a storage reference from our storage service
  var storageRef = storage.ref();

});

var pageObject = new PageObject();

// listings of all custom events
var recurseUpdateEvent = jQuery.Event();
var postLoaded = jQuery.Event();
