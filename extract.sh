# script to extract the matadata
# from all the pcoded files available
# in humanitarian response
# the idea behind this script is to make
# it easier to compare the quality among
# the different pcoding schemes
# and countries.

# this script was designed to first work
# on the ebola-affected countries in
# west africa. it can also be used in
# other contexts.

# this script has to be run inside the
# /geo folder. this script depends on
# gdal for file conversion.

# look at the countries folder
cd countries

# take the country list
# TODO: understand how to store a
# folder list as an array that
# can be used as an intex to the looper
clist=(*/)

# create the storage folders
mkdir output
mkdir output/csv
mkdir output/geojson
mkdir output/topojson

# iterating over each country available
for d in */ ; do
    echo "Reading: $d"
    cd $d  # navigate in

    # if i == 1 create the folders
    # otherwise they will be read by
    # the looper

    # iterating over the admin folders
    # and creating geojson and csv files
    for folder in */ ; do
       file_name=$(find ${folder%?} -type f -name '*.shp')
       country_name=${d%?}
       file_out="${d%?}-${folder%?}"
       echo "Processing csv and geojson: ${folder%?} | $file_name"
       ogr2ogr -f CSV ../output/csv/$file_out.csv $file_name
       ogr2ogr -f GeoJSON ../output/geojson/$file_out.geojson $file_name
    done

    # iterating over the admin folders
    # and creating topojson files
    for folder in */ ; do
      file_name=$(find ${folder%?} -type f -name '*.shp')
      country_name=${d%?}
      file_out="${d%?}-${folder%?}"
      echo "Processing topojson: ${folder%?} | $file_name"
      topojson -o ../output/topojson/$file_out.topojson $file_name
    done

    cd ..  # navigate out
done