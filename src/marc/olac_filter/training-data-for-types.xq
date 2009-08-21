xquery version "1.0";  
   
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace marc="http://www.loc.gov/MARC21/slim";
declare namespace sr="http://www.openarchives.org/OAI/2.0/static-repository";
declare namespace oai="http://www.openarchives.org/OAI/2.0/";
declare namespace olac="http://www.language-archives.org/OLAC/1.1/";
declare namespace xsi="http://www.w3.org/2001/XMLSchema-instance";
declare namespace dcterms="http://purl.org/dc/terms/";
declare namespace fn="http://www.w3.org/2005/xpath-functions";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";


let $repo := doc('file:olac_display_subset.xml')

return
  <records
      xmlns="http://www.openarchives.org/OAI/2.0/"
      xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:dcterms="http://purl.org/dc/terms/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  {
  for $rec in $repo//olac:olac
  where $rec[not(dc:subject[contains('aay
  acc aex ahe aiz akn amd arf atf auv azr bcx bgh bii bke blu bnh boc
  bqe bsd bsz bvs bwv bxt byu cbm ccx ccy chs cit ckc ckd cke ckf cki
  ckj ckk ckw cnm cru cti cun dat dyk eml eni eur fiz flm fri gen ggh
  gmo gsc hsf hva itu ixi ixj jai jap kds knh kob krg krq kxg lms lmt
  lnc lnt lod mbg mdo mhv miv mly mms mob mol mpf mqd mtz muw mvc mvj
  mzf nfg nfk nhj nhs nky nxj occ ogn ope ork paj pec pen plm poa pob
  poj pou ppv prv pun quj qut quu qxi rae rjb rws scc scr sdd sdi sic
  skl slb srj stc suf suh suu szk tle tlz tmx tnj tot ttx tzb tzc tze
  tzs tzt tzu tzz ubm vky vlr vmo wre xah xkm xmi xsk xst xuf yib yio
  ymj ypl ypw yus ywm yym ztc', .)])]
  return
     $rec
  }
  </records>
  
  

