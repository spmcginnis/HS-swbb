xquery version "3.0";

(:
This XQ is designed to combine files for the HS-SWBB project.
Created: spm 20150703
Modified: spm 20150711
:)

(:URIs with the Chapter Number 001-100 plus wildcard.  The output is SinicaHSBZ_{001-100}_combined.xml :)
let $doc := collection('../?select=SinicaHSBZ_100*.html') 
return 
<xml>
<!-- created 20150711 spm.  Needs verification and collation. -->
{for $n in $doc/xml return $n/child::*}</xml>