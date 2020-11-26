xquery version "3.0";

(:This xq counts the pages and words by chapter of the HS-swbb:)
(:created 2016 March 17 by spm:)

(:Function to strip punctuation marks. Input should be a chunk of text.:)
declare function local:strip-punct($x) {
    let $x := translate($x,'，','')
    let $x := translate($x,'、','')
    let $x := translate($x,'。','')
    let $x := translate($x,'！','')
    let $x := translate($x,'？','')
    let $x := translate($x,'「','')
    let $x := translate($x,'」','')
    let $x := translate($x,'〔','')
    let $x := translate($x,'〕','')
    let $x := translate($x,'（','')
    let $x := translate($x,'）','')
    let $x := translate($x,'《','')
    let $x := translate($x,'》','')
    let $x := translate($x,'；','')
    let $x := translate($x,'：','')
return $x
};

(:Normalize All Text w/o commentary:)
declare function local:normalize-text($x){
    let $x1 := string-join($x//div//text()[not(ancestor::note)], '')
    let $x2 := translate(normalize-space($x1),' ','')
return $x2
};

(:Normalize All Text w/in commentary:)
declare function local:normalize-notes($x){
    let $x1 := string-join($x//note//text(), '')
    let $x1 := replace($x1, '\[..?\]', '')(:a stopgap using regex to remove the note numbers, which will be removed from the xml files later:)
    let $x2 := translate(normalize-space($x1),' ','')
return $x2
};


(:The path to the collection (i.e. directory or folder):)
let $path := '/GoogleDrive/SWBB/HS-SWBB/Main_Project_Folder/HS-swbb/'
let $files := collection($path)

return 

<html>
<head>
<title>Han shu page and word counts</title>
<style type="text/css">
    body {{width: 99vw;}}
    div#frame {{width: 90%; margin: auto;}}
    table {{min-width:100%;}}
    table, th, td {{
        border: 1px solid black; 
        text-align: center;
        border-collapse: collapse;}}
    td {{padding: 1px 5px 1px 5px;}}
    
</style>
</head>
<body>
<div id="frame"><table id="chapters">
<tr>
    <th>Filename</th>
    <th>Chapter Number</th>
    <th>Page Range</th>
    <th>Page Count</th>
    <th>Word Count (text)</th>
    <th>Word Count (commentary)</th>
    <th>Word Count (text + commentary)</th>
</tr>
{for $x at $pos in $files 

    (:Here we limit the results to the files we actually care about with a couple of where clauses:)
    where contains(substring(base-uri($x), 63),'HS')
    (:This is hack to get the filename, this will need to change with the path... it would also be better as a local function:)
    where not(contains(substring(base-uri($x), 63),'header'))
    
    (:    Now we get the first and last page of the chapter, using the page break elements.  n.b. these might not line up properly with chpaters whose page breaks have not been edited yet.:)
    let $start := xs:integer(data(($x//pb)[1]/@n))
    let $end := xs:integer(data(($x//pb)[last()]/@n))

    (:Now we need to count strings... first we need just the text, then just the commentary, then the two together:)
    let $textCount := string-length(local:strip-punct(local:normalize-text($x)))
    let $commentaryCount := string-length(local:strip-punct(local:normalize-notes($x)))
    let $totalCount := $textCount + $commentaryCount

    return
    <tr>
        <td>{substring(base-uri($x), 63) (:A hack to get the filename, this will need to change with the path... it would also be better as a local function:)}</td><!-- Filename -->
        <td>{$pos - 1 (:I'm not sure why I need to subtract 1.  Is it counting the files that I've excluded with the where clause? If so, why aren't there more?  .... but somehow this gets the desired output.:)}</td><!-- Ch. Number -->
        <td>pp. {$start} to {$end}</td><!-- Page Range -->
        <td>{$end - $start + 1} pages</td><!-- Page Count-->
        <td>{$textCount}</td><!-- Word Count -->
        <td>{$commentaryCount}</td><!-- Commentary -->
        <td>{$totalCount}</td><!-- Total -->
    </tr>
}
</table>
<table>
    <tr>
        <th>Total for the Han shu</th>
        <th>Word Count (text)</th>
        <th>Word Count (commentary)</th>
        <th>Word Count (total)</th>
    </tr>
    {let $O := doc('output\counts-2016-03-17.html') (:This is the output made with the debugger.  It will have to be updated for future use.:)return
    <tr>
    <td></td>
        <td>{let $td5 := $O//table[@id='chapters']//td[5] return sum($td5)}</td>
        <td>{let $td6 := $O//table[@id='chapters']//td[6] return sum($td6)}</td>
        <td>{let $td7 := $O//table[@id='chapters']//td[7] return xs:integer(sum($td7))}</td>
    </tr>
    }
</table>
</div>
</body>
</html>