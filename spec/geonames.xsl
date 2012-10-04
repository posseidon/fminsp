<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:gml="http://www.opengis.net/gml/3.2" 
  xmlns:base="urn:x-inspire:specification:gmlas:BaseTypes:3.2"
  xmlns:gn="urn:x-inspire:specification:gmlas:GeographicalNames:3.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  version="1.0">
  <xsl:template match="/">
    <xsl:element name="gn:NamedPlace">
      <!-- GML:ID -->
      <xsl:attribute name="gml:id"><xsl:value-of select="fnt/id" /></xsl:attribute>
      <!-- BeginLifeSpanVersion -->
      <xsl:element name="gn:beginLifespanVersion">
        <xsl:attribute name="nilReason">UNKNOWN</xsl:attribute>
        <xsl:attribute name="xsi:nill">true</xsl:attribute>
      </xsl:element>
      <!-- EndLifeSpanVersion -->
      <xsl:element name="gn:endLifespanVersion">
        <xsl:attribute name="nilReason">UNKNOWN</xsl:attribute>
        <xsl:attribute name="xsi:nill">true</xsl:attribute>
      </xsl:element>
      <!-- GN:Geometry -->
      <xsl:element name="gn:geometry">
        <xsl:element name="gml:Point">
          <xsl:attribute name="gml:id"><xsl:value-of select="fnt/id" /></xsl:attribute>
          <xsl:attribute name="srsName">urn:ogc:def:crs:EPSG::4258</xsl:attribute>
          <xsl:element name="gml:pos"><xsl:value-of select="fnt/geometria" /></xsl:element>
        </xsl:element>
      </xsl:element>

      <!-- INSPIRE ID -->
      <xsl:element name="gn:inspireId">
        <xsl:element name="base:Identifier">
          <xsl:element name="base:localId">NINCS</xsl:element>
          <xsl:element name="base:namespace">HU.FOMI.GN</xsl:element>
        </xsl:element>
      </xsl:element>
      <!-- LocalType -->
      <xsl:element name="gn:localType">
        <xsl:element name="gmd:LocalisedCharacterString">
          <xsl:attribute name="locale">hu-HU</xsl:attribute>
          <xsl:value-of select="fnt/tipusnev" />
        </xsl:element>
      </xsl:element>

      <!-- Geographical Name -->
      <xsl:element name="gn:name">
        <xsl:element name="gn:GeographicalName">
          <xsl:element name="gn:language"><xsl:attribute name="xsi:nil">true</xsl:attribute></xsl:element>
          <xsl:element name="gn:nativeness">endonym</xsl:element>
          <xsl:element name="gn:nameStatus">official</xsl:element>
          <xsl:element name="gn:sourceOfName"><xsl:value-of select="fnt/forrasnev" /></xsl:element>
          <xsl:element name="gn:pronunciation"><xsl:attribute name="xsi:nil">true</xsl:attribute></xsl:element>
          <xsl:element name="gn:spelling">
            <xsl:element name="gn:SpellingOfName">
              <xsl:element name="gn:text"><xsl:value-of select="fnt/nev" /></xsl:element>
              <xsl:element name="gn:script">Latn</xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:element name="gn:grammaticalGender"><xsl:attribute name="xsi:nil">true</xsl:attribute></xsl:element>
          <xsl:element name="gn:grammaticalNumber"><xsl:attribute name="xsi:nil">true</xsl:attribute></xsl:element>
        </xsl:element>
      </xsl:element>

      <xsl:element name="gn:relatedSpatialObject"><xsl:attribute name="xsi:nil">true</xsl:attribute></xsl:element>
      <xsl:element name="gn:type"><xsl:value-of select="fnt/tipusnev" /></xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
