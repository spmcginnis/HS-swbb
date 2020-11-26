xquery version "3.0";

(:XQ for HSswbb to sort the biographical index alphabetically:)
(:created 2016 March 23 spm:)

let $doc := doc('biographical_index.xml')
return <xml>
{for $item in $doc//item 

(:to filter for items which have been assigned an xml:id, even if it is blank.  The rest go after.:)
where fn:boolean($item/persName[@xml:id])
order by $item/persName/@xml:id
return $item
}
{for $item in $doc//item 
where not(fn:boolean($item/persName[@xml:id]))

(:to filter items that have no children, which might have crept in:)
where boolean($item/persName)
order by $item/persName/@xml:id

return $item
}
</xml>
