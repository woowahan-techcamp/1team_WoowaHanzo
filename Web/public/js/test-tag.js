document.addEventListener("DOMContentLoaded", function(event) {

  var names = text.split(" ");
  var namesobj = countWords(names);
  console.log(namesobj);

  for(var i = 0; i < Object.keys(namesobj).length; i++) {
    $(".tags_holder").append('<span class="tagger tag_holder_tmp">' +
                  '<span class="starting_sharp_tmp">#</span>' +
                  '<span class="tag_name_tmp">' + Object.keys(namesobj)[i] + ' ' + '</span>' +
                  '<span class="tag_count_tmp">' + Object.values(namesobj)[i] + '</span>' +
                '</span>');
  }


});

function countWords(names) {
  var ret = {};
  for(var i = 0; i < names.length; ++i) {
    var max = 1000;
    var min = 1;
    var num = Math.random() * (max - min) + min;
    num = parseInt(num);
    ret[names[i]] = num;
  }

  return ret;
}


var text = 'Quehanna Wild Area is a wildlife area within parts of Cameron, Clearfield, and Elk counties in the U.S. state of Pennsylvania; with a total area of 48,186 acres (75 sq mi; 195 km2), it covers parts of Elk and Moshannon State Forests. Founded in the 1950s as a nuclear research center, Quehanna has a conflicting legacy of radioactive and toxic waste contamination, while also being the largest state forest wild area in Pennsylvania, with herds of native elk. The wild area is bisected by the Quehanna Highway and is home to second growth forest with mixed hardwoods and evergreens. Quehanna has two state forest natural areas: the 1,215-acre (492 ha) Wykoff Run Natural Area, and the 917-acre (371 ha) Marion Brooks Natural Area. The latter has the largest stand of white birch in Pennsylvania and the eastern United States. The land that became Quehanna Wild Area was home to Native Americans, including the Susquehannock and Iroquois, before it was purchased by the United States in 1784. Settlers soon moved into the region and, in the 19th and early 20th centuries, the logging industry cut the virgin forests; clearcutting and forest fires transformed the once verdant land into the "Pennsylvania Desert". Pennsylvania bought this land for its state forests and in the 1930s the Civilian Conservation Corps worked to improve them. In 1955 the Curtiss-Wright Corporation bought 80 square miles (210 km2) of state forest for a research and manufacturing facility to focus on developing nuclear-powered jet engines. They named their facility Quehanna for the nearby West Branch Susquehanna River, itself named for the Susquehannocks. Curtiss-Wright left in 1960, after which a succession of tenants further contaminated the nuclear reactor facility and its hot cells with radioactive isotopes, including strontium-90 and cobalt-60. The manufacture of radiation-treated hardwood flooring continued until 2002. Pennsylvania reacquired the land in 1963 and 1967, and in 1965 established Quehanna as a wild area, albeit one with a nuclear facility and industrial complex. The cleanup of the reactor and hot cells took over eight years and cost $30 million; the facility was demolished and its nuclear license terminated in 2009. Since 1992 the industrial complex has been home to Quehanna Motivational Boot Camp, a minimum-security prison. Quehanna Wild Area has many sites where radioactive and toxic waste was buried, some of which have been cleaned up while others were dug up by black bears and white-tailed deer. In 1970 the name was officially changed to Quehanna Wild Area, and later that decade the 75-mile (121 km) Quehanna Trail System was built through the wild area and surrounding state forests. Primitive camping by hikers is allowed, but the area has no permanent residents. The trails are open to cross-country skiing in the winter, but closed to vehicles. Quehanna is on the Allegheny Plateau and was struck by a tornado in 1985. Defoliating insects have further damaged the forests. Quehanna Wild Area was named an Important Bird Area by the Pennsylvania Audubon Society, and is home to many species of birds and animals. Eco-tourists come to see the birds and elk, and hunters come for the elk, coyote, and other game.'
