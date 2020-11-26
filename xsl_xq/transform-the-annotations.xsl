<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- created 20150720 spm -->
    <!-- a transformation to render sinicaHS xml files into TEI -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <!-- XSLT Template to copy everything, priority="-1" -->
    <xsl:template match="@*|node()" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- template for converting span to note -->
    <xsl:template match="span">
        <note>
            <xsl:value-of select="."/>
        </note>
    </xsl:template>
    
    <!-- template to add p tags to the divs -->
    <xsl:template match="div">
        <div>
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>
    
    <!-- tranforming tables -->
    <xsl:template match="table">
        <table>
            <!-- creates an attribute @cols and populates it with the number of td elements in the first tr -->
            <xsl:attribute name="cols" select="count(tr[1]/td)"/>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <xsl:template match="tr">
        <row>
            <xsl:apply-templates/>
        </row>
    </xsl:template>
    <xsl:template match="td">
        <cell>
            <xsl:apply-templates/>
        </cell>
    </xsl:template>
    
    <!-- transforming br to lb -->
    <xsl:template match="br">
        <lb/>
    </xsl:template>
    
    <!-- empty templates for removing tags -->
    <xsl:template match="img"/>
    <xsl:template match="a"/>

    
</xsl:stylesheet>