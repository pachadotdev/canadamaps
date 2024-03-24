# canadamaps 0.3.0

* I could not find a way to make it work with the most recent rmapshaper, so
  I re-wrote the functions to use sf only.
  
# canadamaps 0.2.1

* requires rmapshaper version 0.4.6 to avoid problems with version 0.5.0
 (https://github.com/ateucher/rmapshaper/issues/158)

# canadamaps 0.2

* Added a `NEWS.md` file to track changes to the package.
* Uses NAD83 for the maps, otherwise there can be problems when exporting to geojson/topojson
