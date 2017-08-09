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
        this.table += this.template({image: this.templateObject[keys[i]]["image"],
        logo_id: this.templateObject[keys[i]]["logo"] + "_holder"});
      } else if(i == keys.length - 1) {

      } else if (i % 3 == 0) {
        this.table += '<tr></tr>';
        this.table += this.template({image: this.templateObject[keys[i]]["image"],
        logo_id: this.templateObject[keys[i]]["logo"] + "_holder"});
      } else {
        this.table += this.template({image: this.templateObject[keys[i]]["image"],
        logo_id: this.templateObject[keys[i]]["logo"] + "_holder"});
      }

    }

    $(".container_box").append(this.table);
    $(".brand_picker").last().attr("id", this.key + "_table");
    $(".category_picker td").height($(".category_picker td").width());
    $(".brand_picker").last().css("display", "none");

    // clicking a category
    var category_elem = $("." + this.key + "_category");
    category_elem.on("click", function(evt) {
      $(".brand_picker").css("display", "none");
      $("#" + this.key + "_table").css("display", "table");

      $(".logo_holder .shader").css("display", "none");

      scrollTo($("#" + this.key + "_table"));

    }.bind(this));

    for(var i = 0; i < keys.length; ++i) {
      $(".container_box").append(this.makeMenuList(keys[i], this.value[keys[i]]["menu"]));
      $("#" + keys[i] + "_list").css("display", "none");

      $("#" + this.templateObject[keys[i]]["logo"] + "_holder").on("click", function(evt) {
        if(!$(evt.target).is(".logo_holder")) {
          $(evt.target).parent().click();
          return;
        }

        var curElem = $(evt.target);
        $(".logo_holder").parent().children(".brand_check").css("display", "none");
        curElem.parent().children(".brand_check").css("display", "block");

        $(".logo_holder .shader").each(function(index, el) {

          if($(el).parent().attr("id") == $(this).attr("id")) {
            console.log("Found");
            $(el).css("display", "none");
          } else {
            $(el).css("display", "block");
          }
        }.bind(curElem));

        // getting menus for brand
        var brand = $(evt.target).attr("id").split("_")[0];
        $(".menu_list").css("display", "none");
        $("#" + brand + "_list").css("display", "block");
        scrollTo($("#" + brand + "_list"));
        console.log("clicked");
      });
    }
  }

  makeMenuList(key, menuList) {
    var ret = "";
    ret += '<div class="menu_list"  id="' + key + '_list">';
    var templatetext = document.querySelector("#menu_item").innerHTML;
    var template = Handlebars.compile(templatetext);
    for(var i = 0; i < menuList.length; ++i) {
      ret += template({name: menuList[i]});
    }
    ret += "</div>";

    return ret;
  }
}

function scrollTo(elem) {
  console.log(elem.offset());
  $('html, body').animate({scrollTop: elem.offset().top - 80 }, 500);
}
