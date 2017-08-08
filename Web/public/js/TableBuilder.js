class TableBuilder {
  constructor(key, value) {
    console.log(key, value);
    this.key = key;
    this.value = value;

    var templatetext = document.querySelector("#table_element").innerHTML
    this.template = Handlebars.compile(templatetext);

    this.table = '<table class="category_picker brand_picker">';
    this.init();
  }

  init() {
    this.templateObject = {};

    for(var key of Object.keys(this.value)) {

      this.templateObject[key] = {};
      this.templateObject[key]["image"] = "./pictures/food_images/" +
        this.value[key]["image"] + ".jpg";
      this.templateObject[key]["logo"] = key;

    }

    var keys = Object.keys(this.templateObject);
    for(var i = 0; i < keys.length; ++i) {
      if(i == 0) {
        this.table += '<tr>';
        this.table += this.template(this.templateObject[keys[i]]);
      } else if(i == keys.length - 1) {

      } else if (i % 3 == 0) {
        this.table += '<tr></tr>';
        this.table += this.template(this.templateObject[keys[i]]);
      } else {
        this.table += this.template(this.templateObject[keys[i]]);
      }
    }

    $(".container_box").append(this.table);
    $(".brand_picker").last().attr("id", this.key + "_table");

    $(".category_picker td").height($(".category_picker td").width());

    $(".brand_picker").last().css("display", "none");

    var category_elem = $("." + this.key + "_category");
    console.log(this.key);
    category_elem.on("click", function(evt) {
      console.log(evt.target);
      $(".brand_picker").css("display", "none");
      $("#" + this.key + "_table").css("display", "table");
      console.log(this.key);
    }.bind(this));



  }
}


var key
