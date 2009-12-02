# recreate db
cat create_database.sql | mysql -u root --password=classifier4olac
cat olac_schema.sql | mysql --defaults-file=~/oai.my.cnf

# load language data
sed 1d LanguageCodes.tab | python loadtab.py -c ~/oai.my.cnf -t LanguageCodes -e latin-1
sed 1d iso-639-3_20080529.tab | python loadtab.py -c ~/oai.my.cnf -t ISO_639_3
sed 1d iso-639-3_Name_Index_20080603.tab | python loadtab.py -c ~/oai.my.cnf -t ISO_639_3_Names
sed 1d iso-639-3-macrolanguages_20080218.tab | python loadtab.py -c ~/oai.my.cnf -t ISO_639_3_Macrolanguages
sed 1d iso-639-3_Retirements_20080529.tab | python loadtab.py -c ~/oai.my.cnf -t ISO_639_3_Retirements -e latin-1
python load_olac_extensions.py -c ~/oai.my.cnf -n 1.1
