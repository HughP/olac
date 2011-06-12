<?xml version="1.0" encoding="UTF-8"?>
<!-- analyze-sample.xsl
     Run this over an evaluated sample that has been prepared by
     prepare-sample.xsl and then annotated by hand.
     Counts the <result> elements to generate accuracy, recall, and
     precision. For the formulas, see:
        http://www.kdnuggets.com/faq/precision-recall.html
         
     G. Simons, 4 June 2011
-->

<xsl:stylesheet xmlns:olac="http://www.language-archives.org/OLAC/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:sr="http://www.openarchives.org/OAI/2.0/static-repository"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                version="2.0">
   <xsl:output method="xml" encoding="UTF-8"/>
   <xsl:template match="/sr:Repository">
      <xsl:variable name="TP" 
         select="count(sr:ListRecords[@metadataPrefix='positive']//olac:result[@true='yes'])"/>
      <xsl:variable name="FP" 
         select="count(sr:ListRecords[@metadataPrefix='positive']//olac:result[@true='no'])"/>
      <xsl:variable name="TN" 
         select="count(sr:ListRecords[@metadataPrefix='negative']//olac:result[@true='yes'])"/>
      <xsl:variable name="FN" 
         select="count(sr:ListRecords[@metadataPrefix='negative']//olac:result[@true='no'])"/>
      <xsl:variable name="acc" select="($TP+$TN) div ($TP+$TN+$FP+$FN)"/>
      <xsl:variable name="rec" select="$TP div ($TP+$FN)"/>
      <xsl:variable name="prec" select="$TP div ($TP+$FP)"/>
      
      <xsl:variable name="right" 
         select="sum(sr:ListRecords[@metadataPrefix='positive']//olac:result/@right)"/>
      <xsl:variable name="wrong" 
         select="sum(sr:ListRecords[@metadataPrefix='positive']//olac:result/@wrong)"/>
      <xsl:variable name="missing" 
         select="sum(sr:ListRecords[@metadataPrefix='positive']//olac:result/@missing)"/>
      <xsl:variable name="lg-rec" select="$right div ($right+$missing)"/>
      <xsl:variable name="lg-prec" select="$right div ($right+$wrong)"/>
      
      <html>
         <head>
            <title>Evaluation results</title>
         </head>
         <body>
            <h1><xsl:value-of select="oai:repositoryName"/></h1>
            <h2><i>Results for resource identification</i></h2>
            <table cellpadding="6">
               <tr>
                  <th></th>
                  <th>Accepted by classifier</th>
                  <th>Rejected by classifier</th>
               </tr>
               <tr>
                  <th>Actually a language resource</th>
                  <td align="center"><xsl:value-of select="$TP"/></td>
                  <td align="center"><xsl:value-of select="$FN"/></td>
               </tr>
               <tr>
                  <th>Not a language resource</th>
                  <td align="center"><xsl:value-of select="$FP"/></td>
                  <td align="center"><xsl:value-of select="$TN"/></td>
               </tr>
            </table>
            <p>&#160;</p>
            <table cellpadding="6">
               <tr>
                  <th>Accuracy</th>
                  <td align="center" width="100"><xsl:value-of
                     select="format-number($acc, '##%')"/></td>
                  <td>What percentage of times was the classifier
                     right?</td>
               </tr>
               <tr>
                  <th>Recall</th>
                  <td align="center"><xsl:value-of select="format-number($rec, '##%')"/></td>
                  <td>What percentage of the language resources did
                     the classifier find?</td>
               </tr>
               <tr>
                  <th>Precision</th>
                  <td align="center"><xsl:value-of
                     select="format-number($prec, '##%')"/></td>
                  <td>What percentage of the items returned by the
                     classifier were actually language resources?</td>
               </tr>
            </table>
                        
            <p>&#160;</p>
            <h2><i>Results of language identification for the 
               <xsl:value-of select="$TP+$FP"/> records
            accepted as language resources</i></h2>
            <table cellpadding="6">
               <tr>
                  <th>Correct identifications</th>
                  <th>Incorrect identifications</th>
                  <th>Missing identifications</th>
               </tr>
               <tr>
                  <td align="center"><xsl:value-of select="$right"/></td>
                  <td align="center"><xsl:value-of select="$wrong"/></td>
                  <td align="center"><xsl:value-of select="$missing"/></td>
               </tr>
            </table>
            <p>&#160;</p>
            <table cellpadding="6">
               <tr>
                  <th>Recall</th>
                  <td align="center"><xsl:value-of
                     select="format-number($lg-rec, '##%')"/></td>
                  <td>What percentage of actual languages did the 
                     the recognizer identify?</td>
               </tr>
               <tr>
                  <th>Precision</th>
                  <td align="center"><xsl:value-of
                     select="format-number($lg-prec, '##%')"/></td>
                  <td>What percentage of the identifications returned by the
                     recognizer were correct?</td>
               </tr>
            </table>
         </body>
      </html>
   </xsl:template>
   
   
   
</xsl:stylesheet>
