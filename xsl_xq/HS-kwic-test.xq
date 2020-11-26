xquery version "3.0";

(:
first attempt at creating an xq KWIC for the HS collection
2015 Nov. 30 spm
- at this point, the script is skipping encoded names, places, etc.  This needs to be fixed.  
:)

(:VARIABLES:)
let $keyword := ''
let $file := doc('fileIndex.xml/')/xml/file 
(:The above makes use of a list to help construct file names ... this is a work-around:)

return if ($keyword = '') then 
<html><head/><body><p>'ERROR: No keyword has been selected.'</p></body></html>

else
<html>
    <head>
        <meta charset="UTF-8"/>
    </head>
    <body>
        <div class="table">
            <table>
                <caption>[[This is a caption.]]</caption>
                <tr>    
                    <th>Chapter</th>
                    <th>Hits</th>
                </tr>
                {for $file in $file
                let $HS := doc(concat('../Main_Project_Folder/HS-swbb/', $file, '.xml'))
                let $count := count(tokenize(string-join($HS//(p | cell)/text()),$keyword)) - 1
                return
                <tr>
                    <td>{$file/text()}</td>
                    <td>{$count}</td>
               </tr>}

            </table>
        </div>
        <div class="textFragments">
            {for $file in $file
            let $HS := doc(concat('../Main_Project_Folder/HS-swbb/', $file, '.xml'))
            where contains(string-join($HS//(p | cell)/text()), $keyword)
                (: string-join() allows the contains() funtion to work on what would otherwise be a sequence of text nodes :)
            return 
            <div class="chapter">
                <h1>{$file/text()}</h1>
                {for $n in ($HS//p/text(), $HS//table//cell/text())
                where contains($n, $keyword)
                return 
                <div class="hit">
                <h2>fragment</h2>
                    <p>
                        {for $node in $n/parent::node()/node() return
                        typeswitch ($node)
                            case text() return $node
                            case element(note) return <span class="note">{$node/text()}</span>
                            case element(pb) return $node
                        default return ()}
                    </p>
                </div>}
            </div>}
        </div>
    </body>
</html>