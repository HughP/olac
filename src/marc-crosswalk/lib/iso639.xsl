<?xml version="1.0" encoding="UTF-8"?>
<!--
    iso639.xsl - Maps an LCSH or LCCN to an ISO639-3 code. Returns "failed" if
    there is no match.
    This stylesheet is intended to be included by the main marc2olac stylesheet
-->
<xsl:stylesheet version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>
    <xsl:template name="map-to-iso639">

        <!-- only one of the following params are necessary  -->
        <xsl:param name="lcsh"/>
        <xsl:param name="lccn"/>

        <!-- map LCSH to ISO639-3 -->
        <xsl:choose>
            <xsl:when test="$lcsh">
                <xsl:variable name="lcsh_lc" select="lower-case($lcsh)"/>
                <xsl:choose>
                    <xsl:when test="$lcsh_lc = &quot;werchikwar language&quot;"
                        >bsk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bacama language&quot;">bcy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yaqay language&quot;">jaq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;attie language&quot;">ati</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tunica language&quot;">tun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khitan language&quot;">zkt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gadaba (dravidian) language&quot;"
                        >gau</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baka language&quot;">bdh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;avestan language&quot;">ave</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sabela language&quot;">auc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mi gangam language&quot;"
                        >gng</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mangyan language&quot;">iry</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abidji language&quot;">abi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;veps language&quot;">vep</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;egyptian language&quot;">egy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngomba (bamileke) language&quot;"
                        >jgo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ionic greek language&quot;"
                        >grc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;selkup language&quot;">sel</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaje language&quot;">kaj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waropen language&quot;">wrp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cimbrian language&quot;">cim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maithili language&quot;">mai</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;newari language&quot;">new</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kambata language&quot;">ktb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;majingai language&quot;">mwm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;marovo language&quot;">mvo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moghol language&quot;">mhj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;malto language&quot;">mjt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guarijío language&quot;">var</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;quebec sign language&quot;"
                        >fcs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;indonesian language&quot;"
                        >ind</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyungwe language&quot;">nyu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chamí language&quot;">cmi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;beng language&quot;">nhb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lobedu language&quot;">nso</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;central yupik language&quot;"
                        >esu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bhadrawahi language&quot;"
                        >bhd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;betawi language&quot;">bew</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tonsea language&quot;">txs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;upper tanudan kalinga language&quot;"
                        >kgh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khumi awa language&quot;"
                        >cka</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsaiwa language&quot;">atb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lungu language&quot;">mgr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mongolian language&quot;"
                        >mon</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dahalo language&quot;">dal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cayuga language&quot;">cay</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lü language&quot;">khb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;makasar language&quot;">mak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;filipino language&quot;">fil</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fanti language&quot;">fat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wobe language&quot;">wob</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;taveta language&quot;">tvs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;linda language&quot;">liy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;korean language&quot;">kor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sambalpuri language&quot;"
                        >ori</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;votic language&quot;">vot</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koti language&quot;">eko</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;warapu language&quot;">wra</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngonde language&quot;">nyy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;monjombo language&quot;">moj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;berta language&quot;">wti</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;biali language&quot;">beh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;komi language&quot;">kom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;candoshi language&quot;">cbu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aleut language&quot;">ale</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;marshallese language&quot;"
                        >mah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saisiyat language&quot;">xsy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;asilulu language&quot;">asl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;!xõ language&quot;">huc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tamu language&quot;">gvr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zaparo language&quot;">zro</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gawigl language&quot;">ubu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yugh language&quot;">yuu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mon language&quot;">mnw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dari language&quot;">prs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ternate language&quot;">tft</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;caingua language&quot;">kgk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;parsi-gujarati language&quot;"
                        >guj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tagabawa manobo language&quot;"
                        >bgs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;papabuco language&quot;">zpw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kapone language&quot;">kdk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;riang-lang language&quot;"
                        >ril</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abau language&quot;">aau</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wojokeso language&quot;">apz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;biatah language&quot;">bth</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pinai-hagahai language&quot;"
                        >pnn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;somba language&quot;">tbz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gonja language&quot;">gjn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arecuna language&quot;">aoc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koyraboro senni language&quot;"
                        >ses</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;liangmai naga language&quot;"
                        >njn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moklum language&quot;">nst</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abazin language&quot;">abq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;martuyhunira language&quot;"
                        >vma</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;minangkabau language&quot;"
                        >min</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;birom language&quot;">bom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alu-kurumba language&quot;"
                        >xua</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nenets language&quot;">yrk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yuri language&quot;">yuj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baram language&quot;">brd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aragonese language&quot;"
                        >arg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khotta language&quot;">mai</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tabla language&quot;">tnm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;agusan manobo language&quot;"
                        >msm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kapauku language&quot;">ekg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sidamo language&quot;">sid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koronadal blaan language&quot;"
                        >bpr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;daza language&quot;">dzd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;catio language&quot;">cto</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tausug language&quot;">tsg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ewondo language&quot;">ewo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;patamona language&quot;">pbc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tamil language&quot;">tam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cajun french language&quot;"
                        >frc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yuit language&quot;">ess</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;male (ethiopia) language&quot;"
                        >mdy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nakara language&quot;">nck</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;deswali language&quot;">bgc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;burmese language&quot;">mya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nii language&quot;">nii</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hano language&quot;">lml</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;callahuaya language&quot;"
                        >caw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;areare language&quot;">alu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;galoli language&quot;">gal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wintu language&quot;">wit</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;adiwasi oriya language&quot;"
                        >ort</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tuvinian language&quot;">tyv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khumi language&quot;">cnk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dhurga language&quot;">dhu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kela language&quot;">kel</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mituku language&quot;">zmq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;katab language&quot;">kcg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;larrakia language&quot;">lrg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sekani language&quot;">sek</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siwa language&quot;">siz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;araki language&quot;">akr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;orokaiva language&quot;">okv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tayo language&quot;">cks</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kohumono language&quot;">bcs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;miya language&quot;">mkf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lese language&quot;">les</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ekonda language&quot;">lol</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;assamese language&quot;">asm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shilluk language&quot;">shk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;falor language&quot;">fap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;embaloh language&quot;">emb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;murui language&quot;">huu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;halopa language&quot;">gaw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gata' language&quot;">gaq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dayak language&quot;">knx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shilha language&quot;">jbn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chumash language&quot;">chs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ocuiltec language&quot;">ocu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kui language&quot;">kxu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bakossi language&quot;">bss</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mori language&quot;">mzq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nung language&quot;">nun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arabela language&quot;">arl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tohono o'odham language&quot;"
                        >ood</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sangu (tanzania) language&quot;"
                        >sbp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;muyuw language&quot;">myw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;önge language&quot;">oon</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tenyidie dialect&quot;">njm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;seneca language&quot;">see</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hittite language&quot;">hit</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ingano language&quot;">inj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bamun language&quot;">bax</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;crow language&quot;">cro</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;haisla language&quot;">has</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yamdena language&quot;">jmd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kanauri language&quot;">kfk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tunen language&quot;">baz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kom (india) language&quot;"
                        >kmm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern thai language&quot;"
                        >sou</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;agarabe language&quot;">agd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lavongai language&quot;">lcm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tangkhul language&quot;">nmf</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;aka (central african republic) language&quot;"
                        >axk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;itzá language&quot;">itz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uwana language&quot;">hau</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kissi language&quot;">kiz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;patep language&quot;">ptp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;soninke language&quot;">snk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gwa (ghana) language&quot;"
                        >gwx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;norwegian language&quot;"
                        >nor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;turkmen language&quot;">tuk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sawi language&quot;">saw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;avava language&quot;">tmb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sart language&quot;">uzn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;domaaki language&quot;">dmk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tilamuta language&quot;">gor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vaudois language&quot;">frp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fula language&quot;">ful</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ponape language&quot;">pon</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;danish language&quot;">dan</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;romani language&quot;">rom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chamalal language&quot;">cji</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nepali language&quot;">nep</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;akit language&quot;">kvr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wasi language&quot;">ata</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nilamba language&quot;">nim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;suena language&quot;">sue</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wambule language&quot;">wme</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;besisi language&quot;">mhe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jicarilla language&quot;"
                        >apj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kongo language&quot;">kon</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saek language&quot;">skb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kasaba language&quot;">iru</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moseten language&quot;">cas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nemi language&quot;">nem</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tenharim language&quot;">pah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tonga (nyasa) language&quot;"
                        >tog</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chambri language&quot;">can</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;okrika language&quot;">okr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nchumburu language&quot;"
                        >ncu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;upper kuskokwim language&quot;"
                        >kuu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karko language&quot;">kko</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sara language&quot;">sre</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cayapo language&quot;">txu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern khanty language&quot;"
                        >kca</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chayahuita language&quot;"
                        >cbt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tuamotuan language&quot;"
                        >pmt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eudeve language&quot;">opt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bishnupuriya language&quot;"
                        >bpy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shor language&quot;">cjs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;luyia language&quot;">luy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fijian language&quot;">fij</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;south efate language&quot;"
                        >erk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cacua language&quot;">cbv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kako language&quot;">kkj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;seri language&quot;">sei</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;somali language&quot;">som</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;etsako language&quot;">ets</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaluli language&quot;">bco</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zway language&quot;">zwa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;resigero language&quot;">rgr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gadsup language&quot;">gaj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;miami (ind. and okla.) language&quot;"
                        >mia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dido language&quot;">ddo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;thao language&quot;">ssf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jaruára language&quot;">jaa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koongo (western kongo) language&quot;"
                        >kng</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;capanahua language&quot;"
                        >kaq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chemgui language&quot;">ady</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;novial (artificial) language&quot;"
                        >nov</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;roviana language&quot;">rug</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ambo (zambia) language&quot;"
                        >leb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jamsay dialect&quot;">djm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hitchiti language&quot;">mik</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;una language&quot;">mtg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guanche language&quot;">gnc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;labo language&quot;">mwi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hmong language&quot;">hmn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lamnso' language&quot;">lns</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sibo language&quot;">nco</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lahuli language&quot;">lbf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ahanta language&quot;">aha</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hanunóo language&quot;">hnn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bagirmi language&quot;">bmi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rengma language&quot;">nre</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ntomba language&quot;">nto</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;inapari language&quot;">inp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baitadi dialect&quot;">nep</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tofa language&quot;">kim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;crimean tatar language&quot;"
                        >crh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mandak language&quot;">mmx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kumyk language&quot;">kum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nubi language&quot;">kcn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;haroi language&quot;">hro</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;washo language&quot;">was</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kumauni language&quot;">kfy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tzoneca language&quot;">teh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bikol language&quot;">bik</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bantawa language&quot;">bap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yimchungru language&quot;"
                        >yim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ludic language&quot;">lud</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kildin sami language&quot;"
                        >sjd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;korana language&quot;">kqz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tswa language&quot;">tsc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwami language&quot;">ksq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mokilese language&quot;">mkj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yahgan language&quot;">yag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hupa language&quot;">hup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern pomo language&quot;"
                        >pej</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chamling language&quot;">rab</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lule sami language&quot;"
                        >smj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mono-alu language&quot;">mte</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaure language&quot;">bpp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nahuatl language&quot;">nah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;plains miwok language&quot;"
                        >pmw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mabuiag language&quot;">mwp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;usarufa language&quot;">usa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tagbanua language&quot;">tbw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;burunge language&quot;">bds</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siane language&quot;">snp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dargari language&quot;">dhr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngologa language&quot;">xkv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sechelt language&quot;">sec</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;roti language&quot;">rgu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jebel nefusa language&quot;"
                        >jbn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yeyi language&quot;">yey</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gadaba (munda) language&quot;"
                        >gbj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ankave language&quot;">aak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;konyak language&quot;">nbe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tagbana language&quot;">tgw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;creek language&quot;">mus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;quileute language&quot;">qui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pasir language&quot;">zlm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwakiutl language&quot;">kwk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kokota language&quot;">kkk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;greek tatar language&quot;"
                        >uum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;napu language&quot;">npy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuku language&quot;">bfa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;semang language&quot;">kns</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;duruma language&quot;">dug</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yuki language&quot;">yuk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dabida language&quot;">dav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyankole language&quot;">nyn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yawa language&quot;">yva</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moldavian language&quot;"
                        >rum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;martu wangka language&quot;"
                        >mpj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alamblak language&quot;">amp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tauya language&quot;">tya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dargwa language&quot;">dar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zhangzhung language&quot;"
                        >xzh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sierra popoluca language&quot;"
                        >poi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yakama language&quot;">yak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saliva language&quot;">sbe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sambas language&quot;">zlm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chiripá language&quot;">nhd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hakétia language&quot;">lad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ormuri language&quot;">oru</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lendu language&quot;">led</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bhatri dialect&quot;">bgw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;itonama language&quot;">ito</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guarayo language&quot;">gyr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yuruti language&quot;">yui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nzebi language&quot;">nzb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;movima language&quot;">mzp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;massachuset language&quot;"
                        >wam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tchien language&quot;">kqo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;provençal language&quot;"
                        >pro</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;susu language&quot;">sus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chacobo language&quot;">cao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuvi language&quot;">kxv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urii language&quot;">uvh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;western subanon language&quot;"
                        >suc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kerinci language&quot;">kvr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yaghwatadaxa language&quot;"
                        >gdf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sirinek language&quot;">ysr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iraqw language&quot;">irk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;batad ifugao language&quot;"
                        >ifb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mongo-nkundu language&quot;"
                        >lol</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sentani language&quot;">set</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hiri motu language&quot;"
                        >hmo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kankanay language&quot;">kne</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;banda language&quot;">liy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;favorlang language&quot;"
                        >bzg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bekati' language&quot;">bei</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalagan language&quot;">kqe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;caluyanun language&quot;"
                        >clu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yakha language&quot;">ybh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dumi language&quot;">dus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ishkashmi language&quot;"
                        >sgl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yecuana language&quot;">mch</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ethiopic language&quot;">gez</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lamandau language&quot;">xdy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;embu language&quot;">ebu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ahraing khumi language&quot;"
                        >cnk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tagalog language&quot;">tgl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jurchen language&quot;">juc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kana language&quot;">ogo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ingrian language&quot;">izh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bole language&quot;">bol</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sabaean language&quot;">xsa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;faliscan language&quot;">xfa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;angkola language&quot;">akb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;powari language&quot;">pwr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;glosa (artificial) language&quot;"
                        >gls</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chipaya language&quot;">cap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;warumungu language&quot;"
                        >wrm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;agta language&quot;">agt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zebaki language&quot;">sgl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalenjin language&quot;">kln</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ogbronuagum language&quot;"
                        >ogu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oirat language&quot;">xal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pay language&quot;">ped</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;buriat language&quot;">bua</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siroi language&quot;">ssd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;suku (congo) language&quot;"
                        >sub</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sahidic language&quot;">cop</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lycian language&quot;">xlc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tahitian language&quot;">tah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bagulal language&quot;">kva</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hazara language&quot;">haz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mkaa' language&quot;">bqz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;turkana language&quot;">tuv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;banoni language&quot;">bcm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;achagua language&quot;">aca</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pahlavi language&quot;">pal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oneida language&quot;">one</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chothe naga language&quot;"
                        >nct</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;orma language&quot;">orc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lezgian language&quot;">lez</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moken language&quot;">mwt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;magindanao language&quot;"
                        >mdh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;motilon language&quot;">mot</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cahuilla language&quot;">chl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laamang language&quot;">hia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tagoi language&quot;">tag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bambatana language&quot;"
                        >baa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zulu language&quot;">zul</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;syènara language&quot;">shz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eyak language&quot;">eya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;panayati language&quot;">mpx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amele language&quot;">aey</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyaneka language&quot;">nyk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;noon language&quot;">snf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aja (benin and togo) language&quot;"
                        >ajg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moklen language&quot;">mkm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;taman language (indonesia)&quot;"
                        >tmn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ayizo-gbe language&quot;"
                        >ayb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sahu language&quot;">saj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bora language&quot;">boa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yimas language&quot;">yee</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kachchhi language&quot;">kfr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;asu language&quot;">ppt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaonde language&quot;">kqn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;trio language&quot;">tri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hurrian language&quot;">xhu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kanuri language&quot;">kau</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koya language&quot;">kff</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsogo language&quot;">tsv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;barngarla language&quot;"
                        >bjb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngemba (cameroon) language&quot;"
                        >nge</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sea islands creole language&quot;"
                        >gul</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uldeme language&quot;">udl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamaiurá language&quot;">kay</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;achi language&quot;">acr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;higaonon language&quot;">mba</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;toba-batak language&quot;"
                        >bbc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;binongko language&quot;">bhq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bukusu language&quot;">bxk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waigali language&quot;">wbk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tlingit language&quot;">tli</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;binandere language&quot;"
                        >bhg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bete language&quot;">byf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abun language&quot;">kgr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pirahá language&quot;">myp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;daribi language&quot;">mps</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khiamniungan language&quot;"
                        >kix</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;edopi language&quot;">dbf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koryak language&quot;">kpy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sawai language&quot;">szw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yangoru language&quot;">bzf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;degema language&quot;">deg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mupun language&quot;">sur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kom (cameroon) language&quot;"
                        >bkm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laqua language&quot;">laq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;spokane language&quot;">spo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;meru language&quot;">mer</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;djirbal language&quot;">dbl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;longuda language&quot;">lnu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lamalama language&quot;">lby</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bunaba language&quot;">bck</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zezuru language&quot;">sna</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mpur language (indonesia)&quot;"
                        >akc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern thai language&quot;"
                        >nod</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;annobon language&quot;">fab</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lele (chad) language&quot;"
                        >lln</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamano language&quot;">kbq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yogli language&quot;">nst</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bokar language&quot;">adi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;winnebago language&quot;"
                        >win</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;himba language&quot;">dhm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mexican sign language&quot;"
                        >mfs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;western dani language&quot;"
                        >dnw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yaghnobi language&quot;">yai</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bomitaba language&quot;">zmx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kâte language&quot;">kmg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;g//ana language&quot;">gnk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kiowa language&quot;">kio</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kott language&quot;">zko</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cueva language&quot;">cuk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kinaray-a language&quot;"
                        >krj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwese language&quot;">kws</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;diola kasa language&quot;"
                        >csk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;konkani language&quot;">kok</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;swedish sign language&quot;"
                        >swl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mundani language&quot;">mnf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sulung language&quot;">suv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tina sambal language&quot;"
                        >xsb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;suk language&quot;">pko</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pitcairnese language&quot;"
                        >pih</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;thakali language&quot;">ths</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iranxe language&quot;">irn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;odual language&quot;">odu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ofo language&quot;">ofo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wik-mungkan language&quot;"
                        >wim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sindhi language&quot;">snd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;emerillon language&quot;"
                        >eme</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chilliwack language&quot;"
                        >hur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sira language&quot;">swj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bolongan language&quot;">blj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oromo language&quot;">orm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tarascan language&quot;">tsz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;clallam language&quot;">clm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;simeulue language&quot;">smr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bahing language&quot;">bhj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ketengban language&quot;"
                        >xte</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kinga language&quot;">zga</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tetum language&quot;">tet</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lisu language&quot;">lis</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nambya language&quot;">nmq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;judeo-persian language&quot;"
                        >jpr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;medlpa language&quot;">med</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ayta anchi sambal language&quot;"
                        >sgb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lilima language&quot;">kck</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;biri (australia) language&quot;"
                        >bzr</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;lamba (zambia and congo) language&quot;"
                        >lam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bisorio language&quot;">bir</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alyawarra language&quot;"
                        >aly</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;limilngan language&quot;"
                        >lmc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;woccon language&quot;">xwc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aramaic language&quot;">arc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bilaspuri language&quot;"
                        >kfs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chuwabo language&quot;">chw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;puelche language&quot;">pue</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;boni (french guiana and suriname) language&quot;"
                        >djk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yuracare language&quot;">yuz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kumbainggar language&quot;"
                        >kgs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cuyunon language&quot;">cyo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khezha language&quot;">nkh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;english language&quot;">eng</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;djimini language&quot;">dyi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amanab language&quot;">amn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bwamu language&quot;">bww</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rendille language&quot;">rel</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dagur language&quot;">dta</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;luiseño language&quot;">lui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bihari language&quot;">bih</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;matlatzinca language&quot;"
                        >mat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wakawaka language&quot;">wkw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moksha language&quot;">mdf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;akei language&quot;">tsr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;angika language&quot;">anp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ixcateco language&quot;">ixc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;afade language&quot;">aal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abe language&quot;">any</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kok borok language&quot;"
                        >trp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kannada language&quot;">kan</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gidar language&quot;">gid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rue language&quot;">bwg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;téén language&quot;">lor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zakhring language&quot;">zkr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;malagasy language&quot;">mlg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ndau language&quot;">ndc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arosi language&quot;">aia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tinrin language&quot;">cir</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hedi language&quot;">xed</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dusun deyah language&quot;"
                        >dun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;awutu language&quot;">afu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;manui language&quot;">wow</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cauqui language&quot;">jqr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karata language&quot;">kpt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ibibio language&quot;">ibb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dagbani language&quot;">dag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;barasana del norte language&quot;"
                        >bao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shuar language&quot;">jiv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khinalugh language&quot;"
                        >kjj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuanyama language&quot;">kua</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dutch sign language&quot;"
                        >dse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atsugewi language&quot;">atw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sikka language&quot;">ski</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsou language&quot;">tsu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kabre language&quot;">kbp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hua (papua new guinea) language&quot;"
                        >ygr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gureng gureng language&quot;"
                        >gnr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;angal heneng language&quot;"
                        >akh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laki language (iran)&quot;"
                        >lki</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kanite language&quot;">kmu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saa language&quot;">apb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbya language&quot;">gun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;estonian language&quot;">est</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zenaga language&quot;">zen</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bhojpuri language&quot;">bho</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mukawa language&quot;">mwc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arabic language&quot;">ara</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbosi language&quot;">mdw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bayungu language&quot;">bxj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rawang language&quot;">raw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yogad language&quot;">yog</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngalakan language&quot;">nig</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ica language&quot;">arh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yalunka language&quot;">yal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pawari language&quot;">bns</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tuwali language&quot;">ifk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pacific gulf yupik language&quot;"
                        >ems</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sacapulteco language&quot;"
                        >quv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;izere language&quot;">fiz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;irula language&quot;">iru</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maanyan language&quot;">mhy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dairi pakpak language&quot;"
                        >btd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tubetube language&quot;">tte</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gbagyi language&quot;">gbr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kudali language&quot;">gom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kukwa language&quot;">kkw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hanga (ghana) language&quot;"
                        >hag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zoró language&quot;">gvo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nielim language&quot;">nie</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;losengo language&quot;">lse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;darai language&quot;">dry</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kulung language&quot;">kle</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kota (india) language&quot;"
                        >kfe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbuko language&quot;">mqb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fali language&quot;">fli</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iowa language&quot;">iow</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaurna language&quot;">zku</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mulao language&quot;">mlm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pileni language&quot;">piv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;krongo language&quot;">kgo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tabasaran language&quot;"
                        >tab</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amahuaca language&quot;">amc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mooré language&quot;">mos</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shimaore language&quot;">swb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karok language&quot;">kyh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tagakaolo language&quot;"
                        >klg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern sierra miwok language&quot;"
                        >nsq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nanticoke language&quot;"
                        >nnt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;suba language&quot;">suh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;havasupai language&quot;"
                        >yuf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moronene language&quot;">mqn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngyemboon language&quot;"
                        >nnh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rotokas language&quot;">roo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;harari language&quot;">har</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tucuna language&quot;">tca</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zeme language&quot;">nzm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tutsa language&quot;">tvt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;padang language&quot;">dip</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;miju language&quot;">mxj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kemant language&quot;">ahg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;badaga language&quot;">bfq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abua language&quot;">abn</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;mo (côte d'ivoire and ghana) language&quot;"
                        >mzw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;talise language&quot;">tlr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dhodia language&quot;">dho</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rang pas language&quot;">rgk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;crioulo language&quot;">pov</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ono language&quot;">ons</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hualapai language&quot;">yuf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;furu language&quot;">fuu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;syriac language&quot;">syr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fiji hindi language&quot;"
                        >hif</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pekal language&quot;">pel</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alawa language&quot;">alh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ket language&quot;">ket</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rif language&quot;">rif</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lavukaleve language&quot;"
                        >lvk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kipsikis language&quot;">kln</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;panzaleo language&quot;">pbb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kambera language&quot;">xbr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vaagri boli language&quot;"
                        >vaa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nengone language&quot;">nen</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;budu language&quot;">buu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyalayu language&quot;">yly</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;runga language&quot;">rou</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;juang language&quot;">jun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yaruro language&quot;">yae</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;quioucohanock language&quot;"
                        >pim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lojban (artificial) language&quot;"
                        >jbo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pushto language&quot;">pus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iban language&quot;">iba</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sakau language&quot;">sku</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mankon language&quot;">nge</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;godié language&quot;">god</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bori language&quot;">adi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gbete dialect&quot;">mdd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mountain koiari language&quot;"
                        >kpx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moshang language&quot;">nmh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;carib language&quot;">car</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cocama language&quot;">cod</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alsea language&quot;">aes</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pothwari language&quot;">phr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aduma language&quot;">dma</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;akkadian language&quot;">akk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kanauji language&quot;">bjj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cora language&quot;">crn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;takelma language&quot;">tkm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bengali language&quot;">ben</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yulu language&quot;">yul</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;münkü language&quot;">irn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;judeo-tajik language&quot;"
                        >bhh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;semendo language&quot;">pse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dacian language&quot;">xdc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lugbara language&quot;">lgg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;suppire language&quot;">spp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chinook language&quot;">chh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dogrib language&quot;">dgr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gude language&quot;">gde</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dan language&quot;">daf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tolaki language&quot;">lbw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mochó language&quot;">mhc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;thai language&quot;">tha</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fang language&quot;">fan</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bafut language&quot;">bfd</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;kara (central african republic and sudan) language&quot;"
                        >kah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gade language&quot;">ged</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;venezuelan sign language&quot;"
                        >vsl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cocopa language&quot;">coc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saweru language&quot;">swr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uru language&quot;">ure</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sango (ubangi creole) language&quot;"
                        >sag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tifal language&quot;">tif</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lower tanudan kalinga language&quot;"
                        >kml</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ebira language&quot;">igb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;osage language&quot;">osa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern sami language&quot;"
                        >sme</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dalmatian (romance) language&quot;"
                        >dlm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tikopia language&quot;">tkp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atacameno language&quot;"
                        >kuz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cashibo language&quot;">cbr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bati language&quot;">btc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mocha language&quot;">moy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;judeo-arabic language&quot;"
                        >jrb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kristang language&quot;">mcm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atayal language&quot;">tay</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wayana language&quot;">way</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chiquito language&quot;">cax</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anem language&quot;">anz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chibcha language&quot;">chb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kiliwa language&quot;">klb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nomaante language&quot;">lem</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fataluku language&quot;">ddg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shan language&quot;">shn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sundanese language&quot;"
                        >sun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngankikurungkurr language&quot;"
                        >nam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;isneg language&quot;">isd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;parvati language&quot;">gbm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;be language&quot;">onb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yagaria language&quot;">ygr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gondi language&quot;">gon</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;banjarese language&quot;"
                        >bjn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maranao language&quot;">mrw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bakumpai language&quot;">bkr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sindang kelingi language&quot;"
                        >liw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tegal language&quot;">jav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bariai language&quot;">bch</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;suau language&quot;">swp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nez percé language&quot;"
                        >nez</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tanimuca-retuama language&quot;"
                        >ynu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mangala language&quot;">mem</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moru language&quot;">mgd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bangwa language&quot;">nwe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jongor language&quot;">mmy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsonga language&quot;">tso</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shasta language&quot;">sht</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anesu language&quot;">ane</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nzakara language&quot;">nzk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nenusa-miangas language&quot;"
                        >tld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;besemah language&quot;">pse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tonkawa language&quot;">tqw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amharic language&quot;">amh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nunuma language&quot;">xsm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nguôn language&quot;">nuo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tajik language&quot;">tgk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbum language&quot;">mdd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lenje language&quot;">leh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;banten language&quot;">jav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dongxiang language&quot;"
                        >sce</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yasa language&quot;">yko</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;choctaw language&quot;">cho</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;damana language&quot;">mbp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eromanga language&quot;">erg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;unde kaili language&quot;"
                        >unz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gyarung language&quot;">jya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;apma language&quot;">app</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;navajo language&quot;">nav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;macaguan language&quot;">mbn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;miyemu language&quot;">mux</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ubir language&quot;">ubr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kului language&quot;">kfx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern arapesh language&quot;"
                        >aoj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eastern bontoc language&quot;"
                        >bkb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siwai language&quot;">siw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ona language&quot;">ona</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gadi language&quot;">gbk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;prussian language&quot;">prg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;osing language&quot;">osi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pular language&quot;">fuf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;welsh language&quot;">cym</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gidabal language&quot;">bdy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;milang language&quot;">adi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kanakuru language&quot;">kna</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;varhadi-nagpuri language&quot;"
                        >vah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mangbetu language&quot;">mdj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;petats language&quot;">pex</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kubu language&quot;">kvb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yoruba language&quot;">yor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;luxembourgish language&quot;"
                        >ltz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;persian language&quot;">fas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;manx language&quot;">glv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arakanese language&quot;"
                        >rki</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;djaru language&quot;">ddj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;palicur language&quot;">plu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rathvi dialect&quot;">bgd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;faiwol language&quot;">fai</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khari boli language&quot;"
                        >hin</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;namia language&quot;">nnm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mawasangka language&quot;"
                        >mnb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tontemboan language&quot;"
                        >tnt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gascon language&quot;">oci</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;slovak language&quot;">slk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;garawa language&quot;">gbc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abor language&quot;">adi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mao naga language&quot;">nbi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ukrainian language&quot;"
                        >ukr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ottawa language&quot;">otw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;biak language&quot;">bhw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tikar language&quot;">tik</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;negidal language&quot;">neg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ata manobo language&quot;"
                        >atd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbai (moissala) language&quot;"
                        >myb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yaayuwee language&quot;">gya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shawnee language&quot;">sjw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tupuri language&quot;">tui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yau language&quot;">yyu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eastern pomo language&quot;"
                        >peb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mianmin language&quot;">mpt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bohairic language&quot;">cop</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;beja language&quot;">bej</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sabaot language&quot;">spy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sioni language&quot;">snn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kangri language&quot;">xnr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chuave language&quot;">cjv</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;sangir (indonesia and philippines) language&quot;"
                        >sxn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bodega miwok language&quot;"
                        >csi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uripiv language&quot;">upv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abkhaz language&quot;">abk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;athpare language&quot;">aph</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tehit language&quot;">kps</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyah kur language&quot;">cbn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gedaged language&quot;">gdd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;boma (congo) language&quot;"
                        >boh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;luyana language&quot;">lyn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bukawa language&quot;">buk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maxi language&quot;">mxl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guayabero language&quot;"
                        >guo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khün language&quot;">kkh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sampang language&quot;">rav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;achang language&quot;">acn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;matumbi language&quot;">mgw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yokuts language&quot;">yok</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;teop language&quot;">tio</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;choroti language&quot;">crt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;soga language&quot;">xog</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cabecar language&quot;">cjp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dhalandji language&quot;"
                        >dhl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tai nüa language&quot;">tdd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laizo (burma) language&quot;"
                        >cfm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wyandot language&quot;">wya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;namakura language&quot;">nmk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yunca language&quot;">omc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;washkuk language&quot;">kmo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tigak language&quot;">tgc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gedeo language&quot;">drs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalâtdlisut language&quot;"
                        >kal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chitimacha language&quot;"
                        >ctm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tobelo language&quot;">tlb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kingwana language&quot;">swc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;angami language&quot;">njm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tiv language&quot;">tiv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nateni language&quot;">ntm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;béarnais language&quot;">oci</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lomwe language (malawi)&quot;"
                        >lon</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mangareva language&quot;"
                        >mrv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;central subanen language&quot;"
                        >syb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siraiki sindhi language&quot;"
                        >skr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;messapian language&quot;"
                        >cms</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;norn language&quot;">nrn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chinbon language&quot;">cnb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kunama language&quot;">kun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;senya language&quot;">afu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sinhalese language&quot;"
                        >sin</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;boiken language&quot;">bzf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abipon language&quot;">axb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ayta mag indi language&quot;"
                        >blx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amikwa language&quot;">ciw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;achuar language&quot;">acu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rawas language&quot;">mui</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;ma'di (uganda and sudan) language&quot;"
                        >mhi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;akhwakh language&quot;">akv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mumuye language&quot;">mzm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;telugu language&quot;">tel</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mator language&quot;">mtm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urali language&quot;">url</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;latin language&quot;">lat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;himachali language&quot;"
                        >him</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;apatani language&quot;">apt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yagua language&quot;">yad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;phalura language&quot;">phl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;caddo language&quot;">cad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tillamook language&quot;"
                        >til</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;irish language&quot;">gle</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;galician language&quot;">glg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sarsi language&quot;">srs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;heiltsuk language&quot;">hei</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nipissing language&quot;"
                        >ojc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anuak language&quot;">anu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zigula language&quot;">ziw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;narrinyeri language&quot;"
                        >nay</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jabo language&quot;">grj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rengao language&quot;">ren</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;herero language&quot;">her</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sissano language&quot;">sso</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pima bajo language&quot;"
                        >pia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kachin language&quot;">kac</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uighur language&quot;">uig</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dutch language&quot;">nld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;white tai language&quot;"
                        >twh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;illinois language&quot;">mia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;simte language&quot;">smt</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;kaiwa (papua new guinea) language&quot;"
                        >kbm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;scots language&quot;">sco</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;talinga-bwisi language&quot;"
                        >tlj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mishar language&quot;">tat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nogai language&quot;">nog</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;attic greek language&quot;"
                        >grc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tuvaluan language&quot;">tvl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;svan language&quot;">sva</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;xhosa language&quot;">xho</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mahican language&quot;">mjy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maban language&quot;">mfz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nuer language&quot;">nus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sagara language&quot;">kki</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tatana' language&quot;">txx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guahibo language&quot;">guh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karipuna creole language&quot;"
                        >kmv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;quinault language&quot;">qun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;diola language&quot;">dyu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;daa language&quot;">kzf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuuku ya'u language&quot;"
                        >kuy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khandesi language&quot;">khn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwatay language&quot;">cwt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;igo language&quot;">ahl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;turkish language&quot;">tur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sema language&quot;">nsm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kashaya language&quot;">kju</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rangdania language&quot;"
                        >rah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;venda language&quot;">ven</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waima'a language&quot;">wmh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ingilo language&quot;">kat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;enggano language&quot;">eno</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;konda language&quot;">kfc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rawa language&quot;">rwo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lunda language&quot;">lun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;luba-katanga language&quot;"
                        >lub</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mlabri language&quot;">mra</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bini language&quot;">bin</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urim language&quot;">uri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;war language&quot;">aml</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bangaru language&quot;">bgc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vige language&quot;">vig</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chamba lahuli language&quot;"
                        >lae</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mattole language&quot;">mvb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dogri language&quot;">dgo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yapese language&quot;">yap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kurku language&quot;">kfq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cavineño language&quot;">cav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bekwarra language&quot;">bkv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wotu language&quot;">wtw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mailu language&quot;">mgu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lungchang language&quot;"
                        >nst</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nehan language&quot;">nsn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern paiute language&quot;"
                        >pao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;burushaski language&quot;"
                        >bsk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yazghulami language&quot;"
                        >yah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbara (chad) language&quot;"
                        >mpk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ndumu language&quot;">nmd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dungra bhil language&quot;"
                        >duh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yui language&quot;">sll</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hiligaynon language&quot;"
                        >hil</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamchadal language&quot;"
                        >itl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;penesak language&quot;">mui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbugwe language&quot;">mgz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sangil language&quot;">snl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chiricahua language&quot;"
                        >apm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bwaidoga language&quot;">bwd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hungana language&quot;">hum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tagish language&quot;">tgx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;toba (indian) language&quot;"
                        >tob</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bartang language&quot;">sgh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;marathi language&quot;">mar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khomani language&quot;">ngh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;omi language&quot;">omi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wangganguru language&quot;"
                        >wgg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ukhrul language&quot;">nmf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ranquel dialect&quot;">arn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;phu thai language&quot;">pht</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aranda language&quot;">are</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;manyika language&quot;">mxc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sulka language&quot;">sua</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siar-lak language&quot;">sjr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;teda language&quot;">tuq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;murrinhpatha language&quot;"
                        >mwf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uduk language&quot;">udu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyambo language&quot;">now</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;curripaco language&quot;"
                        >kpc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cofán language&quot;">con</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;thulung language&quot;">tdh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;qebena dialect&quot;">ktb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;armenian, modern language&quot;"
                        >hye</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;epena saija language&quot;"
                        >sja</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pitjantjatjara language&quot;"
                        >pjt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gujarati language&quot;">guj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ot danum language&quot;">otd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siksika language&quot;">bla</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;avaric language&quot;">ava</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wiradjuri language&quot;"
                        >wrh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern subanen language&quot;"
                        >laa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dendi language&quot;">ddn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kiriwinian language&quot;"
                        >kij</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pampanga language&quot;">pam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;longgu language&quot;">lgu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dhimal language&quot;">dhi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;afshar language&quot;">azb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uzbek language&quot;">uzb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;walser language&quot;">wae</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hangaza language&quot;">han</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;montagnais language&quot;"
                        >moe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tupi language&quot;">tpw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rembarrnga language&quot;"
                        >rmb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dzongkha language&quot;">dzo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chang language&quot;">nbc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bakundu language&quot;">bdu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;woisika language&quot;">woi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;teso language&quot;">teo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lematang language&quot;">mui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zuni language&quot;">zun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wiyot language&quot;">wiy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sakata language&quot;">skt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bari language&quot;">bfa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jicaque language&quot;">jic</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bella coola language&quot;"
                        >blc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jaminaua language&quot;">yaa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dyula language&quot;">dyu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sharanahua language&quot;"
                        >mcd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;meratus language&quot;">bvu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chutiya language&quot;">der</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laadi language&quot;">ldi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bambara language&quot;">bam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chokwe language&quot;">cjk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ramoaaina language&quot;"
                        >rai</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lika language&quot;">lik</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;konda‑reddi dialect&quot;"
                        >tel</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;boomu language&quot;">bmq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;buol language&quot;">blf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arikara language&quot;">ari</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kusunda language&quot;">kgg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chamicuro language&quot;"
                        >ccc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bobo fing language&quot;"
                        >bbo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;italian language&quot;">ita</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;marari language&quot;">bfy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;soliga language&quot;">sle</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;garo language&quot;">grt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wampanoag language&quot;"
                        >wam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nihali language&quot;">nll</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;krio language&quot;">kri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chaha language&quot;">sgw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;central sama language&quot;"
                        >sml</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ponosakan language&quot;"
                        >pns</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;idaté language&quot;">idt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;inoke language&quot;">ino</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kattang language&quot;">kda</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cubeo language&quot;">cub</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;malvi language&quot;">mup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kurdish language&quot;">kur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bonda language&quot;">bfw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kumiai language&quot;">coj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tatar language&quot;">tat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;czech language&quot;">ces</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;algonquin language&quot;"
                        >alq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kui (mon-khmer) language&quot;"
                        >kdt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sursurunga language&quot;"
                        >sgz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kapingamarangi language&quot;"
                        >kpg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yerukala language&quot;">yeu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sawu language&quot;">hvn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laal language&quot;">gdm</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;boni (kenya and somalia) language&quot;"
                        >bob</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;munichi language&quot;">myr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sotang kura language&quot;"
                        >kle</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alacaluf language&quot;">alc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;twi language&quot;">twi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bondei language&quot;">bou</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;obo manobo language&quot;"
                        >obo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;phoenician language&quot;"
                        >phn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tapirapé language&quot;">taf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fe'fe' language&quot;">fmp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;opata language&quot;">opt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tlakluit language&quot;">wac</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lakher language&quot;">mrh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sena language&quot;">seh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;big nambas language&quot;"
                        >nmb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waris language&quot;">wrs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bagheli language&quot;">bfy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bimanese language&quot;">bhp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;inupiaq language&quot;">ipk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;boran language&quot;">gax</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern mofu language&quot;"
                        >mif</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyanja language&quot;">nya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kimbundu language&quot;">kmb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;palaic language&quot;">plq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moro (south america) language&quot;"
                        >ayo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jhāḍī dialect&quot;">mar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wagdi language&quot;">wbr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yellow uighur language&quot;"
                        >ybe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;duungidjawu language&quot;"
                        >wkw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wardaman language&quot;">wrr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eastern yugur language&quot;"
                        >yuy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lwo (sudan) language&quot;"
                        >lwo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rapanui language&quot;">rap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamoro language&quot;">kgq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;day (chad) language&quot;"
                        >dai</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saho language&quot;">ssy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ritarungo language&quot;"
                        >rit</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lefana language&quot;">lef</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sadani language&quot;">sck</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kara (papua new guinea) language&quot;"
                        >leu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rai language&quot;">aph</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gothic language&quot;">got</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tiddim chin language&quot;"
                        >ctd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;toraja sa'dan language&quot;"
                        >sda</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;huichol language&quot;">hch</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern kankanay language&quot;"
                        >xnn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lyele language&quot;">gnh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cia-cia language&quot;">cia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karachay-balkar language&quot;"
                        >krc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;slovincian language&quot;"
                        >csb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;binukid manobo language&quot;"
                        >bkd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ingush language&quot;">inh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abure language&quot;">abu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;faroese language&quot;">fao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;awadhi language&quot;">awa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;thracian language&quot;">txh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gahuku language&quot;">gah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chugach language&quot;">ems</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gusii language&quot;">guz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tangsa language&quot;">nst</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbaya language&quot;">kbc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;east uvean language&quot;"
                        >wls</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;archi language&quot;">aqc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dakhini language&quot;">dcc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pali language&quot;">pli</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;peranakan indonesian language&quot;"
                        >pea</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amdo language&quot;">adx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sobei language&quot;">sob</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nankina language&quot;">nnk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;musei language&quot;">mse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ladin language&quot;">lld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;balong language&quot;">bwt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tombulu language&quot;">tom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cherokee language&quot;">chr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;doko (congo) language&quot;"
                        >ngc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khaling language&quot;">klr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ute language&quot;">ute</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mambai language&quot;">mgm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;white mountain apache language&quot;"
                        >apw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;isleta language&quot;">tix</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lindrou language&quot;">lid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;serer language&quot;">srr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koshti (marathi) language&quot;"
                        >mar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ganguela language&quot;">nba</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chinali language&quot;">cih</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;natchez language&quot;">ncz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bintauna language&quot;">bne</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngada language&quot;">nxg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;are dialect&quot;">mar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sama sibutu language&quot;"
                        >ssb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gaddang language&quot;">gad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;korekore language&quot;">sna</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;luwian language&quot;">hit</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lenca language&quot;">len</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;puquina language&quot;">puq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aymara language&quot;">aym</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nicaraguan sign language&quot;"
                        >ncs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;simelungun language&quot;"
                        >bts</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ayiwo language&quot;">nfl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;greek language&quot;">grc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anglo-norman language&quot;"
                        >xno</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;mbunda (angola and zambia) language&quot;"
                        >mck</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wawenock language&quot;">aaq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;leuangiua language&quot;"
                        >ojv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dupaninan agta language&quot;"
                        >duo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;balantak language&quot;">blz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kemak language&quot;">kem</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rotuman language&quot;">rtm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bajau language&quot;">bdl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khalaj language&quot;">kjf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;salampasu language&quot;"
                        >slx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mukomuko language&quot;">min</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gunian language&quot;">gni</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cholon language&quot;">cht</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kutenai language&quot;">kut</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guatuso language&quot;">gut</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cakavian language&quot;">hrv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;birri language&quot;">bvq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dampelasa language&quot;"
                        >dms</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kurada language&quot;">kud</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dafla language&quot;">dap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guaymi language&quot;">gym</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mungaka language&quot;">mhk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tetela language&quot;">tll</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;carpatho-rusyn language&quot;"
                        >rue</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;colorado language&quot;">cof</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;burum (papua new guinea) language&quot;"
                        >bmu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gwandara language&quot;">gwn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tagin language&quot;">dap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aklanon language&quot;">akl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;colville language&quot;">oka</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;buru language&quot;">mhs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rao language&quot;">rao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;semelai language&quot;">sza</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nali language&quot;">nss</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;torgut language&quot;">xal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;limbu language&quot;">lif</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saberi language&quot;">srl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chimariko language&quot;"
                        >cid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atsera language&quot;">adz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fulnio language&quot;">fun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;punic language&quot;">xpu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uspanteca language&quot;"
                        >usp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bafia language&quot;">ksf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yavapai language&quot;">yuf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mobilian trade language&quot;"
                        >akz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;birhor language&quot;">biy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;imeretian language&quot;"
                        >kat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yala language&quot;">yba</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;musgu language&quot;">mug</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;harsusi language&quot;">hss</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;swahili language&quot;">swh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;irahutu language&quot;">irh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;snohomish language&quot;"
                        >sno</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lom language&quot;">mfb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;coquille language&quot;">coq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gã language&quot;">gaa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;katingan language&quot;">nij</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;corsican language&quot;">cos</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ulithi language&quot;">li</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kurmali language&quot;">kyw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamba language&quot;">kam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;padam language&quot;">adi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngarinyin language&quot;"
                        >ung</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;catawba language&quot;">chc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lau language&quot;">llu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngarluma language&quot;">nrl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nharo language&quot;">nhr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ubykh language&quot;">uby</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oowekyala language&quot;"
                        >hei</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pengo language&quot;">peg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyamwezi language&quot;">nym</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jur modo language&quot;">bex</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;buli language&quot;">bwu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khalkha language&quot;">khk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dakota language&quot;">dak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;huao language&quot;">auc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tura language&quot;">neb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;berik language&quot;">bkl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amuesha language&quot;">ame</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tamajaq language&quot;">tmh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nancowry language&quot;">ncb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;huli language&quot;">hui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;inor language&quot;">ior</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kajkavian language&quot;"
                        >hrv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lak language&quot;">lbe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;xinca language&quot;">xin</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;valman language&quot;">van</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;santali language&quot;">sat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bahnar language&quot;">bdq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;stalo language&quot;">hur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sumo language&quot;">sum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;icelandic language&quot;"
                        >isl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;udekhe language&quot;">ude</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ogan language&quot;">pse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bribri language&quot;">bzd</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;yombe (congo and angola) language&quot;"
                        >yom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;komi-yaz'va language&quot;"
                        >kpv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khowar language&quot;">khw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bankudu-balue language&quot;"
                        >bdu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;konkomba language&quot;">xon</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yakö language&quot;">yaz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;afrikaans language&quot;"
                        >afr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;meroitic language&quot;">xmr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;secoya language&quot;">sey</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;muinane language&quot;">bmr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;port sandwich language&quot;"
                        >psw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sangu (gabon) language&quot;"
                        >snq</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;magi (southern highlands province, papua new guinea) language&quot;"
                        >aoe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;makonde language&quot;">kde</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nias language&quot;">nia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zande language&quot;">zne</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;to'abaita language&quot;"
                        >mlu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tampulma language&quot;">tpm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sasak language&quot;">sas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nunggubuyu language&quot;"
                        >nuy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;luba-lulua language&quot;"
                        >lua</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mwamba language&quot;">wbh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;coreguaje language&quot;"
                        >coe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mokulu language&quot;">moz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wasco language&quot;">wac</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wantoat language&quot;">wnc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;marwari language&quot;">mwr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ho language&quot;">hoc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;umpila language&quot;">ump</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;acoli language&quot;">ach</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kagaba language&quot;">kog</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;inuktitut language&quot;"
                        >iku</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;thai sign language&quot;"
                        >tsq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;samaritan hebrew language&quot;"
                        >smp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sami language&quot;">raq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vandal language&quot;">xvn</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;japanese--heian period, 794-1185 language&quot;"
                        >ojp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sui language&quot;">swi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kluet language&quot;">btz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuranko language&quot;">knk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ipurina language&quot;">apu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;delaware language&quot;">del</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaulong language&quot;">pss</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bikaneri language&quot;">rwr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alur language&quot;">alz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karanga language&quot;">kth</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;djingili language&quot;">jig</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gisu language&quot;">myx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bakhtiari language&quot;"
                        >bqi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;salinan language&quot;">sln</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;telefol language&quot;">tlf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tok pisin language&quot;"
                        >tpi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wolio language&quot;">wlo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;elamite language&quot;">elx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kgalagadi language&quot;"
                        >xkv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mafa language&quot;">maf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;taiwano language&quot;">bsn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;klingon (artificial) language&quot;"
                        >tlh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;quinnipiac language&quot;"
                        >qyp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bagyele language&quot;">gyi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;american sign language&quot;"
                        >ase</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gbari language&quot;">gby</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yerava language&quot;">yea</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;french language&quot;">fra</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cayapa language&quot;">cbi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kisa language&quot;">luy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kumali language&quot;">kra</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chemehuevi language&quot;"
                        >ute</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;florida language&quot;">nlg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;muduva language&quot;">muv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kato language&quot;">ktw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cheyenne language&quot;">chy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;panjabi language&quot;">pan</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tigré language&quot;">tig</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bubi language (gabon)&quot;"
                        >buw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tectiteco language&quot;"
                        >ttc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rikbaktsa language&quot;"
                        >rkb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vagala language&quot;">vag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saanich language&quot;">str</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;erre language&quot;">err</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bolinao language&quot;">smk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;buduma language&quot;">bdm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khorezmian turkic language&quot;"
                        >zkh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;efik language&quot;">efi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern sotho language&quot;"
                        >nso</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;konjo language&quot;">koo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;quenya (artificial) language&quot;"
                        >qya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;munji language&quot;">mnj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paranan language&quot;">agp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yemba language&quot;">ybb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iwaidji language&quot;">ibd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pahri language&quot;">new</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kakwa language&quot;">keo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eton language&quot;">eto</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;judeo-italian language&quot;"
                        >itk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lower sorbian language&quot;"
                        >dsb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mota language&quot;">mtt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;upper sorbian language&quot;"
                        >hsb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;betsileo language&quot;">plt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern kalinga language&quot;"
                        >ksc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;manam language&quot;">mva</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;javanese language&quot;">jav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maricopa language&quot;">mrc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mpongwe language&quot;">mye</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paama language&quot;">pma</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waja language&quot;">wja</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;melebuganon language&quot;"
                        >pwm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oriya language&quot;">ori</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aguaruna language&quot;">agr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ossetic language&quot;">oss</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwara'ae language&quot;">kwf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;serbian language&quot;">srp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ibani language&quot;">iby</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wotapuri-katarqalai language&quot;"
                        >wsv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mundu (sudan and congo) language&quot;"
                        >muh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paite language&quot;">pck</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;babine language&quot;">bcr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuvakan language&quot;">bak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;harauti language&quot;">hoj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyore language&quot;">nyd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yanomamo language&quot;">guu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oluta language&quot;">plo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nimadi language&quot;">noe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;belarusian language&quot;"
                        >bel</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dumbea language&quot;">duf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nama language&quot;">naq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shona language&quot;">sna</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;costa rican sign language&quot;"
                        >csr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;olonets language&quot;">olo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tiéfo language&quot;">tiq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;djinang language&quot;">dji</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mongour language&quot;">mjg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sumerian language&quot;">sux</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;terraba language&quot;">tfr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gamo language&quot;">gmo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sokotri language&quot;">sqt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bhili language&quot;">bhb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;taimoro language&quot;">mlg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;onondaga language&quot;">ono</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngaun language&quot;">cnw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kawaiisu language&quot;">xaw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kariri language&quot;">kzw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;judeo-tat language&quot;"
                        >jdt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;black tai language&quot;"
                        >blt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ekajuk language&quot;">eka</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngizim language&quot;">ngi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kitja language&quot;">gia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amarag language&quot;">amg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lintang language&quot;">pse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;taensa language&quot;">ncz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;agri language&quot;">knn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ndonga language&quot;">ndo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;managalasi language&quot;"
                        >mcq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ranau language&quot;">ljp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wappo language&quot;">wao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;swedish language&quot;">swe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gogo language&quot;">gog</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bembe (lake tanganyika) language&quot;"
                        >bmb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaki ae language&quot;">tbd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siriano language&quot;">sri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ila language&quot;">ilb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;igala language&quot;">igl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;korean--to 935 language&quot;"
                        >oko</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;raetian language&quot;">xrr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sapuan language&quot;">spu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;letri lgona language&quot;"
                        >lex</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chontaquiro language&quot;"
                        >cuj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uare language&quot;">ksj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jaipuri language&quot;">dhd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;idakho-isukha-tiriki language&quot;"
                        >ida</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yir-yoront language&quot;"
                        >yiy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bune bonda language&quot;"
                        >swu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sogdian language&quot;">sog</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bats language&quot;">bbl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mirandese language&quot;"
                        >mwl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;andoque language&quot;">ano</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wageman language&quot;">waq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;toma language&quot;">tod</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kickapoo language&quot;">kic</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;piaroa language&quot;">pid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chamorro language&quot;">cha</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tiwi (australia) language&quot;"
                        >tiw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;japanese language&quot;">jpn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ese ejja language&quot;">ese</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;byangsi language&quot;">bee</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;serawai language&quot;">pse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;malayalam language&quot;"
                        >mal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern tutchone language&quot;"
                        >tce</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;quara language&quot;">ahg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hula language&quot;">hul</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;misima language&quot;">mpx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;achinese language&quot;">ace</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lovari language&quot;">rmy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sakalava language&quot;">skg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baki language&quot;">bki</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kasem language&quot;">xsm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tolai language&quot;">ksd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;benga language&quot;">bng</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oto language&quot;">iow</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maranungku language&quot;"
                        >zmr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ao language&quot;">njo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngarinyman language&quot;"
                        >nbj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ocaina language&quot;">oca</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bisio language&quot;">nmg</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;luo (kenya and tanzania) language&quot;"
                        >luo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;imbo ungu language&quot;"
                        >imo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tami language&quot;">tmy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;balante language&quot;">ble</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nabak language&quot;">naf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mudburra language&quot;">mwd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nocte language&quot;">njb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tanacross language&quot;"
                        >tcb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;timucua language&quot;">tjm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;penobscot language&quot;"
                        >aaq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dadjriwalé dialect&quot;"
                        >god</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vaiphei language&quot;">vap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guarani language&quot;">grn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tidore language&quot;">tvo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;székely language&quot;">hun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;miskito language&quot;">miq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;benge language&quot;">bww</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yao (africa) language&quot;"
                        >yao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gungabula language&quot;"
                        >gyf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pitta pitta language&quot;"
                        >pit</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shughni language&quot;">sgh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chabacano language&quot;"
                        >cbk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amis language&quot;">ami</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bonan language&quot;">peh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mahri language&quot;">gdq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mopan language&quot;">mop</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chipewyan language&quot;"
                        >chp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khvarshi language&quot;">khv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bakwé language&quot;">bjw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;balinese language&quot;">ban</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;barai language&quot;">bbb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fuliru language&quot;">flr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nimboran language&quot;">nir</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;piro (tanoan) language&quot;"
                        >pie</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rundi language&quot;">run</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;west makian language&quot;"
                        >mqs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bijago language&quot;">bjg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moguex language&quot;">gum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shipibo-conibo language&quot;"
                        >shp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lakota language&quot;">lkt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yakut language&quot;">sah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;diyari language&quot;">dif</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mangue language&quot;">cjr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alutor language&quot;">alr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nkoya language&quot;">nka</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jama mapun language&quot;"
                        >sjm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;folopa language&quot;">ppo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tariana language&quot;">tae</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;salar language&quot;">slr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;toda (india) language&quot;"
                        >tcx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;luvale language&quot;">lue</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yanzi language&quot;">yns</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wariyangga language&quot;"
                        >wri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baluchi language&quot;">bal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ganda language&quot;">lug</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kposo language&quot;">kpo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;suriname hindustani language&quot;"
                        >hns</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;north efate language&quot;"
                        >llp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uma language&quot;">ppk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;asuri language&quot;">asr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;old persian language&quot;"
                        >peo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;caquinte language&quot;">cot</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;quechua language&quot;">que</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atakapa language&quot;">aqp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mwenyi language&quot;">sie</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;digaro language&quot;">mhu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;adygei language&quot;">ady</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maring language&quot;">mbw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kiangan ifugao language&quot;"
                        >ifk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ejagham language&quot;">etu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pamona language&quot;">pmf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lashi language&quot;">lsi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalam language&quot;">kmh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;komo (congo) language&quot;"
                        >kmw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dumagat (umirey) language&quot;"
                        >due</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalamian language&quot;">tbk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tojolabal language&quot;"
                        >toj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;marigl language&quot;">gvf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baining language&quot;">byx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arop-lokep language&quot;"
                        >apr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;puluwat language&quot;">puw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tat language&quot;">ttt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;blang language&quot;">blr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anggor language&quot;">agg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chamacoco language&quot;"
                        >ceg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kare language&quot;">kbj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;piratapuyo language&quot;"
                        >pir</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;coos language&quot;">csz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bolaang mongondow language&quot;"
                        >mog</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbete language&quot;">mdt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mandar language&quot;">mdr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shuswap language&quot;">shs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;huambisa language&quot;">hub</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chamba daka language&quot;"
                        >ccg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ijo language&quot;">ijc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pala language&quot;">gfk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zaza language&quot;">zza</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jenukuruba language&quot;"
                        >kan</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;senari language&quot;">sef</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bakairi language&quot;">bkq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamwe language&quot;">hig</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sukuma language&quot;">suk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karaim language&quot;">kdr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyanga language&quot;">nyj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;seruyan language&quot;">kkx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bemba language&quot;">bem</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mandingo language&quot;">man</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;igbo language&quot;">ibo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;futuna-aniwa language&quot;"
                        >fut</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atchin language&quot;">upv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hua lisu language&quot;">lis</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;magahi language&quot;">mag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nawdm language&quot;">nmz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sivandi language&quot;">siy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shina language&quot;">scl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yeniche language&quot;">yec</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kazakh language&quot;">kaz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngaju language&quot;">nij</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lumbu (gabon) language&quot;"
                        >lup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bunama language&quot;">bdd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;western yugur language&quot;"
                        >ybe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mandaean language&quot;">mid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dangaleat language&quot;"
                        >daa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nisqually language&quot;"
                        >lut</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iduna language&quot;">viv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;korowai language&quot;">khe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyiha language&quot;">nih</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tangut language&quot;">txg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;biloxi language&quot;">bll</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngiti language&quot;">niy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bushoong language&quot;">buf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guhu-samane language&quot;"
                        >ghs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bengkulu language&quot;">pse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ndunga language&quot;">ndt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tepera language&quot;">tnm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lamaholot language&quot;"
                        >slp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bobangi language&quot;">bni</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lewoingu dialect&quot;">slp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nancere language&quot;">nnc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dyan language&quot;">dya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lebou language&quot;">wol</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tarok language&quot;">yer</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gabri language&quot;">gab</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mpiemo language&quot;">mcx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lanao moro language&quot;"
                        >mrw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sissala language&quot;">sld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lamé (cameroon) language&quot;"
                        >lme</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bandjalang language&quot;"
                        >bdy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pipil language&quot;">ppl</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;baka (cameroon and gabon) language&quot;"
                        >bkc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mountain arapesh language&quot;"
                        >ape</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vejoz language&quot;">wlv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bugun language&quot;">bgg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oroch language&quot;">oac</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pattani (thailand) language&quot;"
                        >mfa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lorhon language&quot;">lor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;istro-romanian language&quot;"
                        >ruo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anal language&quot;">anm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bable language&quot;">ast</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mandjak language&quot;">mfv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;timor language&quot;">bkx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwafi language&quot;">mas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;batak language&quot;">bya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pintupi language&quot;">piu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;akka language&quot;">che</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;suquamish language&quot;"
                        >squ</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eastern arrernte language&quot;"
                        >aer</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sherbro language&quot;">bun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwangali language&quot;">kwn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mpus language&quot;">mug</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shi language&quot;">shr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bidjara language&quot;">bym</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hadiya language&quot;">hdy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hunzib language&quot;">huz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bebele language&quot;">beb</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;ngoni language (tanzania and mozambique)&quot;"
                        >ngo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;madaglashti language&quot;"
                        >prs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wewewa language&quot;">wew</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alas language&quot;">btz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;polabian language&quot;">pox</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern khanty language&quot;"
                        >kca</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;basketo language&quot;">bst</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;susquehanna language&quot;"
                        >sqn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yay language&quot;">pcc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mesqan language&quot;">mvz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;armenian, middle language&quot;"
                        >axm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pochury language&quot;">npo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yanyuwa language&quot;">jao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;umbundu language&quot;">umb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;balaesang language&quot;"
                        >bls</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jindjibandji language&quot;"
                        >yij</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kodagu language&quot;">kfa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;au language&quot;">avt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;komodo language&quot;">kvh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;takuu language&quot;">nho</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalkatungu language&quot;"
                        >ktg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;angas language&quot;">anc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jeh language&quot;">jeh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koiari language&quot;">kbk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sarangani manobo language&quot;"
                        >mbs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paipai language&quot;">ppi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;udi language&quot;">udi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yopno language&quot;">yut</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yele language&quot;">yle</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;deli language&quot;">zlm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;macú language&quot;">mbr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;basap language&quot;">bdb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngwa language&quot;">ibo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mayoruna language&quot;">mcf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kongara language&quot;">nas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aulua language&quot;">aul</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bidiyo language&quot;">bid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hindi language&quot;">hin</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;leko language&quot;">lse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;german language&quot;">deu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moro (sudan) language&quot;"
                        >mor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;seminole language&quot;">mus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maa (southeastern asia) language&quot;"
                        >cma</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;frafra language&quot;">gur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pennsylvania german language&quot;"
                        >pdc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;itene language&quot;">ite</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mandan language&quot;">mhq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern bontoc language&quot;"
                        >bkb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;divehi language&quot;">div</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbili language&quot;">baw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tay-nung language&quot;">nut</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;banjar hulu language&quot;"
                        >bjn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;friulian language&quot;">fur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kosarek language&quot;">kkl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;midob language&quot;">mei</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;swazi language&quot;">ssw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;madiya-gondi language&quot;"
                        >mrr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lushai language&quot;">lus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tindi language&quot;">tin</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lopa (nepal) language&quot;"
                        >loy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;british sign language&quot;"
                        >bfi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dharawal language&quot;">tbh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tyembara language&quot;">sef</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rongmei language&quot;">nbu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kisar language&quot;">kje</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bariba language&quot;">bba</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;taungthu language&quot;">blk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;minaean language&quot;">inm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;burarra language&quot;">bvr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuku-yalanji language&quot;"
                        >gvn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;loma language&quot;">lom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;evenki language&quot;">evn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mewari language&quot;">mtr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;samburu language&quot;">saq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dedua language&quot;">ded</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;piapoco language&quot;">pio</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;manchu language&quot;">mnc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jemez language&quot;">tow</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sherdukpen language&quot;"
                        >sdp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gorani language&quot;">hac</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;xaragure language&quot;">axx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cifundi language&quot;">swh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsattine language&quot;">bea</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;manambu language&quot;">mle</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wedau language&quot;">wed</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urartian language&quot;">xur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyulnyul language&quot;">nyv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;south african sign language&quot;"
                        >sfs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;romanian language&quot;"
                        >ron/rum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bororo (brazil) language&quot;"
                        >bor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dii language&quot;">bta</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ongota language&quot;">bxe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tembo (sud-kivu, congo) language&quot;"
                        >tbt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bom language&quot;">boj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;agutaynon language&quot;"
                        >agn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chitapavani language&quot;"
                        >gom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bangolan language&quot;">bgj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tawoyan language&quot;">twy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;izi language&quot;">izi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lhomi language&quot;">lhm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ekpeye language&quot;">ekp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;banton language&quot;">bno</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;batak (philippines) language&quot;"
                        >bya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bugotu language&quot;">bgt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;masacali language&quot;">mbl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bai (china) language&quot;"
                        >bca</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lucazi language&quot;">lch</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nupe language&quot;">nup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hidatsa language&quot;">hid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lepcha language&quot;">lep</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;meta language (cameroon)&quot;"
                        >mgo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;biat language&quot;">cmo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern bullom language&quot;"
                        >buy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bahinemo language&quot;">bjh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yamphu language&quot;">ybi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zou language&quot;">zom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sanskrit language&quot;">san</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mundang language&quot;">mua</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nukunu language&quot;">nnv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vilela language&quot;">vil</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;larike-wakasihu language&quot;"
                        >alo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gilbertese language&quot;"
                        >gil</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nauru language&quot;">nau</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;campa language&quot;">cni</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;andilyaugwa language&quot;"
                        >aoi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;basque language&quot;">eus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chiriguano language&quot;"
                        >gui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kunabi language&quot;">knn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kraho language&quot;">xra</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mura language&quot;">myp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalmyk language&quot;">xal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;indonesian sign language&quot;"
                        >inl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cirebon language&quot;">sun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;silte language&quot;">stv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abulas language&quot;">abt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bilin language&quot;">byn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;makasai language&quot;">mkz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gunwinggu language&quot;"
                        >gup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pehuenche language&quot;"
                        >arn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ouargla language&quot;">oua</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wandala language&quot;">mfi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laven language&quot;">lbo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mambwe language&quot;">mgr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;araona language&quot;">aro</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kagoro (nigeria) language&quot;"
                        >kcg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;finnish language&quot;">fin</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;palan language&quot;">kpy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cheke holo language&quot;"
                        >mrn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lenakel language&quot;">tnl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;stokavian language&quot;"
                        >srp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bukar sadong language&quot;"
                        >sdo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;toposa language&quot;">toq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;murle language&quot;">mur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chahar language&quot;">mvf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lotuko language&quot;">lot</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsakhur language&quot;">tkr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ruc language&quot;">scb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;balangingì language&quot;"
                        >sse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yabiyufa language&quot;">yby</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cotabato manobo language&quot;"
                        >mta</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;phrygian language&quot;">xpg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;orejón language&quot;">ore</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gogodala language&quot;">ggw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;akhmimic dialect&quot;">cop</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;muruwari language&quot;">zmu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hungarian language&quot;"
                        >hun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wiru language&quot;">wiu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;even language&quot;">eve</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tumbuka language&quot;">tum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;macuna language&quot;">myy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;miji language&quot;">sjl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vayu language&quot;">vay</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hixkaryana language&quot;"
                        >hix</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siuslaw language&quot;">sis</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bororo (west africa) language&quot;"
                        >fuv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kayapa kallahan language&quot;"
                        >kak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;duala language&quot;">dua</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koyukon language&quot;">koy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;manuvu language&quot;">obo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bosnian language&quot;">bos</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rembong language&quot;">reb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbo (cameroon) language&quot;"
                        >mbo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lambau language&quot;">snp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;canichana language&quot;"
                        >caz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dimasa language&quot;">dis</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lydian language&quot;">xld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paiwan language&quot;">pwn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;camuhi language&quot;">cam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;obolo language&quot;">ann</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maue language&quot;">mav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;begak language&quot;">dbj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;isinay language&quot;">inn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;awabakal language&quot;">awk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamilaroi language&quot;"
                        >kld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;masa (chadic) language&quot;"
                        >mcn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mono (congo) language&quot;"
                        >mnh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tacana (bolivia) language&quot;"
                        >tna</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bawo (indonesia) language&quot;"
                        >lbx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gimi language&quot;">gim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ilianen manobo language&quot;"
                        >mbi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mukri language&quot;">ckb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maay language&quot;">ymm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hunde language&quot;">hke</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;garhwali language&quot;">gbm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khuf language&quot;">sgh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tulung language&quot;">duu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pero language&quot;">pip</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ndebele (zimbabwe) language&quot;"
                        >nde</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mysian language&quot;">yms</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ajie language&quot;">aji</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;latvian language&quot;">lav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nanai language&quot;">gld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baule language&quot;">bci</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;itawis language&quot;">itv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zaghawa language&quot;">zag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yemsa language&quot;">jnj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vaturanga language&quot;"
                        >gri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;banyjima language&quot;">pnw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mada (cameroon) language&quot;"
                        >mxu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iberian language&quot;">xib</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;carapana (tucanoan) language&quot;"
                        >cbc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iha language&quot;">ihp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hehe language&quot;">heh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chakma language&quot;">ccp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bassari language&quot;">bsc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kusu language&quot;">ksv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sobojo language&quot;">tlv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vietnamese language&quot;"
                        >vie</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hmar language&quot;">hmr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gbandi language&quot;">bza</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urubu kaapor language&quot;"
                        >urb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;old norse language&quot;"
                        >non</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ibaloi language&quot;">ibl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tiwa language&quot;">lax</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;binumarien language&quot;"
                        >bjr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southeastern pomo language&quot;"
                        >pom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;djuka language&quot;">djk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;djapu language&quot;">duj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyoro language&quot;">nyo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ndebele (south africa) language&quot;"
                        >nbl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mapuche language&quot;">arn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fox language&quot;">sac</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yabim language&quot;">jae</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arabana language&quot;">ard</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ojibwa language&quot;">oji</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;korwa language&quot;">kfp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kanembu language&quot;">kbl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mambwe-lungu language&quot;"
                        >mgr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tiruray language&quot;">tiy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mayoyao ifugao language&quot;"
                        >ifu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;engenni language&quot;">enn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;uki language&quot;">bld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;inari sami language&quot;"
                        >smn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hopi language&quot;">hop</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;tavara (papua new guinea) language&quot;"
                        >tbo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngatik language&quot;">ngm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalabari language&quot;">ijn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bunun language&quot;">bnn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kombai language&quot;">tyn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chukchi language&quot;">ckt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lomwe language (mozambique)&quot;"
                        >ngl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;notu language&quot;">nou</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pemón language&quot;">aoc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ulva language&quot;">sum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lao language&quot;">lao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;burji language&quot;">bji</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chakhesang language&quot;"
                        >nri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lembak bilide language&quot;"
                        >liw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ura (vanuatu) language&quot;"
                        >uur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;danuwar rai language&quot;"
                        >dhw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kweni language&quot;">goa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yurok language&quot;">yur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;olo language&quot;">ong</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urhobo language&quot;">urh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aghem language&quot;">agq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;so (uganda) language&quot;"
                        >teu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paku language&quot;">pku</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;natanzi language&quot;">ntz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wule language&quot;">dgi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;croatian language&quot;">hrv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mendalam kayan language&quot;"
                        >xkd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mandjildjara language&quot;"
                        >mpj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;loniu language&quot;">los</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sembla language&quot;">sos</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kosena language&quot;">kze</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wambon language&quot;">wms</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;goajiro language&quot;">guc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngawun language&quot;">nxn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tooro language&quot;">ttj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gagauz language&quot;">gag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wirangu language&quot;">wiw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;narak language&quot;">nac</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mullukmulluk language&quot;"
                        >mpb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chinese language&quot;">zho</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zotung language&quot;">czt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fyam language&quot;">pym</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;australian sign language&quot;"
                        >asf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kadu language&quot;">kdv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mangarayi language&quot;"
                        >mpc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsimshian language&quot;"
                        >tsi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fore language&quot;">for</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mangaian language&quot;">rar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wutun language&quot;">wuh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tewa language&quot;">tew</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lacandon language&quot;">lac</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kharia language&quot;">khr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;amganad ifugao language&quot;"
                        >ifa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atikamekw language&quot;"
                        >atj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kagoma language&quot;">kdm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ami language (australia)&quot;"
                        >amy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guyuk language&quot;">lnu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;madurese language&quot;">mad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laz language&quot;">lzz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;black hmong language&quot;"
                        >hea</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aneme wake language&quot;"
                        >aby</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dumagat (casiguran) language&quot;"
                        >dgc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tibetan language&quot;">bod</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ulawa language&quot;">apb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;diriku language&quot;">diu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;semai language&quot;">sea</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;terena language&quot;">ter</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maka (cameroon) language&quot;"
                        >mcp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tboli language&quot;">tbl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kham language&quot;">xam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cañari language&quot;">quf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nafaanra language&quot;">nfr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;idu language&quot;">clk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;torwali language&quot;">trw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mamara language&quot;">myk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mutsun language&quot;">css</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngaanyatjara language&quot;"
                        >ntj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;idaca language&quot;">idd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;armenian language&quot;">hye</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pende language&quot;">pem</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;benabena language&quot;">bef</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;warlpiri language&quot;">wbp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;teke language&quot;">teg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ambai language&quot;">amk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dänjong-kä language&quot;"
                        >sip</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kayan language&quot;">pdu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eggon language&quot;">ego</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khotanese language&quot;"
                        >kho</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nkunya language&quot;">nko</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;veddah (sinhalese) language&quot;"
                        >ved</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;upper chehalis language&quot;"
                        >cjh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cua language&quot;">cua</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;motu language&quot;">meu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kipchak language&quot;">kue</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chambiali language&quot;"
                        >cdh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lhota language&quot;">njh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;biangai language&quot;">big</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mekongga language&quot;">lbw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iquito language&quot;">iqu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;logooli language&quot;">rag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yucuna language&quot;">ycn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rajbangsi language&quot;"
                        >rjs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;median language&quot;">xme</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tobote language&quot;">bud</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngama language&quot;">nmc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maku'a (indonesia) language&quot;"
                        >lva</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngbaka ma'bo language&quot;"
                        >nbm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sgaw karen language&quot;"
                        >ksw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mangap language&quot;">mna</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;etruscan language&quot;">ett</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kairi language&quot;">klq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;manipuri language&quot;">mni</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khyang language&quot;">csh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lala language&quot;">nrz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;akan language&quot;">aka</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gun-gbe language&quot;">guw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;komi-permyak language&quot;"
                        >koi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cayuvava language&quot;">cyb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bashgali language&quot;">bsh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aribwatsa language&quot;"
                        >laz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urarina language&quot;">ura</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bauré language&quot;">brg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kabyle language&quot;">kab</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kopagmiut language&quot;"
                        >ikt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;inuvialuktun language&quot;"
                        >ikt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;banda (indonesia) language&quot;"
                        >bnd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sylheti language&quot;">syl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ham language&quot;">dad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hatam language&quot;">had</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wongaibon language&quot;"
                        >wyb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ladino language&quot;">lad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ding language&quot;">diz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karelian language&quot;">krl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;solon language&quot;">evn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaike language&quot;">kzq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abaknon language&quot;">abx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nembe language&quot;">ijs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mashco language&quot;">amr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paez language&quot;">pbb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsakonian language&quot;"
                        >tsd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;senga language&quot;">nse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyabwa language&quot;">nwb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wuvulu language&quot;">wuv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rajasthani language&quot;"
                        >raj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ron language&quot;">cla</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;enya language&quot;">gey</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ma'ya (indonesia) language&quot;"
                        >slz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;central bontoc language&quot;"
                        >bnc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ginukh language&quot;">gin</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;niska language&quot;">ncg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngadju (australia) language&quot;"
                        >nju</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zhuang language&quot;">zha</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khetrani language&quot;">xhe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kusaal language&quot;">kus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;temne language&quot;">tem</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbinsa language&quot;">liz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gamit language&quot;">gbl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yuruna language&quot;">jur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;giryama language&quot;">nyf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baham language&quot;">bdw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khmu' language&quot;">kjg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;holoholo language&quot;">hoo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wa language&quot;">wbm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aeolic greek language&quot;"
                        >grc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;komering language&quot;">kge</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;monumbo language&quot;">mxk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;warao language&quot;">wba</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tondano language&quot;">tdn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;purupuru language&quot;">pad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ampale language&quot;">apz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tengger language&quot;">tes</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mano language&quot;">mev</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;polish language&quot;">pol</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waama language&quot;">wwa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;icelandic sign language&quot;"
                        >icl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;livonian language&quot;">liv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gagadu language&quot;">gbu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vulum language&quot;">mug</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wahgi language&quot;">wgi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tokelauan language&quot;"
                        >tkl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yambeta language&quot;">yat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cebuano language&quot;">ceb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;idoma language&quot;">idu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;doric greek language&quot;"
                        >grc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;machiguenga language&quot;"
                        >mcb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eipo language&quot;">eip</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbelime language&quot;">mql</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maltese language&quot;">mlt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yidiny language&quot;">yii</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kedang language&quot;">ksx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pinyin language&quot;">pny</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mentawai language&quot;">mwv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ha language&quot;">haq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bungku language&quot;">bkz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lambadi language&quot;">lmn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dobel language&quot;">kvo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gola language&quot;">gol</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;loko language&quot;">lok</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;church slavic language&quot;"
                        >chu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ya language&quot;">cuu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kanjobal language&quot;">kjb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;godoberi language&quot;">gdo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kubachi language&quot;">dar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngandi language&quot;">nid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;culina language&quot;">cul</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aja (sudan) language&quot;"
                        >aja</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bhumij language&quot;">unr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;numfor language&quot;">bhw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;betsimisaraka language&quot;"
                        >bjq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamassin language&quot;">xas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;minaveha language&quot;">mvn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gayardilt language&quot;"
                        >gyd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;manggarai (indonesia) language&quot;"
                        >mqy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaingang language&quot;">kgp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pasaale language&quot;">sig</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khanty language&quot;">kca</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jaunsari language&quot;">jns</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kapau language&quot;">hmt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;samoan language&quot;">smo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;musom language&quot;">msu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbugu language&quot;">mhd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;new zealand sign language&quot;"
                        >nzs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vata language&quot;">dic</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ndjebbana language&quot;"
                        >djj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;futuna language&quot;">fud</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mün chin language&quot;">mwq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bulu language&quot;">bum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urdu language&quot;">urd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sulod language&quot;">srg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;parya language&quot;">paq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saramaccan language&quot;"
                        >srm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;russian language&quot;">rus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mohawk language&quot;">moh</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;yana (burkina faso and togo) language&quot;"
                        >mos</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;italian sign language&quot;"
                        >ise</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gwedena language&quot;">gdn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;upper tanana language&quot;"
                        >tau</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ahtena language&quot;">aht</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hre language&quot;">hre</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maisin language&quot;">mbq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;powhatan language&quot;">pim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kunimaipa language&quot;"
                        >kup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maba language&quot;">mde</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;skou language&quot;">skv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abui language&quot;">abz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koozime language&quot;">ozm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;misima-panayati language&quot;"
                        >mpx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oksapmin language&quot;">opm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tabwa language&quot;">tap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ruri language&quot;">kya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bouyei language&quot;">pcc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hassaniyya dialect&quot;"
                        >mey</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;orya language&quot;">ury</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;taurepan language&quot;">aoc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;celtiberian language&quot;"
                        >xce</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paici language&quot;">pri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;halbi language&quot;">hlb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dolakha language&quot;">new</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nootka language&quot;">noo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abung dialect&quot;">abl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gurian language&quot;">kat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;passamaquoddy language&quot;"
                        >pqm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gbaya language&quot;">gba</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;mende (papua new guinea) language&quot;"
                        >sim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;toaripi language&quot;">tqo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hmong njua language&quot;"
                        >hnj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yareba language&quot;">yrb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wandamen language&quot;">wad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pangwa language&quot;">pbr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mohegan language&quot;">mof</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;logo language&quot;">log</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tigrinya language&quot;">tir</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;barasana del sur language&quot;"
                        >bsn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gangte language&quot;">gnb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;margany language&quot;">zmc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gagu language&quot;">ggu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koasati language&quot;">cku</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yinggarda language&quot;"
                        >yia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dehu language&quot;">dhv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ikwo language&quot;">izi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bote-mahi language&quot;"
                        >bmj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;boruca language&quot;">brn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yahi language&quot;">ynn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nukuoro language&quot;">nkr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wailpi language&quot;">adt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;munsee language&quot;">umu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bulgarian language&quot;"
                        >bul</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;esselen language&quot;">esq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lashkh language&quot;">sva</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;omaha language&quot;">oma</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsamai language&quot;">tsb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lithuanian language&quot;"
                        >lit</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;western meohang language&quot;"
                        >raf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dingal language&quot;">mwr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern paiute language&quot;"
                        >ute</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern roglai language&quot;"
                        >rog</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kusaie language&quot;">kos</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jah hut language&quot;">jah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rarotongan language&quot;"
                        >rar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yaqui language&quot;">yaq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zulgo language&quot;">gnd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyaheun language&quot;">nev</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;macedonian language&quot;"
                        >mkd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cape verde creole language&quot;"
                        >kea</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;munduruku language&quot;">my</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maa (vietnam) language&quot;"
                        >cma</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bundeli language&quot;">bns</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tharaka language&quot;">thk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;carrier language&quot;">crx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;falam chin language&quot;"
                        >cfm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chopi language&quot;">cce</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kombe language&quot;">nui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anmatyerre language&quot;"
                        >amx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lombard language&quot;">lmo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;muong language&quot;">mtq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oroqen language&quot;">orh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kashubian language&quot;"
                        >csb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tenetehara language&quot;"
                        >tqb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ahirani language&quot;">ahr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;itsekiri language&quot;">its</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pawaian language&quot;">pwa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;huanca language&quot;">qvw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kekchi language&quot;">kek</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ezaa language&quot;">izi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;island carib language&quot;"
                        >crb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wayampi language&quot;">oym</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mulgi language&quot;">est</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yongkom language&quot;">yon</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hua hmong language&quot;"
                        >hmd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mewati language&quot;">wtm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ligbi language&quot;">lig</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kenga language&quot;">kyq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bangubangu language&quot;"
                        >bnx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;enga language&quot;">enq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kerebe language&quot;">ked</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;galela language&quot;">gbi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;catalan language&quot;">cat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atsina language&quot;">ats</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chechen language&quot;">che</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vute language&quot;">vut</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;walmatjari language&quot;"
                        >wmt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;trumai language&quot;">tpy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;foi language&quot;">foi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mansi language&quot;">mns</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;adiwasi garasia language&quot;"
                        >gas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuo language&quot;">xuo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cuaiquer language&quot;">kwi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mangseng language&quot;">mbh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lillooet language&quot;">lil</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gambai language&quot;">sba</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pangutaran sama language&quot;"
                        >slm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;igede language&quot;">ige</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;qottu language&quot;">hae</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shoshoni language&quot;">shh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;walloon language&quot;">wln</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nirere language&quot;">kib</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;naxi language&quot;">nbf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;masai language&quot;">mas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;migili language&quot;">mgi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;basa language&quot;">bas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;grebo language&quot;">grb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atisa language&quot;">epi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fordata language&quot;">frd</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;korean--middle korean, 935-1500 language&quot;"
                        >okm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;skolt sami language&quot;"
                        >sms</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lawangan language&quot;">lbx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;panamint language&quot;">par</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;adangme language&quot;">ada</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gilyak language&quot;">niv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalash language&quot;">kls</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sedang language&quot;">sed</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maori language&quot;">mri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chantel language&quot;">chx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;komba language&quot;">kpf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;brissa language&quot;">any</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bugis language&quot;">bug</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jupda language&quot;">jup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;halia language&quot;">hla</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oghuz language&quot;">ozn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;glavda language&quot;">glw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ikwere language&quot;">ikw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yugumbeh language&quot;">bdy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;forest nenets language&quot;"
                        >yrk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbukushu language&quot;">mhw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;camsa language&quot;">kbh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mzab language&quot;">mzb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mwini dialect&quot;">swh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dompago language&quot;">dop</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pawnee language&quot;">paw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;punu language&quot;">puu</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;bassa (liberia and sierra leone) language&quot;"
                        >bsq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chiapanec language&quot;"
                        >cip</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;malfaxal language&quot;">mlx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aomie language&quot;">aom</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anyi language&quot;">any</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kassonke language&quot;">kao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vegliote language&quot;">dlm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;holu language&quot;">hol</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;acoma language&quot;">kjq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aladian language&quot;">ald</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaffa language&quot;">kbr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ilongot language&quot;">ilk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nukahiva language&quot;">mrq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;beothuk language&quot;">bue</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mandegusu language&quot;"
                        >sbb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baria language&quot;">nrb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;talysh language&quot;">tly</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karo-batak language&quot;"
                        >btx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pogoro language&quot;">poy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bara (madagascar) language&quot;"
                        >bhr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kpelle language&quot;">kpe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gokana language&quot;">gkn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kahayan language&quot;">nij</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;apalai language&quot;">apy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karitiana language&quot;"
                        >ktn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;central pomo language&quot;"
                        >poo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaguru language&quot;">kki</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rennellese language&quot;"
                        >mnv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;balti language&quot;">bft</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bagobo language&quot;">obo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lou language&quot;">loj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cupeño language&quot;">cup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kurumba language&quot;">kfi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lardil language&quot;">lbz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gafat language&quot;">gft</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rutul language&quot;">rut</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lozi language&quot;">loz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;masikoro language&quot;">msh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bor (lwo) language&quot;"
                        >bxb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;western bukidnon manobo language&quot;"
                        >mbb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koalib language&quot;">kib</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwaio language&quot;">kwd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baré language&quot;">bae</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aglemiut language&quot;">esu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pattani (india) language&quot;"
                        >lae</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;auyana language&quot;">kze</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;matigsalug language&quot;"
                        >mbt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mascoi language&quot;">emo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siraiki hindki language&quot;"
                        >skr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;braj language&quot;">bra</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;samba leko language&quot;"
                        >ndi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;agul language&quot;">agx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guanano language&quot;">gvc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mamanwa language&quot;">mmn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamula language&quot;">xla</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karang (cameroon) language&quot;"
                        >kzr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rade language&quot;">rad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;portuguese language&quot;"
                        >por</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;venetic language&quot;">xve</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;majang language&quot;">mpe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ndali language&quot;">ndh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mikasuki language&quot;">mik</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;santee language&quot;">dak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tangale language&quot;">tan</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;orok language&quot;">oaa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;adyukru language&quot;">adj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fasu language&quot;">faa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dungan language&quot;">dng</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sauraseni language&quot;"
                        >psu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tutelo language&quot;">tta</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yami language&quot;">tao</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dawawa language&quot;">dww</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dena'ina language&quot;">tfn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chocho language&quot;">coz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tonga (inhambane) language&quot;"
                        >toh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atta language&quot;">att</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koho language&quot;">kpm</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;yamba (cameroon and nigeria) language&quot;"
                        >yam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urubu language&quot;">urb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bongo language&quot;">bot</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pelende language&quot;">ppp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shambala language&quot;">ksb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;safwa language&quot;">sbk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gujuri language&quot;">gju</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aekyom language&quot;">awi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;digo language&quot;">dig</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;malgwa language&quot;">mfi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gananwa language&quot;">nso</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;norwegian (nynorsk) language&quot;"
                        >nno</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yakan language&quot;">yka</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zanaki language&quot;">zak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;koniagmiut language&quot;"
                        >ems</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mankanya language&quot;">knf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iwam language&quot;">iwm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;brokpa language&quot;">bkk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;albanian language&quot;">sqi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sanwi language&quot;">any</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lolak language&quot;">llq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bamu river language&quot;"
                        >bcf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wakhi language&quot;">wbl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mikir language&quot;">mjw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alune language&quot;">alp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ombo language&quot;">oml</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;umotina language&quot;">umo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sangtam language&quot;">nsa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pamoa language&quot;">tav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kyrgyz language&quot;">kir</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tumak language&quot;">tmc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karré language&quot;">kbn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;east makian language&quot;"
                        >mky</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;panobo language&quot;">pno</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shekhawati language&quot;"
                        >swv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mouk language&quot;">mqt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lamma language&quot;">lev</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mara (australia) language&quot;"
                        >mec</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;samo language&quot;">smq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ormu language&quot;">orz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sunwar language&quot;">suz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;olcha language&quot;">ulc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;palauan language&quot;">pau</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gumasi language&quot;">gvs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;worora language&quot;">unp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;talaud language&quot;">tld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngombe language&quot;">ngc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abujhmaria language&quot;"
                        >mrr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mamvu language&quot;">mdi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;roro (new guinea) language&quot;"
                        >rro</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sotho language&quot;">sot</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;parengi language&quot;">pcj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sinagoro language&quot;">snc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oscan language&quot;">osc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaytetye language&quot;">gbb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sulu language&quot;">tsg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mingrelian language&quot;"
                        >xmf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyangumarta language&quot;"
                        >nna</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;daga language&quot;">dgz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;haida language&quot;">hai</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;puoc language&quot;">puo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yankton language&quot;">dak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;taita language&quot;">dav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lengua language&quot;">leg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;li language&quot;">dij</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lahu bakeo dialect&quot;"
                        >lhu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maram language&quot;">nma</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cheso language&quot;">arg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mansaka language&quot;">msk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;irumu language&quot;">iou</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;interglossa (artificial) language&quot;"
                        >igs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eteocretan language&quot;"
                        >ecr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ngaliwuru language&quot;"
                        >djd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lakona language&quot;">lkn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nisenan language&quot;">nsz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;purik language&quot;">prx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ugaritic language&quot;">uga</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jukun language&quot;">jbu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;central mnong language&quot;"
                        >cmo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;carian language&quot;">xcr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wanetsi language&quot;">wne</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;western apache language&quot;"
                        >apw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waffa language&quot;">waj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sayula language&quot;">pos</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;daba language&quot;">dbq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maru language&quot;">mhx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ipili language&quot;">ipi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ratahan language&quot;">rth</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wangkumara (galali) language&quot;"
                        >nbx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waray language&quot;">wrz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kyaka language&quot;">kyc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bagri language&quot;">bgq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sindarin (artificial) language&quot;"
                        >sjn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kete language&quot;">kcv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karao language&quot;">kyj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;achomawi language&quot;">acv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pacoh language&quot;">pac</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yiddish language&quot;">yid</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;udmurt language&quot;">udm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;apalachee language&quot;"
                        >xap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hausa language&quot;">hau</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sicuane language&quot;">cui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;masbateno language&quot;"
                        >msb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kriol language&quot;">rop</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dinka language&quot;">din</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kreish language&quot;">kpl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iatmul language&quot;">ian</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tsimihety language&quot;"
                        >xmw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paraujano language&quot;"
                        >pbg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;toraja language&quot;">sda</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sigi language&quot;">lew</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dizi language&quot;">mdx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hawaiian language&quot;">haw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;motlav language&quot;">mlv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paduko language&quot;">pbi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bada (indonesia) language&quot;"
                        >bhz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arapaho language&quot;">arp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dolgan language&quot;">dlg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iamalele language&quot;">yml</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;purari language&quot;">iar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maiya language&quot;">mvy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mandeali language&quot;">mjl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kobon language&quot;">kpw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lummi language&quot;">str</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bashkir language&quot;">bak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ama (papua new guinea) language&quot;"
                        >amm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;akatek language&quot;">knj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bende language&quot;">bdp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuria language&quot;">kuj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hazili language&quot;">kup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ik language&quot;">ikx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;esuulaalu language&quot;"
                        >csk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;carolinian language&quot;"
                        >cal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;komunku language&quot;">snp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;selepet language&quot;">spl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yana language&quot;">ynn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sanga language&quot;">sng</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;barambu language&quot;">brm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bolia language&quot;">bli</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;taino language&quot;">tnq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;roma language&quot;">rmm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tho language&quot;">tou</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;meax language&quot;">mej</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gunu language&quot;">yas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sumbawa language&quot;">smw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;avikam language&quot;">avi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;badakhshani language&quot;"
                        >drw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tolitoli language&quot;">txe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;watjari language&quot;">wbv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kupia language&quot;">key</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaw language&quot;">ahk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arekena language&quot;">gae</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hattic language&quot;">xht</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;katu language&quot;">kax</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northern altai language&quot;"
                        >atv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bardi language&quot;">bcj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tubatulabal language&quot;"
                        >tub</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;memba language&quot;">tsj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;black carib language&quot;"
                        >cab</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;desana language&quot;">des</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gólo language&quot;">bbp</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;awa (eastern highlands province, papua new guinea) language&quot;"
                        >awb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;portuguese sign language&quot;"
                        >psr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waskia language&quot;">wsk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dukawa language&quot;">dud</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;occitan language&quot;">oci</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nande language&quot;">nnb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chimane language&quot;">cas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;spanish language&quot;">spa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wan'guri language&quot;">dhg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gilaki language&quot;">glk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dibabawon language&quot;"
                        >mbd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karo (brazil) language&quot;"
                        >arr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;blagar language&quot;">beu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siraiki language&quot;">skr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lote language&quot;">uvl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chrau language&quot;">crw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bor (dinka) language&quot;"
                        >dks</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kolo language&quot;">bhp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;assiniboine language&quot;"
                        >asb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gapapaiwa language&quot;"
                        >pwg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anakalang language&quot;"
                        >akg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kukatja language&quot;">kux</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;agau language&quot;">awn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;thado language&quot;">tcz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jamee language&quot;">min</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bube language&quot;">bvb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mortlockese language&quot;"
                        >mrl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nomatsiguenga language&quot;"
                        >not</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yakoma language&quot;">yky</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;molima language&quot;">mox</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;breton language&quot;">bre</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sherpa language&quot;">xsr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bedik language&quot;">tnr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kara-kalpak language&quot;"
                        >kaa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lusi language&quot;">khl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bade language&quot;">bde</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chagatai language&quot;">chg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;argobba language&quot;">agj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iai language&quot;">iai</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zarma language&quot;">dje</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;paressi language&quot;">pab</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mojo language&quot;">ign</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sirmauri language&quot;">srx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ronga language&quot;">rng</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalabra language&quot;">kzz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;thayore language&quot;">thd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bunak language&quot;">bfn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ordos language&quot;">mvf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aguacatec language&quot;"
                        >agu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ijebu language&quot;">yor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ladakhi language&quot;">lbj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gwere language&quot;">gwr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;urak lawoi' language&quot;"
                        >urk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tugen language&quot;">tuy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sora language&quot;">srb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waunana language&quot;">noa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;temiar language&quot;">tea</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;macusi language&quot;">mbc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;old turkic language&quot;"
                        >otk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nandi language&quot;">kln</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;banggai language&quot;">bgz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ayangan ifugao language&quot;"
                        >ifb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hayu language&quot;">vay</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sandawe language&quot;">sad</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wancho language&quot;">nnp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chulupí language&quot;">cag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tumleo language&quot;">tmq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pailibo language&quot;">adi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hani language&quot;">hni</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;goemai language&quot;">ank</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;phom language&quot;">nph</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gen-gbe language&quot;">gej</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;buin language&quot;">buo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cuiba language&quot;">cui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pear language&quot;">pcb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;potawatomi language&quot;"
                        >pot</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;menominee language&quot;"
                        >mez</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gwich'in language&quot;">gwi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;iloko language&quot;">ilo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;usan language&quot;">wnu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;parthian language&quot;">xpr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ruund language&quot;">rnd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;micmac language&quot;">mic</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;serbo-croatian language&quot;"
                        >hbs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lahu language&quot;">lhu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;deg hit'an language&quot;"
                        >ing</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;bembe (congo (brazzaville)) language&quot;"
                        >beq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;srê language&quot;">kpm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;budukh language&quot;">bdk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guguyimidjir language&quot;"
                        >kky</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maonan language&quot;">mmd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cashinawa language&quot;"
                        >cbs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gumatj language&quot;">gnn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jita language&quot;">jit</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kisan language (dravidian)&quot;"
                        >kru</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;medumba language&quot;">byv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mahas-fiyadikka language&quot;"
                        >fia</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kùláál language&quot;">glj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fon language&quot;">fon</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;comanche language&quot;">com</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alabama language&quot;">akz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maca language&quot;">mca</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nakanai language&quot;">nak</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laguna language&quot;">kjq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kumak language&quot;">nee</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mishmi language&quot;">clk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saurashtri language&quot;"
                        >saz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;subiya language&quot;">sbs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kitabwa language&quot;">tap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baima language&quot;">bqh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jirel language&quot;">jul</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gope language&quot;">kiw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;golin language&quot;">gvf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gugada language&quot;">ktd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;shauri language&quot;">shv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wampar language&quot;">lbq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;doyayo language&quot;">dow</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;north straits salish language&quot;"
                        >str</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moluche language&quot;">arn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;occidental (artificial) language&quot;"
                        >ile</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;oron language&quot;">enw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;setu language&quot;">est</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yuchi language&quot;">yuc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cree language&quot;">cre</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anuta language&quot;">aud</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ambonese malay language&quot;"
                        >abs</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pakaasnovos language&quot;"
                        >pav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khamti language&quot;">kht</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;notsi language&quot;">ncf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;alangan language&quot;">alj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ewe language&quot;">ewe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wichita language&quot;">wic</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anufo language&quot;">cko</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;balangao language&quot;">blw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kawi language&quot;">kaw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;squawmish language&quot;"
                        >squ</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mekeo language&quot;">mek</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;okanagan language&quot;">oka</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aromanian language&quot;"
                        >rup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;suwawa language&quot;">swu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;atinggola language&quot;"
                        >bld</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lonwolwol language&quot;"
                        >crc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arawak language&quot;">arw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lokele language&quot;">khy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;muna language&quot;">mnb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mai brat language&quot;">ayz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwakum language&quot;">kwu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kagate language&quot;">syw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yao (southeastern asia) language&quot;"
                        >ium</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tepo language&quot;">ted</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abo (cameroon) language&quot;"
                        >abb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yaouré language&quot;">yre</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;zapotec language&quot;">zap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eastern mnong language&quot;"
                        >mng</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tera language&quot;">ttr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;woleai language&quot;">woe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;afrihili (artificial) language&quot;"
                        >afh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yaka (congo and angola) language&quot;"
                        >yaf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chattisgarhi language&quot;"
                        >hne</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;maung language&quot;">mph</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dongola-kenuz language&quot;"
                        >kzh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khasi language&quot;">kha</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;georgian language&quot;">kat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tanga (tanga islands) language&quot;"
                        >tgg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rangi language&quot;">lag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gallong language&quot;">adl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tawahka (honduras) language&quot;"
                        >sum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bisa language&quot;">leb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;panare language&quot;">pbh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tunni language&quot;">tqq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mayo (piman) language&quot;"
                        >mfy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;camaracoto language&quot;"
                        >aoc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;slovenian language&quot;"
                        >slv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;duna language&quot;">duc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cubulco achi language&quot;"
                        >acc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bhalesi language&quot;">bhd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lango language&quot;">lno</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;michif language&quot;">crg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dobu language&quot;">dob</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;old saxon language&quot;"
                        >osx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwiri language&quot;">bri</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalapuya language&quot;">kyl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jeli language&quot;">jek</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;teleut language&quot;">atv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mbala (bandundu, congo) language&quot;"
                        >mdp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nalik language&quot;">nal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;hanga (kenya) language&quot;"
                        >luy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ammassalimiut language&quot;"
                        >kal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yessan-mayo language&quot;"
                        >yss</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;antaisaka language&quot;"
                        >bjq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;armenian, classical language&quot;"
                        >xcl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fur language&quot;">fvr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;coptic language&quot;">cop</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cornish language&quot;">cor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;jarai language&quot;">jra</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tinputz language&quot;">tpz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kuki language&quot;">tcz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;umbrian language&quot;">xum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karamojong language&quot;"
                        >kdj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;delki khadia dialect&quot;"
                        >khr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;edolo language&quot;">etr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;caló (romani) language&quot;"
                        >rmr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chuvash language&quot;">chv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;khoikhoi language&quot;">xuu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;fuyuge language&quot;">fuy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sardinian language&quot;"
                        >srd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ma language&quot;">grg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bareë language&quot;">pmf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lule language&quot;">vil</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;danish sign language&quot;"
                        >dsl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;brahui language&quot;">brh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sarikoli language&quot;">srh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;warembori language&quot;"
                        >wsa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yupa language&quot;">yup</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;haya language&quot;">hay</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tswana language&quot;">tsn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;niuean language&quot;">niu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nogugu language&quot;">nkk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mau language&quot;">mxx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;west armenian language&quot;"
                        >hye</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chilean sign language&quot;"
                        >csg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tucano language&quot;">tuo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;arbore language&quot;">arv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;azerbaijani language&quot;"
                        >aze</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baruya language&quot;">byr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tombonuwo language&quot;"
                        >txa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;songye language&quot;">sop</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gorontalo language&quot;"
                        >gor</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nganasan language&quot;">nio</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bauzi language&quot;">bvz</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;kalanga (botswana and zimbabwe) language&quot;"
                        >kck</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;car nicobarese language&quot;"
                        >caq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kaili language&quot;">pbz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dengese language&quot;">dez</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;xavante language&quot;">xav</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kung-ekoka language&quot;"
                        >knw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kinyarwanda language&quot;"
                        >kin</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chiga language&quot;">cgg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kurukh language&quot;">kru</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vili language&quot;">vif</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;naskapi language&quot;">nsk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;asaro language&quot;">aso</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kru language&quot;">klu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;orokolo language&quot;">oro</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;narragansett language&quot;"
                        >mof</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bandjoun language&quot;">bbj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kayabi language&quot;">kyz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mohave language&quot;">mov</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;g/wi language&quot;">gwj</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;southern sami language&quot;"
                        >sma</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sawos language&quot;">gbf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chewa language&quot;">nya</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tapanta language&quot;">abq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bezhta language&quot;">kap</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rama language&quot;">rma</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;badyara language&quot;">pbp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gayo language&quot;">gay</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;batan language&quot;">ivv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;coahuilteco language&quot;"
                        >xcw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;botlikh language&quot;">bph</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;enim language&quot;">pse</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kikuyu language&quot;">kik</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;saposa language&quot;">sps</xsl:when>
                    <xsl:when
                        test="$lcsh_lc = &quot;rejang (sumatra, indonesia) language&quot;"
                        >rej</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kashmiri language&quot;">kas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wandarang language&quot;"
                        >wnd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;northeastern kiwai language&quot;"
                        >kiw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;muana language&quot;">moa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baiso language&quot;">bsw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;laha (vietnam) language&quot;"
                        >lkh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lahnda language&quot;">lah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;rabha language&quot;">rah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nyikina language&quot;">nyh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;timbe language&quot;">tim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;eblaite language&quot;">xeb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;wolof language&quot;">wol</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pangasinan language&quot;"
                        >pag</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mescalero language&quot;"
                        >apm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tuscarora language&quot;"
                        >tus</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;vai language&quot;">vai</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ibanag language&quot;">ibg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;cuna language&quot;">cuk</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mende language&quot;">men</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;musi language&quot;">mui</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pima language&quot;">ood</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pauserna language&quot;">psm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;walamo language&quot;">wal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;afar language&quot;">aar</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;parji language&quot;">pci</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;dehawali language&quot;">vas</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gupapuyngu language&quot;"
                        >guf</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;anyang language&quot;">ken</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kayu agung language&quot;"
                        >kge</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;noone language&quot;">nhu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ingassana language&quot;"
                        >tbi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kolokuma language&quot;">ijc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;adzhar language&quot;">kat</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bau-jagoi language&quot;"
                        >sne</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;itbayat language&quot;">ivb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kabardian language&quot;"
                        >kbd</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;waiwai language&quot;">waw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;esan language&quot;">ish</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moplah language&quot;">mal</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;parintintin language&quot;"
                        >pah</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;karksi language&quot;">est</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamasau language&quot;">kms</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pasir (lawangan) language&quot;"
                        >lbx</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;haka chin language&quot;"
                        >cnh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nahu language&quot;">nca</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kera language&quot;">ker</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chepang language&quot;">cdm</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;limburgish language&quot;"
                        >lim</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;acawai language&quot;">ake</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sipacapense language&quot;"
                        >qum</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ahom language&quot;">aho</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;guayaki language&quot;">guq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tagula language&quot;">tgo</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;lampung language&quot;">ljp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;spanish sign language&quot;"
                        >ssp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;gurma language&quot;">gux</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kalispel language&quot;">fla</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tongan language&quot;">ton</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sio language&quot;">xsi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;white hmong language&quot;"
                        >mww</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mampruli language&quot;">maw</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chickasaw language&quot;"
                        >cic</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;abron language&quot;">abr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bongu language&quot;">bpu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chorti language&quot;">caa</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;biliau language&quot;">bcu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;aneityum language&quot;">aty</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tuyuca language&quot;">tue</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;baniwa language&quot;">bwi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;keley-i kallahan language&quot;"
                        >ify</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kwerba language&quot;">kwe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;klamath language&quot;">kla</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;raeto-romance language&quot;"
                        >roh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;botolan sambal language&quot;"
                        >sbl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pingelap language&quot;">pif</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;samaritan aramaic language&quot;"
                        >sam</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pazeh language&quot;">uun</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sedik language&quot;">trv</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mele-fila language&quot;"
                        >mxe</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;chinese sign language&quot;"
                        >csl</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;bislama language&quot;">bis</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kele language&quot;">keb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tulu language&quot;">tcy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mugil language&quot;">mlp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;east armenian language&quot;"
                        >hye</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;moba language&quot;">mfq</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;siyin language&quot;">csy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;canella language&quot;">ram</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kituba language&quot;">ktu</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;sranan language&quot;">srn</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kagayanen language&quot;"
                        >cgc</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;yugambeh‑bundjalung dialects&quot;"
                        >bdy</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;mwaghavul language&quot;"
                        >sur</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;pilaga language&quot;">plg</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ozumacín language&quot;">chz</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kamtuk language&quot;">kmt</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;ntlakyapamuk language&quot;"
                        >thp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tem language&quot;">kdh</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;nzima language&quot;">nzi</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;kifuliru language&quot;">flr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;korape language&quot;">kpr</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;limbum language&quot;">lmp</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;tutong language&quot;">bsb</xsl:when>
                    <xsl:when test="$lcsh_lc = &quot;warrwa language&quot;">wwr</xsl:when>
                    <xsl:otherwise>failed</xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <!-- map LCCN to ISO639-3 -->
            <xsl:when test="$lccn">
                <xsl:choose>
                    <xsl:when test="$lccn = 'sh85136093'">toq</xsl:when>
                    <xsl:when test="$lccn = 'sh85108601'">pcc</xsl:when>
                    <xsl:when test="$lccn = 'sh85139514'">ppk</xsl:when>
                    <xsl:when test="$lccn = 'sh96004176'">akg</xsl:when>
                    <xsl:when test="$lccn = 'sh85071533'">kau</xsl:when>
                    <xsl:when test="$lccn = 'sh85148906'">gdf</xsl:when>
                    <xsl:when test="$lccn = 'sh85148909'">yad</xsl:when>
                    <xsl:when test="$lccn = 'sh85024399'">chh</xsl:when>
                    <xsl:when test="$lccn = 'sh85148903'">ygr</xsl:when>
                    <xsl:when test="$lccn = 'sh86005679'">tdd</xsl:when>
                    <xsl:when test="$lccn = 'sh85139435'">li</xsl:when>
                    <xsl:when test="$lccn = 'sh85074171'">lmn</xsl:when>
                    <xsl:when test="$lccn = 'sh99004558'">wae</xsl:when>
                    <xsl:when test="$lccn = 'sh85064320'">mia</xsl:when>
                    <xsl:when test="$lccn = 'sh85096570'">pbb</xsl:when>
                    <xsl:when test="$lccn = 'sh97004126'">inl</xsl:when>
                    <xsl:when test="$lccn = 'sh85096875'">ute</xsl:when>
                    <xsl:when test="$lccn = 'sh85101028'">phn</xsl:when>
                    <xsl:when test="$lccn = 'sh85071623'">kbj</xsl:when>
                    <xsl:when test="$lccn = 'sh92004875'">nnk</xsl:when>
                    <xsl:when test="$lccn = 'sh2002002075'">bck</xsl:when>
                    <xsl:when test="$lccn = 'sh92004873'">nas</xsl:when>
                    <xsl:when test="$lccn = 'sh92004872'">kms</xsl:when>
                    <xsl:when test="$lccn = 'sh92004871'">tow</xsl:when>
                    <xsl:when test="$lccn = 'sh92004870'">mlp</xsl:when>
                    <xsl:when test="$lccn = 'sh85071766'">zku</xsl:when>
                    <xsl:when test="$lccn = 'sh85133970'">ted</xsl:when>
                    <xsl:when test="$lccn = 'sh97003239'">kko</xsl:when>
                    <xsl:when test="$lccn = 'sh85133974'">ttr</xsl:when>
                    <xsl:when test="$lccn = 'sh87003881'">mrr</xsl:when>
                    <xsl:when test="$lccn = 'sh85103978'">pox</xsl:when>
                    <xsl:when test="$lccn = 'sh85071449'">kfk</xsl:when>
                    <xsl:when test="$lccn = 'sh85117594'">uzn</xsl:when>
                    <xsl:when test="$lccn = 'sh89005564'">skr</xsl:when>
                    <xsl:when test="$lccn = 'sh85071445'">kna</xsl:when>
                    <xsl:when test="$lccn = 'sh92004899'">cmo</xsl:when>
                    <xsl:when test="$lccn = 'sh92004898'">cmo</xsl:when>
                    <xsl:when test="$lccn = 'sh85057905'">gnn</xsl:when>
                    <xsl:when test="$lccn = 'sh85092022'">nsz</xsl:when>
                    <xsl:when test="$lccn = 'sh85074670'">raq</xsl:when>
                    <xsl:when test="$lccn = 'sh2003000246'">sfs</xsl:when>
                    <xsl:when test="$lccn = 'sh92004893'">sgz</xsl:when>
                    <xsl:when test="$lccn = 'sh87005476'">pah</xsl:when>
                    <xsl:when test="$lccn = 'sh85012399'">bbl</xsl:when>
                    <xsl:when test="$lccn = 'sh92004897'">pnw</xsl:when>
                    <xsl:when test="$lccn = 'sh2001009622'">cht</xsl:when>
                    <xsl:when test="$lccn = 'sh85064250'">ilb</xsl:when>
                    <xsl:when test="$lccn = 'sh85072857'">kpf</xsl:when>
                    <xsl:when test="$lccn = 'sh85072858'">nui</xsl:when>
                    <xsl:when test="$lccn = 'sh95003826'">min</xsl:when>
                    <xsl:when test="$lccn = 'sh92005279'">arg</xsl:when>
                    <xsl:when test="$lccn = 'sh85054929'">gil</xsl:when>
                    <xsl:when test="$lccn = 'sh85053028'">gnb</xsl:when>
                    <xsl:when test="$lccn = 'sh85053029'">nba</xsl:when>
                    <xsl:when test="$lccn = 'sh85087454'">cas</xsl:when>
                    <xsl:when test="$lccn = 'sh85097472'">pno</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002014'">wuh</xsl:when>
                    <xsl:when test="$lccn = 'sh85132738'">ttt</xsl:when>
                    <xsl:when test="$lccn = 'sh85054927'">glk</xsl:when>
                    <xsl:when test="$lccn = 'sh86005099'">mvf</xsl:when>
                    <xsl:when test="$lccn = 'sh85012138'">eus</xsl:when>
                    <xsl:when test="$lccn = 'sh85135705'">bbc</xsl:when>
                    <xsl:when test="$lccn = 'sh93006492'">kiw</xsl:when>
                    <xsl:when test="$lccn = 'sh93006490'">cmi</xsl:when>
                    <xsl:when test="$lccn = 'sh93006491'">kiw</xsl:when>
                    <xsl:when test="$lccn = 'sh97005156'">bnd</xsl:when>
                    <xsl:when test="$lccn = 'sh91002680'">beu</xsl:when>
                    <xsl:when test="$lccn = 'sh86002260'">cbn</xsl:when>
                    <xsl:when test="$lccn = 'sh90004607'">atv</xsl:when>
                    <xsl:when test="$lccn = 'sh85138393'">tub</xsl:when>
                    <xsl:when test="$lccn = 'sh85092112'">nko</xsl:when>
                    <xsl:when test="$lccn = 'sh85057876'">gju</xsl:when>
                    <xsl:when test="$lccn = 'sh85139267'">wls</xsl:when>
                    <xsl:when test="$lccn = 'sh85139266'">udu</xsl:when>
                    <xsl:when test="$lccn = 'sh93006548'">dad</xsl:when>
                    <xsl:when test="$lccn = 'sh89003502'">gbk</xsl:when>
                    <xsl:when test="$lccn = 'sh85116659'">sku</xsl:when>
                    <xsl:when test="$lccn = 'sh85036489'">dhv</xsl:when>
                    <xsl:when test="$lccn = 'sh85109048'">puw</xsl:when>
                    <xsl:when test="$lccn = 'sh89005769'">xkd</xsl:when>
                    <xsl:when test="$lccn = 'sh86000177'">dlg</xsl:when>
                    <xsl:when test="$lccn = 'sh99013338'">dgr</xsl:when>
                    <xsl:when test="$lccn = 'sh85135367'">til</xsl:when>
                    <xsl:when test="$lccn = 'sh85003029'">aja</xsl:when>
                    <xsl:when test="$lccn = 'sh85003028'">ajg</xsl:when>
                    <xsl:when test="$lccn = 'sh85037994'">dig</xsl:when>
                    <xsl:when test="$lccn = 'sh85017988'">bns</xsl:when>
                    <xsl:when test="$lccn = 'sh85043173'">enn</xsl:when>
                    <xsl:when test="$lccn = 'sh85116407'">sck</xsl:when>
                    <xsl:when test="$lccn = 'sh85116157'">apb</xsl:when>
                    <xsl:when test="$lccn = 'sh85017986'">bfn</xsl:when>
                    <xsl:when test="$lccn = 'sh85001765'">afr</xsl:when>
                    <xsl:when test="$lccn = 'sh85048183'">fij</xsl:when>
                    <xsl:when test="$lccn = 'sh85116653'">skg</xsl:when>
                    <xsl:when test="$lccn = 'sh85102439'">pie</xsl:when>
                    <xsl:when test="$lccn = 'sh85088425'">my</xsl:when>
                    <xsl:when test="$lccn = 'sh90004112'">gaq</xsl:when>
                    <xsl:when test="$lccn = 'sh2008004170'">bjw</xsl:when>
                    <xsl:when test="$lccn = 'sh85003070'">akk</xsl:when>
                    <xsl:when test="$lccn = 'sh99002241'">yuu</xsl:when>
                    <xsl:when test="$lccn = 'sh00003130'">tes</xsl:when>
                    <xsl:when test="$lccn = 'sh85092207'">not</xsl:when>
                    <xsl:when test="$lccn = 'sh90004283'">tya</xsl:when>
                    <xsl:when test="$lccn = 'sh2002004828'">mox</xsl:when>
                    <xsl:when test="$lccn = 'sh2004000918'">lag</xsl:when>
                    <xsl:when test="$lccn = 'sh90004284'">drs</xsl:when>
                    <xsl:when test="$lccn = 'sh85041203'">efi</xsl:when>
                    <xsl:when test="$lccn = 'sh98003462'">abb</xsl:when>
                    <xsl:when test="$lccn = 'sh87000364'">xrr</xsl:when>
                    <xsl:when test="$lccn = 'sh85085637'">xmf</xsl:when>
                    <xsl:when test="$lccn = 'sh91002445'">jah</xsl:when>
                    <xsl:when test="$lccn = 'sh2006006915'">gwr</xsl:when>
                    <xsl:when test="$lccn = 'sh85079941'">mai</xsl:when>
                    <xsl:when test="$lccn = 'sh85047678'">fmp</xsl:when>
                    <xsl:when test="$lccn = 'sh87001682'">hvn</xsl:when>
                    <xsl:when test="$lccn = 'sh93007528'">ipi</xsl:when>
                    <xsl:when test="$lccn = 'sh85148924'">yky</xsl:when>
                    <xsl:when test="$lccn = 'sh85132056'">tkm</xsl:when>
                    <xsl:when test="$lccn = 'sh85072146'">kjf</xsl:when>
                    <xsl:when test="$lccn = 'sh85018217'">bsk</xsl:when>
                    <xsl:when test="$lccn = 'sh85018214'">mhs</xsl:when>
                    <xsl:when test="$lccn = 'sh92000977'">yva</xsl:when>
                    <xsl:when test="$lccn = 'sh85072148'">khk</xsl:when>
                    <xsl:when test="$lccn = 'sh96010747'">txe</xsl:when>
                    <xsl:when test="$lccn = 'sh2003005696'">lev</xsl:when>
                    <xsl:when test="$lccn = 'sh85027634'">coc</xsl:when>
                    <xsl:when test="$lccn = 'sh00002639'">igl</xsl:when>
                    <xsl:when test="$lccn = 'sh00002637'">csl</xsl:when>
                    <xsl:when test="$lccn = 'sh87003658'">bhd</xsl:when>
                    <xsl:when test="$lccn = 'sh91004875'">rou</xsl:when>
                    <xsl:when test="$lccn = 'sh87001877'">guq</xsl:when>
                    <xsl:when test="$lccn = 'sh93007635'">enw</xsl:when>
                    <xsl:when test="$lccn = 'sh2004007040'">yon</xsl:when>
                    <xsl:when test="$lccn = 'sh93007141'">cnb</xsl:when>
                    <xsl:when test="$lccn = 'sh97003847'">tvo</xsl:when>
                    <xsl:when test="$lccn = 'sh2004007041'">pnn</xsl:when>
                    <xsl:when test="$lccn = 'sh87001878'">kat</xsl:when>
                    <xsl:when test="$lccn = 'sh85071627'">krl</xsl:when>
                    <xsl:when test="$lccn = 'sh00007475'">tsr</xsl:when>
                    <xsl:when test="$lccn = 'sh00007215'">piv</xsl:when>
                    <xsl:when test="$lccn = 'sh87002436'">dhg</xsl:when>
                    <xsl:when test="$lccn = 'sh85072166'">hin</xsl:when>
                    <xsl:when test="$lccn = 'sh85078837'">lup</xsl:when>
                    <xsl:when test="$lccn = 'sh2001003388'">gkn</xsl:when>
                    <xsl:when test="$lccn = 'sh93003394'">lbx</xsl:when>
                    <xsl:when test="$lccn = 'sh93003391'">pku</xsl:when>
                    <xsl:when test="$lccn = 'sh85019585'">ram</xsl:when>
                    <xsl:when test="$lccn = 'sh85014080'">bhg</xsl:when>
                    <xsl:when test="$lccn = 'sh85114100'">rkb</xsl:when>
                    <xsl:when test="$lccn = 'sh85019040'">clu</xsl:when>
                    <xsl:when test="$lccn = 'sh85079894'">mgu</xsl:when>
                    <xsl:when test="$lccn = 'sh93002719'">zlm</xsl:when>
                    <xsl:when test="$lccn = 'sh99013626'">lig</xsl:when>
                    <xsl:when test="$lccn = 'sh85037778'">coj</xsl:when>
                    <xsl:when test="$lccn = 'sh87006122'">kfp</xsl:when>
                    <xsl:when test="$lccn = 'sh85122966'">skr</xsl:when>
                    <xsl:when test="$lccn = 'sh85122964'">skr</xsl:when>
                    <xsl:when test="$lccn = 'sh85132244'">tfn</xsl:when>
                    <xsl:when test="$lccn = 'sh85073382'">tcz</xsl:when>
                    <xsl:when test="$lccn = 'sh85044987'">est</xsl:when>
                    <xsl:when test="$lccn = 'sh85044985'">est</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002334'">mql</xsl:when>
                    <xsl:when test="$lccn = 'sh85073417'">kfy</xsl:when>
                    <xsl:when test="$lccn = 'sh85100070'">fas</xsl:when>
                    <xsl:when test="$lccn = 'sh94005217'">kyj</xsl:when>
                    <xsl:when test="$lccn = 'sh85125668'">sou</xsl:when>
                    <xsl:when test="$lccn = 'sh85149737'">zen</xsl:when>
                    <xsl:when test="$lccn = 'sh85119995'">see</xsl:when>
                    <xsl:when test="$lccn = 'sh92002105'">dms</xsl:when>
                    <xsl:when test="$lccn = 'sh92006485'">squ</xsl:when>
                    <xsl:when test="$lccn = 'sh85010890'">bfq</xsl:when>
                    <xsl:when test="$lccn = 'sh85010891'">drw</xsl:when>
                    <xsl:when test="$lccn = 'sh92006538'">dez</xsl:when>
                    <xsl:when test="$lccn = 'sh85035355'">xdc</xsl:when>
                    <xsl:when test="$lccn = 'sh85117591'">srs</xsl:when>
                    <xsl:when test="$lccn = 'sh85057676'">gym</xsl:when>
                    <xsl:when test="$lccn = 'sh85059952'">hei</xsl:when>
                    <xsl:when test="$lccn = 'sh92003693'">puo</xsl:when>
                    <xsl:when test="$lccn = 'sh85011477'">liy</xsl:when>
                    <xsl:when test="$lccn = 'sh85115520'">rtm</xsl:when>
                    <xsl:when test="$lccn = 'sh85070544'">yij</xsl:when>
                    <xsl:when test="$lccn = 'sh87000507'">sbl</xsl:when>
                    <xsl:when test="$lccn = 'sh85057906'">kgs</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002792'">ymm</xsl:when>
                    <xsl:when test="$lccn = 'sh85126261'">spa</xsl:when>
                    <xsl:when test="$lccn = 'sh85091695'">ibo</xsl:when>
                    <xsl:when test="$lccn = 'sh87005970'">kal</xsl:when>
                    <xsl:when test="$lccn = 'sh00008823'">snq</xsl:when>
                    <xsl:when test="$lccn = 'sh87001276'">kge</xsl:when>
                    <xsl:when test="$lccn = 'sh85015339'">bzf</xsl:when>
                    <xsl:when test="$lccn = 'sh85099337'">aoc</xsl:when>
                    <xsl:when test="$lccn = 'sh92002033'">dug</xsl:when>
                    <xsl:when test="$lccn = 'sh92004890'">sua</xsl:when>
                    <xsl:when test="$lccn = 'sh85073880'">lbj</xsl:when>
                    <xsl:when test="$lccn = 'sh97006954'">ncs</xsl:when>
                    <xsl:when test="$lccn = 'sh85004907'">ano</xsl:when>
                    <xsl:when test="$lccn = 'sh85071708'">csb</xsl:when>
                    <xsl:when test="$lccn = 'sh85010670'">nah</xsl:when>
                    <xsl:when test="$lccn = 'sh91003822'">cro</xsl:when>
                    <xsl:when test="$lccn = 'sh85041445'">ekp</xsl:when>
                    <xsl:when test="$lccn = 'sh85071703'">kas</xsl:when>
                    <xsl:when test="$lccn = 'sh85082465'">myb</xsl:when>
                    <xsl:when test="$lccn = 'sh85080916'">mar</xsl:when>
                    <xsl:when test="$lccn = 'sh85149504'">yul</xsl:when>
                    <xsl:when test="$lccn = 'sh2002005784'">ayb</xsl:when>
                    <xsl:when test="$lccn = 'sh85148916'">yaf</xsl:when>
                    <xsl:when test="$lccn = 'sh2002001680'">gbu</xsl:when>
                    <xsl:when test="$lccn = 'sh85148912'">yag</xsl:when>
                    <xsl:when test="$lccn = 'sh85069868'">jeh</xsl:when>
                    <xsl:when test="$lccn = 'sh85095667'">ori</xsl:when>
                    <xsl:when test="$lccn = 'sh85057708'">ghs</xsl:when>
                    <xsl:when test="$lccn = 'sh85070816'">juc</xsl:when>
                    <xsl:when test="$lccn = 'sh85057705'">ktd</xsl:when>
                    <xsl:when test="$lccn = 'sh85057706'">gvn</xsl:when>
                    <xsl:when test="$lccn = 'sh90001565'">gvo</xsl:when>
                    <xsl:when test="$lccn = 'sh85012920'">bej</xsl:when>
                    <xsl:when test="$lccn = 'sh85012926'">bkv</xsl:when>
                    <xsl:when test="$lccn = 'sh85132434'">taf</xsl:when>
                    <xsl:when test="$lccn = 'sh85096867'">pck</xsl:when>
                    <xsl:when test="$lccn = 'sh85039845'">dua</xsl:when>
                    <xsl:when test="$lccn = 'sh85070892'">jpr</xsl:when>
                    <xsl:when test="$lccn = 'sh85080000'">kde</xsl:when>
                    <xsl:when test="$lccn = 'sh85138359'">tsn</xsl:when>
                    <xsl:when test="$lccn = 'sh85071639'">kmv</xsl:when>
                    <xsl:when test="$lccn = 'sh85023952'">cas</xsl:when>
                    <xsl:when test="$lccn = 'sh85096041'">iow</xsl:when>
                    <xsl:when test="$lccn = 'sh85078138'">rag</xsl:when>
                    <xsl:when test="$lccn = 'sh85023955'">cid</xsl:when>
                    <xsl:when test="$lccn = 'sh85117566'">srh</xsl:when>
                    <xsl:when test="$lccn = 'sh85123541'">csb</xsl:when>
                    <xsl:when test="$lccn = 'sh97004142'">bap</xsl:when>
                    <xsl:when test="$lccn = 'sh85133312'">tlf</xsl:when>
                    <xsl:when test="$lccn = 'sh2003010445'">bjb</xsl:when>
                    <xsl:when test="$lccn = 'sh2001012439'">mdy</xsl:when>
                    <xsl:when test="$lccn = 'sh85017614'">bdk</xsl:when>
                    <xsl:when test="$lccn = 'sh85015800'">gax</xsl:when>
                    <xsl:when test="$lccn = 'sh90005077'">mal</xsl:when>
                    <xsl:when test="$lccn = 'sh92005264'">hmd</xsl:when>
                    <xsl:when test="$lccn = 'sh85072844'">kmm</xsl:when>
                    <xsl:when test="$lccn = 'sh92005260'">mtg</xsl:when>
                    <xsl:when test="$lccn = 'sh85132225'">tpm</xsl:when>
                    <xsl:when test="$lccn = 'sh85020593'">cbr</xsl:when>
                    <xsl:when test="$lccn = 'sh85020596'">cbs</xsl:when>
                    <xsl:when test="$lccn = 'sh85135573'">tri</xsl:when>
                    <xsl:when test="$lccn = 'sh93000923'">cuu</xsl:when>
                    <xsl:when test="$lccn = 'sh85102115'">plg</xsl:when>
                    <xsl:when test="$lccn = 'sh85011102'">bdu</xsl:when>
                    <xsl:when test="$lccn = 'sh2005002638'">lbo</xsl:when>
                    <xsl:when test="$lccn = 'sh96004239'">huz</xsl:when>
                    <xsl:when test="$lccn = 'sh85006445'">arw</xsl:when>
                    <xsl:when test="$lccn = 'sh85086537'">mdf</xsl:when>
                    <xsl:when test="$lccn = 'sh85103647'">npo</xsl:when>
                    <xsl:when test="$lccn = 'sh85017400'">bvb</xsl:when>
                    <xsl:when test="$lccn = 'sh85086533'">mkj</xsl:when>
                    <xsl:when test="$lccn = 'sh97005144'">bhp</xsl:when>
                    <xsl:when test="$lccn = 'sh85124302'">xog</xsl:when>
                    <xsl:when test="$lccn = 'sh85124307'">sog</xsl:when>
                    <xsl:when test="$lccn = 'sh92004895'">yuj</xsl:when>
                    <xsl:when test="$lccn = 'sh87003439'">gls</xsl:when>
                    <xsl:when test="$lccn = 'sh97007948'">chx</xsl:when>
                    <xsl:when test="$lccn = 'sh85079853'">mjy</xsl:when>
                    <xsl:when test="$lccn = 'sh85022445'">cha</xsl:when>
                    <xsl:when test="$lccn = 'sh85139254'">udi</xsl:when>
                    <xsl:when test="$lccn = 'sh87003431'">div</xsl:when>
                    <xsl:when test="$lccn = 'sh87003436'">bkr</xsl:when>
                    <xsl:when test="$lccn = 'sh85139253'">ude</xsl:when>
                    <xsl:when test="$lccn = 'sh93002874'">reb</xsl:when>
                    <xsl:when test="$lccn = 'sh2002012352'">zmc</xsl:when>
                    <xsl:when test="$lccn = 'sh85072932'">nbe</xsl:when>
                    <xsl:when test="$lccn = 'sh85072937'">kng</xsl:when>
                    <xsl:when test="$lccn = 'sh85079066'">lwo</xsl:when>
                    <xsl:when test="$lccn = 'sh96003836'">cma</xsl:when>
                    <xsl:when test="$lccn = 'sh85013030'">blc</xsl:when>
                    <xsl:when test="$lccn = 'sh85086885'">mte</xsl:when>
                    <xsl:when test="$lccn = 'sh85069053'">itv</xsl:when>
                    <xsl:when test="$lccn = 'sh91002689'">twy</xsl:when>
                    <xsl:when test="$lccn = 'sh85078959'">lus</xsl:when>
                    <xsl:when test="$lccn = 'sh85117419'">any</xsl:when>
                    <xsl:when test="$lccn = 'sh85135707'">tob</xsl:when>
                    <xsl:when test="$lccn = 'sh85149793'">ziw</xsl:when>
                    <xsl:when test="$lccn = 'sh85068806'">ita</xsl:when>
                    <xsl:when test="$lccn = 'sh85086502'">moh</xsl:when>
                    <xsl:when test="$lccn = 'sh00010107'">mdx</xsl:when>
                    <xsl:when test="$lccn = 'sh85045963'">eve</xsl:when>
                    <xsl:when test="$lccn = 'sh85023225'">chb</xsl:when>
                    <xsl:when test="$lccn = 'sh94000809'">xcr</xsl:when>
                    <xsl:when test="$lccn = 'sh86007447'">kfi</xsl:when>
                    <xsl:when test="$lccn = 'sh98003413'">mra</xsl:when>
                    <xsl:when test="$lccn = 'sh85014417'">bpy</xsl:when>
                    <xsl:when test="$lccn = 'sh85085997'">mpx</xsl:when>
                    <xsl:when test="$lccn = 'sh85085996'">mpx</xsl:when>
                    <xsl:when test="$lccn = 'sh93001679'">wms</xsl:when>
                    <xsl:when test="$lccn = 'sh2002006549'">ssf</xsl:when>
                    <xsl:when test="$lccn = 'sh85085993'">clk</xsl:when>
                    <xsl:when test="$lccn = 'sh85072154'">kht</xsl:when>
                    <xsl:when test="$lccn = 'sh85072151'">xam</xsl:when>
                    <xsl:when test="$lccn = 'sh91002728'">slm</xsl:when>
                    <xsl:when test="$lccn = 'sh85129423'">sbs</xsl:when>
                    <xsl:when test="$lccn = 'sh85052810'">orm</xsl:when>
                    <xsl:when test="$lccn = 'sh2003005680'">dbj</xsl:when>
                    <xsl:when test="$lccn = 'sh85052814'">glg</xsl:when>
                    <xsl:when test="$lccn = 'sh86006784'">ssb</xsl:when>
                    <xsl:when test="$lccn = 'sh86006786'">lbw</xsl:when>
                    <xsl:when test="$lccn = 'sh86006787'">swu</xsl:when>
                    <xsl:when test="$lccn = 'sh85138782'">tuv</xsl:when>
                    <xsl:when test="$lccn = 'sh85066338'">ing</xsl:when>
                    <xsl:when test="$lccn = 'sh85122981'">sri</xsl:when>
                    <xsl:when test="$lccn = 'sh98003529'">tqq</xsl:when>
                    <xsl:when test="$lccn = 'sh85006998'">gae</xsl:when>
                    <xsl:when test="$lccn = 'sh85006996'">aoc</xsl:when>
                    <xsl:when test="$lccn = 'sh93007608'">ata</xsl:when>
                    <xsl:when test="$lccn = 'sh96012120'">ksq</xsl:when>
                    <xsl:when test="$lccn = 'sh85110329'">rad</xsl:when>
                    <xsl:when test="$lccn = 'sh85111251'">rjs</xsl:when>
                    <xsl:when test="$lccn = 'sh98000812'">sml</xsl:when>
                    <xsl:when test="$lccn = 'sh98000811'">vsl</xsl:when>
                    <xsl:when test="$lccn = 'sh85084718'">mic</xsl:when>
                    <xsl:when test="$lccn = 'sh85052606'">fud</xsl:when>
                    <xsl:when test="$lccn = 'sh85052605'">fut</xsl:when>
                    <xsl:when test="$lccn = 'sh2002005964'">gom</xsl:when>
                    <xsl:when test="$lccn = 'sh85091946'">nim</xsl:when>
                    <xsl:when test="$lccn = 'sh85148676'">dgi</xsl:when>
                    <xsl:when test="$lccn = 'sh2008004328'">ntz</xsl:when>
                    <xsl:when test="$lccn = 'sh85093788'">oca</xsl:when>
                    <xsl:when test="$lccn = 'sh85133956'">tio</xsl:when>
                    <xsl:when test="$lccn = 'sh85143318'">vig</xsl:when>
                    <xsl:when test="$lccn = 'sh85120021'">nse</xsl:when>
                    <xsl:when test="$lccn = 'sh85115846'">run</xsl:when>
                    <xsl:when test="$lccn = 'sh88005176'">bkb</xsl:when>
                    <xsl:when test="$lccn = 'sh85059437'">haz</xsl:when>
                    <xsl:when test="$lccn = 'sh2003005574'">pit</xsl:when>
                    <xsl:when test="$lccn = 'sh85059433'">vay</xsl:when>
                    <xsl:when test="$lccn = 'sh87006119'">ikw</xsl:when>
                    <xsl:when test="$lccn = 'sh85141247'">hsb</xsl:when>
                    <xsl:when test="$lccn = 'sh92003201'">kbl</xsl:when>
                    <xsl:when test="$lccn = 'sh2006008547'">brd</xsl:when>
                    <xsl:when test="$lccn = 'sh85095743'">oro</xsl:when>
                    <xsl:when test="$lccn = 'sh85081291'">mbw</xsl:when>
                    <xsl:when test="$lccn = 'sh85047334'">fao</xsl:when>
                    <xsl:when test="$lccn = 'sh85052774'">gbi</xsl:when>
                    <xsl:when test="$lccn = 'sh88001431'">adx</xsl:when>
                    <xsl:when test="$lccn = 'sh97002651'">kkl</xsl:when>
                    <xsl:when test="$lccn = 'sh85037433'">tbh</xsl:when>
                    <xsl:when test="$lccn = 'sh2001003488'">bfa</xsl:when>
                    <xsl:when test="$lccn = 'sh97003750'">bne</xsl:when>
                    <xsl:when test="$lccn = 'sh85088022'">mzp</xsl:when>
                    <xsl:when test="$lccn = 'sh96002072'">bae</xsl:when>
                    <xsl:when test="$lccn = 'sh85073174'">mar</xsl:when>
                    <xsl:when test="$lccn = 'sh85000148'">abi</xsl:when>
                    <xsl:when test="$lccn = 'sh85060811'">hil</xsl:when>
                    <xsl:when test="$lccn = 'sh2008005940'">beb</xsl:when>
                    <xsl:when test="$lccn = 'sh85076382'">njh</xsl:when>
                    <xsl:when test="$lccn = 'sh92006497'">lol</xsl:when>
                    <xsl:when test="$lccn = 'sh97006122'">est</xsl:when>
                    <xsl:when test="$lccn = 'sh85073357'">gom</xsl:when>
                    <xsl:when test="$lccn = 'sh85035340'">dbq</xsl:when>
                    <xsl:when test="$lccn = 'sh85035342'">dav</xsl:when>
                    <xsl:when test="$lccn = 'sh93006465'">txa</xsl:when>
                    <xsl:when test="$lccn = 'sh85073192'">kfe</xsl:when>
                    <xsl:when test="$lccn = 'sh91002836'">azb</xsl:when>
                    <xsl:when test="$lccn = 'sh85105054'">psw</xsl:when>
                    <xsl:when test="$lccn = 'sh00007004'">erk</xsl:when>
                    <xsl:when test="$lccn = 'sh00007002'">llp</xsl:when>
                    <xsl:when test="$lccn = 'sh00007003'">nmk</xsl:when>
                    <xsl:when test="$lccn = 'sh85070551'">jit</xsl:when>
                    <xsl:when test="$lccn = 'sh85070550'">jul</xsl:when>
                    <xsl:when test="$lccn = 'sh85020962'">chc</xsl:when>
                    <xsl:when test="$lccn = 'sh85070559'">jiv</xsl:when>
                    <xsl:when test="$lccn = 'sh2005000173'">bde</xsl:when>
                    <xsl:when test="$lccn = 'sh90004824'">pbb</xsl:when>
                    <xsl:when test="$lccn = 'sh85079056'">lyn</xsl:when>
                    <xsl:when test="$lccn = 'sh2005000174'">bol</xsl:when>
                    <xsl:when test="$lccn = 'sh85007286'">xcl</xsl:when>
                    <xsl:when test="$lccn = 'sh85093493'">nyj</xsl:when>
                    <xsl:when test="$lccn = 'sh86007782'">suc</xsl:when>
                    <xsl:when test="$lccn = 'sh86007781'">laa</xsl:when>
                    <xsl:when test="$lccn = 'sh85127122'">srn</xsl:when>
                    <xsl:when test="$lccn = 'sh85127125'">kpm</xsl:when>
                    <xsl:when test="$lccn = 'sh85074275'">mrw</xsl:when>
                    <xsl:when test="$lccn = 'sh87001266'">pse</xsl:when>
                    <xsl:when test="$lccn = 'sh85079527'">mhi</xsl:when>
                    <xsl:when test="$lccn = 'sh85094817'">ono</xsl:when>
                    <xsl:when test="$lccn = 'sh98005031'">nsn</xsl:when>
                    <xsl:when test="$lccn = 'sh85080476'">rar</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002279'">sjr</xsl:when>
                    <xsl:when test="$lccn = 'sh85071739'">kmg</xsl:when>
                    <xsl:when test="$lccn = 'sh85125617'">sja</xsl:when>
                    <xsl:when test="$lccn = 'sh91002945'">ase</xsl:when>
                    <xsl:when test="$lccn = 'sh85141429'">upv</xsl:when>
                    <xsl:when test="$lccn = 'sh85149236'">yor</xsl:when>
                    <xsl:when test="$lccn = 'sh91002254'">yee</xsl:when>
                    <xsl:when test="$lccn = 'sh85109134'">puu</xsl:when>
                    <xsl:when test="$lccn = 'sh86007875'">cui</xsl:when>
                    <xsl:when test="$lccn = 'sh85089930'">ncz</xsl:when>
                    <xsl:when test="$lccn = 'sh85069859'">jbn</xsl:when>
                    <xsl:when test="$lccn = 'sh85071286'">kzq</xsl:when>
                    <xsl:when test="$lccn = 'sh85004937'">aty</xsl:when>
                    <xsl:when test="$lccn = 'sh91001897'">itz</xsl:when>
                    <xsl:when test="$lccn = 'sh99002917'">tbd</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002874'">bds</xsl:when>
                    <xsl:when test="$lccn = 'sh92002315'">xra</xsl:when>
                    <xsl:when test="$lccn = 'sh99014696'">cwt</xsl:when>
                    <xsl:when test="$lccn = 'sh85040653'">xeb</xsl:when>
                    <xsl:when test="$lccn = 'sh85132405'">abq</xsl:when>
                    <xsl:when test="$lccn = 'sh92005781'">ons</xsl:when>
                    <xsl:when test="$lccn = 'sh85005482'">bjq</xsl:when>
                    <xsl:when test="$lccn = 'sh2004007542'">wrh</xsl:when>
                    <xsl:when test="$lccn = 'sh97004970'">kat</xsl:when>
                    <xsl:when test="$lccn = 'sh85071469'">ems</xsl:when>
                    <xsl:when test="$lccn = 'sh89007219'">ttc</xsl:when>
                    <xsl:when test="$lccn = 'sh88007669'">msm</xsl:when>
                    <xsl:when test="$lccn = 'sh85104776'">pon</xsl:when>
                    <xsl:when test="$lccn = 'sh90004596'">urb</xsl:when>
                    <xsl:when test="$lccn = 'sh85011825'">pmf</xsl:when>
                    <xsl:when test="$lccn = 'sh85011820'">bcj</xsl:when>
                    <xsl:when test="$lccn = 'sh2005003800'">khy</xsl:when>
                    <xsl:when test="$lccn = 'sh85078517'">rmy</xsl:when>
                    <xsl:when test="$lccn = 'sh85007106'">agj</xsl:when>
                    <xsl:when test="$lccn = 'sh85080286'">maw</xsl:when>
                    <xsl:when test="$lccn = 'sh92005257'">bsn</xsl:when>
                    <xsl:when test="$lccn = 'sh2003005172'">mfs</xsl:when>
                    <xsl:when test="$lccn = 'sh85017675'">bug</xsl:when>
                    <xsl:when test="$lccn = 'sh85071778'">xaw</xsl:when>
                    <xsl:when test="$lccn = 'sh95003806'">idt</xsl:when>
                    <xsl:when test="$lccn = 'sh99014211'">nev</xsl:when>
                    <xsl:when test="$lccn = 'sh85139069'">sef</xsl:when>
                    <xsl:when test="$lccn = 'sh85009086'">upv</xsl:when>
                    <xsl:when test="$lccn = 'sh85089671'">kln</xsl:when>
                    <xsl:when test="$lccn = 'sh85011134'">blw</xsl:when>
                    <xsl:when test="$lccn = 'sh99014218'">spu</xsl:when>
                    <xsl:when test="$lccn = 'sh93009494'">nmq</xsl:when>
                    <xsl:when test="$lccn = 'sh2003004884'">wmh</xsl:when>
                    <xsl:when test="$lccn = 'sh85024446'">apm</xsl:when>
                    <xsl:when test="$lccn = 'sh85058739'">luy</xsl:when>
                    <xsl:when test="$lccn = 'sh85003481'">alq</xsl:when>
                    <xsl:when test="$lccn = 'sh85079988'">mak</xsl:when>
                    <xsl:when test="$lccn = 'sh85072898'">kon</xsl:when>
                    <xsl:when test="$lccn = 'sh85072547'">kiz</xsl:when>
                    <xsl:when test="$lccn = 'sh85058046'">jya</xsl:when>
                    <xsl:when test="$lccn = 'sh85072890'">kfc</xsl:when>
                    <xsl:when test="$lccn = 'sh85058041'">gby</xsl:when>
                    <xsl:when test="$lccn = 'sh85149003'">yns</xsl:when>
                    <xsl:when test="$lccn = 'sh85058281'">hai</xsl:when>
                    <xsl:when test="$lccn = 'sh85055658'">god</xsl:when>
                    <xsl:when test="$lccn = 'sh85092176'">nkk</xsl:when>
                    <xsl:when test="$lccn = 'sh87003423'">dhw</xsl:when>
                    <xsl:when test="$lccn = 'sh86004897'">wal</xsl:when>
                    <xsl:when test="$lccn = 'sh2006007240'">bwt</xsl:when>
                    <xsl:when test="$lccn = 'sh85055843'">gon</xsl:when>
                    <xsl:when test="$lccn = 'sh85072942'">ikt</xsl:when>
                    <xsl:when test="$lccn = 'sh85120213'">srr</xsl:when>
                    <xsl:when test="$lccn = 'sh96003821'">cay</xsl:when>
                    <xsl:when test="$lccn = 'sh85071554'">ekg</xsl:when>
                    <xsl:when test="$lccn = 'sh85088651'">huu</xsl:when>
                    <xsl:when test="$lccn = 'sh85139537'">umb</xsl:when>
                    <xsl:when test="$lccn = 'sh00007497'">tuy</xsl:when>
                    <xsl:when test="$lccn = 'sh93006230'">pns</xsl:when>
                    <xsl:when test="$lccn = 'sh85072760'">kpw</xsl:when>
                    <xsl:when test="$lccn = 'sh85048412'">fin</xsl:when>
                    <xsl:when test="$lccn = 'sh85063892'">ian</xsl:when>
                    <xsl:when test="$lccn = 'sh85068810'">itk</xsl:when>
                    <xsl:when test="$lccn = 'sh85018050'">bvr</xsl:when>
                    <xsl:when test="$lccn = 'sh85138534'">tcy</xsl:when>
                    <xsl:when test="$lccn = 'sh96005086'">scb</xsl:when>
                    <xsl:when test="$lccn = 'sh85138538'">duu</xsl:when>
                    <xsl:when test="$lccn = 'sh85148921'">yak</xsl:when>
                    <xsl:when test="$lccn = 'sh85102410'">ppl</xsl:when>
                    <xsl:when test="$lccn = 'sh85135682'">wac</xsl:when>
                    <xsl:when test="$lccn = 'sh85045974'">evn</xsl:when>
                    <xsl:when test="$lccn = 'sh89007032'">lkh</xsl:when>
                    <xsl:when test="$lccn = 'sh85023219'">cip</xsl:when>
                    <xsl:when test="$lccn = 'sh85092572'">nso</xsl:when>
                    <xsl:when test="$lccn = 'sh85092574'">nod</xsl:when>
                    <xsl:when test="$lccn = 'sh85014401'">leb</xsl:when>
                    <xsl:when test="$lccn = 'sh85003174'">alh</xsl:when>
                    <xsl:when test="$lccn = 'sh88004018'">nhr</xsl:when>
                    <xsl:when test="$lccn = 'sh85139255'">udm</xsl:when>
                    <xsl:when test="$lccn = 'sh85072169'">khr</xsl:when>
                    <xsl:when test="$lccn = 'sh85072162'">kca</xsl:when>
                    <xsl:when test="$lccn = 'sh85149012'">yap</xsl:when>
                    <xsl:when test="$lccn = 'sh85035479'">dcc</xsl:when>
                    <xsl:when test="$lccn = 'sh88001882'">kdh</xsl:when>
                    <xsl:when test="$lccn = 'sh88001883'">kbp</xsl:when>
                    <xsl:when test="$lccn = 'sh90004399'">tld</xsl:when>
                    <xsl:when test="$lccn = 'sh94000377'">kls</xsl:when>
                    <xsl:when test="$lccn = 'sh85073615'">gdm</xsl:when>
                    <xsl:when test="$lccn = 'sh85073614'">ldi</xsl:when>
                    <xsl:when test="$lccn = 'sh85085988'">tat</xsl:when>
                    <xsl:when test="$lccn = 'sh85093553'">nzk</xsl:when>
                    <xsl:when test="$lccn = 'sh85093556'">nzi</xsl:when>
                    <xsl:when test="$lccn = 'sh85038790'">dgo</xsl:when>
                    <xsl:when test="$lccn = 'sh85130823'">hns</xsl:when>
                    <xsl:when test="$lccn = 'sh2003010163'">djd</xsl:when>
                    <xsl:when test="$lccn = 'sh85082467'">mdp</xsl:when>
                    <xsl:when test="$lccn = 'sh86002290'">wsv</xsl:when>
                    <xsl:when test="$lccn = 'sh89004481'">hun</xsl:when>
                    <xsl:when test="$lccn = 'sh85014572'">hea</xsl:when>
                    <xsl:when test="$lccn = 'sh85000343'">ake</xsl:when>
                    <xsl:when test="$lccn = 'sh96012132'">thk</xsl:when>
                    <xsl:when test="$lccn = 'sh85111241'">raj</xsl:when>
                    <xsl:when test="$lccn = 'sh88005503'">xsb</xsl:when>
                    <xsl:when test="$lccn = 'sh85046639'">eya</xsl:when>
                    <xsl:when test="$lccn = 'sh85121786'">cjs</xsl:when>
                    <xsl:when test="$lccn = 'sh87007630'">lok</xsl:when>
                    <xsl:when test="$lccn = 'sh85014357'">bom</xsl:when>
                    <xsl:when test="$lccn = 'sh2001006288'">csr</xsl:when>
                    <xsl:when test="$lccn = 'sh85091970'">nir</xsl:when>
                    <xsl:when test="$lccn = 'sh85014358'">bvq</xsl:when>
                    <xsl:when test="$lccn = 'sh93006907'">bwi</xsl:when>
                    <xsl:when test="$lccn = 'sh94005832'">tvt</xsl:when>
                    <xsl:when test="$lccn = 'sh2006004233'">tsb</xsl:when>
                    <xsl:when test="$lccn = 'sh2004005699'">tcb</xsl:when>
                    <xsl:when test="$lccn = 'sh94005839'">myp</xsl:when>
                    <xsl:when test="$lccn = 'sh85004588'">apz</xsl:when>
                    <xsl:when test="$lccn = 'sh2002007687'">ego</xsl:when>
                    <xsl:when test="$lccn = 'sh85082263'">mvb</xsl:when>
                    <xsl:when test="$lccn = 'sh85000043'">abx</xsl:when>
                    <xsl:when test="$lccn = 'sh85115308'">nbu</xsl:when>
                    <xsl:when test="$lccn = 'sh85059372'">haw</xsl:when>
                    <xsl:when test="$lccn = 'sh85115307'">rng</xsl:when>
                    <xsl:when test="$lccn = 'sh96001089'">wwr</xsl:when>
                    <xsl:when test="$lccn = 'sh85025890'">chv</xsl:when>
                    <xsl:when test="$lccn = 'sh87007985'">kbm</xsl:when>
                    <xsl:when test="$lccn = 'sh87007986'">pio</xsl:when>
                    <xsl:when test="$lccn = 'sh87007987'">tpz</xsl:when>
                    <xsl:when test="$lccn = 'sh85019018'">rmr</xsl:when>
                    <xsl:when test="$lccn = 'sh85095864'">osa</xsl:when>
                    <xsl:when test="$lccn = 'sh88005185'">fia</xsl:when>
                    <xsl:when test="$lccn = 'sh97002646'">obo</xsl:when>
                    <xsl:when test="$lccn = 'sh91004323'">shz</xsl:when>
                    <xsl:when test="$lccn = 'sh85073168'">kze</xsl:when>
                    <xsl:when test="$lccn = 'sh85141652'">hau</xsl:when>
                    <xsl:when test="$lccn = 'sh85053604'">gba</xsl:when>
                    <xsl:when test="$lccn = 'sh85073160'">kpy</xsl:when>
                    <xsl:when test="$lccn = 'sh85053600'">gbr</xsl:when>
                    <xsl:when test="$lccn = 'sh85053602'">bza</xsl:when>
                    <xsl:when test="$lccn = 'sh96007788'">pwr</xsl:when>
                    <xsl:when test="$lccn = 'sh2008005939'">mdd</xsl:when>
                    <xsl:when test="$lccn = 'sh85076391'">dij</xsl:when>
                    <xsl:when test="$lccn = 'sh85045068'">ecr</xsl:when>
                    <xsl:when test="$lccn = 'sh97006151'">txs</xsl:when>
                    <xsl:when test="$lccn = 'sh96007832'">klq</xsl:when>
                    <xsl:when test="$lccn = 'sh96007786'">aer</xsl:when>
                    <xsl:when test="$lccn = 'sh97006158'">lva</xsl:when>
                    <xsl:when test="$lccn = 'sh85000266'">abn</xsl:when>
                    <xsl:when test="$lccn = 'sh85145173'">aml</xsl:when>
                    <xsl:when test="$lccn = 'sh85035800'">mps</xsl:when>
                    <xsl:when test="$lccn = 'sh85099551'">pdc</xsl:when>
                    <xsl:when test="$lccn = 'sh88003806'">kra</xsl:when>
                    <xsl:when test="$lccn = 'sh85073346'">kua</xsl:when>
                    <xsl:when test="$lccn = 'sh85073617'">hia</xsl:when>
                    <xsl:when test="$lccn = 'sh85073344'">ksd</xsl:when>
                    <xsl:when test="$lccn = 'sh85073348'">dar</xsl:when>
                    <xsl:when test="$lccn = 'sh85095733'">oac</xsl:when>
                    <xsl:when test="$lccn = 'sh85098024'">pab</xsl:when>
                    <xsl:when test="$lccn = 'sh85078732'">lch</xsl:when>
                    <xsl:when test="$lccn = 'sh85080247'">mmn</xsl:when>
                    <xsl:when test="$lccn = 'sh85058434'">hla</xsl:when>
                    <xsl:when test="$lccn = 'sh86004587'">sre</xsl:when>
                    <xsl:when test="$lccn = 'sh96010966'">syl</xsl:when>
                    <xsl:when test="$lccn = 'sh85072147'">klr</xsl:when>
                    <xsl:when test="$lccn = 'sh85150062'">zun</xsl:when>
                    <xsl:when test="$lccn = 'sh85097521'">peh</xsl:when>
                    <xsl:when test="$lccn = 'sh85121165'">shv</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003301'">lgu</xsl:when>
                    <xsl:when test="$lccn = 'sh85094247'">ozn</xsl:when>
                    <xsl:when test="$lccn = 'sh85138327'">tsi</xsl:when>
                    <xsl:when test="$lccn = 'sh2002001995'">pea</xsl:when>
                    <xsl:when test="$lccn = 'sh96009143'">xce</xsl:when>
                    <xsl:when test="$lccn = 'sh85120224'">sei</xsl:when>
                    <xsl:when test="$lccn = 'sh85125227'">snk</xsl:when>
                    <xsl:when test="$lccn = 'sh2001004741'">ysr</xsl:when>
                    <xsl:when test="$lccn = 'sh2002012353'">wrm</xsl:when>
                    <xsl:when test="$lccn = 'sh87005173'">grc</xsl:when>
                    <xsl:when test="$lccn = 'sh87005172'">grc</xsl:when>
                    <xsl:when test="$lccn = 'sh87005171'">grc</xsl:when>
                    <xsl:when test="$lccn = 'sh95007487'">mug</xsl:when>
                    <xsl:when test="$lccn = 'sh85057030'">grb</xsl:when>
                    <xsl:when test="$lccn = 'sh85010986'">kva</xsl:when>
                    <xsl:when test="$lccn = 'sh85145084'">wne</xsl:when>
                    <xsl:when test="$lccn = 'sh98005029'">xla</xsl:when>
                    <xsl:when test="$lccn = 'sh85010980'">bgq</xsl:when>
                    <xsl:when test="$lccn = 'sh99003562'">ybb</xsl:when>
                    <xsl:when test="$lccn = 'sh98005027'">buk</xsl:when>
                    <xsl:when test="$lccn = 'sh85022362'">ccp</xsl:when>
                    <xsl:when test="$lccn = 'sh85121670'">swj</xsl:when>
                    <xsl:when test="$lccn = 'sh85011053'">gyi</xsl:when>
                    <xsl:when test="$lccn = 'sh85011052'">bdl</xsl:when>
                    <xsl:when test="$lccn = 'sh85022360'">nri</xsl:when>
                    <xsl:when test="$lccn = 'sh85149207'">yok</xsl:when>
                    <xsl:when test="$lccn = 'sh85013169'">bww</xsl:when>
                    <xsl:when test="$lccn = 'sh85024233'">ndc</xsl:when>
                    <xsl:when test="$lccn = 'sh99004097'">rth</xsl:when>
                    <xsl:when test="$lccn = 'sh85145777'">noa</xsl:when>
                    <xsl:when test="$lccn = 'sh85122306'">sid</xsl:when>
                    <xsl:when test="$lccn = 'sh85139212'">teh</xsl:when>
                    <xsl:when test="$lccn = 'sh00008639'">gbl</xsl:when>
                    <xsl:when test="$lccn = 'sh85071294'">kgp</xsl:when>
                    <xsl:when test="$lccn = 'sh85096409'">pma</xsl:when>
                    <xsl:when test="$lccn = 'sh92002303'">cka</xsl:when>
                    <xsl:when test="$lccn = 'sh92002304'">cnk</xsl:when>
                    <xsl:when test="$lccn = 'sh85015796'">boa</xsl:when>
                    <xsl:when test="$lccn = 'sh85132270'">nmf</xsl:when>
                    <xsl:when test="$lccn = 'sh92005408'">atb</xsl:when>
                    <xsl:when test="$lccn = 'sh85145794'">aaq</xsl:when>
                    <xsl:when test="$lccn = 'sh85015793'">dks</xsl:when>
                    <xsl:when test="$lccn = 'sh85069336'">yaa</xsl:when>
                    <xsl:when test="$lccn = 'sh86003945'">bkl</xsl:when>
                    <xsl:when test="$lccn = 'sh85071610'">kpt</xsl:when>
                    <xsl:when test="$lccn = 'sh2002005507'">foi</xsl:when>
                    <xsl:when test="$lccn = 'sh85080809'">nbi</xsl:when>
                    <xsl:when test="$lccn = 'sh85023936'">hur</xsl:when>
                    <xsl:when test="$lccn = 'sh87001050'">zlm</xsl:when>
                    <xsl:when test="$lccn = 'sh85003198'">sqi</xsl:when>
                    <xsl:when test="$lccn = 'sh85071473'">kjb</xsl:when>
                    <xsl:when test="$lccn = 'sh85071472'">kmu</xsl:when>
                    <xsl:when test="$lccn = 'sh88007673'">mbt</xsl:when>
                    <xsl:when test="$lccn = 'sh88007672'">mbi</xsl:when>
                    <xsl:when test="$lccn = 'sh88007675'">mbb</xsl:when>
                    <xsl:when test="$lccn = 'sh88007674'">mbs</xsl:when>
                    <xsl:when test="$lccn = 'sh85071475'">kne</xsl:when>
                    <xsl:when test="$lccn = 'sh00002632'">ybi</xsl:when>
                    <xsl:when test="$lccn = 'sh88006271'">ksc</xsl:when>
                    <xsl:when test="$lccn = 'sh85013987'">bih</xsl:when>
                    <xsl:when test="$lccn = 'sh85011834'">bfa</xsl:when>
                    <xsl:when test="$lccn = 'sh88000341'">udl</xsl:when>
                    <xsl:when test="$lccn = 'sh90004586'">zkh</xsl:when>
                    <xsl:when test="$lccn = 'sh85064205'">ige</xsl:when>
                    <xsl:when test="$lccn = 'sh85064203'">ibo</xsl:when>
                    <xsl:when test="$lccn = 'sh85098831'">psm</xsl:when>
                    <xsl:when test="$lccn = 'sh95003814'">pse</xsl:when>
                    <xsl:when test="$lccn = 'sh92005083'">sgb</xsl:when>
                    <xsl:when test="$lccn = 'sh85035020'">cyo</xsl:when>
                    <xsl:when test="$lccn = 'sh2006007337'">kix</xsl:when>
                    <xsl:when test="$lccn = 'sh85135558'">trp</xsl:when>
                    <xsl:when test="$lccn = 'sh85089665'">nnc</xsl:when>
                    <xsl:when test="$lccn = 'sh2001001246'">orc</xsl:when>
                    <xsl:when test="$lccn = 'sh85053057'">gbc</xsl:when>
                    <xsl:when test="$lccn = 'sh86004312'">wad</xsl:when>
                    <xsl:when test="$lccn = 'sh85089661'">gld</xsl:when>
                    <xsl:when test="$lccn = 'sh85075028'">llu</xsl:when>
                    <xsl:when test="$lccn = 'sh85089669'">nnb</xsl:when>
                    <xsl:when test="$lccn = 'sh92006042'">blk</xsl:when>
                    <xsl:when test="$lccn = 'sh86007514'">tld</xsl:when>
                    <xsl:when test="$lccn = 'sh85024450'">gui</xsl:when>
                    <xsl:when test="$lccn = 'sh85148880'">gya</xsl:when>
                    <xsl:when test="$lccn = 'sh85071989'">kzh</xsl:when>
                    <xsl:when test="$lccn = 'sh88007010'">kuy</xsl:when>
                    <xsl:when test="$lccn = 'sh94000203'">myp</xsl:when>
                    <xsl:when test="$lccn = 'sh85088636'">mur</xsl:when>
                    <xsl:when test="$lccn = 'sh85139236'">ubr</xsl:when>
                    <xsl:when test="$lccn = 'sh92004202'">now</xsl:when>
                    <xsl:when test="$lccn = 'sh85054242'">kat</xsl:when>
                    <xsl:when test="$lccn = 'sh85146212'">mqs</xsl:when>
                    <xsl:when test="$lccn = 'sh2004005416'">nyh</xsl:when>
                    <xsl:when test="$lccn = 'sh85139238'">uby</xsl:when>
                    <xsl:when test="$lccn = 'sh85079082'">xlc</xsl:when>
                    <xsl:when test="$lccn = 'sh98000059'">bgs</xsl:when>
                    <xsl:when test="$lccn = 'sh85068317'">iru</xsl:when>
                    <xsl:when test="$lccn = 'sh90001321'">cku</xsl:when>
                    <xsl:when test="$lccn = 'sh85069152'">izi</xsl:when>
                    <xsl:when test="$lccn = 'sh85079243'">mca</xsl:when>
                    <xsl:when test="$lccn = 'sh93006225'">blj</xsl:when>
                    <xsl:when test="$lccn = 'sh93006224'">abl</xsl:when>
                    <xsl:when test="$lccn = 'sh85072773'">kfa</xsl:when>
                    <xsl:when test="$lccn = 'sh93006228'">sun</xsl:when>
                    <xsl:when test="$lccn = 'sh88007703'">mpc</xsl:when>
                    <xsl:when test="$lccn = 'sh85009059'">kuz</xsl:when>
                    <xsl:when test="$lccn = 'sh85052493'">fvr</xsl:when>
                    <xsl:when test="$lccn = 'sh85063883'">yml</xsl:when>
                    <xsl:when test="$lccn = 'sh91002765'">kzf</xsl:when>
                    <xsl:when test="$lccn = 'sh2001004346'">lbq</xsl:when>
                    <xsl:when test="$lccn = 'sh2007010904'">kwu</xsl:when>
                    <xsl:when test="$lccn = 'sh85071876'">keb</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009992'">atj</xsl:when>
                    <xsl:when test="$lccn = 'sh85071874'">kel</xsl:when>
                    <xsl:when test="$lccn = 'sh96004459'">kal</xsl:when>
                    <xsl:when test="$lccn = 'sh99004393'">qya</xsl:when>
                    <xsl:when test="$lccn = 'sh85028776'">oka</xsl:when>
                    <xsl:when test="$lccn = 'sh85149525'">yuz</xsl:when>
                    <xsl:when test="$lccn = 'sh85003104'">akz</xsl:when>
                    <xsl:when test="$lccn = 'sh85092542'">atv</xsl:when>
                    <xsl:when test="$lccn = 'sh88000725'">tkl</xsl:when>
                    <xsl:when test="$lccn = 'sh85006426'">ape</xsl:when>
                    <xsl:when test="$lccn = 'sh85013963'">nmb</xsl:when>
                    <xsl:when test="$lccn = 'sh85006423'">arp</xsl:when>
                    <xsl:when test="$lccn = 'sh85064428'">ilo</xsl:when>
                    <xsl:when test="$lccn = 'sh85006421'">aro</xsl:when>
                    <xsl:when test="$lccn = 'sh99004140'">kao</xsl:when>
                    <xsl:when test="$lccn = 'sh85145398'">was</xsl:when>
                    <xsl:when test="$lccn = 'sh85072177'">kha</xsl:when>
                    <xsl:when test="$lccn = 'sh85134461'">ths</xsl:when>
                    <xsl:when test="$lccn = 'sh85013566'">big</xsl:when>
                    <xsl:when test="$lccn = 'sh85013562'">bhw</xsl:when>
                    <xsl:when test="$lccn = 'sh97005347'">gnr</xsl:when>
                    <xsl:when test="$lccn = 'sh86004813'">kpy</xsl:when>
                    <xsl:when test="$lccn = 'sh85013568'">bth</xsl:when>
                    <xsl:when test="$lccn = 'sh85004989'">akh</xsl:when>
                    <xsl:when test="$lccn = 'sh85022249'">cao</xsl:when>
                    <xsl:when test="$lccn = 'sh87001847'">mog</xsl:when>
                    <xsl:when test="$lccn = 'sh93001589'">pwg</xsl:when>
                    <xsl:when test="$lccn = 'sh85078314'">crc</xsl:when>
                    <xsl:when test="$lccn = 'sh2007002055'">mgo</xsl:when>
                    <xsl:when test="$lccn = 'sh85072089'">kcv</xsl:when>
                    <xsl:when test="$lccn = 'sh85072088'">ket</xsl:when>
                    <xsl:when test="$lccn = 'sh85082471'">kbc</xsl:when>
                    <xsl:when test="$lccn = 'sh85002218'">esu</xsl:when>
                    <xsl:when test="$lccn = 'sh91004273'">frd</xsl:when>
                    <xsl:when test="$lccn = 'sh85079861'">gdq</xsl:when>
                    <xsl:when test="$lccn = 'sh85061012'">hmo</xsl:when>
                    <xsl:when test="$lccn = 'sh89001275'">snn</xsl:when>
                    <xsl:when test="$lccn = 'sh85138461'">tte</xsl:when>
                    <xsl:when test="$lccn = 'sh91004245'">yiy</xsl:when>
                    <xsl:when test="$lccn = 'sh85111471'">rar</xsl:when>
                    <xsl:when test="$lccn = 'sh85078845'">str</xsl:when>
                    <xsl:when test="$lccn = 'sh85079059'">luy</xsl:when>
                    <xsl:when test="$lccn = 'sh85027698'">con</xsl:when>
                    <xsl:when test="$lccn = 'sh85088224'">moa</xsl:when>
                    <xsl:when test="$lccn = 'sh2008009200'">cos</xsl:when>
                    <xsl:when test="$lccn = 'sh85091967'">noe</xsl:when>
                    <xsl:when test="$lccn = 'sh87007199'">gab</xsl:when>
                    <xsl:when test="$lccn = 'sh87007198'">duc</xsl:when>
                    <xsl:when test="$lccn = 'sh85134998'">txh</xsl:when>
                    <xsl:when test="$lccn = 'sh85096089'">otw</xsl:when>
                    <xsl:when test="$lccn = 'sh85119522'">sec</xsl:when>
                    <xsl:when test="$lccn = 'sh85080397'">mnc</xsl:when>
                    <xsl:when test="$lccn = 'sh85076258'">ojv</xsl:when>
                    <xsl:when test="$lccn = 'sh85040270'">knx</xsl:when>
                    <xsl:when test="$lccn = 'sh89006381'">sma</xsl:when>
                    <xsl:when test="$lccn = 'sh85005358'">fab</xsl:when>
                    <xsl:when test="$lccn = 'sh2006008142'">app</xsl:when>
                    <xsl:when test="$lccn = 'sh85092437'">nrn</xsl:when>
                    <xsl:when test="$lccn = 'sh2002007695'">tan</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006550'">apr</xsl:when>
                    <xsl:when test="$lccn = 'sh85091662'">nju</xsl:when>
                    <xsl:when test="$lccn = 'sh85000059'">abq</xsl:when>
                    <xsl:when test="$lccn = 'sh85000058'">aau</xsl:when>
                    <xsl:when test="$lccn = 'sh91005756'">mrr</xsl:when>
                    <xsl:when test="$lccn = 'sh85001057'">dma</xsl:when>
                    <xsl:when test="$lccn = 'sh88005402'">wol</xsl:when>
                    <xsl:when test="$lccn = 'sh85025887'">der</xsl:when>
                    <xsl:when test="$lccn = 'sh85122956'">shp</xsl:when>
                    <xsl:when test="$lccn = 'sh85019579'">cbu</xsl:when>
                    <xsl:when test="$lccn = 'sh85148884'">yby</xsl:when>
                    <xsl:when test="$lccn = 'sh85052711'">gft</xsl:when>
                    <xsl:when test="$lccn = 'sh85073994'">lbe</xsl:when>
                    <xsl:when test="$lccn = 'sh2004001950'">smp</xsl:when>
                    <xsl:when test="$lccn = 'sh87002571'">acn</xsl:when>
                    <xsl:when test="$lccn = 'sh85100008'">pip</xsl:when>
                    <xsl:when test="$lccn = 'sh93004966'">mxc</xsl:when>
                    <xsl:when test="$lccn = 'sh90004933'">msh</xsl:when>
                    <xsl:when test="$lccn = 'sh85121374'">xsr</xsl:when>
                    <xsl:when test="$lccn = 'sh89006577'">oon</xsl:when>
                    <xsl:when test="$lccn = 'sh85145075'">nnp</xsl:when>
                    <xsl:when test="$lccn = 'sh92003042'">bhd</xsl:when>
                    <xsl:when test="$lccn = 'sh2008005693'">tin</xsl:when>
                    <xsl:when test="$lccn = 'sh85115224'">cla</xsl:when>
                    <xsl:when test="$lccn = 'sh85000120'">any</xsl:when>
                    <xsl:when test="$lccn = 'sh88005536'">fap</xsl:when>
                    <xsl:when test="$lccn = 'sh96007790'">thd</xsl:when>
                    <xsl:when test="$lccn = 'sh85099015'">pcb</xsl:when>
                    <xsl:when test="$lccn = 'sh85000273'">abt</xsl:when>
                    <xsl:when test="$lccn = 'sh85034540'">cua</xsl:when>
                    <xsl:when test="$lccn = 'sh85034541'">kwi</xsl:when>
                    <xsl:when test="$lccn = 'sh2002010064'">urh</xsl:when>
                    <xsl:when test="$lccn = 'sh85098015'">pah</xsl:when>
                    <xsl:when test="$lccn = 'sh85089165'">wbh</xsl:when>
                    <xsl:when test="$lccn = 'sh85080252'">mgr</xsl:when>
                    <xsl:when test="$lccn = 'sh92000889'">ynn</xsl:when>
                    <xsl:when test="$lccn = 'sh85115558'">rug</xsl:when>
                    <xsl:when test="$lccn = 'sh85145893'">wed</xsl:when>
                    <xsl:when test="$lccn = 'sh85138999'">tvl</xsl:when>
                    <xsl:when test="$lccn = 'sh85138990'">tta</xsl:when>
                    <xsl:when test="$lccn = 'sh2007001728'">buu</xsl:when>
                    <xsl:when test="$lccn = 'sh2007001729'">bgj</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003317'">jgo</xsl:when>
                    <xsl:when test="$lccn = 'sh89006579'">sva</xsl:when>
                    <xsl:when test="$lccn = 'sh87003179'">kvb</xsl:when>
                    <xsl:when test="$lccn = 'sh87003178'">bls</xsl:when>
                    <xsl:when test="$lccn = 'sh85035965'">dai</xsl:when>
                    <xsl:when test="$lccn = 'sh85121756'">sna</xsl:when>
                    <xsl:when test="$lccn = 'sh99005132'">ljp</xsl:when>
                    <xsl:when test="$lccn = 'sh99005133'">kkx</xsl:when>
                    <xsl:when test="$lccn = 'sh85091685'">ngc</xsl:when>
                    <xsl:when test="$lccn = 'sh85091682'">ngi</xsl:when>
                    <xsl:when test="$lccn = 'sh99005134'">bkz</xsl:when>
                    <xsl:when test="$lccn = 'sh85015497'">bfw</xsl:when>
                    <xsl:when test="$lccn = 'sh95003311'">slz</xsl:when>
                    <xsl:when test="$lccn = 'sh92006054'">cnw</xsl:when>
                    <xsl:when test="$lccn = 'sh92006053'">kdv</xsl:when>
                    <xsl:when test="$lccn = 'sh85035707'">daa</xsl:when>
                    <xsl:when test="$lccn = 'sh85145096'">nbx</xsl:when>
                    <xsl:when test="$lccn = 'sh85089474'">naf</xsl:when>
                    <xsl:when test="$lccn = 'sh85089475'">ibl</xsl:when>
                    <xsl:when test="$lccn = 'sh85079508'">prs</xsl:when>
                    <xsl:when test="$lccn = 'sh85098496'">pqm</xsl:when>
                    <xsl:when test="$lccn = 'sh85122081'">shh</xsl:when>
                    <xsl:when test="$lccn = 'sh85078695'">loz</xsl:when>
                    <xsl:when test="$lccn = 'sh85090484'">ndo</xsl:when>
                    <xsl:when test="$lccn = 'sh96001509'">akb</xsl:when>
                    <xsl:when test="$lccn = 'sh85071263'">syw</xsl:when>
                    <xsl:when test="$lccn = 'sh85071260'">kog</xsl:when>
                    <xsl:when test="$lccn = 'sh85123047'">sis</xsl:when>
                    <xsl:when test="$lccn = 'sh85071265'">cgc</xsl:when>
                    <xsl:when test="$lccn = 'sh99001309'">arr</xsl:when>
                    <xsl:when test="$lccn = 'sh85025464'">cjv</xsl:when>
                    <xsl:when test="$lccn = 'sh85114208'">rit</xsl:when>
                    <xsl:when test="$lccn = 'sh85132468'">tsz</xsl:when>
                    <xsl:when test="$lccn = 'sh85025462'">zha</xsl:when>
                    <xsl:when test="$lccn = 'sh85132467'">mhu</xsl:when>
                    <xsl:when test="$lccn = 'sh85007290'">hye</xsl:when>
                    <xsl:when test="$lccn = 'sh85035389'">dgz</xsl:when>
                    <xsl:when test="$lccn = 'sh94001789'">yre</xsl:when>
                    <xsl:when test="$lccn = 'sh97007587'">ssp</xsl:when>
                    <xsl:when test="$lccn = 'sh96005088'">lbw</xsl:when>
                    <xsl:when test="$lccn = 'sh93008535'">ihp</xsl:when>
                    <xsl:when test="$lccn = 'sh85024599'">coz</xsl:when>
                    <xsl:when test="$lccn = 'sh85071667'">kbn</xsl:when>
                    <xsl:when test="$lccn = 'sh85071665'">kyh</xsl:when>
                    <xsl:when test="$lccn = 'sh85035387'">dap</xsl:when>
                    <xsl:when test="$lccn = 'sh2008003184'">eto</xsl:when>
                    <xsl:when test="$lccn = 'sh85011488'">bdy</xsl:when>
                    <xsl:when test="$lccn = 'sh85011489'">bbj</xsl:when>
                    <xsl:when test="$lccn = 'sh93006113'">jun</xsl:when>
                    <xsl:when test="$lccn = 'sh96010755'">inp</xsl:when>
                    <xsl:when test="$lccn = 'sh85086311'">zmq</xsl:when>
                    <xsl:when test="$lccn = 'sh85015302'">cop</xsl:when>
                    <xsl:when test="$lccn = 'sh85127105'">squ</xsl:when>
                    <xsl:when test="$lccn = 'sh85080812'">mri</xsl:when>
                    <xsl:when test="$lccn = 'sh85022505'">nbc</xsl:when>
                    <xsl:when test="$lccn = 'sh85054873'">bdy</xsl:when>
                    <xsl:when test="$lccn = 'sh2005006805'">vil</xsl:when>
                    <xsl:when test="$lccn = 'sh85099380'">pem</xsl:when>
                    <xsl:when test="$lccn = 'sh90000035'">xua</xsl:when>
                    <xsl:when test="$lccn = 'sh87003999'">btz</xsl:when>
                    <xsl:when test="$lccn = 'sh93006448'">ped</xsl:when>
                    <xsl:when test="$lccn = 'sh85096538'">pac</xsl:when>
                    <xsl:when test="$lccn = 'sh85132260'">tgg</xsl:when>
                    <xsl:when test="$lccn = 'sh85088703'">mse</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009530'">nxn</xsl:when>
                    <xsl:when test="$lccn = 'sh85087413'">mgd</xsl:when>
                    <xsl:when test="$lccn = 'sh93005100'">min</xsl:when>
                    <xsl:when test="$lccn = 'sh85142784'">vep</xsl:when>
                    <xsl:when test="$lccn = 'sh85071061'">jup</xsl:when>
                    <xsl:when test="$lccn = 'sh85097435'">pbr</xsl:when>
                    <xsl:when test="$lccn = 'sh85097431'">pag</xsl:when>
                    <xsl:when test="$lccn = 'sh94001497'">gbb</xsl:when>
                    <xsl:when test="$lccn = 'sh85139000'">tyv</xsl:when>
                    <xsl:when test="$lccn = 'sh85012174'">bsq</xsl:when>
                    <xsl:when test="$lccn = 'sh85044220'">gey</xsl:when>
                    <xsl:when test="$lccn = 'sh85080023'">mlg</xsl:when>
                    <xsl:when test="$lccn = 'sh85072560'">tap</xsl:when>
                    <xsl:when test="$lccn = 'sh85086389'">akz</xsl:when>
                    <xsl:when test="$lccn = 'sh2001004751'">bzr</xsl:when>
                    <xsl:when test="$lccn = 'sh85132282'">txg</xsl:when>
                    <xsl:when test="$lccn = 'sh85055672'">gog</xsl:when>
                    <xsl:when test="$lccn = 'sh85129741'">swi</xsl:when>
                    <xsl:when test="$lccn = 'sh2002011318'">kyc</xsl:when>
                    <xsl:when test="$lccn = 'sh85055674'">ggw</xsl:when>
                    <xsl:when test="$lccn = 'sh85139227'">waw</xsl:when>
                    <xsl:when test="$lccn = 'sh85002517'">agx</xsl:when>
                    <xsl:when test="$lccn = 'sh85002512'">agr</xsl:when>
                    <xsl:when test="$lccn = 'sh85092159'">njb</xsl:when>
                    <xsl:when test="$lccn = 'sh85002511'">agu</xsl:when>
                    <xsl:when test="$lccn = 'sh2008003560'">arg</xsl:when>
                    <xsl:when test="$lccn = 'sh96004681'">yba</xsl:when>
                    <xsl:when test="$lccn = 'sh96004683'">jnj</xsl:when>
                    <xsl:when test="$lccn = 'sh85069168'">jae</xsl:when>
                    <xsl:when test="$lccn = 'sh85088633'">mwf</xsl:when>
                    <xsl:when test="$lccn = 'sh85117551'">srd</xsl:when>
                    <xsl:when test="$lccn = 'sh96004867'">bfd</xsl:when>
                    <xsl:when test="$lccn = 'sh96004862'">ged</xsl:when>
                    <xsl:when test="$lccn = 'sh85083402'">mxe</xsl:when>
                    <xsl:when test="$lccn = 'sh85083406'">pwm</xsl:when>
                    <xsl:when test="$lccn = 'sh98000731'">xsa</xsl:when>
                    <xsl:when test="$lccn = 'sh85112833'">rel</xsl:when>
                    <xsl:when test="$lccn = 'sh85063189'">xhu</xsl:when>
                    <xsl:when test="$lccn = 'sh2003000221'">duj</xsl:when>
                    <xsl:when test="$lccn = 'sh85063187'">wya</xsl:when>
                    <xsl:when test="$lccn = 'sh85101444'">xpg</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009985'">sig</xsl:when>
                    <xsl:when test="$lccn = 'sh85150030'">zom</xsl:when>
                    <xsl:when test="$lccn = 'sh92000330'">maf</xsl:when>
                    <xsl:when test="$lccn = 'sh90005920'">bjq</xsl:when>
                    <xsl:when test="$lccn = 'sh85146336'">wew</xsl:when>
                    <xsl:when test="$lccn = 'sh97000762'">ccg</xsl:when>
                    <xsl:when test="$lccn = 'sh85083249'">byv</xsl:when>
                    <xsl:when test="$lccn = 'sh85003114'">alc</xsl:when>
                    <xsl:when test="$lccn = 'sh85003116'">ald</xsl:when>
                    <xsl:when test="$lccn = 'sh85064432'">ilk</xsl:when>
                    <xsl:when test="$lccn = 'sh88007021'">hif</xsl:when>
                    <xsl:when test="$lccn = 'sh85006436'">arn</xsl:when>
                    <xsl:when test="$lccn = 'sh85085948'">mwl</xsl:when>
                    <xsl:when test="$lccn = 'sh85117331'">san</xsl:when>
                    <xsl:when test="$lccn = 'sh87007053'">dyi</xsl:when>
                    <xsl:when test="$lccn = 'sh85006540'">aqc</xsl:when>
                    <xsl:when test="$lccn = 'sh88007670'">atd</xsl:when>
                    <xsl:when test="$lccn = 'sh85036550'">del</xsl:when>
                    <xsl:when test="$lccn = 'sh85131135'">swe</xsl:when>
                    <xsl:when test="$lccn = 'sh2005002886'">akc</xsl:when>
                    <xsl:when test="$lccn = 'sh85024429'">oji</xsl:when>
                    <xsl:when test="$lccn = 'sh96009998'">khe</xsl:when>
                    <xsl:when test="$lccn = 'sh85138172'">tpy</xsl:when>
                    <xsl:when test="$lccn = 'sh87000522'">krj</xsl:when>
                    <xsl:when test="$lccn = 'sh87000521'">nij</xsl:when>
                    <xsl:when test="$lccn = 'sh85066340'">inj</xsl:when>
                    <xsl:when test="$lccn = 'sh85102504'">pjt</xsl:when>
                    <xsl:when test="$lccn = 'sh85066342'">tbi</xsl:when>
                    <xsl:when test="$lccn = 'sh2003005414'">ltz</xsl:when>
                    <xsl:when test="$lccn = 'sh2004010398'">ngo</xsl:when>
                    <xsl:when test="$lccn = 'sh85098341'">xpr</xsl:when>
                    <xsl:when test="$lccn = 'sh85082440'">mcf</xsl:when>
                    <xsl:when test="$lccn = 'sh2004010397'">tap</xsl:when>
                    <xsl:when test="$lccn = 'sh2003010188'">mwd</xsl:when>
                    <xsl:when test="$lccn = 'sh2008006517'">tmh</xsl:when>
                    <xsl:when test="$lccn = 'sh89003679'">wit</xsl:when>
                    <xsl:when test="$lccn = 'sh90002810'">ipk</xsl:when>
                    <xsl:when test="$lccn = 'sh85086399'">moy</xsl:when>
                    <xsl:when test="$lccn = 'sh92001884'">bmj</xsl:when>
                    <xsl:when test="$lccn = 'sh85041339'">egy</xsl:when>
                    <xsl:when test="$lccn = 'sh85103902'">poy</xsl:when>
                    <xsl:when test="$lccn = 'sh85074644'">lao</xsl:when>
                    <xsl:when test="$lccn = 'sh91004504'">szw</xsl:when>
                    <xsl:when test="$lccn = 'sh85078874'">lun</xsl:when>
                    <xsl:when test="$lccn = 'sh85094486'">okr</xsl:when>
                    <xsl:when test="$lccn = 'sh87007613'">kud</xsl:when>
                    <xsl:when test="$lccn = 'sh88003813'">rog</xsl:when>
                    <xsl:when test="$lccn = 'sh85094489'">opm</xsl:when>
                    <xsl:when test="$lccn = 'sh94005815'">bgg</xsl:when>
                    <xsl:when test="$lccn = 'sh85004761'">anm</xsl:when>
                    <xsl:when test="$lccn = 'sh85120762'">ksw</xsl:when>
                    <xsl:when test="$lccn = 'sh86006662'">csi</xsl:when>
                    <xsl:when test="$lccn = 'sh85082280'">mav</xsl:when>
                    <xsl:when test="$lccn = 'sh92000448'">str</xsl:when>
                    <xsl:when test="$lccn = 'sh93002028'">jns</xsl:when>
                    <xsl:when test="$lccn = 'sh85115036'">ron/rum</xsl:when>
                    <xsl:when test="$lccn = 'sh88005740'">cuk</xsl:when>
                    <xsl:when test="$lccn = 'sh87007478'">rai</xsl:when>
                    <xsl:when test="$lccn = 'sh87007479'">gbf</xsl:when>
                    <xsl:when test="$lccn = 'sh85005018'">anp</xsl:when>
                    <xsl:when test="$lccn = 'sh87007471'">cot</xsl:when>
                    <xsl:when test="$lccn = 'sh87007472'">gaw</xsl:when>
                    <xsl:when test="$lccn = 'sh86006115'">mcn</xsl:when>
                    <xsl:when test="$lccn = 'sh87007475'">kzr</xsl:when>
                    <xsl:when test="$lccn = 'sh87007476'">mua</xsl:when>
                    <xsl:when test="$lccn = 'sh85005015'">agg</xsl:when>
                    <xsl:when test="$lccn = 'sh2007001640'">bxe</xsl:when>
                    <xsl:when test="$lccn = 'sh85052728'">ggu</xsl:when>
                    <xsl:when test="$lccn = 'sh92005614'">rwo</xsl:when>
                    <xsl:when test="$lccn = 'sh85014026'">byn</xsl:when>
                    <xsl:when test="$lccn = 'sh97003762'">llq</xsl:when>
                    <xsl:when test="$lccn = 'sh2003010420'">rmb</xsl:when>
                    <xsl:when test="$lccn = 'sh85090733'">nen</xsl:when>
                    <xsl:when test="$lccn = 'sh85059289'">xht</xsl:when>
                    <xsl:when test="$lccn = 'sh92005242'">pir</xsl:when>
                    <xsl:when test="$lccn = 'sh85147779'">wyb</xsl:when>
                    <xsl:when test="$lccn = 'sh93004402'">dus</xsl:when>
                    <xsl:when test="$lccn = 'sh85004163'">leb</xsl:when>
                    <xsl:when test="$lccn = 'sh87001722'">trv</xsl:when>
                    <xsl:when test="$lccn = 'sh92003367'">pcc</xsl:when>
                    <xsl:when test="$lccn = 'sh92003361'">bba</xsl:when>
                    <xsl:when test="$lccn = 'sh85064185'">clk</xsl:when>
                    <xsl:when test="$lccn = 'sh85064186'">viv</xsl:when>
                    <xsl:when test="$lccn = 'sh2002004299'">bew</xsl:when>
                    <xsl:when test="$lccn = 'sh89006379'">sjd</xsl:when>
                    <xsl:when test="$lccn = 'sh93007899'">adi</xsl:when>
                    <xsl:when test="$lccn = 'sh2007001730'">lns</xsl:when>
                    <xsl:when test="$lccn = 'sh2007001733'">ish</xsl:when>
                    <xsl:when test="$lccn = 'sh2007001732'">lik</xsl:when>
                    <xsl:when test="$lccn = 'sh85150044'">zul</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002062'">djm</xsl:when>
                    <xsl:when test="$lccn = 'sh85052039'">fur</xsl:when>
                    <xsl:when test="$lccn = 'sh85150042'">gnd</xsl:when>
                    <xsl:when test="$lccn = 'sh87003144'">tau</xsl:when>
                    <xsl:when test="$lccn = 'sh85098311'">guj</xsl:when>
                    <xsl:when test="$lccn = 'sh85094462'">oka</xsl:when>
                    <xsl:when test="$lccn = 'sh85046963'">xfa</xsl:when>
                    <xsl:when test="$lccn = 'sh85046961'">fli</xsl:when>
                    <xsl:when test="$lccn = 'sh85081805'">amr</xsl:when>
                    <xsl:when test="$lccn = 'sh99005124'">kje</xsl:when>
                    <xsl:when test="$lccn = 'sh85000484'">aca</xsl:when>
                    <xsl:when test="$lccn = 'sh99005126'">jav</xsl:when>
                    <xsl:when test="$lccn = 'sh99005129'">dnw</xsl:when>
                    <xsl:when test="$lccn = 'sh85035731'">dan</xsl:when>
                    <xsl:when test="$lccn = 'sh85094865'">opt</xsl:when>
                    <xsl:when test="$lccn = 'sh2001007851'">kgh</xsl:when>
                    <xsl:when test="$lccn = 'sh92008001248'">siy</xsl:when>
                    <xsl:when test="$lccn = 'sh89004858'">smn</xsl:when>
                    <xsl:when test="$lccn = 'sh85011039'">byx</xsl:when>
                    <xsl:when test="$lccn = 'sh90006164'">sea</xsl:when>
                    <xsl:when test="$lccn = 'sh86007445'">bvz</xsl:when>
                    <xsl:when test="$lccn = 'sh86007446'">ibb</xsl:when>
                    <xsl:when test="$lccn = 'sh85010527'">ave</xsl:when>
                    <xsl:when test="$lccn = 'sh85122984'">srx</xsl:when>
                    <xsl:when test="$lccn = 'sh85122986'">ssd</xsl:when>
                    <xsl:when test="$lccn = 'sh87002384'">ifb</xsl:when>
                    <xsl:when test="$lccn = 'sh85071272'">kki</xsl:when>
                    <xsl:when test="$lccn = 'sh85149133'">yss</xsl:when>
                    <xsl:when test="$lccn = 'sh97000067'">beh</xsl:when>
                    <xsl:when test="$lccn = 'sh91001597'">xnn</xsl:when>
                    <xsl:when test="$lccn = 'sh85135338'">tik</xsl:when>
                    <xsl:when test="$lccn = 'sh85007289'">hye</xsl:when>
                    <xsl:when test="$lccn = 'sh85007288'">hye</xsl:when>
                    <xsl:when test="$lccn = 'sh85053189'">grt</xsl:when>
                    <xsl:when test="$lccn = 'sh85077822'">liv</xsl:when>
                    <xsl:when test="$lccn = 'sh85007285'">hye</xsl:when>
                    <xsl:when test="$lccn = 'sh85007287'">axm</xsl:when>
                    <xsl:when test="$lccn = 'sh85077829'">njn</xsl:when>
                    <xsl:when test="$lccn = 'sh97006840'">ntm</xsl:when>
                    <xsl:when test="$lccn = 'sh85136114'">xal</xsl:when>
                    <xsl:when test="$lccn = 'sh85080532'">cjr</xsl:when>
                    <xsl:when test="$lccn = 'sh85080533'">iry</xsl:when>
                    <xsl:when test="$lccn = 'sh85090833'">nep</xsl:when>
                    <xsl:when test="$lccn = 'sh87001067'">zlm</xsl:when>
                    <xsl:when test="$lccn = 'sh85142530'">dlm</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003104'">ahl</xsl:when>
                    <xsl:when test="$lccn = 'sh85144944'">wln</xsl:when>
                    <xsl:when test="$lccn = 'sh93009491'">led</xsl:when>
                    <xsl:when test="$lccn = 'sh93009490'">kmw</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003101'">eko</xsl:when>
                    <xsl:when test="$lccn = 'sh85024613'">cho</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003103'">ior</xsl:when>
                    <xsl:when test="$lccn = 'sh95008089'">bcs</xsl:when>
                    <xsl:when test="$lccn = 'sh85016310'">brh</xsl:when>
                    <xsl:when test="$lccn = 'sh85087085'">mxk</xsl:when>
                    <xsl:when test="$lccn = 'sh2008000750'">kru</xsl:when>
                    <xsl:when test="$lccn = 'sh87000093'">srg</xsl:when>
                    <xsl:when test="$lccn = 'sh2001004769'">tiq</xsl:when>
                    <xsl:when test="$lccn = 'sh90005525'">sum</xsl:when>
                    <xsl:when test="$lccn = 'sh2008008501'">mcx</xsl:when>
                    <xsl:when test="$lccn = 'sh92004590'">ifu</xsl:when>
                    <xsl:when test="$lccn = 'sh92004591'">agp</xsl:when>
                    <xsl:when test="$lccn = 'sh85095736'">orh</xsl:when>
                    <xsl:when test="$lccn = 'sh2002001717'">cim</xsl:when>
                    <xsl:when test="$lccn = 'sh85111401'">rap</xsl:when>
                    <xsl:when test="$lccn = 'sh85138638'">tun</xsl:when>
                    <xsl:when test="$lccn = 'sh99013540'">swl</xsl:when>
                    <xsl:when test="$lccn = 'sh2008004776'">god</xsl:when>
                    <xsl:when test="$lccn = 'sh85079315'">mcb</xsl:when>
                    <xsl:when test="$lccn = 'sh85087406'">mrl</xsl:when>
                    <xsl:when test="$lccn = 'sh98004758'">kzz</xsl:when>
                    <xsl:when test="$lccn = 'sh85016790'">bzd</xsl:when>
                    <xsl:when test="$lccn = 'sh85132278'">nst</xsl:when>
                    <xsl:when test="$lccn = 'sh85139030'">twi</xsl:when>
                    <xsl:when test="$lccn = 'sh85149008'">ium</xsl:when>
                    <xsl:when test="$lccn = 'sh85011141'">ble</xsl:when>
                    <xsl:when test="$lccn = 'sh88006677'">kge</xsl:when>
                    <xsl:when test="$lccn = 'sh85149000'">guu</xsl:when>
                    <xsl:when test="$lccn = 'sh85069794'">jav</xsl:when>
                    <xsl:when test="$lccn = 'sh85108100'">prg</xsl:when>
                    <xsl:when test="$lccn = 'sh85149007'">yao</xsl:when>
                    <xsl:when test="$lccn = 'sh91002064'">sek</xsl:when>
                    <xsl:when test="$lccn = 'sh85071309'">hrv</xsl:when>
                    <xsl:when test="$lccn = 'sh85071308'">kaj</xsl:when>
                    <xsl:when test="$lccn = 'sh85135224'">bod</xsl:when>
                    <xsl:when test="$lccn = 'sh85017684'">bgt</xsl:when>
                    <xsl:when test="$lccn = 'sh85123476'">slk</xsl:when>
                    <xsl:when test="$lccn = 'sh85022404'">ceg</xsl:when>
                    <xsl:when test="$lccn = 'sh85055605'">gdo</xsl:when>
                    <xsl:when test="$lccn = 'sh85135329'">tir</xsl:when>
                    <xsl:when test="$lccn = 'sh85002509'">agt</xsl:when>
                    <xsl:when test="$lccn = 'sh85121100'">shn</xsl:when>
                    <xsl:when test="$lccn = 'sh88000630'">lor</xsl:when>
                    <xsl:when test="$lccn = 'sh88000631'">lor</xsl:when>
                    <xsl:when test="$lccn = 'sh88000632'">tui</xsl:when>
                    <xsl:when test="$lccn = 'sh85020469'">crx</xsl:when>
                    <xsl:when test="$lccn = 'sh85068375'">inn</xsl:when>
                    <xsl:when test="$lccn = 'sh92005359'">ril</xsl:when>
                    <xsl:when test="$lccn = 'sh85068371'">sgl</xsl:when>
                    <xsl:when test="$lccn = 'sh85107831'">pro</xsl:when>
                    <xsl:when test="$lccn = 'sh85069172'">grj</xsl:when>
                    <xsl:when test="$lccn = 'sh85079224'">mhy</xsl:when>
                    <xsl:when test="$lccn = 'sh85054365'">deu</xsl:when>
                    <xsl:when test="$lccn = 'sh85097359'">mpx</xsl:when>
                    <xsl:when test="$lccn = 'sh2004006904'">mnh</xsl:when>
                    <xsl:when test="$lccn = 'sh85058389'">lad</xsl:when>
                    <xsl:when test="$lccn = 'sh85075971'">tnl</xsl:when>
                    <xsl:when test="$lccn = 'sh2004007459'">ppp</xsl:when>
                    <xsl:when test="$lccn = 'sh99014661'">had</xsl:when>
                    <xsl:when test="$lccn = 'sh85079229'">mde</xsl:when>
                    <xsl:when test="$lccn = 'sh85072998'">kqz</xsl:when>
                    <xsl:when test="$lccn = 'sh85012780'">tnr</xsl:when>
                    <xsl:when test="$lccn = 'sh85116698'">slr</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006896'">wra</xsl:when>
                    <xsl:when test="$lccn = 'sh91003699'">aby</xsl:when>
                    <xsl:when test="$lccn = 'sh85018020'">bnn</xsl:when>
                    <xsl:when test="$lccn = 'sh99005127'">mkz</xsl:when>
                    <xsl:when test="$lccn = 'sh85013096'">bem</xsl:when>
                    <xsl:when test="$lccn = 'sh85013099'">bmb</xsl:when>
                    <xsl:when test="$lccn = 'sh85013098'">beq</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009736'">bcm</xsl:when>
                    <xsl:when test="$lccn = 'sh94007785'">amk</xsl:when>
                    <xsl:when test="$lccn = 'sh85006396'">axx</xsl:when>
                    <xsl:when test="$lccn = 'sh85003127'">amp</xsl:when>
                    <xsl:when test="$lccn = 'sh95007219'">swb</xsl:when>
                    <xsl:when test="$lccn = 'sh85006404'">arc</xsl:when>
                    <xsl:when test="$lccn = 'sh85022798'">cbt</xsl:when>
                    <xsl:when test="$lccn = 'sh85038075'">din</xsl:when>
                    <xsl:when test="$lccn = 'sh2008001571'">slp</xsl:when>
                    <xsl:when test="$lccn = 'sh85027563'">cod</xsl:when>
                    <xsl:when test="$lccn = 'sh85072195'">nkh</xsl:when>
                    <xsl:when test="$lccn = 'sh85013549'">bho</xsl:when>
                    <xsl:when test="$lccn = 'sh85072199'">kjj</xsl:when>
                    <xsl:when test="$lccn = 'sh85013542'">bhb</xsl:when>
                    <xsl:when test="$lccn = 'sh85146492'">apw</xsl:when>
                    <xsl:when test="$lccn = 'sh85072353'">kmb</xsl:when>
                    <xsl:when test="$lccn = 'sh2004006017'">kfs</xsl:when>
                    <xsl:when test="$lccn = 'sh85129399'">swp</xsl:when>
                    <xsl:when test="$lccn = 'sh85147017'">win</xsl:when>
                    <xsl:when test="$lccn = 'sh87000399'">sse</xsl:when>
                    <xsl:when test="$lccn = 'sh85086357'">mng</xsl:when>
                    <xsl:when test="$lccn = 'sh2003010193'">lrg</xsl:when>
                    <xsl:when test="$lccn = 'sh2003010198'">djj</xsl:when>
                    <xsl:when test="$lccn = 'sh99002248'">zko</xsl:when>
                    <xsl:when test="$lccn = 'sh85116105'">rnd</xsl:when>
                    <xsl:when test="$lccn = 'sh85116103'">rut</xsl:when>
                    <xsl:when test="$lccn = 'sh85089865'">nay</xsl:when>
                    <xsl:when test="$lccn = 'sh85027306'">xcw</xsl:when>
                    <xsl:when test="$lccn = 'sh87007603'">bdd</xsl:when>
                    <xsl:when test="$lccn = 'sh87007602'">bxb</xsl:when>
                    <xsl:when test="$lccn = 'sh2001007071'">osc</xsl:when>
                    <xsl:when test="$lccn = 'sh85086551'">rum</xsl:when>
                    <xsl:when test="$lccn = 'sh2006004871'">swh</xsl:when>
                    <xsl:when test="$lccn = 'sh85134084'">tfr</xsl:when>
                    <xsl:when test="$lccn = 'sh85119814'">sel</xsl:when>
                    <xsl:when test="$lccn = 'sh85094677'">oml</xsl:when>
                    <xsl:when test="$lccn = 'sh85149778'">hay</xsl:when>
                    <xsl:when test="$lccn = 'sh94002687'">mhk</xsl:when>
                    <xsl:when test="$lccn = 'sh85082295'">mph</xsl:when>
                    <xsl:when test="$lccn = 'sh85040106'">nld</xsl:when>
                    <xsl:when test="$lccn = 'sh85033883'">cre</xsl:when>
                    <xsl:when test="$lccn = 'sh93006063'">gbj</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009951'">ank</xsl:when>
                    <xsl:when test="$lccn = 'sh88005464'">ken</xsl:when>
                    <xsl:when test="$lccn = 'sh85083893'">mer</xsl:when>
                    <xsl:when test="$lccn = 'sh85034708'">cul</xsl:when>
                    <xsl:when test="$lccn = 'sh87007466'">bwu</xsl:when>
                    <xsl:when test="$lccn = 'sh87007463'">bmu</xsl:when>
                    <xsl:when test="$lccn = 'sh85110213'">rah</xsl:when>
                    <xsl:when test="$lccn = 'sh93008044'">xdy</xsl:when>
                    <xsl:when test="$lccn = 'sh85062719'">ygr</xsl:when>
                    <xsl:when test="$lccn = 'sh85052732'">gah</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002610'">ybh</xsl:when>
                    <xsl:when test="$lccn = 'sh90004954'">hnj</xsl:when>
                    <xsl:when test="$lccn = 'sh85130508'">sun</xsl:when>
                    <xsl:when test="$lccn = 'sh2008007713'">bex</xsl:when>
                    <xsl:when test="$lccn = 'sh85138907'">tuk</xsl:when>
                    <xsl:when test="$lccn = 'sh2006020081'">poo</xsl:when>
                    <xsl:when test="$lccn = 'sh85048918'">kwf</xsl:when>
                    <xsl:when test="$lccn = 'sh96007771'">url</xsl:when>
                    <xsl:when test="$lccn = 'sh85115971'">rus</xsl:when>
                    <xsl:when test="$lccn = 'sh85087556'">mot</xsl:when>
                    <xsl:when test="$lccn = 'sh96007809'">chz</xsl:when>
                    <xsl:when test="$lccn = 'sh85073488'">kru</xsl:when>
                    <xsl:when test="$lccn = 'sh85057601'">grn</xsl:when>
                    <xsl:when test="$lccn = 'sh85004449'">amh</xsl:when>
                    <xsl:when test="$lccn = 'sh85144417'">vot</xsl:when>
                    <xsl:when test="$lccn = 'sh2001005511'">wwa</xsl:when>
                    <xsl:when test="$lccn = 'sh85086508'">mof</xsl:when>
                    <xsl:when test="$lccn = 'sh85034019'">crh</xsl:when>
                    <xsl:when test="$lccn = 'sh85088289'">bmr</xsl:when>
                    <xsl:when test="$lccn = 'sh95007203'">wja</xsl:when>
                    <xsl:when test="$lccn = 'sh93006227'">cia</xsl:when>
                    <xsl:when test="$lccn = 'sh98006664'">wbk</xsl:when>
                    <xsl:when test="$lccn = 'sh85138975'">tus</xsl:when>
                    <xsl:when test="$lccn = 'sh99005274'">wow</xsl:when>
                    <xsl:when test="$lccn = 'sh85052633'">gnk</xsl:when>
                    <xsl:when test="$lccn = 'sh85141752'">vag</xsl:when>
                    <xsl:when test="$lccn = 'sh85073002'">kpr</xsl:when>
                    <xsl:when test="$lccn = 'sh85061299'">hmn</xsl:when>
                    <xsl:when test="$lccn = 'sh85061296'">hmr</xsl:when>
                    <xsl:when test="$lccn = 'sh88007671'">mta</xsl:when>
                    <xsl:when test="$lccn = 'sh87000954'">ifb</xsl:when>
                    <xsl:when test="$lccn = 'sh93009159'">bxj</xsl:when>
                    <xsl:when test="$lccn = 'sh85141573'">usa</xsl:when>
                    <xsl:when test="$lccn = 'sh85041438'">eka</xsl:when>
                    <xsl:when test="$lccn = 'sh85007388'">rup</xsl:when>
                    <xsl:when test="$lccn = 'sh87001421'">bfy</xsl:when>
                    <xsl:when test="$lccn = 'sh85073799'">lac</xsl:when>
                    <xsl:when test="$lccn = 'sh85131019'">ssw</xsl:when>
                    <xsl:when test="$lccn = 'sh89006211'">kca</xsl:when>
                    <xsl:when test="$lccn = 'sh85011008'">bjh</xsl:when>
                    <xsl:when test="$lccn = 'sh85011009'">bhj</xsl:when>
                    <xsl:when test="$lccn = 'sh2002005884'">ksj</xsl:when>
                    <xsl:when test="$lccn = 'sh99000092'">nmz</xsl:when>
                    <xsl:when test="$lccn = 'sh85080630'">msk</xsl:when>
                    <xsl:when test="$lccn = 'sh85070689'">mmy</xsl:when>
                    <xsl:when test="$lccn = 'sh85090350'">nav</xsl:when>
                    <xsl:when test="$lccn = 'sh91000630'">ppi</xsl:when>
                    <xsl:when test="$lccn = 'sh85099568'">aaq</xsl:when>
                    <xsl:when test="$lccn = 'sh85138883'">tur</xsl:when>
                    <xsl:when test="$lccn = 'sh85122995'">sld</xsl:when>
                    <xsl:when test="$lccn = 'sh85073316'">klu</xsl:when>
                    <xsl:when test="$lccn = 'sh85088518'">mtq</xsl:when>
                    <xsl:when test="$lccn = 'sh85071792'">kaw</xsl:when>
                    <xsl:when test="$lccn = 'sh85123061'">siw</xsl:when>
                    <xsl:when test="$lccn = 'sh85050171'">fon</xsl:when>
                    <xsl:when test="$lccn = 'sh85075980'">leg</xsl:when>
                    <xsl:when test="$lccn = 'sh85148913'">ynu</xsl:when>
                    <xsl:when test="$lccn = 'sh85035619'">daf</xsl:when>
                    <xsl:when test="$lccn = 'sh2003010757'">fiz</xsl:when>
                    <xsl:when test="$lccn = 'sh85071641'">kzw</xsl:when>
                    <xsl:when test="$lccn = 'sh91001108'">emo</xsl:when>
                    <xsl:when test="$lccn = 'sh85071873'">kek</xsl:when>
                    <xsl:when test="$lccn = 'sh85091532'">new</xsl:when>
                    <xsl:when test="$lccn = 'sh92004816'">mwt</xsl:when>
                    <xsl:when test="$lccn = 'sh85122195'">snp</xsl:when>
                    <xsl:when test="$lccn = 'sh85022887'">ute</xsl:when>
                    <xsl:when test="$lccn = 'sh85080290'">mdi</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003118'">tlj</xsl:when>
                    <xsl:when test="$lccn = 'sh85096982'">pau</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002540'">lml</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003111'">ogu</xsl:when>
                    <xsl:when test="$lccn = 'sh93006356'">nss</xsl:when>
                    <xsl:when test="$lccn = 'sh92005354'">raw</xsl:when>
                    <xsl:when test="$lccn = 'sh86004299'">slx</xsl:when>
                    <xsl:when test="$lccn = 'sh85020782'">cat</xsl:when>
                    <xsl:when test="$lccn = 'sh85051829'">fra</xsl:when>
                    <xsl:when test="$lccn = 'sh85064231'">ijc</xsl:when>
                    <xsl:when test="$lccn = 'sh92004587'">nhd</xsl:when>
                    <xsl:when test="$lccn = 'sh92004586'">bjg</xsl:when>
                    <xsl:when test="$lccn = 'sh85148918'">yka</xsl:when>
                    <xsl:when test="$lccn = 'sh85003358'">ale</xsl:when>
                    <xsl:when test="$lccn = 'sh86008213'">tft</xsl:when>
                    <xsl:when test="$lccn = 'sh85133667'">tel</xsl:when>
                    <xsl:when test="$lccn = 'sh97008872'">yog</xsl:when>
                    <xsl:when test="$lccn = 'sh97008870'">ayz</xsl:when>
                    <xsl:when test="$lccn = 'sh85011177'">ban</xsl:when>
                    <xsl:when test="$lccn = 'sh85149018'">yrb</xsl:when>
                    <xsl:when test="$lccn = 'sh88006669'">ngc</xsl:when>
                    <xsl:when test="$lccn = 'sh85079284'">mkd</xsl:when>
                    <xsl:when test="$lccn = 'sh92004900'">bdw</xsl:when>
                    <xsl:when test="$lccn = 'sh85011776'">bao</xsl:when>
                    <xsl:when test="$lccn = 'sh85011777'">bsn</xsl:when>
                    <xsl:when test="$lccn = 'sh85045159'">gez</xsl:when>
                    <xsl:when test="$lccn = 'sh85013150'">ben</xsl:when>
                    <xsl:when test="$lccn = 'sh85022418'">lae</xsl:when>
                    <xsl:when test="$lccn = 'sh85086366'">mfq</xsl:when>
                    <xsl:when test="$lccn = 'sh85022415'">cji</xsl:when>
                    <xsl:when test="$lccn = 'sh85096361'">oym</xsl:when>
                    <xsl:when test="$lccn = 'sh85132918'">tbl</xsl:when>
                    <xsl:when test="$lccn = 'sh85096363'">way</xsl:when>
                    <xsl:when test="$lccn = 'sh85071331'">kyl</xsl:when>
                    <xsl:when test="$lccn = 'sh85087184'">mop</xsl:when>
                    <xsl:when test="$lccn = 'sh2008001568'">lhu</xsl:when>
                    <xsl:when test="$lccn = 'sh85002533'">aho</xsl:when>
                    <xsl:when test="$lccn = 'sh2006002320'">mey</xsl:when>
                    <xsl:when test="$lccn = 'sh85002537'">aht</xsl:when>
                    <xsl:when test="$lccn = 'sh85041489'">elx</xsl:when>
                    <xsl:when test="$lccn = 'sh90005153'">biy</xsl:when>
                    <xsl:when test="$lccn = 'sh92005365'">nmh</xsl:when>
                    <xsl:when test="$lccn = 'sh88000627'">mcp</xsl:when>
                    <xsl:when test="$lccn = 'sh88000626'">xuo</xsl:when>
                    <xsl:when test="$lccn = 'sh88000625'">iqu</xsl:when>
                    <xsl:when test="$lccn = 'sh88000624'">pov</xsl:when>
                    <xsl:when test="$lccn = 'sh88000623'">bno</xsl:when>
                    <xsl:when test="$lccn = 'sh88000622'">aoi</xsl:when>
                    <xsl:when test="$lccn = 'sh98000082'">akl</xsl:when>
                    <xsl:when test="$lccn = 'sh85117480'">srm</xsl:when>
                    <xsl:when test="$lccn = 'sh94000219'">irn</xsl:when>
                    <xsl:when test="$lccn = 'sh85141298'">xur</xsl:when>
                    <xsl:when test="$lccn = 'sh89004699'">apw</xsl:when>
                    <xsl:when test="$lccn = 'sh88000628'">lem</xsl:when>
                    <xsl:when test="$lccn = 'sh85071428'">kgq</xsl:when>
                    <xsl:when test="$lccn = 'sh85049251'">nlg</xsl:when>
                    <xsl:when test="$lccn = 'sh85055858'">gjn</xsl:when>
                    <xsl:when test="$lccn = 'sh90004794'">kqe</xsl:when>
                    <xsl:when test="$lccn = 'sh85135106'">tdh</xsl:when>
                    <xsl:when test="$lccn = 'sh85087501'">mtt</xsl:when>
                    <xsl:when test="$lccn = 'sh85135458'">tem</xsl:when>
                    <xsl:when test="$lccn = 'sh97000387'">mvn</xsl:when>
                    <xsl:when test="$lccn = 'sh85012375'">btc</xsl:when>
                    <xsl:when test="$lccn = 'sh95004091'">dic</xsl:when>
                    <xsl:when test="$lccn = 'sh85038665'">dji</xsl:when>
                    <xsl:when test="$lccn = 'sh85083464'">tsj</xsl:when>
                    <xsl:when test="$lccn = 'sh85038667'">dbl</xsl:when>
                    <xsl:when test="$lccn = 'sh85038666'">jig</xsl:when>
                    <xsl:when test="$lccn = 'sh85038661'">ddj</xsl:when>
                    <xsl:when test="$lccn = 'sh85038660'">dif</xsl:when>
                    <xsl:when test="$lccn = 'sh85072214'">xuu</xsl:when>
                    <xsl:when test="$lccn = 'sh85135672'">tiw</xsl:when>
                    <xsl:when test="$lccn = 'sh85121473'">scl</xsl:when>
                    <xsl:when test="$lccn = 'sh85055968'">gor</xsl:when>
                    <xsl:when test="$lccn = 'sh85038668'">djk</xsl:when>
                    <xsl:when test="$lccn = 'sh85109404'">hae</xsl:when>
                    <xsl:when test="$lccn = 'sh85149432'">ycn</xsl:when>
                    <xsl:when test="$lccn = 'sh2002006282'">aul</xsl:when>
                    <xsl:when test="$lccn = 'sh85149017'">yaq</xsl:when>
                    <xsl:when test="$lccn = 'sh85060372'">her</xsl:when>
                    <xsl:when test="$lccn = 'sh85040355'">dyu</xsl:when>
                    <xsl:when test="$lccn = 'sh85105670'">pot</xsl:when>
                    <xsl:when test="$lccn = 'sh85057987'">guz</xsl:when>
                    <xsl:when test="$lccn = 'sh85003134'">alj</xsl:when>
                    <xsl:when test="$lccn = 'sh85038063'">mwr</xsl:when>
                    <xsl:when test="$lccn = 'sh85006413'">are</xsl:when>
                    <xsl:when test="$lccn = 'sh98000024'">mpj</xsl:when>
                    <xsl:when test="$lccn = 'sh85088505'">mnj</xsl:when>
                    <xsl:when test="$lccn = 'sh85088509'">umu</xsl:when>
                    <xsl:when test="$lccn = 'sh85042731'">ebu</xsl:when>
                    <xsl:when test="$lccn = 'sh85072501'">kln</xsl:when>
                    <xsl:when test="$lccn = 'sh93006302'">bcu</xsl:when>
                    <xsl:when test="$lccn = 'sh93006303'">dww</xsl:when>
                    <xsl:when test="$lccn = 'sh92000912'">blr</xsl:when>
                    <xsl:when test="$lccn = 'sh85146480'">mww</xsl:when>
                    <xsl:when test="$lccn = 'sh93006878'">wbv</xsl:when>
                    <xsl:when test="$lccn = 'sh93006308'">pss</xsl:when>
                    <xsl:when test="$lccn = 'sh93006309'">gdn</xsl:when>
                    <xsl:when test="$lccn = 'sh85066365'">inh</xsl:when>
                    <xsl:when test="$lccn = 'sh85072322'">klb</xsl:when>
                    <xsl:when test="$lccn = 'sh85066360'">izh</xsl:when>
                    <xsl:when test="$lccn = 'sh85075410'">lzz</xsl:when>
                    <xsl:when test="$lccn = 'sh85134422'">tcz</xsl:when>
                    <xsl:when test="$lccn = 'sh96003287'">gwi</xsl:when>
                    <xsl:when test="$lccn = 'sh2002004936'">fuu</xsl:when>
                    <xsl:when test="$lccn = 'sh85055037'">myx</xsl:when>
                    <xsl:when test="$lccn = 'sh90002786'">esu</xsl:when>
                    <xsl:when test="$lccn = 'sh85055030'">nyf</xsl:when>
                    <xsl:when test="$lccn = 'sh85022232'">cbk</xsl:when>
                    <xsl:when test="$lccn = 'sh98003283'">gmo</xsl:when>
                    <xsl:when test="$lccn = 'sh85078094'">lgg</xsl:when>
                    <xsl:when test="$lccn = 'sh85014537'">cab</xsl:when>
                    <xsl:when test="$lccn = 'sh2002012128'">ikt</xsl:when>
                    <xsl:when test="$lccn = 'sh2007003533'">njm</xsl:when>
                    <xsl:when test="$lccn = 'sh85085108'">adi</xsl:when>
                    <xsl:when test="$lccn = 'sh2005002122'">yko</xsl:when>
                    <xsl:when test="$lccn = 'sh85123761'">sno</xsl:when>
                    <xsl:when test="$lccn = 'sh95002634'">gyd</xsl:when>
                    <xsl:when test="$lccn = 'sh2001007065'">xum</xsl:when>
                    <xsl:when test="$lccn = 'sh2002002069'">nyv</xsl:when>
                    <xsl:when test="$lccn = 'sh85094669'">oma</xsl:when>
                    <xsl:when test="$lccn = 'sh85086634'">arn</xsl:when>
                    <xsl:when test="$lccn = 'sh2008001038'">gid</xsl:when>
                    <xsl:when test="$lccn = 'sh85017903'">bul</xsl:when>
                    <xsl:when test="$lccn = 'sh94002692'">kux</xsl:when>
                    <xsl:when test="$lccn = 'sh85063876'">iai</xsl:when>
                    <xsl:when test="$lccn = 'sh85005892'">xap</xsl:when>
                    <xsl:when test="$lccn = 'sh89003728'">par</xsl:when>
                    <xsl:when test="$lccn = 'sh94006579'">ddg</xsl:when>
                    <xsl:when test="$lccn = 'sh91004188'">nst</xsl:when>
                    <xsl:when test="$lccn = 'sh85033895'">mus</xsl:when>
                    <xsl:when test="$lccn = 'sh85110222'">acr</xsl:when>
                    <xsl:when test="$lccn = 'sh85059330'">yuf</xsl:when>
                    <xsl:when test="$lccn = 'sh91005764'">cjh</xsl:when>
                    <xsl:when test="$lccn = 'sh85022435'">cdh</xsl:when>
                    <xsl:when test="$lccn = 'sh2003002048'">tce</xsl:when>
                    <xsl:when test="$lccn = 'sh85005812'">anu</xsl:when>
                    <xsl:when test="$lccn = 'sh85037117'">des</xsl:when>
                    <xsl:when test="$lccn = 'sh85141343'">urd</xsl:when>
                    <xsl:when test="$lccn = 'sh85005816'">cko</xsl:when>
                    <xsl:when test="$lccn = 'sh85032419'">cop</xsl:when>
                    <xsl:when test="$lccn = 'sh90004946'">bjj</xsl:when>
                    <xsl:when test="$lccn = 'sh99003683'">sqn</xsl:when>
                    <xsl:when test="$lccn = 'sh93006297'">aak</xsl:when>
                    <xsl:when test="$lccn = 'sh85147195'">wiy</xsl:when>
                    <xsl:when test="$lccn = 'sh85121439'">jbn</xsl:when>
                    <xsl:when test="$lccn = 'sh87003621'">mui</xsl:when>
                    <xsl:when test="$lccn = 'sh86007872'">smw</xsl:when>
                    <xsl:when test="$lccn = 'sh88005094'">bnc</xsl:when>
                    <xsl:when test="$lccn = 'sh85124475'">sqt</xsl:when>
                    <xsl:when test="$lccn = 'sh85119488'">sed</xsl:when>
                    <xsl:when test="$lccn = 'sh96012088'">yea</xsl:when>
                    <xsl:when test="$lccn = 'sh96007749'">wgg</xsl:when>
                    <xsl:when test="$lccn = 'sh85088299'">ckb</xsl:when>
                    <xsl:when test="$lccn = 'sh85100567'">phl</xsl:when>
                    <xsl:when test="$lccn = 'sh85057611'">gyr</xsl:when>
                    <xsl:when test="$lccn = 'sh85034824'">cup</xsl:when>
                    <xsl:when test="$lccn = 'sh85088293'">mwc</xsl:when>
                    <xsl:when test="$lccn = 'sh85073496'">kos</xsl:when>
                    <xsl:when test="$lccn = 'sh85035532'">dlm</xsl:when>
                    <xsl:when test="$lccn = 'sh85004457'">ami</xsl:when>
                    <xsl:when test="$lccn = 'sh85130400'">tsg</xsl:when>
                    <xsl:when test="$lccn = 'sh85037757'">ddo</xsl:when>
                    <xsl:when test="$lccn = 'sh00007291'">mxu</xsl:when>
                    <xsl:when test="$lccn = 'sh85019182'">cni</xsl:when>
                    <xsl:when test="$lccn = 'sh91000530'">kml</xsl:when>
                    <xsl:when test="$lccn = 'sh91000533'">ifa</xsl:when>
                    <xsl:when test="$lccn = 'sh93007666'">yui</xsl:when>
                    <xsl:when test="$lccn = 'sh85094115'">odu</xsl:when>
                    <xsl:when test="$lccn = 'sh85076045'">lep</xsl:when>
                    <xsl:when test="$lccn = 'sh85061286'">hix</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006561'">jbo</xsl:when>
                    <xsl:when test="$lccn = 'sh99000888'">waq</xsl:when>
                    <xsl:when test="$lccn = 'sh87003128'">lld</xsl:when>
                    <xsl:when test="$lccn = 'sh85073272'">kpl</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006184'">ksv</xsl:when>
                    <xsl:when test="$lccn = 'sh85015193'">bbo</xsl:when>
                    <xsl:when test="$lccn = 'sh85010945'">ksf</xsl:when>
                    <xsl:when test="$lccn = 'sh93009145'">mai</xsl:when>
                    <xsl:when test="$lccn = 'sh85010497'">ava</xsl:when>
                    <xsl:when test="$lccn = 'sh85141564'">usp</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006189'">aha</xsl:when>
                    <xsl:when test="$lccn = 'sh2001005233'">xed</xsl:when>
                    <xsl:when test="$lccn = 'sh85041429'">etu</xsl:when>
                    <xsl:when test="$lccn = 'sh91005013'">flr</xsl:when>
                    <xsl:when test="$lccn = 'sh91005015'">flr</xsl:when>
                    <xsl:when test="$lccn = 'sh85041420'">eip</xsl:when>
                    <xsl:when test="$lccn = 'sh85083868'">xmr</xsl:when>
                    <xsl:when test="$lccn = 'sh85011543'">bjn</xsl:when>
                    <xsl:when test="$lccn = 'sh2001009653'">duo</xsl:when>
                    <xsl:when test="$lccn = 'sh85073543'">kwn</xsl:when>
                    <xsl:when test="$lccn = 'sh85011010'">bdq</xsl:when>
                    <xsl:when test="$lccn = 'sh85078668'">dsb</xsl:when>
                    <xsl:when test="$lccn = 'sh89004879'">gni</xsl:when>
                    <xsl:when test="$lccn = 'sh85082477'">liz</xsl:when>
                    <xsl:when test="$lccn = 'sh2003010440'">nbj</xsl:when>
                    <xsl:when test="$lccn = 'sh85082476'">mdt</xsl:when>
                    <xsl:when test="$lccn = 'sh85146520'">twh</xsl:when>
                    <xsl:when test="$lccn = 'sh85141916'">van</xsl:when>
                    <xsl:when test="$lccn = 'sh85095408'">mvf</xsl:when>
                    <xsl:when test="$lccn = 'sh96010309'">nnv</xsl:when>
                    <xsl:when test="$lccn = 'sh85141478'">urb</xsl:when>
                    <xsl:when test="$lccn = 'sh85081915'">wam</xsl:when>
                    <xsl:when test="$lccn = 'sh99001048'">pym</xsl:when>
                    <xsl:when test="$lccn = 'sh99013999'">xhe</xsl:when>
                    <xsl:when test="$lccn = 'sh00005847'">slp</xsl:when>
                    <xsl:when test="$lccn = 'sh86004510'">lme</xsl:when>
                    <xsl:when test="$lccn = 'sh92005149'">nzm</xsl:when>
                    <xsl:when test="$lccn = 'sh87001425'">liw</xsl:when>
                    <xsl:when test="$lccn = 'sh00007228'">yly</xsl:when>
                    <xsl:when test="$lccn = 'sh2004003295'">sme</xsl:when>
                    <xsl:when test="$lccn = 'sh85149156'">yii</xsl:when>
                    <xsl:when test="$lccn = 'sh85080514'">mdj</xsl:when>
                    <xsl:when test="$lccn = 'sh85052274'">ful</xsl:when>
                    <xsl:when test="$lccn = 'sh85080517'">mqy</xsl:when>
                    <xsl:when test="$lccn = 'sh85080512'">mrv</xsl:when>
                    <xsl:when test="$lccn = 'sh95003830'">wrp</xsl:when>
                    <xsl:when test="$lccn = 'sh85122456'">bla</xsl:when>
                    <xsl:when test="$lccn = 'sh2002004707'">nih</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003120'">bqz</xsl:when>
                    <xsl:when test="$lccn = 'sh96002574'">gal</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003127'">afu</xsl:when>
                    <xsl:when test="$lccn = 'sh85025944'">swh</xsl:when>
                    <xsl:when test="$lccn = 'sh96005078'">laq</xsl:when>
                    <xsl:when test="$lccn = 'sh85074170'">lam</xsl:when>
                    <xsl:when test="$lccn = 'sh85023061'">cdm</xsl:when>
                    <xsl:when test="$lccn = 'sh85045527'">opt</xsl:when>
                    <xsl:when test="$lccn = 'sh90005015'">ksx</xsl:when>
                    <xsl:when test="$lccn = 'sh85131834'">tna</xsl:when>
                    <xsl:when test="$lccn = 'sh85007150'">ari</xsl:when>
                    <xsl:when test="$lccn = 'sh85117607'">sas</xsl:when>
                    <xsl:when test="$lccn = 'sh85097979'">pcj</xsl:when>
                    <xsl:when test="$lccn = 'sh85024493'">ctm</xsl:when>
                    <xsl:when test="$lccn = 'sh85011166'">les</xsl:when>
                    <xsl:when test="$lccn = 'sh85054990'">gin</xsl:when>
                    <xsl:when test="$lccn = 'sh85136007'">tqw</xsl:when>
                    <xsl:when test="$lccn = 'sh85149028'">yae</xsl:when>
                    <xsl:when test="$lccn = 'sh96000155'">bee</xsl:when>
                    <xsl:when test="$lccn = 'sh85011766'">bhr</xsl:when>
                    <xsl:when test="$lccn = 'sh85071322'">ijn</xsl:when>
                    <xsl:when test="$lccn = 'sh85132903'">nut</xsl:when>
                    <xsl:when test="$lccn = 'sh85071320'">keo</xsl:when>
                    <xsl:when test="$lccn = 'sh85071327'">tbk</xsl:when>
                    <xsl:when test="$lccn = 'sh85132906'">tay</xsl:when>
                    <xsl:when test="$lccn = 'sh86004434'">pia</xsl:when>
                    <xsl:when test="$lccn = 'sh85058983'">hro</xsl:when>
                    <xsl:when test="$lccn = 'sh85016753'">bre</xsl:when>
                    <xsl:when test="$lccn = 'sh85086358'">mzw</xsl:when>
                    <xsl:when test="$lccn = 'sh85024301'">zho</xsl:when>
                    <xsl:when test="$lccn = 'sh85005850'">njo</xsl:when>
                    <xsl:when test="$lccn = 'sh85148996'">dak</xsl:when>
                    <xsl:when test="$lccn = 'sh85148990'">bzf</xsl:when>
                    <xsl:when test="$lccn = 'sh98004642'">pel</xsl:when>
                    <xsl:when test="$lccn = 'sh85131907'">tgw</xsl:when>
                    <xsl:when test="$lccn = 'sh98003615'">csk</xsl:when>
                    <xsl:when test="$lccn = 'sh85086824'">mon</xsl:when>
                    <xsl:when test="$lccn = 'sh98003618'">gng</xsl:when>
                    <xsl:when test="$lccn = 'sh85012311'">bya</xsl:when>
                    <xsl:when test="$lccn = 'sh85131908'">tbw</xsl:when>
                    <xsl:when test="$lccn = 'sh2008005194'">tel</xsl:when>
                    <xsl:when test="$lccn = 'sh97008265'">myr</xsl:when>
                    <xsl:when test="$lccn = 'sh85038277'">diu</xsl:when>
                    <xsl:when test="$lccn = 'sh85071439'">ogo</xsl:when>
                    <xsl:when test="$lccn = 'sh85055826'">bbp</xsl:when>
                    <xsl:when test="$lccn = 'sh85062741'">auc</xsl:when>
                    <xsl:when test="$lccn = 'sh85071435'">kmt</xsl:when>
                    <xsl:when test="$lccn = 'sh85055822'">gvf</xsl:when>
                    <xsl:when test="$lccn = 'sh85086534'">nst</xsl:when>
                    <xsl:when test="$lccn = 'sh97005093'">hke</xsl:when>
                    <xsl:when test="$lccn = 'sh88000367'">bid</xsl:when>
                    <xsl:when test="$lccn = 'sh85055482'">guc</xsl:when>
                    <xsl:when test="$lccn = 'sh85072208'">kjg</xsl:when>
                    <xsl:when test="$lccn = 'sh85134248'">tew</xsl:when>
                    <xsl:when test="$lccn = 'sh85093181'">nus</xsl:when>
                    <xsl:when test="$lccn = 'sh88001614'">ure</xsl:when>
                    <xsl:when test="$lccn = 'sh85089525'">nll</xsl:when>
                    <xsl:when test="$lccn = 'sh85144966'">wmt</xsl:when>
                    <xsl:when test="$lccn = 'sh85139302'">uga</xsl:when>
                    <xsl:when test="$lccn = 'sh85080633'">mns</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003431'">ncf</xsl:when>
                    <xsl:when test="$lccn = 'sh85135306'">tif</xsl:when>
                    <xsl:when test="$lccn = 'sh85128243'">srp</xsl:when>
                    <xsl:when test="$lccn = 'sh85051121'">sac</xsl:when>
                    <xsl:when test="$lccn = 'sh89004656'">saq</xsl:when>
                    <xsl:when test="$lccn = 'sh85057970'">gux</xsl:when>
                    <xsl:when test="$lccn = 'sh89003263'">eme</xsl:when>
                    <xsl:when test="$lccn = 'sh2002006078'">dse</xsl:when>
                    <xsl:when test="$lccn = 'sh85083721'">mwv</xsl:when>
                    <xsl:when test="$lccn = 'sh85039010'">dop</xsl:when>
                    <xsl:when test="$lccn = 'sh85023087'">chr</xsl:when>
                    <xsl:when test="$lccn = 'sh86004586'">nmc</xsl:when>
                    <xsl:when test="$lccn = 'sh85013921'">bym</xsl:when>
                    <xsl:when test="$lccn = 'sh85094715'">ona</xsl:when>
                    <xsl:when test="$lccn = 'sh85058740'">hag</xsl:when>
                    <xsl:when test="$lccn = 'sh85013141'">bng</xsl:when>
                    <xsl:when test="$lccn = 'sh85072516'">kir</xsl:when>
                    <xsl:when test="$lccn = 'sh85135308'">tgc</xsl:when>
                    <xsl:when test="$lccn = 'sh85138364'">pmt</xsl:when>
                    <xsl:when test="$lccn = 'sh93006310'">hre</xsl:when>
                    <xsl:when test="$lccn = 'sh93006312'">iou</xsl:when>
                    <xsl:when test="$lccn = 'sh93006861'">wrr</xsl:when>
                    <xsl:when test="$lccn = 'sh98001619'">baw</xsl:when>
                    <xsl:when test="$lccn = 'sh93006319'">mej</xsl:when>
                    <xsl:when test="$lccn = 'sh96003703'">bkm</xsl:when>
                    <xsl:when test="$lccn = 'sh85093279'">nun</xsl:when>
                    <xsl:when test="$lccn = 'sh2005003242'">umo</xsl:when>
                    <xsl:when test="$lccn = 'sh85006288'">arl</xsl:when>
                    <xsl:when test="$lccn = 'sh87000375'">dun</xsl:when>
                    <xsl:when test="$lccn = 'sh85002257'">knn</xsl:when>
                    <xsl:when test="$lccn = 'sh85135578'">tiy</xsl:when>
                    <xsl:when test="$lccn = 'sh86002298'">abu</xsl:when>
                    <xsl:when test="$lccn = 'sh85071926'">kyq</xsl:when>
                    <xsl:when test="$lccn = 'sh85116474'">kki</xsl:when>
                    <xsl:when test="$lccn = 'sh2007020061'">gas</xsl:when>
                    <xsl:when test="$lccn = 'sh85088407'">mzm</xsl:when>
                    <xsl:when test="$lccn = 'sh2006007963'">abr</xsl:when>
                    <xsl:when test="$lccn = 'sh87007666'">bph</xsl:when>
                    <xsl:when test="$lccn = 'sh85146586'">wic</xsl:when>
                    <xsl:when test="$lccn = 'sh98002387'">liw</xsl:when>
                    <xsl:when test="$lccn = 'sh85147243'">wlo</xsl:when>
                    <xsl:when test="$lccn = 'sh85072029'">ker</xsl:when>
                    <xsl:when test="$lccn = 'sh85013456'">byf</xsl:when>
                    <xsl:when test="$lccn = 'sh85119879'">sos</xsl:when>
                    <xsl:when test="$lccn = 'sh85123060'">siz</xsl:when>
                    <xsl:when test="$lccn = 'sh85059109'">hss</xsl:when>
                    <xsl:when test="$lccn = 'sh85071242'">kac</xsl:when>
                    <xsl:when test="$lccn = 'sh85017979'">bum</xsl:when>
                    <xsl:when test="$lccn = 'sh87000287'">adi</xsl:when>
                    <xsl:when test="$lccn = 'sh87007063'">kuu</xsl:when>
                    <xsl:when test="$lccn = 'sh85080443'">man</xsl:when>
                    <xsl:when test="$lccn = 'sh85104898'">poi</xsl:when>
                    <xsl:when test="$lccn = 'sh85130962'">swh</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009975'">ses</xsl:when>
                    <xsl:when test="$lccn = 'sh85093498'">nya</xsl:when>
                    <xsl:when test="$lccn = 'sh93002784'">ems</xsl:when>
                    <xsl:when test="$lccn = 'sh85093491'">nyk</xsl:when>
                    <xsl:when test="$lccn = 'sh85093490'">nym</xsl:when>
                    <xsl:when test="$lccn = 'sh93002788'">kps</xsl:when>
                    <xsl:when test="$lccn = 'sh93002789'">bld</xsl:when>
                    <xsl:when test="$lccn = 'sh85093495'">nna</xsl:when>
                    <xsl:when test="$lccn = 'sh96006530'">mgm</xsl:when>
                    <xsl:when test="$lccn = 'sh85130567'">suz</xsl:when>
                    <xsl:when test="$lccn = 'sh85014075'">bhp</xsl:when>
                    <xsl:when test="$lccn = 'sh2007008170'">ndi</xsl:when>
                    <xsl:when test="$lccn = 'sh85014073'">bll</xsl:when>
                    <xsl:when test="$lccn = 'sh85065767'">ind</xsl:when>
                    <xsl:when test="$lccn = 'sh85044918'">esq</xsl:when>
                    <xsl:when test="$lccn = 'sh85062731'">hub</xsl:when>
                    <xsl:when test="$lccn = 'sh85053651'">gdd</xsl:when>
                    <xsl:when test="$lccn = 'sh85062733'">qvw</xsl:when>
                    <xsl:when test="$lccn = 'sh85078404'">ame</xsl:when>
                    <xsl:when test="$lccn = 'sh86003727'">ulc</xsl:when>
                    <xsl:when test="$lccn = 'sh96007753'">ard</xsl:when>
                    <xsl:when test="$lccn = 'sh2008005652'">mqb</xsl:when>
                    <xsl:when test="$lccn = 'sh85147211'">apz</xsl:when>
                    <xsl:when test="$lccn = 'sh85147210'">woi</xsl:when>
                    <xsl:when test="$lccn = 'sh85026542'">clm</xsl:when>
                    <xsl:when test="$lccn = 'sh85147216'">woe</xsl:when>
                    <xsl:when test="$lccn = 'sh85073463'">kur</xsl:when>
                    <xsl:when test="$lccn = 'sh85033287'">ore</xsl:when>
                    <xsl:when test="$lccn = 'sh85008742'">asm</xsl:when>
                    <xsl:when test="$lccn = 'sh2002011317'">mvo</xsl:when>
                    <xsl:when test="$lccn = 'sh85014103'">bin</xsl:when>
                    <xsl:when test="$lccn = 'sh85130413'">sux</xsl:when>
                    <xsl:when test="$lccn = 'sh85001491'">aar</xsl:when>
                    <xsl:when test="$lccn = 'sh2003001733'">tae</xsl:when>
                    <xsl:when test="$lccn = 'sh85005930'">apt</xsl:when>
                    <xsl:when test="$lccn = 'sh85142557'">wlv</xsl:when>
                    <xsl:when test="$lccn = 'sh85121089'">ksb</xsl:when>
                    <xsl:when test="$lccn = 'sh85141777'">vap</xsl:when>
                    <xsl:when test="$lccn = 'sh85141770'">vai</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003596'">gvr</xsl:when>
                    <xsl:when test="$lccn = 'sh96002148'">nhb</xsl:when>
                    <xsl:when test="$lccn = 'sh86004211'">neg</xsl:when>
                    <xsl:when test="$lccn = 'sh00005327'">amg</xsl:when>
                    <xsl:when test="$lccn = 'sh92005963'">suv</xsl:when>
                    <xsl:when test="$lccn = 'sh87000976'">sda</xsl:when>
                    <xsl:when test="$lccn = 'sh85090731'">nee</xsl:when>
                    <xsl:when test="$lccn = 'sh85010486'">kze</xsl:when>
                    <xsl:when test="$lccn = 'sh85057578'">guh</xsl:when>
                    <xsl:when test="$lccn = 'sh85090732'">yrk</xsl:when>
                    <xsl:when test="$lccn = 'sh85139389'">ukr</xsl:when>
                    <xsl:when test="$lccn = 'sh85004995'">anc</xsl:when>
                    <xsl:when test="$lccn = 'sh85004990'">njm</xsl:when>
                    <xsl:when test="$lccn = 'sh85062818'">hch</xsl:when>
                    <xsl:when test="$lccn = 'sh85035985'">dzd</xsl:when>
                    <xsl:when test="$lccn = 'sh2006005955'">tgx</xsl:when>
                    <xsl:when test="$lccn = 'sh85133261'">teg</xsl:when>
                    <xsl:when test="$lccn = 'sh85143345'">vif</xsl:when>
                    <xsl:when test="$lccn = 'sh2007010718'">agq</xsl:when>
                    <xsl:when test="$lccn = 'sh90002122'">xte</xsl:when>
                    <xsl:when test="$lccn = 'sh85123074'">csy</xsl:when>
                    <xsl:when test="$lccn = 'sh99005776'">loj</xsl:when>
                    <xsl:when test="$lccn = 'sh85149496'">yuk</xsl:when>
                    <xsl:when test="$lccn = 'sh85149490'">sll</xsl:when>
                    <xsl:when test="$lccn = 'sh93004782'">mqn</xsl:when>
                    <xsl:when test="$lccn = 'sh85149492'">ess</xsl:when>
                    <xsl:when test="$lccn = 'sh85081584'">mah</xsl:when>
                    <xsl:when test="$lccn = 'sh85052718'">gag</xsl:when>
                    <xsl:when test="$lccn = 'sh85099239'">arn</xsl:when>
                    <xsl:when test="$lccn = 'sh85142471'">ved</xsl:when>
                    <xsl:when test="$lccn = 'sh85149431'">yuc</xsl:when>
                    <xsl:when test="$lccn = 'sh87005872'">bhh</xsl:when>
                    <xsl:when test="$lccn = 'sh85073514'">kut</xsl:when>
                    <xsl:when test="$lccn = 'sh85020274'">car</xsl:when>
                    <xsl:when test="$lccn = 'sh85089581'">naq</xsl:when>
                    <xsl:when test="$lccn = 'sh85063162'">hup</xsl:when>
                    <xsl:when test="$lccn = 'sh00009401'">wrs</xsl:when>
                    <xsl:when test="$lccn = 'sh85133196'">tuq</xsl:when>
                    <xsl:when test="$lccn = 'sh2004144624'">jaa</xsl:when>
                    <xsl:when test="$lccn = 'sh85057151'">grc</xsl:when>
                    <xsl:when test="$lccn = 'sh96003716'">pos</xsl:when>
                    <xsl:when test="$lccn = 'sh85064179'">idu</xsl:when>
                    <xsl:when test="$lccn = 'sh85077471'">lis</xsl:when>
                    <xsl:when test="$lccn = 'sh85149145'">yid</xsl:when>
                    <xsl:when test="$lccn = 'sh2008007719'">ktb</xsl:when>
                    <xsl:when test="$lccn = 'sh85093487'">nwb</xsl:when>
                    <xsl:when test="$lccn = 'sh85096611'">pri</xsl:when>
                    <xsl:when test="$lccn = 'sh92006093'">mwq</xsl:when>
                    <xsl:when test="$lccn = 'sh85015457'">boh</xsl:when>
                    <xsl:when test="$lccn = 'sh2004009507'">wkw</xsl:when>
                    <xsl:when test="$lccn = 'sh85101048'">nph</xsl:when>
                    <xsl:when test="$lccn = 'sh92004815'">mhx</xsl:when>
                    <xsl:when test="$lccn = 'sh85071689'">iru</xsl:when>
                    <xsl:when test="$lccn = 'sh85020058'">cbc</xsl:when>
                    <xsl:when test="$lccn = 'sh85093190'">nkr</xsl:when>
                    <xsl:when test="$lccn = 'sh85145328'">wac</xsl:when>
                    <xsl:when test="$lccn = 'sh97008458'">pim</xsl:when>
                    <xsl:when test="$lccn = 'sh93004963'">kth</xsl:when>
                    <xsl:when test="$lccn = 'sh85097199'">plu</xsl:when>
                    <xsl:when test="$lccn = 'sh85133999'">ter</xsl:when>
                    <xsl:when test="$lccn = 'sh85088742'">mug</xsl:when>
                    <xsl:when test="$lccn = 'sh85089697'">nnt</xsl:when>
                    <xsl:when test="$lccn = 'sh85035271'">ces</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003113'">mlg</xsl:when>
                    <xsl:when test="$lccn = 'sh85132023'">tgk</xsl:when>
                    <xsl:when test="$lccn = 'sh85058406'">hlb</xsl:when>
                    <xsl:when test="$lccn = 'sh85069292'">dhd</xsl:when>
                    <xsl:when test="$lccn = 'sh95007186'">nka</xsl:when>
                    <xsl:when test="$lccn = 'sh85011978'">sgh</xsl:when>
                    <xsl:when test="$lccn = 'sh85123000'">sso</xsl:when>
                    <xsl:when test="$lccn = 'sh88006359'">kpm</xsl:when>
                    <xsl:when test="$lccn = 'sh88006358'">cma</xsl:when>
                    <xsl:when test="$lccn = 'sh99013591'">guw</xsl:when>
                    <xsl:when test="$lccn = 'sh85071353'">ktg</xsl:when>
                    <xsl:when test="$lccn = 'sh85071351'">fla</xsl:when>
                    <xsl:when test="$lccn = 'sh85109790'">que</xsl:when>
                    <xsl:when test="$lccn = 'sh85032249'">csz</xsl:when>
                    <xsl:when test="$lccn = 'sh85011998'">byr</xsl:when>
                    <xsl:when test="$lccn = 'sh90004003'">tea</xsl:when>
                    <xsl:when test="$lccn = 'sh85122711'">bts</xsl:when>
                    <xsl:when test="$lccn = 'sh91005993'">sie</xsl:when>
                    <xsl:when test="$lccn = 'sh85122717'">smr</xsl:when>
                    <xsl:when test="$lccn = 'sh85131914'">tag</xsl:when>
                    <xsl:when test="$lccn = 'sh85070889'">jrb</xsl:when>
                    <xsl:when test="$lccn = 'sh93001550'">mpj</xsl:when>
                    <xsl:when test="$lccn = 'sh85024415'">cap</xsl:when>
                    <xsl:when test="$lccn = 'sh85079219'">grg</xsl:when>
                    <xsl:when test="$lccn = 'sh85005079'">xno</xsl:when>
                    <xsl:when test="$lccn = 'sh85135464'">bkx</xsl:when>
                    <xsl:when test="$lccn = 'sh85074149'">mrh</xsl:when>
                    <xsl:when test="$lccn = 'sh95001594'">cir</xsl:when>
                    <xsl:when test="$lccn = 'sh85012314'">ivv</xsl:when>
                    <xsl:when test="$lccn = 'sh85096544'">dip</xsl:when>
                    <xsl:when test="$lccn = 'sh85015502'">bou</xsl:when>
                    <xsl:when test="$lccn = 'sh86002353'">kgo</xsl:when>
                    <xsl:when test="$lccn = 'sh85124716'">evn</xsl:when>
                    <xsl:when test="$lccn = 'sh85022321'">chg</xsl:when>
                    <xsl:when test="$lccn = 'sh85117262'">sng</xsl:when>
                    <xsl:when test="$lccn = 'sh85117265'">sag</xsl:when>
                    <xsl:when test="$lccn = 'sh85072239'">kic</xsl:when>
                    <xsl:when test="$lccn = 'sh85117267'">nsa</xsl:when>
                    <xsl:when test="$lccn = 'sh85082487'">mhw</xsl:when>
                    <xsl:when test="$lccn = 'sh2004001662'">sjn</xsl:when>
                    <xsl:when test="$lccn = 'sh85044665'">erg</xsl:when>
                    <xsl:when test="$lccn = 'sh85082481'">mbo</xsl:when>
                    <xsl:when test="$lccn = 'sh85040572'">mky</xsl:when>
                    <xsl:when test="$lccn = 'sh85057963'">kat</xsl:when>
                    <xsl:when test="$lccn = 'sh85135787'">kim</xsl:when>
                    <xsl:when test="$lccn = 'sh91003734'">sey</xsl:when>
                    <xsl:when test="$lccn = 'sh85079103'">xld</xsl:when>
                    <xsl:when test="$lccn = 'sh85144487'">wbm</xsl:when>
                    <xsl:when test="$lccn = 'sh85072526'">kij</xsl:when>
                    <xsl:when test="$lccn = 'sh85072835'">ijc</xsl:when>
                    <xsl:when test="$lccn = 'sh2008001545'">kru</xsl:when>
                    <xsl:when test="$lccn = 'sh2008001544'">bgw</xsl:when>
                    <xsl:when test="$lccn = 'sh85138314'">bea</xsl:when>
                    <xsl:when test="$lccn = 'sh85109221'">pad</xsl:when>
                    <xsl:when test="$lccn = 'sh85135272'">ctd</xsl:when>
                    <xsl:when test="$lccn = 'sh90004680'">swu</xsl:when>
                    <xsl:when test="$lccn = 'sh85116507'">ssy</xsl:when>
                    <xsl:when test="$lccn = 'sh85083537'">men</xsl:when>
                    <xsl:when test="$lccn = 'sh85028786'">com</xsl:when>
                    <xsl:when test="$lccn = 'sh85116806'">sbe</xsl:when>
                    <xsl:when test="$lccn = 'sh96003718'">plo</xsl:when>
                    <xsl:when test="$lccn = 'sh85052862'">adl</xsl:when>
                    <xsl:when test="$lccn = 'sh89006430'">yrk</xsl:when>
                    <xsl:when test="$lccn = 'sh85072460'">swc</xsl:when>
                    <xsl:when test="$lccn = 'sh87000561'">sda</xsl:when>
                    <xsl:when test="$lccn = 'sh89006436'">cbi</xsl:when>
                    <xsl:when test="$lccn = 'sh2003000170'">mwi</xsl:when>
                    <xsl:when test="$lccn = 'sh85082484'">mdw</xsl:when>
                    <xsl:when test="$lccn = 'sh2004010350'">mgz</xsl:when>
                    <xsl:when test="$lccn = 'sh2004010351'">mhd</xsl:when>
                    <xsl:when test="$lccn = 'sh85064198'">igb</xsl:when>
                    <xsl:when test="$lccn = 'sh85089831'">mof</xsl:when>
                    <xsl:when test="$lccn = 'sh91003089'">caq</xsl:when>
                    <xsl:when test="$lccn = 'sh85082488'">mdd</xsl:when>
                    <xsl:when test="$lccn = 'sh85082489'">mck</xsl:when>
                    <xsl:when test="$lccn = 'sh93002206'">mar</xsl:when>
                    <xsl:when test="$lccn = 'sh85057897'">gul</xsl:when>
                    <xsl:when test="$lccn = 'sh85002064'">awn</xsl:when>
                    <xsl:when test="$lccn = 'sh85141686'">vaa</xsl:when>
                    <xsl:when test="$lccn = 'sh85102281'">piu</xsl:when>
                    <xsl:when test="$lccn = 'sh85130312'">sub</xsl:when>
                    <xsl:when test="$lccn = 'sh85131779'">tab</xsl:when>
                    <xsl:when test="$lccn = 'sh85130311'">suk</xsl:when>
                    <xsl:when test="$lccn = 'sh85085475'">min</xsl:when>
                    <xsl:when test="$lccn = 'sh00008825'">sbp</xsl:when>
                    <xsl:when test="$lccn = 'sh85018619'">cad</xsl:when>
                    <xsl:when test="$lccn = 'sh97002830'">ise</xsl:when>
                    <xsl:when test="$lccn = 'sh85119863'">nsm</xsl:when>
                    <xsl:when test="$lccn = 'sh85098421'">paq</xsl:when>
                    <xsl:when test="$lccn = 'sh85017967'">buy</xsl:when>
                    <xsl:when test="$lccn = 'sh00005131'">saw</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009965'">lbx</xsl:when>
                    <xsl:when test="$lccn = 'sh85146114'">bsk</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009966'">sna</xsl:when>
                    <xsl:when test="$lccn = 'sh93007234'">alp</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009969'">fcs</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009968'">lim</xsl:when>
                    <xsl:when test="$lccn = 'sh93002793'">nij</xsl:when>
                    <xsl:when test="$lccn = 'sh85105681'">phr</xsl:when>
                    <xsl:when test="$lccn = 'sh91005703'">sna</xsl:when>
                    <xsl:when test="$lccn = 'sh85087007'">moe</xsl:when>
                    <xsl:when test="$lccn = 'sh85109884'">qyp</xsl:when>
                    <xsl:when test="$lccn = 'sh85008510'">aso</xsl:when>
                    <xsl:when test="$lccn = 'sh85005833'">aud</xsl:when>
                    <xsl:when test="$lccn = 'sh91006071'">lcm</xsl:when>
                    <xsl:when test="$lccn = 'sh89006659'">kvh</xsl:when>
                    <xsl:when test="$lccn = 'sh85018724'">hrv</xsl:when>
                    <xsl:when test="$lccn = 'sh85018722'">frc</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003457'">mlx</xsl:when>
                    <xsl:when test="$lccn = 'sh98006737'">asf</xsl:when>
                    <xsl:when test="$lccn = 'sh85111393'">rao</xsl:when>
                    <xsl:when test="$lccn = 'sh85094049'">ocu</xsl:when>
                    <xsl:when test="$lccn = 'sh85019272'">cam</xsl:when>
                    <xsl:when test="$lccn = 'sh85093808'">ile</xsl:when>
                    <xsl:when test="$lccn = 'sh85136035'">tnt</xsl:when>
                    <xsl:when test="$lccn = 'sh85084476'">wtm</xsl:when>
                    <xsl:when test="$lccn = 'sh85084475'">mtr</xsl:when>
                    <xsl:when test="$lccn = 'sh92004865'">leu</xsl:when>
                    <xsl:when test="$lccn = 'sh85073471'">kuj</xsl:when>
                    <xsl:when test="$lccn = 'sh2001005810'">bch</xsl:when>
                    <xsl:when test="$lccn = 'sh2001005811'">tmy</xsl:when>
                    <xsl:when test="$lccn = 'sh85004474'">ciw</xsl:when>
                    <xsl:when test="$lccn = 'sh85043175'">eno</xsl:when>
                    <xsl:when test="$lccn = 'sh85121389'">shr</xsl:when>
                    <xsl:when test="$lccn = 'sh85001489'">aal</xsl:when>
                    <xsl:when test="$lccn = 'sh2007008306'">bst</xsl:when>
                    <xsl:when test="$lccn = 'sh85032507'">crn</xsl:when>
                    <xsl:when test="$lccn = 'sh85014116'">bjr</xsl:when>
                    <xsl:when test="$lccn = 'sh85077000'">lif</xsl:when>
                    <xsl:when test="$lccn = 'sh85077001'">lmp</xsl:when>
                    <xsl:when test="$lccn = 'sh85018438'">bel</xsl:when>
                    <xsl:when test="$lccn = 'sh85011771'">bbb</xsl:when>
                    <xsl:when test="$lccn = 'sh85052677'">gad</xsl:when>
                    <xsl:when test="$lccn = 'sh85134920'">tou</xsl:when>
                    <xsl:when test="$lccn = 'sh87003107'">osi</xsl:when>
                    <xsl:when test="$lccn = 'sh85094425'">xal</xsl:when>
                    <xsl:when test="$lccn = 'sh85011774'">brm</xsl:when>
                    <xsl:when test="$lccn = 'sh85084657'">mpt</xsl:when>
                    <xsl:when test="$lccn = 'sh85059313'">hau</xsl:when>
                    <xsl:when test="$lccn = 'sh85004053'">alz</xsl:when>
                    <xsl:when test="$lccn = 'sh85010964'">bfy</xsl:when>
                    <xsl:when test="$lccn = 'sh85145065'">wam</xsl:when>
                    <xsl:when test="$lccn = 'sh85010966'">bmi</xsl:when>
                    <xsl:when test="$lccn = 'sh85073216'">koy</xsl:when>
                    <xsl:when test="$lccn = 'sh93009163'">wri</xsl:when>
                    <xsl:when test="$lccn = 'sh93009162'">mem</xsl:when>
                    <xsl:when test="$lccn = 'sh93009161'">kld</xsl:when>
                    <xsl:when test="$lccn = 'sh93009160'">dhl</xsl:when>
                    <xsl:when test="$lccn = 'sh85004982'">ane</xsl:when>
                    <xsl:when test="$lccn = 'sh85144515'">waj</xsl:when>
                    <xsl:when test="$lccn = 'sh85010969'">obo</xsl:when>
                    <xsl:when test="$lccn = 'sh85062823'">hul</xsl:when>
                    <xsl:when test="$lccn = 'sh85062828'">hui</xsl:when>
                    <xsl:when test="$lccn = 'sh85092387'">noo</xsl:when>
                    <xsl:when test="$lccn = 'sh85037644'">mbd</xsl:when>
                    <xsl:when test="$lccn = 'sh85080370'">mle</xsl:when>
                    <xsl:when test="$lccn = 'sh85010567'">awb</xsl:when>
                    <xsl:when test="$lccn = 'sh85010568'">awa</xsl:when>
                    <xsl:when test="$lccn = 'sh91000607'">zmx</xsl:when>
                    <xsl:when test="$lccn = 'sh2002005878'">etr</xsl:when>
                    <xsl:when test="$lccn = 'sh85094559'">peo</xsl:when>
                    <xsl:when test="$lccn = 'sh85145112'">wao</xsl:when>
                    <xsl:when test="$lccn = 'sh85094570'">otk</xsl:when>
                    <xsl:when test="$lccn = 'sh85094550'">non</xsl:when>
                    <xsl:when test="$lccn = 'sh85127288'">hur</xsl:when>
                    <xsl:when test="$lccn = 'sh85133857'">tqb</xsl:when>
                    <xsl:when test="$lccn = 'sh85145401'">wsk</xsl:when>
                    <xsl:when test="$lccn = 'sh85025491'">chs</xsl:when>
                    <xsl:when test="$lccn = 'sh85073501'">kus</xsl:when>
                    <xsl:when test="$lccn = 'sh85073503'">kgg</xsl:when>
                    <xsl:when test="$lccn = 'sh85025499'">cuj</xsl:when>
                    <xsl:when test="$lccn = 'sh85122384'">lew</xsl:when>
                    <xsl:when test="$lccn = 'sh85098627'">pbc</xsl:when>
                    <xsl:when test="$lccn = 'sh2002001285'">yey</xsl:when>
                    <xsl:when test="$lccn = 'sh85000514'">acu</xsl:when>
                    <xsl:when test="$lccn = 'sh85080087'">mal</xsl:when>
                    <xsl:when test="$lccn = 'sh93009696'">lex</xsl:when>
                    <xsl:when test="$lccn = 'sh85080579'">nge</xsl:when>
                    <xsl:when test="$lccn = 'sh85080577'">knf</xsl:when>
                    <xsl:when test="$lccn = 'sh89002891'">fuv</xsl:when>
                    <xsl:when test="$lccn = 'sh85070523'">apj</xsl:when>
                    <xsl:when test="$lccn = 'sh85096605'">new</xsl:when>
                    <xsl:when test="$lccn = 'sh85070521'">jic</xsl:when>
                    <xsl:when test="$lccn = 'sh85096602'">pal</xsl:when>
                    <xsl:when test="$lccn = 'sh85091657'">ntj</xsl:when>
                    <xsl:when test="$lccn = 'sh85091658'">nxg</xsl:when>
                    <xsl:when test="$lccn = 'sh2002005055'">ite</xsl:when>
                    <xsl:when test="$lccn = 'sh99010327'">sms</xsl:when>
                    <xsl:when test="$lccn = 'sh85142606'">ven</xsl:when>
                    <xsl:when test="$lccn = 'sh85071697'">kju</xsl:when>
                    <xsl:when test="$lccn = 'sh85015881'">bor</xsl:when>
                    <xsl:when test="$lccn = 'sh85071695'">xsm</xsl:when>
                    <xsl:when test="$lccn = 'sh85091687'">nyy</xsl:when>
                    <xsl:when test="$lccn = 'sh2008006478'">kkk</xsl:when>
                    <xsl:when test="$lccn = 'sh92004555'">sps</xsl:when>
                    <xsl:when test="$lccn = 'sh85080884'">mec</xsl:when>
                    <xsl:when test="$lccn = 'sh92003583'">pao</xsl:when>
                    <xsl:when test="$lccn = 'sh85089682'">gur</xsl:when>
                    <xsl:when test="$lccn = 'sh2002009431'">mbq</xsl:when>
                    <xsl:when test="$lccn = 'sh97000390'">bya</xsl:when>
                    <xsl:when test="$lccn = 'sh97008843'">bgz</xsl:when>
                    <xsl:when test="$lccn = 'sh85091680'">nnh</xsl:when>
                    <xsl:when test="$lccn = 'sh85099395'">peg</xsl:when>
                    <xsl:when test="$lccn = 'sh85069751'">jra</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003586'">vas</xsl:when>
                    <xsl:when test="$lccn = 'sh85010618'">aym</xsl:when>
                    <xsl:when test="$lccn = 'sh86008121'">can</xsl:when>
                    <xsl:when test="$lccn = 'sh85080406'">mid</xsl:when>
                    <xsl:when test="$lccn = 'sh85071238'">kfr</xsl:when>
                    <xsl:when test="$lccn = 'sh85135481'">tjm</xsl:when>
                    <xsl:when test="$lccn = 'sh2008006272'">mar</xsl:when>
                    <xsl:when test="$lccn = 'sh2008006273'">ndh</xsl:when>
                    <xsl:when test="$lccn = 'sh85071233'">kab</xsl:when>
                    <xsl:when test="$lccn = 'sh85135690'">tli</xsl:when>
                    <xsl:when test="$lccn = 'sh85071340'">kln</xsl:when>
                    <xsl:when test="$lccn = 'sh85136200'">trw</xsl:when>
                    <xsl:when test="$lccn = 'sh90002806'">iku</xsl:when>
                    <xsl:when test="$lccn = 'sh90004360'">kca</xsl:when>
                    <xsl:when test="$lccn = 'sh85148971'">yam</xsl:when>
                    <xsl:when test="$lccn = 'sh85148972'">yat</xsl:when>
                    <xsl:when test="$lccn = 'sh85148974'">tao</xsl:when>
                    <xsl:when test="$lccn = 'sh85131968'">dav</xsl:when>
                    <xsl:when test="$lccn = 'sh85148978'">ynn</xsl:when>
                    <xsl:when test="$lccn = 'sh99005940'">alr</xsl:when>
                    <xsl:when test="$lccn = 'sh87000104'">lse</xsl:when>
                    <xsl:when test="$lccn = 'sh88007185'">pbg</xsl:when>
                    <xsl:when test="$lccn = 'sh92005150'">nam</xsl:when>
                    <xsl:when test="$lccn = 'sh87000103'">lse</xsl:when>
                    <xsl:when test="$lccn = 'sh85069137'">ixc</xsl:when>
                    <xsl:when test="$lccn = 'sh85006992'">alu</xsl:when>
                    <xsl:when test="$lccn = 'sh85069133'">iwm</xsl:when>
                    <xsl:when test="$lccn = 'sh85069131'">ibd</xsl:when>
                    <xsl:when test="$lccn = 'sh89004001'">bco</xsl:when>
                    <xsl:when test="$lccn = 'sh92005162'">mfb</xsl:when>
                    <xsl:when test="$lccn = 'sh85149213'">yom</xsl:when>
                    <xsl:when test="$lccn = 'sh91001734'">rop</xsl:when>
                    <xsl:when test="$lccn = 'sh85074156'">nrz</xsl:when>
                    <xsl:when test="$lccn = 'sh94001046'">mnf</xsl:when>
                    <xsl:when test="$lccn = 'sh85074152'">lkt</xsl:when>
                    <xsl:when test="$lccn = 'sh85075939'">gnh</xsl:when>
                    <xsl:when test="$lccn = 'sh85138547'">tmq</xsl:when>
                    <xsl:when test="$lccn = 'sh85138546'">tum</xsl:when>
                    <xsl:when test="$lccn = 'sh00010161'">zwa</xsl:when>
                    <xsl:when test="$lccn = 'sh85036693'">ddn</xsl:when>
                    <xsl:when test="$lccn = 'sh85138541'">tmc</xsl:when>
                    <xsl:when test="$lccn = 'sh85139320'">uig</xsl:when>
                    <xsl:when test="$lccn = 'sh94004940'">spp</xsl:when>
                    <xsl:when test="$lccn = 'sh85045473'">ets</xsl:when>
                    <xsl:when test="$lccn = 'sh96005071'">nuo</xsl:when>
                    <xsl:when test="$lccn = 'sh99013637'">pny</xsl:when>
                    <xsl:when test="$lccn = 'sh88000629'">tbo</xsl:when>
                    <xsl:when test="$lccn = 'sh87003583'">has</xsl:when>
                    <xsl:when test="$lccn = 'sh85123525'">slv</xsl:when>
                    <xsl:when test="$lccn = 'sh85057954'">guf</xsl:when>
                    <xsl:when test="$lccn = 'sh85057950'">yas</xsl:when>
                    <xsl:when test="$lccn = 'sh94000885'">ccc</xsl:when>
                    <xsl:when test="$lccn = 'sh94000886'">gut</xsl:when>
                    <xsl:when test="$lccn = 'sh85057953'">gup</xsl:when>
                    <xsl:when test="$lccn = 'sh87000035'">gau</xsl:when>
                    <xsl:when test="$lccn = 'sh87000037'">pbz</xsl:when>
                    <xsl:when test="$lccn = 'sh85072537'">luy</xsl:when>
                    <xsl:when test="$lccn = 'sh85079236'">mwp</xsl:when>
                    <xsl:when test="$lccn = 'sh2005006934'">hdy</xsl:when>
                    <xsl:when test="$lccn = 'sh98005406'">blx</xsl:when>
                    <xsl:when test="$lccn = 'sh85118883'">sco</xsl:when>
                    <xsl:when test="$lccn = 'sh2005006939'">ktb</xsl:when>
                    <xsl:when test="$lccn = 'sh85138307'">tkr</xsl:when>
                    <xsl:when test="$lccn = 'sh85132920'">kqo</xsl:when>
                    <xsl:when test="$lccn = 'sh2007010899'">mvz</xsl:when>
                    <xsl:when test="$lccn = 'sh96003764'">zro</xsl:when>
                    <xsl:when test="$lccn = 'sh2004006727'">hol</xsl:when>
                    <xsl:when test="$lccn = 'sh85052896'">sba</xsl:when>
                    <xsl:when test="$lccn = 'sh85071387'">aoc</xsl:when>
                    <xsl:when test="$lccn = 'sh85134134'">teo</xsl:when>
                    <xsl:when test="$lccn = 'sh88004087'">kyw</xsl:when>
                    <xsl:when test="$lccn = 'sh88006899'">ifk</xsl:when>
                    <xsl:when test="$lccn = 'sh85072310'">kik</xsl:when>
                    <xsl:when test="$lccn = 'sh2003000169'">lkn</xsl:when>
                    <xsl:when test="$lccn = 'sh2003000168'">bki</xsl:when>
                    <xsl:when test="$lccn = 'sh00007260'">snf</xsl:when>
                    <xsl:when test="$lccn = 'sh85148559'">unp</xsl:when>
                    <xsl:when test="$lccn = 'sh85082492'">gun</xsl:when>
                    <xsl:when test="$lccn = 'sh2003000167'">akr</xsl:when>
                    <xsl:when test="$lccn = 'sh85058037'">gwx</xsl:when>
                    <xsl:when test="$lccn = 'sh85058034'">lnu</xsl:when>
                    <xsl:when test="$lccn = 'sh85131901'">tgl</xsl:when>
                    <xsl:when test="$lccn = 'sh85071903'">kem</xsl:when>
                    <xsl:when test="$lccn = 'sh87000355'">urk</xsl:when>
                    <xsl:when test="$lccn = 'sh85071906'">ahg</xsl:when>
                    <xsl:when test="$lccn = 'sh92001384'">spo</xsl:when>
                    <xsl:when test="$lccn = 'sh92001382'">ski</xsl:when>
                    <xsl:when test="$lccn = 'sh85131708'">syr</xsl:when>
                    <xsl:when test="$lccn = 'sh85086481'">mif</xsl:when>
                    <xsl:when test="$lccn = 'sh85072229'">csh</xsl:when>
                    <xsl:when test="$lccn = 'sh85116658'">skt</xsl:when>
                    <xsl:when test="$lccn = 'sh85086485'">mhj</xsl:when>
                    <xsl:when test="$lccn = 'sh85072223'">sgh</xsl:when>
                    <xsl:when test="$lccn = 'sh85072222'">khw</xsl:when>
                    <xsl:when test="$lccn = 'sh85072221'">kho</xsl:when>
                    <xsl:when test="$lccn = 'sh85087466'">nbf</xsl:when>
                    <xsl:when test="$lccn = 'sh85072226'">kkh</xsl:when>
                    <xsl:when test="$lccn = 'sh85088422'">muh</xsl:when>
                    <xsl:when test="$lccn = 'sh85085463'">bca</xsl:when>
                    <xsl:when test="$lccn = 'sh93002416'">wbr</xsl:when>
                    <xsl:when test="$lccn = 'sh85085465'">gej</xsl:when>
                    <xsl:when test="$lccn = 'sh85130302'">pko</xsl:when>
                    <xsl:when test="$lccn = 'sh85028682'">cof</xsl:when>
                    <xsl:when test="$lccn = 'sh85013476'">plt</xsl:when>
                    <xsl:when test="$lccn = 'sh85086666'">mnw</xsl:when>
                    <xsl:when test="$lccn = 'sh85090486'">nmd</xsl:when>
                    <xsl:when test="$lccn = 'sh00005128'">bpr</xsl:when>
                    <xsl:when test="$lccn = 'sh94005842'">cih</xsl:when>
                    <xsl:when test="$lccn = 'sh85094637'">ong</xsl:when>
                    <xsl:when test="$lccn = 'sh85094638'">olo</xsl:when>
                    <xsl:when test="$lccn = 'sh85018608'">cbv</xsl:when>
                    <xsl:when test="$lccn = 'sh90000305'">tlr</xsl:when>
                    <xsl:when test="$lccn = 'sh92001624'">nzb</xsl:when>
                    <xsl:when test="$lccn = 'sh93002099'">kns</xsl:when>
                    <xsl:when test="$lccn = 'sh94006010'">knj</xsl:when>
                    <xsl:when test="$lccn = 'sh85018938'">caw</xsl:when>
                    <xsl:when test="$lccn = 'sh87007005'">hni</xsl:when>
                    <xsl:when test="$lccn = 'sh92001499'">ppo</xsl:when>
                    <xsl:when test="$lccn = 'sh85135670'">tiv</xsl:when>
                    <xsl:when test="$lccn = 'sh2002004215'">uri</xsl:when>
                    <xsl:when test="$lccn = 'sh94003719'">var</xsl:when>
                    <xsl:when test="$lccn = 'sh88005110'">bkb</xsl:when>
                    <xsl:when test="$lccn = 'sh85092929'">nto</xsl:when>
                    <xsl:when test="$lccn = 'sh85071437'">hig</xsl:when>
                    <xsl:when test="$lccn = 'sh96008851'">tod</xsl:when>
                    <xsl:when test="$lccn = 'sh85092927'">thp</xsl:when>
                    <xsl:when test="$lccn = 'sh93002522'">heh</xsl:when>
                    <xsl:when test="$lccn = 'sh85009369'">adz</xsl:when>
                    <xsl:when test="$lccn = 'sh85035797'">prs</xsl:when>
                    <xsl:when test="$lccn = 'sh98000948'">aph</xsl:when>
                    <xsl:when test="$lccn = 'sh85075991'">leh</xsl:when>
                    <xsl:when test="$lccn = 'sh93002529'">tlh</xsl:when>
                    <xsl:when test="$lccn = 'sh97003999'">its</xsl:when>
                    <xsl:when test="$lccn = 'sh85144855'">wbl</xsl:when>
                    <xsl:when test="$lccn = 'sh85017824'">sdo</xsl:when>
                    <xsl:when test="$lccn = 'sh85073981'">lhu</xsl:when>
                    <xsl:when test="$lccn = 'sh85017827'">bkd</xsl:when>
                    <xsl:when test="$lccn = 'sh89006661'">sob</xsl:when>
                    <xsl:when test="$lccn = 'sh85017823'">buo</xsl:when>
                    <xsl:when test="$lccn = 'sh2002007295'">lmc</xsl:when>
                    <xsl:when test="$lccn = 'sh2004005039'">skv</xsl:when>
                    <xsl:when test="$lccn = 'sh2004005038'">mlv</xsl:when>
                    <xsl:when test="$lccn = 'sh99002901'">kap</xsl:when>
                    <xsl:when test="$lccn = 'sh85073444'">kup</xsl:when>
                    <xsl:when test="$lccn = 'sh85149632'">zak</xsl:when>
                    <xsl:when test="$lccn = 'sh85060875'">hin</xsl:when>
                    <xsl:when test="$lccn = 'sh85073193'">ort</xsl:when>
                    <xsl:when test="$lccn = 'sh97006124'">est</xsl:when>
                    <xsl:when test="$lccn = 'sh85035500'">dak</xsl:when>
                    <xsl:when test="$lccn = 'sh98005393'">nwe</xsl:when>
                    <xsl:when test="$lccn = 'sh85149635'">zne</xsl:when>
                    <xsl:when test="$lccn = 'sh85093282'">nuy</xsl:when>
                    <xsl:when test="$lccn = 'sh87006513'">tom</xsl:when>
                    <xsl:when test="$lccn = 'sh85034694'">cui</xsl:when>
                    <xsl:when test="$lccn = 'sh2002011338'">sbk</xsl:when>
                    <xsl:when test="$lccn = 'sh85095945'">oss</xsl:when>
                    <xsl:when test="$lccn = 'sh96008986'">nal</xsl:when>
                    <xsl:when test="$lccn = 'sh2006005092'">nck</xsl:when>
                    <xsl:when test="$lccn = 'sh85121269'">swv</xsl:when>
                    <xsl:when test="$lccn = 'sh85018423'">bwd</xsl:when>
                    <xsl:when test="$lccn = 'sh96000265'">mpk</xsl:when>
                    <xsl:when test="$lccn = 'sh92004537'">tim</xsl:when>
                    <xsl:when test="$lccn = 'sh85067959'">irk</xsl:when>
                    <xsl:when test="$lccn = 'sh85004206'">aey</xsl:when>
                    <xsl:when test="$lccn = 'sh85021456'">jqr</xsl:when>
                    <xsl:when test="$lccn = 'sh2007000540'">bdy</xsl:when>
                    <xsl:when test="$lccn = 'sh85080369'">mva</xsl:when>
                    <xsl:when test="$lccn = 'sh85074944'">lat</xsl:when>
                    <xsl:when test="$lccn = 'sh2007000544'">tmb</xsl:when>
                    <xsl:when test="$lccn = 'sh89004821'">khn</xsl:when>
                    <xsl:when test="$lccn = 'sh85061276'">hit</xsl:when>
                    <xsl:when test="$lccn = 'sh2007003961'">unz</xsl:when>
                    <xsl:when test="$lccn = 'sh85011513'">bgc</xsl:when>
                    <xsl:when test="$lccn = 'sh85004085'">amm</xsl:when>
                    <xsl:when test="$lccn = 'sh85047429'">faa</xsl:when>
                    <xsl:when test="$lccn = 'sh92003278'">sur</xsl:when>
                    <xsl:when test="$lccn = 'sh85021584'">ceb</xsl:when>
                    <xsl:when test="$lccn = 'sh97001588'">dud</xsl:when>
                    <xsl:when test="$lccn = 'sh85145102'">wnc</xsl:when>
                    <xsl:when test="$lccn = 'sh97008871'">smj</xsl:when>
                    <xsl:when test="$lccn = 'sh2001005807'">sim</xsl:when>
                    <xsl:when test="$lccn = 'sh2001005806'">khv</xsl:when>
                    <xsl:when test="$lccn = 'sh85094563'">osx</xsl:when>
                    <xsl:when test="$lccn = 'sh85081788'">mas</xsl:when>
                    <xsl:when test="$lccn = 'sh91000810'">kcg</xsl:when>
                    <xsl:when test="$lccn = 'sh91000811'">kcg</xsl:when>
                    <xsl:when test="$lccn = 'sh85073536'">kwd</xsl:when>
                    <xsl:when test="$lccn = 'sh85073473'">kfq</xsl:when>
                    <xsl:when test="$lccn = 'sh85081784'">mbl</xsl:when>
                    <xsl:when test="$lccn = 'sh85073533'">mas</xsl:when>
                    <xsl:when test="$lccn = 'sh00001800'">ikx</xsl:when>
                    <xsl:when test="$lccn = 'sh85000504'">ace</xsl:when>
                    <xsl:when test="$lccn = 'sh85000509'">acv</xsl:when>
                    <xsl:when test="$lccn = 'sh93009002'">kpc</xsl:when>
                    <xsl:when test="$lccn = 'sh2004003260'">nge</xsl:when>
                    <xsl:when test="$lccn = 'sh85119942'">mus</xsl:when>
                    <xsl:when test="$lccn = 'sh85011358'">bft</xsl:when>
                    <xsl:when test="$lccn = 'sh85080564'">mni</xsl:when>
                    <xsl:when test="$lccn = 'sh85011428'">bcf</xsl:when>
                    <xsl:when test="$lccn = 'sh2003008958'">lby</xsl:when>
                    <xsl:when test="$lccn = 'sh85091664'">nig</xsl:when>
                    <xsl:when test="$lccn = 'sh85091666'">nio</xsl:when>
                    <xsl:when test="$lccn = 'sh85145078'">wnd</xsl:when>
                    <xsl:when test="$lccn = 'sh85091661'">nij</xsl:when>
                    <xsl:when test="$lccn = 'sh85090719'">nem</xsl:when>
                    <xsl:when test="$lccn = 'sh89005040'">yeu</xsl:when>
                    <xsl:when test="$lccn = 'sh85090715'">ijs</xsl:when>
                    <xsl:when test="$lccn = 'sh85067859'">iow</xsl:when>
                    <xsl:when test="$lccn = 'sh85091668'">nid</xsl:when>
                    <xsl:when test="$lccn = 'sh85073226'">kpe</xsl:when>
                    <xsl:when test="$lccn = 'sh85073227'">kpo</xsl:when>
                    <xsl:when test="$lccn = 'sh85087704'">meu</xsl:when>
                    <xsl:when test="$lccn = 'sh98008149'">kck</xsl:when>
                    <xsl:when test="$lccn = 'sh91000920'">mba</xsl:when>
                    <xsl:when test="$lccn = 'sh92004546'">yle</xsl:when>
                    <xsl:when test="$lccn = 'sh92004544'">bir</xsl:when>
                    <xsl:when test="$lccn = 'sh92005010'">mcm</xsl:when>
                    <xsl:when test="$lccn = 'sh85080896'">nma</xsl:when>
                    <xsl:when test="$lccn = 'sh85132794'">tsg</xsl:when>
                    <xsl:when test="$lccn = 'sh92005014'">rah</xsl:when>
                    <xsl:when test="$lccn = 'sh85132797'">tvs</xsl:when>
                    <xsl:when test="$lccn = 'sh85080899'">mrw</xsl:when>
                    <xsl:when test="$lccn = 'sh2003010776'">vut</xsl:when>
                    <xsl:when test="$lccn = 'sh85080783'">obo</xsl:when>
                    <xsl:when test="$lccn = 'sh85064029'">isl</xsl:when>
                    <xsl:when test="$lccn = 'sh85080787'">glv</xsl:when>
                    <xsl:when test="$lccn = 'sh85071598'">kdj</xsl:when>
                    <xsl:when test="$lccn = 'sh85069303'">sjm</xsl:when>
                    <xsl:when test="$lccn = 'sh85087320'">mor</xsl:when>
                    <xsl:when test="$lccn = 'sh85071753'">kax</xsl:when>
                    <xsl:when test="$lccn = 'sh85071751'">kda</xsl:when>
                    <xsl:when test="$lccn = 'sh85149051'">yah</xsl:when>
                    <xsl:when test="$lccn = 'sh98001085'">rki</xsl:when>
                    <xsl:when test="$lccn = 'sh85080419'">mdr</xsl:when>
                    <xsl:when test="$lccn = 'sh85080418'">mhq</xsl:when>
                    <xsl:when test="$lccn = 'sh85025481'">ckt</xsl:when>
                    <xsl:when test="$lccn = 'sh85109158'">iar</xsl:when>
                    <xsl:when test="$lccn = 'sh85025485'">cag</xsl:when>
                    <xsl:when test="$lccn = 'sh90002818'">ems</xsl:when>
                    <xsl:when test="$lccn = 'sh85071578'">kah</xsl:when>
                    <xsl:when test="$lccn = 'sh85023183'">nya</xsl:when>
                    <xsl:when test="$lccn = 'sh85054964'">niv</xsl:when>
                    <xsl:when test="$lccn = 'sh85071573'">kaa</xsl:when>
                    <xsl:when test="$lccn = 'sh85054967'">gim</xsl:when>
                    <xsl:when test="$lccn = 'sh95008141'">pav</xsl:when>
                    <xsl:when test="$lccn = 'sh85039977'">dng</xsl:when>
                    <xsl:when test="$lccn = 'sh85003082'">xav</xsl:when>
                    <xsl:when test="$lccn = 'sh97004089'">ino</xsl:when>
                    <xsl:when test="$lccn = 'sh98004672'">adi</xsl:when>
                    <xsl:when test="$lccn = 'sh96000588'">bdu</xsl:when>
                    <xsl:when test="$lccn = 'sh98004677'">gor</xsl:when>
                    <xsl:when test="$lccn = 'sh85086816'">lol</xsl:when>
                    <xsl:when test="$lccn = 'sh86005147'">uum</xsl:when>
                    <xsl:when test="$lccn = 'sh85089786'">npy</xsl:when>
                    <xsl:when test="$lccn = 'sh85089789'">nac</xsl:when>
                    <xsl:when test="$lccn = 'sh92003277'">sur</xsl:when>
                    <xsl:when test="$lccn = 'sh85149107'">ybe</xsl:when>
                    <xsl:when test="$lccn = 'sh85015890'">brn</xsl:when>
                    <xsl:when test="$lccn = 'sh85097547'">ood</xsl:when>
                    <xsl:when test="$lccn = 'sh85087781'">kpx</xsl:when>
                    <xsl:when test="$lccn = 'sh85072498'">kue</xsl:when>
                    <xsl:when test="$lccn = 'sh85135326'">tig</xsl:when>
                    <xsl:when test="$lccn = 'sh85036471'">deg</xsl:when>
                    <xsl:when test="$lccn = 'sh89006521'">cjp</xsl:when>
                    <xsl:when test="$lccn = 'sh85045468'">ett</xsl:when>
                    <xsl:when test="$lccn = 'sh96004352'">kky</xsl:when>
                    <xsl:when test="$lccn = 'sh85122876'">sin</xsl:when>
                    <xsl:when test="$lccn = 'sh85072496'">kio</xsl:when>
                    <xsl:when test="$lccn = 'sh87003846'">btd</xsl:when>
                    <xsl:when test="$lccn = 'sh2007002170'">han</xsl:when>
                    <xsl:when test="$lccn = 'sh90002090'">pse</xsl:when>
                    <xsl:when test="$lccn = 'sh85102174'">ood</xsl:when>
                    <xsl:when test="$lccn = 'sh87003848'">bld</xsl:when>
                    <xsl:when test="$lccn = 'sh00004044'">hac</xsl:when>
                    <xsl:when test="$lccn = 'sh2004005552'">bta</xsl:when>
                    <xsl:when test="$lccn = 'sh86001021'">ast</xsl:when>
                    <xsl:when test="$lccn = 'sh85117399'">dak</xsl:when>
                    <xsl:when test="$lccn = 'sh85038029'">dis</xsl:when>
                    <xsl:when test="$lccn = 'sh2004005559'">bcy</xsl:when>
                    <xsl:when test="$lccn = 'sh85012441'">sne</xsl:when>
                    <xsl:when test="$lccn = 'sh85117393'">sat</xsl:when>
                    <xsl:when test="$lccn = 'sh85080810'">mmd</xsl:when>
                    <xsl:when test="$lccn = 'sh85138332'">tso</xsl:when>
                    <xsl:when test="$lccn = 'sh85138335'">tsu</xsl:when>
                    <xsl:when test="$lccn = 'sh85089883'">nsk</xsl:when>
                    <xsl:when test="$lccn = 'sh92001245'">kkj</xsl:when>
                    <xsl:when test="$lccn = 'sh85139425'">apb</xsl:when>
                    <xsl:when test="$lccn = 'sh85148830'">xin</xsl:when>
                    <xsl:when test="$lccn = 'sh2002006641'">swr</xsl:when>
                    <xsl:when test="$lccn = 'sh85120159'">pse</xsl:when>
                    <xsl:when test="$lccn = 'sh85016942'">any</xsl:when>
                    <xsl:when test="$lccn = 'sh85003069'">che</xsl:when>
                    <xsl:when test="$lccn = 'sh85002045'">agd</xsl:when>
                    <xsl:when test="$lccn = 'sh85038111'">dyu</xsl:when>
                    <xsl:when test="$lccn = 'sh96007026'">rue</xsl:when>
                    <xsl:when test="$lccn = 'sh85125343'">sot</xsl:when>
                    <xsl:when test="$lccn = 'sh85086490'">gum</xsl:when>
                    <xsl:when test="$lccn = 'sh85003061'">cop</xsl:when>
                    <xsl:when test="$lccn = 'sh85003062'">akv</xsl:when>
                    <xsl:when test="$lccn = 'sh85086499'">mov</xsl:when>
                    <xsl:when test="$lccn = 'sh85134232'">tet</xsl:when>
                    <xsl:when test="$lccn = 'sh85100313'">pex</xsl:when>
                    <xsl:when test="$lccn = 'sh88001332'">kan</xsl:when>
                    <xsl:when test="$lccn = 'sh2008001077'">asl</xsl:when>
                    <xsl:when test="$lccn = 'sh93006298'">irh</xsl:when>
                    <xsl:when test="$lccn = 'sh93006295'">kvo</xsl:when>
                    <xsl:when test="$lccn = 'sh85023198'">hne</xsl:when>
                    <xsl:when test="$lccn = 'sh2001004534'">amx</xsl:when>
                    <xsl:when test="$lccn = 'sh86002393'">arv</xsl:when>
                    <xsl:when test="$lccn = 'sh98002281'">lbz</xsl:when>
                    <xsl:when test="$lccn = 'sh2004010246'">bei</xsl:when>
                    <xsl:when test="$lccn = 'sh85084654'">mia</xsl:when>
                    <xsl:when test="$lccn = 'sh2008004647'">arn</xsl:when>
                    <xsl:when test="$lccn = 'sh85071802'">pdu</xsl:when>
                    <xsl:when test="$lccn = 'sh90003765'">bvu</xsl:when>
                    <xsl:when test="$lccn = 'sh85138597'">sce</xsl:when>
                    <xsl:when test="$lccn = 'sh85076381'">lhm</xsl:when>
                    <xsl:when test="$lccn = 'sh85130933'">sva</xsl:when>
                    <xsl:when test="$lccn = 'sh85059465'">kup</xsl:when>
                    <xsl:when test="$lccn = 'sh85092933'">kcn</xsl:when>
                    <xsl:when test="$lccn = 'sh85005853'">aom</xsl:when>
                    <xsl:when test="$lccn = 'sh93007567'">bdb</xsl:when>
                    <xsl:when test="$lccn = 'sh85009373'">atw</xsl:when>
                    <xsl:when test="$lccn = 'sh85009371'">ats</xsl:when>
                    <xsl:when test="$lccn = 'sh93009164'">yia</xsl:when>
                    <xsl:when test="$lccn = 'sh85009377'">aqp</xsl:when>
                    <xsl:when test="$lccn = 'sh93002530'">spy</xsl:when>
                    <xsl:when test="$lccn = 'sh85009375'">att</xsl:when>
                    <xsl:when test="$lccn = 'sh85018701'">chl</xsl:when>
                    <xsl:when test="$lccn = 'sh85085090'">mjw</xsl:when>
                    <xsl:when test="$lccn = 'sh85018254'">buf</xsl:when>
                    <xsl:when test="$lccn = 'sh85017831'">bxk</xsl:when>
                    <xsl:when test="$lccn = 'sh89006670'">ury</xsl:when>
                    <xsl:when test="$lccn = 'sh85063908'">xib</xsl:when>
                    <xsl:when test="$lccn = 'sh85147248'">wol</xsl:when>
                    <xsl:when test="$lccn = 'sh2001000988'">lln</xsl:when>
                    <xsl:when test="$lccn = 'sh85063904'">ibg</xsl:when>
                    <xsl:when test="$lccn = 'sh85073212'">kff</xsl:when>
                    <xsl:when test="$lccn = 'sh85063901'">iba</xsl:when>
                    <xsl:when test="$lccn = 'sh85093537'">nyd</xsl:when>
                    <xsl:when test="$lccn = 'sh2008000350'">nho</xsl:when>
                    <xsl:when test="$lccn = 'sh85001242'">awi</xsl:when>
                    <xsl:when test="$lccn = 'sh85093538'">nyo</xsl:when>
                    <xsl:when test="$lccn = 'sh99002916'">msu</xsl:when>
                    <xsl:when test="$lccn = 'sh99002910'">laz</xsl:when>
                    <xsl:when test="$lccn = 'sh95004597'">mgw</xsl:when>
                    <xsl:when test="$lccn = 'sh85147087'">wiu</xsl:when>
                    <xsl:when test="$lccn = 'sh85125337'">kle</xsl:when>
                    <xsl:when test="$lccn = 'sh85060847'">him</xsl:when>
                    <xsl:when test="$lccn = 'sh85008796'">asb</xsl:when>
                    <xsl:when test="$lccn = 'sh2004004977'">wsa</xsl:when>
                    <xsl:when test="$lccn = 'sh85019476'">quf</xsl:when>
                    <xsl:when test="$lccn = 'sh85033031'">coe</xsl:when>
                    <xsl:when test="$lccn = 'sh85142031'">xvn</xsl:when>
                    <xsl:when test="$lccn = 'sh92003336'">skb</xsl:when>
                    <xsl:when test="$lccn = 'sh85089145'">css</xsl:when>
                    <xsl:when test="$lccn = 'sh95002951'">new</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003548'">avi</xsl:when>
                    <xsl:when test="$lccn = 'sh93004804'">otd</xsl:when>
                    <xsl:when test="$lccn = 'sh85004076'">aly</xsl:when>
                    <xsl:when test="$lccn = 'sh2008004357'">tsq</xsl:when>
                    <xsl:when test="$lccn = 'sh85134171'">tll</xsl:when>
                    <xsl:when test="$lccn = 'sh00001672'">sgw</xsl:when>
                    <xsl:when test="$lccn = 'sh85035409'">dta</xsl:when>
                    <xsl:when test="$lccn = 'sh85035406'">dag</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006251'">sza</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006250'">lvk</xsl:when>
                    <xsl:when test="$lccn = 'sh85061263'">mik</xsl:when>
                    <xsl:when test="$lccn = 'sh85011508'">baz</xsl:when>
                    <xsl:when test="$lccn = 'sh85110110'">pim</xsl:when>
                    <xsl:when test="$lccn = 'sh98001334'">mkf</xsl:when>
                    <xsl:when test="$lccn = 'sh85004090'">amc</xsl:when>
                    <xsl:when test="$lccn = 'sh85117011'">ori</xsl:when>
                    <xsl:when test="$lccn = 'sh90002173'">bun</xsl:when>
                    <xsl:when test="$lccn = 'sh85019271'">kbh</xsl:when>
                    <xsl:when test="$lccn = 'sh86002415'">blt</xsl:when>
                    <xsl:when test="$lccn = 'sh85088303'">mlm</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006099'">wme</xsl:when>
                    <xsl:when test="$lccn = 'sh85091709'">nia</xsl:when>
                    <xsl:when test="$lccn = 'sh85073458'">key</xsl:when>
                    <xsl:when test="$lccn = 'sh85119706'">spl</xsl:when>
                    <xsl:when test="$lccn = 'sh99013592'">mei</xsl:when>
                    <xsl:when test="$lccn = 'sh85007408'">aia</xsl:when>
                    <xsl:when test="$lccn = 'sh85024760'">crt</xsl:when>
                    <xsl:when test="$lccn = 'sh85073521'">kxv</xsl:when>
                    <xsl:when test="$lccn = 'sh85115084'">rom</xsl:when>
                    <xsl:when test="$lccn = 'sh85090472'">nde</xsl:when>
                    <xsl:when test="$lccn = 'sh90002897'">sxn</xsl:when>
                    <xsl:when test="$lccn = 'sh85024767'">caa</xsl:when>
                    <xsl:when test="$lccn = 'sh85090471'">nbl</xsl:when>
                    <xsl:when test="$lccn = 'sh85081792'">msb</xsl:when>
                    <xsl:when test="$lccn = 'sh2002005875'">nca</xsl:when>
                    <xsl:when test="$lccn = 'sh85012688'">oci</xsl:when>
                    <xsl:when test="$lccn = 'sh2004003271'">nso</xsl:when>
                    <xsl:when test="$lccn = 'sh2004003273'">nso</xsl:when>
                    <xsl:when test="$lccn = 'sh86008212'">tnm</xsl:when>
                    <xsl:when test="$lccn = 'sh2004003277'">mui</xsl:when>
                    <xsl:when test="$lccn = 'sh85011431'">bax</xsl:when>
                    <xsl:when test="$lccn = 'sh93008727'">asr</xsl:when>
                    <xsl:when test="$lccn = 'sh2006006711'">kib</xsl:when>
                    <xsl:when test="$lccn = 'sh2006006710'">kya</xsl:when>
                    <xsl:when test="$lccn = 'sh85073288'">kri</xsl:when>
                    <xsl:when test="$lccn = 'sh91001628'">rma</xsl:when>
                    <xsl:when test="$lccn = 'sh85080225'">mjt</xsl:when>
                    <xsl:when test="$lccn = 'sh85145396'">kmo</xsl:when>
                    <xsl:when test="$lccn = 'sh85062991'">hum</xsl:when>
                    <xsl:when test="$lccn = 'sh85080228'">mlu</xsl:when>
                    <xsl:when test="$lccn = 'sh85091670'">ung</xsl:when>
                    <xsl:when test="$lccn = 'sh85096957'">plq</xsl:when>
                    <xsl:when test="$lccn = 'sh85091676'">nbm</xsl:when>
                    <xsl:when test="$lccn = 'sh93008728'">unr</xsl:when>
                    <xsl:when test="$lccn = 'sh85062997'">hun</xsl:when>
                    <xsl:when test="$lccn = 'sh85079488'">mbc</xsl:when>
                    <xsl:when test="$lccn = 'sh94005161'">idd</xsl:when>
                    <xsl:when test="$lccn = 'sh94005162'">ozm</xsl:when>
                    <xsl:when test="$lccn = 'sh85035792'">dhr</xsl:when>
                    <xsl:when test="$lccn = 'sh85035793'">dar</xsl:when>
                    <xsl:when test="$lccn = 'sh85073983'">cnh</xsl:when>
                    <xsl:when test="$lccn = 'sh85070980'">bdy</xsl:when>
                    <xsl:when test="$lccn = 'sh85070987'">jbu</xsl:when>
                    <xsl:when test="$lccn = 'sh85015373'">bli</xsl:when>
                    <xsl:when test="$lccn = 'sh85012177'">bsc</xsl:when>
                    <xsl:when test="$lccn = 'sh92004530'">djk</xsl:when>
                    <xsl:when test="$lccn = 'sh92004531'">kea</xsl:when>
                    <xsl:when test="$lccn = 'sh92005005'">wtw</xsl:when>
                    <xsl:when test="$lccn = 'sh85024693'">cce</xsl:when>
                    <xsl:when test="$lccn = 'sh85138356'">tsc</xsl:when>
                    <xsl:when test="$lccn = 'sh98003392'">teu</xsl:when>
                    <xsl:when test="$lccn = 'sh2004007547'">wkw</xsl:when>
                    <xsl:when test="$lccn = 'sh85132788'">aoc</xsl:when>
                    <xsl:when test="$lccn = 'sh85071587'">kdr</xsl:when>
                    <xsl:when test="$lccn = 'sh85071582'">krc</xsl:when>
                    <xsl:when test="$lccn = 'sh86002220'">mxx</xsl:when>
                    <xsl:when test="$lccn = 'sh85113139'">rgr</xsl:when>
                    <xsl:when test="$lccn = 'sh93008437'">btz</xsl:when>
                    <xsl:when test="$lccn = 'sh85047169'">fat</xsl:when>
                    <xsl:when test="$lccn = 'sh86004487'">wnu</xsl:when>
                    <xsl:when test="$lccn = 'sh85071214'">kbd</xsl:when>
                    <xsl:when test="$lccn = 'sh85071745'">ktw</xsl:when>
                    <xsl:when test="$lccn = 'sh85080421'">mfi</xsl:when>
                    <xsl:when test="$lccn = 'sh85112848'">ren</xsl:when>
                    <xsl:when test="$lccn = 'sh85142440'">vay</xsl:when>
                    <xsl:when test="$lccn = 'sh85148923'">yaz</xsl:when>
                    <xsl:when test="$lccn = 'sh85024439'">cax</xsl:when>
                    <xsl:when test="$lccn = 'sh91006080'">khb</xsl:when>
                    <xsl:when test="$lccn = 'sh85023193'">chy</xsl:when>
                    <xsl:when test="$lccn = 'sh97008886'">ify</xsl:when>
                    <xsl:when test="$lccn = 'sh97008884'">kak</xsl:when>
                    <xsl:when test="$lccn = 'sh85071561'">kdk</xsl:when>
                    <xsl:when test="$lccn = 'sh90002823'">fil</xsl:when>
                    <xsl:when test="$lccn = 'sh97004074'">mqt</xsl:when>
                    <xsl:when test="$lccn = 'sh92005134'">lis</xsl:when>
                    <xsl:when test="$lccn = 'sh97003086'">ady</xsl:when>
                    <xsl:when test="$lccn = 'sh86004730'">mzb</xsl:when>
                    <xsl:when test="$lccn = 'sh85079486'">myy</xsl:when>
                    <xsl:when test="$lccn = 'sh85016374'">bra</xsl:when>
                    <xsl:when test="$lccn = 'sh85079483'">mbr</xsl:when>
                    <xsl:when test="$lccn = 'sh92004849'">cnk</xsl:when>
                    <xsl:when test="$lccn = 'sh85081684'">mwr</xsl:when>
                    <xsl:when test="$lccn = 'sh2008000738'">abz</xsl:when>
                    <xsl:when test="$lccn = 'sh85089559'">nak</xsl:when>
                    <xsl:when test="$lccn = 'sh85078172'">lom</xsl:when>
                    <xsl:when test="$lccn = 'sh85078177'">lmo</xsl:when>
                    <xsl:when test="$lccn = 'sh85117724'">saz</xsl:when>
                    <xsl:when test="$lccn = 'sh85097195'">pli</xsl:when>
                    <xsl:when test="$lccn = 'sh85023289'">cic</xsl:when>
                    <xsl:when test="$lccn = 'sh87002872'">zkt</xsl:when>
                    <xsl:when test="$lccn = 'sh85117723'">psu</xsl:when>
                    <xsl:when test="$lccn = 'sh85012070'">bak</xsl:when>
                    <xsl:when test="$lccn = 'sh85074270'">ljp</xsl:when>
                    <xsl:when test="$lccn = 'sh2008003640'">bqh</xsl:when>
                    <xsl:when test="$lccn = 'sh86007780'">syb</xsl:when>
                    <xsl:when test="$lccn = 'sh85092018'">kib</xsl:when>
                    <xsl:when test="$lccn = 'sh98007129'">nfr</xsl:when>
                    <xsl:when test="$lccn = 'sh85131922'">tah</xsl:when>
                    <xsl:when test="$lccn = 'sh91003701'">bww</xsl:when>
                    <xsl:when test="$lccn = 'sh91003700'">bmq</xsl:when>
                    <xsl:when test="$lccn = 'sh85098891'">paw</xsl:when>
                    <xsl:when test="$lccn = 'sh85131896'">klg</xsl:when>
                    <xsl:when test="$lccn = 'sh85087244'">mos</xsl:when>
                    <xsl:when test="$lccn = 'sh85097283'">pam</xsl:when>
                    <xsl:when test="$lccn = 'sh85138323'">xmw</xsl:when>
                    <xsl:when test="$lccn = 'sh85058781'">hnn</xsl:when>
                    <xsl:when test="$lccn = 'sh85013101'">bef</xsl:when>
                    <xsl:when test="$lccn = 'sh85131891'">ncz</xsl:when>
                    <xsl:when test="$lccn = 'sh96009858'">vma</xsl:when>
                    <xsl:when test="$lccn = 'sh85071365'">xal</xsl:when>
                    <xsl:when test="$lccn = 'sh85012453'">brg</xsl:when>
                    <xsl:when test="$lccn = 'sh85138328'">tsv</xsl:when>
                    <xsl:when test="$lccn = 'sh85018133'">mya</xsl:when>
                    <xsl:when test="$lccn = 'sh91004842'">sdp</xsl:when>
                    <xsl:when test="$lccn = 'sh85135754'">tlb</xsl:when>
                    <xsl:when test="$lccn = 'sh85135827'">tpi</xsl:when>
                    <xsl:when test="$lccn = 'sh86007738'">nco</xsl:when>
                    <xsl:when test="$lccn = 'sh97005106'">ahr</xsl:when>
                    <xsl:when test="$lccn = 'sh2007010852'">knw</xsl:when>
                    <xsl:when test="$lccn = 'sh90004650'">loy</xsl:when>
                    <xsl:when test="$lccn = 'sh85138695'">tpw</xsl:when>
                    <xsl:when test="$lccn = 'sh85146070'">cym</xsl:when>
                    <xsl:when test="$lccn = 'sh93007629'">snp</xsl:when>
                    <xsl:when test="$lccn = 'sh85022480'">toj</xsl:when>
                    <xsl:when test="$lccn = 'sh85055993'">got</xsl:when>
                    <xsl:when test="$lccn = 'sh85038696'">dob</xsl:when>
                    <xsl:when test="$lccn = 'sh85102488'">pih</xsl:when>
                    <xsl:when test="$lccn = 'sh2005006681'">ida</xsl:when>
                    <xsl:when test="$lccn = 'sh85135332'">lax</xsl:when>
                    <xsl:when test="$lccn = 'sh97008084'">ivb</xsl:when>
                    <xsl:when test="$lccn = 'sh85043413'">eng</xsl:when>
                    <xsl:when test="$lccn = 'sh92001345'">pse</xsl:when>
                    <xsl:when test="$lccn = 'sh93006287'">xsi</xsl:when>
                    <xsl:when test="$lccn = 'sh2001004523'">kay</xsl:when>
                    <xsl:when test="$lccn = 'sh93006284'">lid</xsl:when>
                    <xsl:when test="$lccn = 'sh98005034'">uvl</xsl:when>
                    <xsl:when test="$lccn = 'sh85011835'">nrb</xsl:when>
                    <xsl:when test="$lccn = 'sh85069645'">ojp</xsl:when>
                    <xsl:when test="$lccn = 'sh98003899'">orz</xsl:when>
                    <xsl:when test="$lccn = 'sh85097281'">pue</xsl:when>
                    <xsl:when test="$lccn = 'sh88001812'">tkp</xsl:when>
                    <xsl:when test="$lccn = 'sh2002004857'">csg</xsl:when>
                    <xsl:when test="$lccn = 'sh85078309'">lnu</xsl:when>
                    <xsl:when test="$lccn = 'sh85085062'">mgi</xsl:when>
                    <xsl:when test="$lccn = 'sh85092722'">nor</xsl:when>
                    <xsl:when test="$lccn = 'sh2008001649'">bgd</xsl:when>
                    <xsl:when test="$lccn = 'sh92000635'">rmm</xsl:when>
                    <xsl:when test="$lccn = 'sh93006354'">mek</xsl:when>
                    <xsl:when test="$lccn = 'sh85032849'">cor</xsl:when>
                    <xsl:when test="$lccn = 'sh92000636'">mnb</xsl:when>
                    <xsl:when test="$lccn = 'sh86001613'">adj</xsl:when>
                    <xsl:when test="$lccn = 'sh85009160'">epi</xsl:when>
                    <xsl:when test="$lccn = 'sh85013250'">bue</xsl:when>
                    <xsl:when test="$lccn = 'sh85069643'">jpn</xsl:when>
                    <xsl:when test="$lccn = 'sh85046718'">izi</xsl:when>
                    <xsl:when test="$lccn = 'sh85105344'">por</xsl:when>
                    <xsl:when test="$lccn = 'sh87007203'">kyz</xsl:when>
                    <xsl:when test="$lccn = 'sh87007202'">ktn</xsl:when>
                    <xsl:when test="$lccn = 'sh85005843'">any</xsl:when>
                    <xsl:when test="$lccn = 'sh87007200'">kmh</xsl:when>
                    <xsl:when test="$lccn = 'sh85121441'">shk</xsl:when>
                    <xsl:when test="$lccn = 'sh85104296'">pol</xsl:when>
                    <xsl:when test="$lccn = 'sh85037254'">bgc</xsl:when>
                    <xsl:when test="$lccn = 'sh87007599'">tue</xsl:when>
                    <xsl:when test="$lccn = 'sh2007000116'">nfl</xsl:when>
                    <xsl:when test="$lccn = 'sh85085085'">mik</xsl:when>
                    <xsl:when test="$lccn = 'sh85018712'">kgk</xsl:when>
                    <xsl:when test="$lccn = 'sh2007001421'">bdp</xsl:when>
                    <xsl:when test="$lccn = 'sh87000798'">mfa</xsl:when>
                    <xsl:when test="$lccn = 'sh85149668'">zap</xsl:when>
                    <xsl:when test="$lccn = 'sh91004820'">nst</xsl:when>
                    <xsl:when test="$lccn = 'sh85093297'">nup</xsl:when>
                    <xsl:when test="$lccn = 'sh85093295'">xsm</xsl:when>
                    <xsl:when test="$lccn = 'sh95004839'">dow</xsl:when>
                    <xsl:when test="$lccn = 'sh2004003259'">mos</xsl:when>
                    <xsl:when test="$lccn = 'sh85076967'">kck</xsl:when>
                    <xsl:when test="$lccn = 'sh85000189'">adi</xsl:when>
                    <xsl:when test="$lccn = 'sh85009040'">ppt</xsl:when>
                    <xsl:when test="$lccn = 'sh88001780'">hei</xsl:when>
                    <xsl:when test="$lccn = 'sh2002011353'">chw</xsl:when>
                    <xsl:when test="$lccn = 'sh85130456'">sum</xsl:when>
                    <xsl:when test="$lccn = 'sh85052643'">gaa</xsl:when>
                    <xsl:when test="$lccn = 'sh85052641'">gwj</xsl:when>
                    <xsl:when test="$lccn = 'sh85122803'">snd</xsl:when>
                    <xsl:when test="$lccn = 'sh85091650'">nez</xsl:when>
                    <xsl:when test="$lccn = 'sh87000662'">mui</xsl:when>
                    <xsl:when test="$lccn = 'sh85115394'">rro</xsl:when>
                    <xsl:when test="$lccn = 'sh85120069'">sef</xsl:when>
                    <xsl:when test="$lccn = 'sh85125037'">sop</xsl:when>
                    <xsl:when test="$lccn = 'sh85115623'">kin</xsl:when>
                    <xsl:when test="$lccn = 'sh85120060'">set</xsl:when>
                    <xsl:when test="$lccn = 'sh85009433'">avt</xsl:when>
                    <xsl:when test="$lccn = 'sh2002007163'">xsy</xsl:when>
                    <xsl:when test="$lccn = 'sh85080902'">zmr</xsl:when>
                    <xsl:when test="$lccn = 'sh94005378'">pif</xsl:when>
                    <xsl:when test="$lccn = 'sh85073088'">kor</xsl:when>
                    <xsl:when test="$lccn = 'sh85073089'">oko</xsl:when>
                    <xsl:when test="$lccn = 'sh85001761'">afh</xsl:when>
                    <xsl:when test="$lccn = 'sh85035410'">dal</xsl:when>
                    <xsl:when test="$lccn = 'sh85067933'">irn</xsl:when>
                    <xsl:when test="$lccn = 'sh85011534'">bnx</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006062'">nep</xsl:when>
                    <xsl:when test="$lccn = 'sh2003006063'">jaq</xsl:when>
                    <xsl:when test="$lccn = 'sh85088335'">mpb</xsl:when>
                    <xsl:when test="$lccn = 'sh85148822'">xho</xsl:when>
                    <xsl:when test="$lccn = 'sh85142644'">xve</xsl:when>
                    <xsl:when test="$lccn = 'sh85109853'">qui</xsl:when>
                    <xsl:when test="$lccn = 'sh87007979'">iby</xsl:when>
                    <xsl:when test="$lccn = 'sh87007978'">dhm</xsl:when>
                    <xsl:when test="$lccn = 'sh85141605'">ute</xsl:when>
                    <xsl:when test="$lccn = 'sh85144472'">mug</xsl:when>
                    <xsl:when test="$lccn = 'sh85098093'">pci</xsl:when>
                    <xsl:when test="$lccn = 'sh85025002'">crw</xsl:when>
                    <xsl:when test="$lccn = 'sh2008005166'">lsi</xsl:when>
                    <xsl:when test="$lccn = 'sh85062727'">yuf</xsl:when>
                    <xsl:when test="$lccn = 'sh85090465'">ncu</xsl:when>
                    <xsl:when test="$lccn = 'sh00008820'">stv</xsl:when>
                    <xsl:when test="$lccn = 'sh85073554'">kws</xsl:when>
                    <xsl:when test="$lccn = 'sh85073552'">goa</xsl:when>
                    <xsl:when test="$lccn = 'sh85073553'">kwe</xsl:when>
                    <xsl:when test="$lccn = 'sh00008826'">haq</xsl:when>
                    <xsl:when test="$lccn = 'sh85021542'">cav</xsl:when>
                    <xsl:when test="$lccn = 'sh85000564'">ach</xsl:when>
                    <xsl:when test="$lccn = 'sh85000567'">kjq</xsl:when>
                    <xsl:when test="$lccn = 'sh98004935'">bjn</xsl:when>
                    <xsl:when test="$lccn = 'sh85057683'">gde</xsl:when>
                    <xsl:when test="$lccn = 'sh85011404'">baa</xsl:when>
                    <xsl:when test="$lccn = 'sh85011402'">bam</xsl:when>
                    <xsl:when test="$lccn = 'sh85080236'">mup</xsl:when>
                    <xsl:when test="$lccn = 'sh85046045'">ewe</xsl:when>
                    <xsl:when test="$lccn = 'sh99010735'">quv</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003176'">yer</xsl:when>
                    <xsl:when test="$lccn = 'sh85147201'">wob</xsl:when>
                    <xsl:when test="$lccn = 'sh85035784'">dry</xsl:when>
                    <xsl:when test="$lccn = 'sh94005172'">yal</xsl:when>
                    <xsl:when test="$lccn = 'sh92002285'">prx</xsl:when>
                    <xsl:when test="$lccn = 'sh2008006683'">koo</xsl:when>
                    <xsl:when test="$lccn = 'sh85095742'">okv</xsl:when>
                    <xsl:when test="$lccn = 'sh85095741'">oaa</xsl:when>
                    <xsl:when test="$lccn = 'sh95009944'">los</xsl:when>
                    <xsl:when test="$lccn = 'sh85025754'">chu</xsl:when>
                    <xsl:when test="$lccn = 'sh2001005737'">diz</xsl:when>
                    <xsl:when test="$lccn = 'sh99004934'">xkv</xsl:when>
                    <xsl:when test="$lccn = 'sh85136055'">ttj</xsl:when>
                    <xsl:when test="$lccn = 'sh85004939'">anz</xsl:when>
                    <xsl:when test="$lccn = 'sh85079567'">mag</xsl:when>
                    <xsl:when test="$lccn = 'sh85080432'">sbb</xsl:when>
                    <xsl:when test="$lccn = 'sh85080431'">mjl</xsl:when>
                    <xsl:when test="$lccn = 'sh85149074'">mch</xsl:when>
                    <xsl:when test="$lccn = 'sh85011715'">bci</xsl:when>
                    <xsl:when test="$lccn = 'sh85149071'">yor</xsl:when>
                    <xsl:when test="$lccn = 'sh85101462'">pht</xsl:when>
                    <xsl:when test="$lccn = 'sh85050483'">for</xsl:when>
                    <xsl:when test="$lccn = 'sh85071771'">ahk</xsl:when>
                    <xsl:when test="$lccn = 'sh98003426'">mxl</xsl:when>
                    <xsl:when test="$lccn = 'sh85112857'">mnv</xsl:when>
                    <xsl:when test="$lccn = 'sh85112851'">nre</xsl:when>
                    <xsl:when test="$lccn = 'sh85011086'">bqi</xsl:when>
                    <xsl:when test="$lccn = 'sh85097451'">pan</xsl:when>
                    <xsl:when test="$lccn = 'sh97001837'">moj</xsl:when>
                    <xsl:when test="$lccn = 'sh97001836'">zga</xsl:when>
                    <xsl:when test="$lccn = 'sh86007831'">grc</xsl:when>
                    <xsl:when test="$lccn = 'sh85071556'">kpg</xsl:when>
                    <xsl:when test="$lccn = 'sh85074505'">lno</xsl:when>
                    <xsl:when test="$lccn = 'sh85071552'">hmt</xsl:when>
                    <xsl:when test="$lccn = 'sh2008000691'">jur</xsl:when>
                    <xsl:when test="$lccn = 'sh85122756'">smt</xsl:when>
                    <xsl:when test="$lccn = 'sh94005357'">zmu</xsl:when>
                    <xsl:when test="$lccn = 'sh00007431'">sum</xsl:when>
                    <xsl:when test="$lccn = 'sh85148905'">yai</xsl:when>
                    <xsl:when test="$lccn = 'sh85131958'">tnq</xsl:when>
                    <xsl:when test="$lccn = 'sh97003091'">coq</xsl:when>
                    <xsl:when test="$lccn = 'sh94000075'">ngm</xsl:when>
                    <xsl:when test="$lccn = 'sh85117005'">wrz</xsl:when>
                    <xsl:when test="$lccn = 'sh91006169'">knk</xsl:when>
                    <xsl:when test="$lccn = 'sh85071484'">kan</xsl:when>
                    <xsl:when test="$lccn = 'sh93009065'">lbx</xsl:when>
                    <xsl:when test="$lccn = 'sh85058822'">har</xsl:when>
                    <xsl:when test="$lccn = 'sh85097529'">zpw</xsl:when>
                    <xsl:when test="$lccn = 'sh85058824'">hoj</xsl:when>
                    <xsl:when test="$lccn = 'sh85089520'">vah</xsl:when>
                    <xsl:when test="$lccn = 'sh93008789'">bsb</xsl:when>
                    <xsl:when test="$lccn = 'sh92004855'">ded</xsl:when>
                    <xsl:when test="$lccn = 'sh85015565'">bob</xsl:when>
                    <xsl:when test="$lccn = 'sh85015564'">bpu</xsl:when>
                    <xsl:when test="$lccn = 'sh85015563'">bot</xsl:when>
                    <xsl:when test="$lccn = 'sh92004850'">boj</xsl:when>
                    <xsl:when test="$lccn = 'sh86004582'">mxj</xsl:when>
                    <xsl:when test="$lccn = 'sh85022814'">che</xsl:when>
                    <xsl:when test="$lccn = 'sh85012064'">bsh</xsl:when>
                    <xsl:when test="$lccn = 'sh2008030084'">nct</xsl:when>
                    <xsl:when test="$lccn = 'sh87001708'">dap</xsl:when>
                    <xsl:when test="$lccn = 'sh85012068'">bak</xsl:when>
                    <xsl:when test="$lccn = 'sh2008030083'">rav</xsl:when>
                    <xsl:when test="$lccn = 'sh85057929'">gyf</xsl:when>
                    <xsl:when test="$lccn = 'sh85092008'">ojc</xsl:when>
                    <xsl:when test="$lccn = 'sh95004387'">tyn</xsl:when>
                    <xsl:when test="$lccn = 'sh85132190'">tam</xsl:when>
                    <xsl:when test="$lccn = 'sh85083242'">med</xsl:when>
                    <xsl:when test="$lccn = 'sh2006004882'">buw</xsl:when>
                    <xsl:when test="$lccn = 'sh85068765'">ruo</xsl:when>
                    <xsl:when test="$lccn = 'sh86004279'">tnm</xsl:when>
                    <xsl:when test="$lccn = 'sh85098883'">bns</xsl:when>
                    <xsl:when test="$lccn = 'sh85098882'">pwa</xsl:when>
                    <xsl:when test="$lccn = 'sh98003739'">bhz</xsl:when>
                    <xsl:when test="$lccn = 'sh85071393'">xbr</xsl:when>
                    <xsl:when test="$lccn = 'sh85053008'">lug</xsl:when>
                    <xsl:when test="$lccn = 'sh85071391'">kam</xsl:when>
                    <xsl:when test="$lccn = 'sh85071395'">itl</xsl:when>
                    <xsl:when test="$lccn = 'sh87004493'">mnb</xsl:when>
                    <xsl:when test="$lccn = 'sh85109155'">puq</xsl:when>
                    <xsl:when test="$lccn = 'sh85087476'">miq</xsl:when>
                    <xsl:when test="$lccn = 'sh85123835'">tlv</xsl:when>
                    <xsl:when test="$lccn = 'sh85075698'">lef</xsl:when>
                    <xsl:when test="$lccn = 'sh85135980'">toh</xsl:when>
                    <xsl:when test="$lccn = 'sh85135981'">tog</xsl:when>
                    <xsl:when test="$lccn = 'sh85135982'">ton</xsl:when>
                    <xsl:when test="$lccn = 'sh85121179'">sjw</xsl:when>
                    <xsl:when test="$lccn = 'sh88007043'">ump</xsl:when>
                    <xsl:when test="$lccn = 'sh85135761'">bud</xsl:when>
                    <xsl:when test="$lccn = 'sh85072619'">kla</xsl:when>
                    <xsl:when test="$lccn = 'sh85097279'">tav</xsl:when>
                    <xsl:when test="$lccn = 'sh2001008087'">jao</xsl:when>
                    <xsl:when test="$lccn = 'sh98003592'">csk</xsl:when>
                    <xsl:when test="$lccn = 'sh85083909'">apm</xsl:when>
                    <xsl:when test="$lccn = 'sh85116194'">srl</xsl:when>
                    <xsl:when test="$lccn = 'sh85055690'">gol</xsl:when>
                    <xsl:when test="$lccn = 'sh85057858'">guj</xsl:when>
                    <xsl:when test="$lccn = 'sh95010794'">mrn</xsl:when>
                    <xsl:when test="$lccn = 'sh85149044'">yuf</xsl:when>
                    <xsl:when test="$lccn = 'sh85003047'">aka</xsl:when>
                    <xsl:when test="$lccn = 'sh85149692'">sgl</xsl:when>
                    <xsl:when test="$lccn = 'sh85124757'">som</xsl:when>
                    <xsl:when test="$lccn = 'sh2004006628'">raf</xsl:when>
                    <xsl:when test="$lccn = 'sh88000337'">pwn</xsl:when>
                    <xsl:when test="$lccn = 'sh85053576'">ubu</xsl:when>
                    <xsl:when test="$lccn = 'sh85082198'">mat</xsl:when>
                    <xsl:when test="$lccn = 'sh85019869'">kaq</xsl:when>
                    <xsl:when test="$lccn = 'sh85109872'">qun</xsl:when>
                    <xsl:when test="$lccn = 'sh85072053'">kvr</xsl:when>
                    <xsl:when test="$lccn = 'sh92001354'">abs</xsl:when>
                    <xsl:when test="$lccn = 'sh85078962'">khl</xsl:when>
                    <xsl:when test="$lccn = 'sh85072299'">cgg</xsl:when>
                    <xsl:when test="$lccn = 'sh90005924'">onb</xsl:when>
                    <xsl:when test="$lccn = 'sh85116991'">sam</xsl:when>
                    <xsl:when test="$lccn = 'sh85018097'">bji</xsl:when>
                    <xsl:when test="$lccn = 'sh2008000834'">zkr</xsl:when>
                    <xsl:when test="$lccn = 'sh2002005317'">wuv</xsl:when>
                    <xsl:when test="$lccn = 'sh87000529'">tbt</xsl:when>
                    <xsl:when test="$lccn = 'sh85124662'">sle</xsl:when>
                    <xsl:when test="$lccn = 'sh91003113'">ncb</xsl:when>
                    <xsl:when test="$lccn = 'sh98002463'">inm</xsl:when>
                    <xsl:when test="$lccn = 'sh85068101'">gle</xsl:when>
                    <xsl:when test="$lccn = 'sh85006306'">ara</xsl:when>
                    <xsl:when test="$lccn = 'sh2008001653'">duh</xsl:when>
                    <xsl:when test="$lccn = 'sh2008001655'">mhe</xsl:when>
                    <xsl:when test="$lccn = 'sh92000179'">log</xsl:when>
                    <xsl:when test="$lccn = 'sh91005457'">kdm</xsl:when>
                    <xsl:when test="$lccn = 'sh91003333'">tgo</xsl:when>
                    <xsl:when test="$lccn = 'sh85079963'">mwm</xsl:when>
                    <xsl:when test="$lccn = 'sh85047098'">fan</xsl:when>
                    <xsl:when test="$lccn = 'sh93006388'">yyu</xsl:when>
                    <xsl:when test="$lccn = 'sh85075973'">len</xsl:when>
                    <xsl:when test="$lccn = 'sh85052696'">gaj</xsl:when>
                    <xsl:when test="$lccn = 'sh2008005826'">yec</xsl:when>
                    <xsl:when test="$lccn = 'sh85144860'">wbp</xsl:when>
                    <xsl:when test="$lccn = 'sh85076373'">lez</xsl:when>
                    <xsl:when test="$lccn = 'sh95001065'">cks</xsl:when>
                    <xsl:when test="$lccn = 'sh85135968'">tdn</xsl:when>
                    <xsl:when test="$lccn = 'sh85143298'">vie</xsl:when>
                    <xsl:when test="$lccn = 'sh85063961'">arh</xsl:when>
                    <xsl:when test="$lccn = 'sh85055238'">glw</xsl:when>
                    <xsl:when test="$lccn = 'sh85149678'">dje</xsl:when>
                    <xsl:when test="$lccn = 'sh85146646'">wim</xsl:when>
                    <xsl:when test="$lccn = 'sh85092825'">nou</xsl:when>
                    <xsl:when test="$lccn = 'sh85071467'">xnr</xsl:when>
                    <xsl:when test="$lccn = 'sh00003985'">mtm</xsl:when>
                    <xsl:when test="$lccn = 'sh87006565'">ann</xsl:when>
                    <xsl:when test="$lccn = 'sh98004856'">nzs</xsl:when>
                    <xsl:when test="$lccn = 'sh97001480'">psr</xsl:when>
                    <xsl:when test="$lccn = 'sh85071661'">btx</xsl:when>
                    <xsl:when test="$lccn = 'sh85149514'">omc</xsl:when>
                    <xsl:when test="$lccn = 'sh85149518'">yup</xsl:when>
                    <xsl:when test="$lccn = 'sh85009404'">ati</xsl:when>
                    <xsl:when test="$lccn = 'sh85071254'">kbr</xsl:when>
                    <xsl:when test="$lccn = 'sh85084691'">crg</xsl:when>
                    <xsl:when test="$lccn = 'sh93004861'">mbn</xsl:when>
                    <xsl:when test="$lccn = 'sh85013993'">rwr</xsl:when>
                    <xsl:when test="$lccn = 'sh85119885'">pse</xsl:when>
                    <xsl:when test="$lccn = 'sh85110829'">roh</xsl:when>
                    <xsl:when test="$lccn = 'sh99004230'">kgr</xsl:when>
                    <xsl:when test="$lccn = 'sh85073090'">okm</xsl:when>
                    <xsl:when test="$lccn = 'sh93004601'">alo</xsl:when>
                    <xsl:when test="$lccn = 'sh85013996'">bik</xsl:when>
                    <xsl:when test="$lccn = 'sh85060627'">hid</xsl:when>
                    <xsl:when test="$lccn = 'sh85141297'">ura</xsl:when>
                    <xsl:when test="$lccn = 'sh97006206'">mui</xsl:when>
                    <xsl:when test="$lccn = 'sh85097353'">pbh</xsl:when>
                    <xsl:when test="$lccn = 'sh92003270'">bhq</xsl:when>
                    <xsl:when test="$lccn = 'sh85071814'">kaz</xsl:when>
                    <xsl:when test="$lccn = 'sh85021246'">cto</xsl:when>
                    <xsl:when test="$lccn = 'sh85080334'">mcq</xsl:when>
                    <xsl:when test="$lccn = 'sh93004599'">kbk</xsl:when>
                    <xsl:when test="$lccn = 'sh93004598'">bpp</xsl:when>
                    <xsl:when test="$lccn = 'sh87002309'">jmd</xsl:when>
                    <xsl:when test="$lccn = 'sh85037445'">dhi</xsl:when>
                    <xsl:when test="$lccn = 'sh85034799'">cuk</xsl:when>
                    <xsl:when test="$lccn = 'sh85005897'">apy</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002901'">tmn</xsl:when>
                    <xsl:when test="$lccn = 'sh85081087'">gvf</xsl:when>
                    <xsl:when test="$lccn = 'sh85076978'">lil</xsl:when>
                    <xsl:when test="$lccn = 'sh85081083'">mrc</xsl:when>
                    <xsl:when test="$lccn = 'sh85073435'">kun</xsl:when>
                    <xsl:when test="$lccn = 'sh85073434'">knn</xsl:when>
                    <xsl:when test="$lccn = 'sh2008002689'">ngh</xsl:when>
                    <xsl:when test="$lccn = 'sh85082832'">xme</xsl:when>
                    <xsl:when test="$lccn = 'sh85073430'">kum</xsl:when>
                    <xsl:when test="$lccn = 'sh00003103'">gia</xsl:when>
                    <xsl:when test="$lccn = 'sh00003107'">hrv</xsl:when>
                    <xsl:when test="$lccn = 'sh00003105'">bos</xsl:when>
                    <xsl:when test="$lccn = 'sh85073542'">kwk</xsl:when>
                    <xsl:when test="$lccn = 'sh92006130'">cfm</xsl:when>
                    <xsl:when test="$lccn = 'sh85098666'">ptp</xsl:when>
                    <xsl:when test="$lccn = 'sh00003109'">srp</xsl:when>
                    <xsl:when test="$lccn = 'sh85092723'">nno</xsl:when>
                    <xsl:when test="$lccn = 'sh85021555'">txu</xsl:when>
                    <xsl:when test="$lccn = 'sh85040628'">yuy</xsl:when>
                    <xsl:when test="$lccn = 'sh85114051'">rif</xsl:when>
                    <xsl:when test="$lccn = 'sh85078778'">vil</xsl:when>
                    <xsl:when test="$lccn = 'sh85078771'">lui</xsl:when>
                    <xsl:when test="$lccn = 'sh85073375'">kxu</xsl:when>
                    <xsl:when test="$lccn = 'sh88001958'">ybe</xsl:when>
                    <xsl:when test="$lccn = 'sh85115504'">roo</xsl:when>
                    <xsl:when test="$lccn = 'sh85000795'">ada</xsl:when>
                    <xsl:when test="$lccn = 'sh85083973'">cms</xsl:when>
                    <xsl:when test="$lccn = 'sh85046052'">ewo</xsl:when>
                    <xsl:when test="$lccn = 'sh85052296'">fun</xsl:when>
                    <xsl:when test="$lccn = 'sh85088210'">mye</xsl:when>
                    <xsl:when test="$lccn = 'sh85078752'">lud</xsl:when>
                    <xsl:when test="$lccn = 'sh85079631'">mdh</xsl:when>
                    <xsl:when test="$lccn = 'sh85053584'">gay</xsl:when>
                    <xsl:when test="$lccn = 'sh2007000669'">lki</xsl:when>
                    <xsl:when test="$lccn = 'sh96001688'">rab</xsl:when>
                    <xsl:when test="$lccn = 'sh85010924'">pbp</xsl:when>
                    <xsl:when test="$lccn = 'sh2003005810'">ndt</xsl:when>
                    <xsl:when test="$lccn = 'sh85121128'">mcd</xsl:when>
                    <xsl:when test="$lccn = 'sh85015179'">bni</xsl:when>
                    <xsl:when test="$lccn = 'sh96001668'">txx</xsl:when>
                    <xsl:when test="$lccn = 'sh92005029'">nmf</xsl:when>
                    <xsl:when test="$lccn = 'sh96000247'">mgr</xsl:when>
                    <xsl:when test="$lccn = 'sh2007008482'">mpe</xsl:when>
                    <xsl:when test="$lccn = 'sh85122160'">sgh</xsl:when>
                    <xsl:when test="$lccn = 'sh85015355'">adi</xsl:when>
                    <xsl:when test="$lccn = 'sh85011389'">bal</xsl:when>
                    <xsl:when test="$lccn = 'sh96000248'">mgr</xsl:when>
                    <xsl:when test="$lccn = 'sh85067877'">apu</xsl:when>
                    <xsl:when test="$lccn = 'sh85078706'">lub</xsl:when>
                    <xsl:when test="$lccn = 'sh94004161'">nnm</xsl:when>
                    <xsl:when test="$lccn = 'sh94004160'">amn</xsl:when>
                    <xsl:when test="$lccn = 'sh85035755'">sip</xsl:when>
                    <xsl:when test="$lccn = 'sh85079555'">mad</xsl:when>
                    <xsl:when test="$lccn = 'sh85057587'">gnc</xsl:when>
                    <xsl:when test="$lccn = 'sh85057586'">gvc</xsl:when>
                    <xsl:when test="$lccn = 'sh85061535'">hoo</xsl:when>
                    <xsl:when test="$lccn = 'sh2008000918'">khr</xsl:when>
                    <xsl:when test="$lccn = 'sh85080445'">mfv</xsl:when>
                    <xsl:when test="$lccn = 'sh91001634'">cal</xsl:when>
                    <xsl:when test="$lccn = 'sh85087319'">ayo</xsl:when>
                    <xsl:when test="$lccn = 'sh97000756'">niy</xsl:when>
                    <xsl:when test="$lccn = 'sh85145287'">wba</xsl:when>
                    <xsl:when test="$lccn = 'sh85011099'">bss</xsl:when>
                    <xsl:when test="$lccn = 'sh2007000865'">err</xsl:when>
                    <xsl:when test="$lccn = 'sh85073893'">lad</xsl:when>
                    <xsl:when test="$lccn = 'sh85090323'">nau</xsl:when>
                    <xsl:when test="$lccn = 'sh85074998'">lot</xsl:when>
                    <xsl:when test="$lccn = 'sh85142421'">frp</xsl:when>
                    <xsl:when test="$lccn = 'sh85077647'">lit</xsl:when>
                    <xsl:when test="$lccn = 'sh97001806'">bdm</xsl:when>
                    <xsl:when test="$lccn = 'sh85024417'">chp</xsl:when>
                    <xsl:when test="$lccn = 'sh85071545'">kqn</xsl:when>
                    <xsl:when test="$lccn = 'sh85148937'">sah</xsl:when>
                    <xsl:when test="$lccn = 'sh87004150'">blf</xsl:when>
                    <xsl:when test="$lccn = 'sh85086840'">mjg</xsl:when>
                    <xsl:when test="$lccn = 'sh2004009499'">uun</xsl:when>
                    <xsl:when test="$lccn = 'sh92005119'">mux</xsl:when>
                    <xsl:when test="$lccn = 'sh2008000712'">omi</xsl:when>
                    <xsl:when test="$lccn = 'sh90005384'">rgk</xsl:when>
                    <xsl:when test="$lccn = 'sh92005116'">imo</xsl:when>
                    <xsl:when test="$lccn = 'sh85092903'">nov</xsl:when>
                    <xsl:when test="$lccn = 'sh85080605'">mev</xsl:when>
                    <xsl:when test="$lccn = 'sh85117030'">smq</xsl:when>
                    <xsl:when test="$lccn = 'sh2008000710'">suh</xsl:when>
                    <xsl:when test="$lccn = 'sh85117034'">smo</xsl:when>
                    <xsl:when test="$lccn = 'sh2004007039'">snp</xsl:when>
                    <xsl:when test="$lccn = 'sh94000048'">gvs</xsl:when>
                    <xsl:when test="$lccn = 'sh86004221'">lae</xsl:when>
                    <xsl:when test="$lccn = 'sh86004223'">lbf</xsl:when>
                    <xsl:when test="$lccn = 'sh85075013'">lav</xsl:when>
                    <xsl:when test="$lccn = 'sh85053163'">gbm</xsl:when>
                    <xsl:when test="$lccn = 'sh92004867'">mmx</xsl:when>
                    <xsl:when test="$lccn = 'sh92004868'">mna</xsl:when>
                    <xsl:when test="$lccn = 'sh92004869'">mbh</xsl:when>
                    <xsl:when test="$lccn = 'sh99013636'">nhu</xsl:when>
                    <xsl:when test="$lccn = 'sh85003855'">aes</xsl:when>
                    <xsl:when test="$lccn = 'sh85012012'">bas</xsl:when>
                    <xsl:when test="$lccn = 'sh94004900'">bfi</xsl:when>
                    <xsl:when test="$lccn = 'sh86004912'">sjl</xsl:when>
                    <xsl:when test="$lccn = 'sh85092031'">ncg</xsl:when>
                    <xsl:when test="$lccn = 'sh85092033'">lut</xsl:when>
                    <xsl:when test="$lccn = 'sh85074607'">oci</xsl:when>
                    <xsl:when test="$lccn = 'sh92004882'">aoj</xsl:when>
                    <xsl:when test="$lccn = 'sh85079603'">aoe</xsl:when>
                    <xsl:when test="$lccn = 'sh90004184'">oua</xsl:when>
                    <xsl:when test="$lccn = 'sh85072868'">kpv</xsl:when>
                    <xsl:when test="$lccn = 'sh85087267'">mzq</xsl:when>
                    <xsl:when test="$lccn = 'sh92001900'">moz</xsl:when>
                    <xsl:when test="$lccn = 'sh85064248'">izi</xsl:when>
                    <xsl:when test="$lccn = 'sh85072861'">kom</xsl:when>
                    <xsl:when test="$lccn = 'sh2005002496'">bzg</xsl:when>
                    <xsl:when test="$lccn = 'sh85072863'">koi</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003426'">yut</xsl:when>
                    <xsl:when test="$lccn = 'sh85132743'">tat</xsl:when>
                    <xsl:when test="$lccn = 'sh86005267'">rej</xsl:when>
                    <xsl:when test="$lccn = 'sh88006898'">ifk</xsl:when>
                    <xsl:when test="$lccn = 'sh85071386'">kbq</xsl:when>
                    <xsl:when test="$lccn = 'sh85071389'">xas</xsl:when>
                    <xsl:when test="$lccn = 'sh85091671'">nrl</xsl:when>
                    <xsl:when test="$lccn = 'sh85069066'">ito</xsl:when>
                    <xsl:when test="$lccn = 'sh85138472'">tuo</xsl:when>
                    <xsl:when test="$lccn = 'sh85135774'">tcx</xsl:when>
                    <xsl:when test="$lccn = 'sh85134429'">tha</xsl:when>
                    <xsl:when test="$lccn = 'sh85138479'">tca</xsl:when>
                    <xsl:when test="$lccn = 'sh92004082'">zag</xsl:when>
                    <xsl:when test="$lccn = 'sh85148840'">huc</xsl:when>
                    <xsl:when test="$lccn = 'sh85072593'">ktu</xsl:when>
                    <xsl:when test="$lccn = 'sh2001004720'">uur</xsl:when>
                    <xsl:when test="$lccn = 'sh87000318'">smk</xsl:when>
                    <xsl:when test="$lccn = 'sh2008008072'">dsl</xsl:when>
                    <xsl:when test="$lccn = 'sh2008008071'">icl</xsl:when>
                    <xsl:when test="$lccn = 'sh85068628'">isd</xsl:when>
                    <xsl:when test="$lccn = 'sh85116186'">auc</xsl:when>
                    <xsl:when test="$lccn = 'sh00005428'">wiw</xsl:when>
                    <xsl:when test="$lccn = 'sh85092100'">niu</xsl:when>
                    <xsl:when test="$lccn = 'sh93002855'">kvr</xsl:when>
                    <xsl:when test="$lccn = 'sh85068623'">tix</xsl:when>
                    <xsl:when test="$lccn = 'sh85117218'">sad</xsl:when>
                    <xsl:when test="$lccn = 'sh85079044'">hit</xsl:when>
                    <xsl:when test="$lccn = 'sh85072912'">kok</xsl:when>
                    <xsl:when test="$lccn = 'sh85079043'">lue</xsl:when>
                    <xsl:when test="$lccn = 'sh85003030'">aji</xsl:when>
                    <xsl:when test="$lccn = 'sh85117749'">srb</xsl:when>
                    <xsl:when test="$lccn = 'sh85072918'">xon</xsl:when>
                    <xsl:when test="$lccn = 'sh85121159'">sht</xsl:when>
                    <xsl:when test="$lccn = 'sh85109472'">ahg</xsl:when>
                    <xsl:when test="$lccn = 'sh85017040'">bkk</xsl:when>
                    <xsl:when test="$lccn = 'sh85003039'">axk</xsl:when>
                    <xsl:when test="$lccn = 'sh85043161'">enq</xsl:when>
                    <xsl:when test="$lccn = 'sh91003036'">gbm</xsl:when>
                    <xsl:when test="$lccn = 'sh89003354'">saj</xsl:when>
                    <xsl:when test="$lccn = 'sh85072047'">ked</xsl:when>
                    <xsl:when test="$lccn = 'sh85040360'">dzo</xsl:when>
                    <xsl:when test="$lccn = 'sh85093187'">mrq</xsl:when>
                    <xsl:when test="$lccn = 'sh85104767'">peb</xsl:when>
                    <xsl:when test="$lccn = 'sh85093183'">bhw</xsl:when>
                    <xsl:when test="$lccn = 'sh85018089'">bua</xsl:when>
                    <xsl:when test="$lccn = 'sh85092174'">nog</xsl:when>
                    <xsl:when test="$lccn = 'sh85104768'">pom</xsl:when>
                    <xsl:when test="$lccn = 'sh86006663'">nsq</xsl:when>
                    <xsl:when test="$lccn = 'sh87000267'">oru</xsl:when>
                    <xsl:when test="$lccn = 'sh96000932'">bwg</xsl:when>
                    <xsl:when test="$lccn = 'sh85130905'">sus</xsl:when>
                    <xsl:when test="$lccn = 'sh85044810'">ese</xsl:when>
                    <xsl:when test="$lccn = 'sh93006371'">snc</xsl:when>
                    <xsl:when test="$lccn = 'sh85116503'">cop</xsl:when>
                    <xsl:when test="$lccn = 'sh92001747'">pej</xsl:when>
                    <xsl:when test="$lccn = 'sh85085641'">myk</xsl:when>
                    <xsl:when test="$lccn = 'sh85083589'">mez</xsl:when>
                    <xsl:when test="$lccn = 'sh85014432'">bis</xsl:when>
                    <xsl:when test="$lccn = 'sh85134170'">nyu</xsl:when>
                    <xsl:when test="$lccn = 'sh85014431'">nmg</xsl:when>
                    <xsl:when test="$lccn = 'sh85079951'">mvy</xsl:when>
                    <xsl:when test="$lccn = 'sh00007334'">qum</xsl:when>
                    <xsl:when test="$lccn = 'sh86006664'">pmw</xsl:when>
                    <xsl:when test="$lccn = 'sh92000446'">str</xsl:when>
                    <xsl:when test="$lccn = 'sh85120199'">hbs</xsl:when>
                    <xsl:when test="$lccn = 'sh85072136'">xkv</xsl:when>
                    <xsl:when test="$lccn = 'sh85149641'">xzh</xsl:when>
                    <xsl:when test="$lccn = 'sh85144812'">wgi</xsl:when>
                    <xsl:when test="$lccn = 'sh85138704'">neb</xsl:when>
                    <xsl:when test="$lccn = 'sh85093500'">nyn</xsl:when>
                    <xsl:when test="$lccn = 'sh85108980'">fuf</xsl:when>
                    <xsl:when test="$lccn = 'sh85067265'">igs</xsl:when>
                    <xsl:when test="$lccn = 'sh85001214'">ady</xsl:when>
                    <xsl:when test="$lccn = 'sh2003000182'">mfi</xsl:when>
                    <xsl:when test="$lccn = 'sh85001219'">kat</xsl:when>
                    <xsl:when test="$lccn = 'sh85040273'">dya</xsl:when>
                    <xsl:when test="$lccn = 'sh85082432'">mfy</xsl:when>
                    <xsl:when test="$lccn = 'sh85116761'">sln</xsl:when>
                    <xsl:when test="$lccn = 'sh85094781'">one</xsl:when>
                    <xsl:when test="$lccn = 'sh85124790'">tbz</xsl:when>
                    <xsl:when test="$lccn = 'sh85000164'">axb</xsl:when>
                    <xsl:when test="$lccn = 'sh85000169'">abk</xsl:when>
                    <xsl:when test="$lccn = 'sh86000904'">bri</xsl:when>
                    <xsl:when test="$lccn = 'sh85034657'">acc</xsl:when>
                    <xsl:when test="$lccn = 'sh85034651'">cub</xsl:when>
                    <xsl:when test="$lccn = 'sh00006338'">jek</xsl:when>
                    <xsl:when test="$lccn = 'sh85052622'">fuy</xsl:when>
                    <xsl:when test="$lccn = 'sh98001968'">xwc</xsl:when>
                    <xsl:when test="$lccn = 'sh2002007782'">awk</xsl:when>
                    <xsl:when test="$lccn = 'sh85068492'">crb</xsl:when>
                    <xsl:when test="$lccn = 'sh85091929'">nii</xsl:when>
                    <xsl:when test="$lccn = 'sh2002007147'">dho</xsl:when>
                    <xsl:when test="$lccn = 'sh2002011288'">pid</xsl:when>
                    <xsl:when test="$lccn = 'sh95010211'">pmf</xsl:when>
                    <xsl:when test="$lccn = 'sh85019593'">caz</xsl:when>
                    <xsl:when test="$lccn = 'sh85138308'">tsd</xsl:when>
                    <xsl:when test="$lccn = 'sh85109110'">xpu</xsl:when>
                    <xsl:when test="$lccn = 'sh85046938'">fai</xsl:when>
                    <xsl:when test="$lccn = 'sh85149159'">yim</xsl:when>
                    <xsl:when test="$lccn = 'sh99004228'">dbf</xsl:when>
                    <xsl:when test="$lccn = 'sh85061940'">hop</xsl:when>
                    <xsl:when test="$lccn = 'sh85109230'">pus</xsl:when>
                    <xsl:when test="$lccn = 'sh85091827'">nie</xsl:when>
                    <xsl:when test="$lccn = 'sh87007477'">pbi</xsl:when>
                    <xsl:when test="$lccn = 'sh93002706'">emb</xsl:when>
                    <xsl:when test="$lccn = 'sh2003007062'">amy</xsl:when>
                    <xsl:when test="$lccn = 'sh93002705'">jav</xsl:when>
                    <xsl:when test="$lccn = 'sh85073390'">kkw</xsl:when>
                    <xsl:when test="$lccn = 'sh85037452'">dhu</xsl:when>
                    <xsl:when test="$lccn = 'sh85073392'">glj</xsl:when>
                    <xsl:when test="$lccn = 'sh85010736'">bcr</xsl:when>
                    <xsl:when test="$lccn = 'sh85141661'">uzb</xsl:when>
                    <xsl:when test="$lccn = 'sh85132150'">tly</xsl:when>
                    <xsl:when test="$lccn = 'sh85000945'">adt</xsl:when>
                    <xsl:when test="$lccn = 'sh85073408'">kfx</xsl:when>
                    <xsl:when test="$lccn = 'sh85073409'">kle</xsl:when>
                    <xsl:when test="$lccn = 'sh85119980'">seh</xsl:when>
                    <xsl:when test="$lccn = 'sh2004001818'">zza</xsl:when>
                    <xsl:when test="$lccn = 'sh92006129'">czt</xsl:when>
                    <xsl:when test="$lccn = 'sh85141401'">uvh</xsl:when>
                    <xsl:when test="$lccn = 'sh92006127'">cfm</xsl:when>
                    <xsl:when test="$lccn = 'sh85073376'">kdt</xsl:when>
                    <xsl:when test="$lccn = 'sh85021563'">cyb</xsl:when>
                    <xsl:when test="$lccn = 'sh85089321'">yms</xsl:when>
                    <xsl:when test="$lccn = 'sh85080219'">mlt</xsl:when>
                    <xsl:when test="$lccn = 'sh85053374'">oci</xsl:when>
                    <xsl:when test="$lccn = 'sh85057664'">guo</xsl:when>
                    <xsl:when test="$lccn = 'sh2007008483'">wti</xsl:when>
                    <xsl:when test="$lccn = 'sh85061304'">hoc</xsl:when>
                    <xsl:when test="$lccn = 'sh85078707'">lua</xsl:when>
                    <xsl:when test="$lccn = 'sh85089155'">myw</xsl:when>
                    <xsl:when test="$lccn = 'sh85115516'">rgu</xsl:when>
                    <xsl:when test="$lccn = 'sh86007747'">liy</xsl:when>
                    <xsl:when test="$lccn = 'sh85117264'">snl</xsl:when>
                    <xsl:when test="$lccn = 'sh85129627'">sue</xsl:when>
                    <xsl:when test="$lccn = 'sh85088260'">muv</xsl:when>
                    <xsl:when test="$lccn = 'sh85096908'">gfk</xsl:when>
                    <xsl:when test="$lccn = 'sh85078929'">luo</xsl:when>
                    <xsl:when test="$lccn = 'sh85024635'">cjk</xsl:when>
                    <xsl:when test="$lccn = 'sh93007849'">blz</xsl:when>
                    <xsl:when test="$lccn = 'sh2005005908'">lon</xsl:when>
                    <xsl:when test="$lccn = 'sh2005005909'">ngl</xsl:when>
                    <xsl:when test="$lccn = 'sh85149523'">yur</xsl:when>
                    <xsl:when test="$lccn = 'sh85094235'">pse</xsl:when>
                    <xsl:when test="$lccn = 'sh85094232'">ofo</xsl:when>
                    <xsl:when test="$lccn = 'sh2003009028'">mkm</xsl:when>
                    <xsl:when test="$lccn = 'sh96000785'">aph</xsl:when>
                    <xsl:when test="$lccn = 'sh85122171'">shs</xsl:when>
                    <xsl:when test="$lccn = 'sh85079231'">mfz</xsl:when>
                    <xsl:when test="$lccn = 'sh92005056'">bsw</xsl:when>
                    <xsl:when test="$lccn = 'sh92005054'">agn</xsl:when>
                    <xsl:when test="$lccn = 'sh97007140'">jdt</xsl:when>
                    <xsl:when test="$lccn = 'sh85073978'">lah</xsl:when>
                    <xsl:when test="$lccn = 'sh85135700'">tqo</xsl:when>
                    <xsl:when test="$lccn = 'sh85073971'">kjq</xsl:when>
                    <xsl:when test="$lccn = 'sh85039943'">dmk</xsl:when>
                    <xsl:when test="$lccn = 'sh85039942'">due</xsl:when>
                    <xsl:when test="$lccn = 'sh85039941'">dgc</xsl:when>
                    <xsl:when test="$lccn = 'sh85039947'">duf</xsl:when>
                    <xsl:when test="$lccn = 'sh2003003126'">afu</xsl:when>
                    <xsl:when test="$lccn = 'sh85080105'">mbp</xsl:when>
                    <xsl:when test="$lccn = 'sh87004817'">mhc</xsl:when>
                    <xsl:when test="$lccn = 'sh85011063'">bdh</xsl:when>
                    <xsl:when test="$lccn = 'sh85058039'">gwn</xsl:when>
                    <xsl:when test="$lccn = 'sh85011066'">bkq</xsl:when>
                    <xsl:when test="$lccn = 'sh85010640'">aze</xsl:when>
                    <xsl:when test="$lccn = 'sh85011064'">bkc</xsl:when>
                    <xsl:when test="$lccn = 'sh85142417'">gri</xsl:when>
                    <xsl:when test="$lccn = 'sh87004818'">ign</xsl:when>
                    <xsl:otherwise>failed</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
