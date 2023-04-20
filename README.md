# Replication files for "A perfect storm and the natural endowments of trade-enabling infrastructure"

This is the repository of the paper 'A perfect storm and the natural endowments of trade-enabling infrastructure'. The repository was created as I refactored all the code of the project to tie it up for a version to include in my thesis. A short version of the paper is enclosed in this repository as 'Paper_short_version.pdf'. This specific version of the paper won the [EHS's New Researcher Prize](https://ehs.org.uk/society/grants-prizes/new-researcher-paper-prize-winners/) in the spring of 2023.

The scripts in this repository are numbered to indicate the order in which to run them. Some of the data cannot be shared in this repository either because I am not authorized to redistribute it, or because it is too large. However, I have included all the necessary information to download or obtain the data below. All scripts from "006_..." onwards require only data that is included in the repository.  
## 1. Included data
The following data is included in this repository

### A. Popdata.csv
This contains demographic data at the parish level. The data contains the following variables:  

| Variable | Description |
|----------|-------------|
| Year | Census year |
| GIS_ID | Unique identifier for each parish, which links to the shape data |
| Pop | Population in parish |
| Age_[x]_[y] | People in age group x <= age <= y |
| Fishing | Fishermen in parish |
| Manufacturing | People working in manufacturing |
| Farmer | Farmers and farm workers in the parish |
| Born_different_county | Number of people born in a different county |
| hisco_1st_digit[x] | Number of people with first digit of their HISCO code [x]. See https://historyofwork.iisg.nl/major.php |
| prime_labor_age | Number of people of prime working age (between 25 to 54 years) |
| occupation_in_prime | Number of people with a HISCO code in prime working age (between 25 to 54 years) |
| consistent | Dummy for parishes which are consistently observed across all years (1590 parishes) |  

Each variables also has an equivalently named counterpart with suffix "_f" and "_m" for female/male part of the population. 

### B. sogne_shape
'Sogne' tranlates to parishes. This is the shape file of Danish parishes as of January 1, 1820. Which was passed on to me from the authors of Boberg-Fazlic et al (2023). Originally this comes from www.digdag.dk. The market town of Lemvig (which is important in this application) was missing and added manually using borders downloaded directly from www.digdag.dk. The shape file has a an associated dataframe, which contains the following variables: 

| Variable | Description |
|----------|-------------|
| STEDNR | ID used by digdag |
| SOGN | Name of the parish |
| HERRED | The herred in which the parish is located. Administrative division above parish and below county. Roughly translates to 'hundred'. |
| AMT | County of the the parish. |
| GIS_ID | Unique identified used in this project. |
| long | Longitude of the centroid of the parish |
| lat | Latitude of the centroid of the parish |

### C. Key_census_to_shape.csv
Key linking the census data to the shape data. 

| Variable | Description |
|----------|-------------|
| event_parish | The parish |
| event_district | The herred in which the parish is located. Administrative division above parish and below county. Roughly translates to 'hundred'. |
| event_county | The county of the parish. |
| GIS_ID | GIS_ID - unique ID in the shape data. |

### D. limfjorden
Shape file which covers the body of water known as Limfjorden. From this repository: https://github.com/DenAutonomePirat/shapefile

### E. Geo.csv
This contains various geographic information.
| Variable | Description |
|----------|-------------|
| GIS_ID | GIS_ID - unique ID in the parish shape data. |
| limfjord_placement | Does the parish belong the Limfjord area of Denmark? And which part of the Limfjord? West/middle/east |
| distance_oce | Distance to closest coast in meters |
| distance_lim | Distance to the Limfjord in meters |


The Limfjord regions are based on the following definitions: 
- The parish is categorized as being a Limfjord parish, if the closest coast is the Limfjord i.e. distance_oce >= distance_lim-200


## 2. Large or non-redistributable data:
These are not available in this repository, either because I am not allowed to redistribute them, or because they are too large. 

### A. Danish census data from Link Lives 
I use the publicly available from Link Lives, available at www.rigsarkivet.dk/udforsk/link-lives-data/

### B. Sound toll registers online
This database of the Sound Toll Registers is available at http://www.soundtoll.nl/index.php/en/over-het-project/str-online. Although you cannot download it directly from the website, you can request a copy of the full database by sending them an email describing your project.

### C. Digdag
The parish borders from 1820 are available in the Digital Atlas of Danish Historical Administrative Geography. You can download it from https://digdag.dk/.

### D. Hisco codes for Danish census data 
This is data is available [here](https://www.dropbox.com/s/ov7ubxtqq21c6za/LL_hisco_codes_clean.csv?dl=0). It was created from the automatic HISCO labelling procedure described on my website: https://sites.google.com/view/christianvedel

| Variable | Description |
|----------|-------------|
| pa_id | ID, which is unique for every year, which links to the rest of [links lives](https://link-lives.dk/en/link-lives-a-research-project/) data |
| Kilde | Source of the the data |
| Year | Census year |
| Erhverv | Occupational description (in Danish) |
| Stilling_i_husstanden | Household position. Sometimes contains occupational description. (in Danish) |
| RowID | ID used internally by the automatic HISCO labeling procedure |
| hisco[x] | 1-5 hisco codes for each occupational description. Most only have one, but a few have more than one occupation. |
| en_hisco_text[x] | English hisco code description from [this repository](https://github.com/cedarfoundation/hisco) |

### E. Coast-line shape
This is only used in 005_Limfjord_regions.R. It is slightly too large to redistribute. It contains coast lines, and is downloadable from: https://osmdata.openstreetmap.de/data/water-polygons.html. This was downloaded 2023-04-19.

## References 
Boberg-Fazlic, N., Jensen, P.S., Lampe, M. et al. ‘Getting to Denmark’: the role of agricultural elites for development. J Econ Growth (2023). https://doi.org/10.1007/s10887-023-09226-8
