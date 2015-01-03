# 42MapGenerator

<img src="http://i.imgur.com/RLfUrZc.png" align="right" width="50%" />42 Map Generator is a tiny bash script developed at 42 school for generating maps for FdF project whose data are extracted from IGN's and NOAA's servers.

Choose a region and an export directory and let the script generate 5 maps of different accuracies (XXL is original data, XL, L, M and S).

Horizontal accuracy of the maps according to the data source:
* IGN's data: up to 250 meters
* NOAA's data: up to 1852 meters (1 arc-minute)

## install & launch
	git clone https://github.com/jgigault/42MapGenerator ~/42MapGenerator
	cd ~/42MapGenerator && sh ./42MapGenerator.sh

## features
* Choose a preset region
* Find your own country with the Google Geocoding API
* Generate random maps (in progress)

## preset regions
* France and Overseas
* Europe, Italy, Great Britain & Ireland
* Great Lakes, West Coast (North America)
* Amazonia, Cordillera de los Andes
* Himalaya & India
* Ethiopia
* Australia, New Zealand

## options
	--no-update   // Do not check for updates at launch
	--no-color    // Do not display color tags
	--no-timeout  // Disable time-out child process

## preview
<img src="http://i.imgur.com/uO6Egii.png?1" width="50%" /><img src="http://i.imgur.com/v5uApWX.png" width="50%" /><img src="http://i.imgur.com/pkOpXLX.png" width="50%" /><img src="http://i.imgur.com/n3K2lh4.png" width="50%" />

## credits
* BD ALTI® - IGN (http://professionnels.ign.fr/bdalti)
* ETOPO1 - NGDC Grid Extraction Tool - NOAA (http://maps.ngdc.noaa.gov/viewers/wcs-client/)
* Google Geocoding API (https://developers.google.com/maps/documentation/geocoding/)