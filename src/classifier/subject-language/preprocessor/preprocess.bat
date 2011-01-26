rem Command lines for preprocessing data for subject language classifier

rem Set the traget directory for the results
rem For production: target=..\subjectlanguagedata\
set target=test\

rem Linguist List list of ancient and extinct languages
python LinguistList_preprocessor.py data\GetListOfAncientLgs.html >%target%ancient-extinct.txt

rem ISO 639-3 Code Set from sil.org downloads
python iso-639_preprocessor.py data\iso-639-3_20090210.tab >%target%iso639.txt

rem CountryCodes country data from Ethnologue.com/codes downloads
python CountryCodes_preprocessor.py data\CountryCodes.tab >%target%iso3166_CountryCodes.txt

rem Region data from Ethnologue
python region_preprocessor.py -o %target%ethnologue_region.txt data\region_data.txt

rem Complex names from Ethnologue
python complexname_preprocessor.py -o %target%ethnologue_complex_names.txt data\complex_name_data.txt

rem These last two are slow ... 

rem Historical country names (edited by hand, so don't redo)
rem python HistoricalCountryNames_preprocessor.py http://www.nationsonline.org/oneworld/hist_country_names.htm >%target%historical_country_names.txt

rem Countries for ancient and extinct languages compiled from Linguist List data
python ancient_countries.py data\GetListOfAncientLgs.html >%target%ancient-countries.txt

pause

