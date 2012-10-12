<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:GN="urn:x-inspire:specification:gmlas:GeographicalNames:3.0" >

<xsl:include href="common.xsl"/>

  <!-- Generate NamedPlace element -->
  <xsl:template name="GN.NamedPlace" priority="1" match="/" 
    xmlns:gml="http://www.opengis.net/gml/3.2/3.2"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:param name="idPrefix"/>
    <xsl:param name="localId"/>
    <xsl:param name="point"/>
    <xsl:param name="name"/>
    <xsl:param name="localType"/>
    <xsl:param name="type"/>

    <!-- Create gml Id by concatenating idPrefix and local id -->
    <xsl:variable name="gmlId"><xsl:value-of select="fnt/id" /></xsl:variable>
    <xsl:variable name="pointId"><xsl:value-of select="fnt/id" /></xsl:variable>

    <base:member xmlns:base="urn:x-inspire:specification:gmlas:BaseTypes:3.2">
      <GN:NamedPlace gml:id="{$gmlId}">

        <xsl:call-template name="GML.Identifier">
          <xsl:with-param name="id">
            <xsl:value-of select="$gmlId"/>
          </xsl:with-param>
        </xsl:call-template>

        <GN:beginLifespanVersion xsi:nil="true" nilReason="other:unpopulated"></GN:beginLifespanVersion>
        <GN:endLifespanVersion xsi:nil="true" nilReason="other:unpopulated"></GN:endLifespanVersion>
   
        <!-- Generate Point geometry -->
        <GN:geometry>
          <!-- Generate gML3 Point with coordinates swapped -->
          <xsl:call-template name="createPoint">
            <xsl:with-param name="pointId">
              <xsl:value-of select="$gmlId"/>
            </xsl:with-param>
            <xsl:with-param name="point">
              <xsl:value-of select="fnt/geometria"/>
            </xsl:with-param>
          </xsl:call-template>
        </GN:geometry>

        <!-- Generate INSPIRE id -->
        <GN:inspireId>
          <xsl:call-template name="Base.InspireId">
            <xsl:with-param name="localId">NINCS</xsl:with-param>
            <xsl:with-param name="idPrefix">HU.FOMI.GN</xsl:with-param>
          </xsl:call-template>
        </GN:inspireId>

        <GN:localType>
          <xsl:call-template name="GMD.LocalisedCharacterString">
            <xsl:with-param name="value">
              <xsl:value-of select="fnt/tipusnev" />
            </xsl:with-param>
          </xsl:call-template>
        </GN:localType>

        <GN:name>
          <!-- Generate minimal GeographicalName -->
          <xsl:call-template name="GN.GeographicalName.Minimal">
            <xsl:with-param name="name">
              <xsl:value-of select="fnt/nev" />
            </xsl:with-param>
          </xsl:call-template>
        </GN:name>

        <GN:relatedSpatialObject xsi:nil="true" nilReason="other:unpopulated"></GN:relatedSpatialObject>
        <GN:type codeSpace="{$namedPlaceTypeValueCodeSpace}"><xsl:value-of select="fnt/typename" /></GN:type>

      </GN:NamedPlace>
    </base:member>
  </xsl:template>

  <!-- Generate minimal GeographicalName element -->
  <xsl:template name="GN.GeographicalName.Minimal" priority="1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:param name="name"/>
    <xsl:param name="nativeness" select="'endonym'"/>
    <xsl:param name="nameStatus" select="'official'"/>
    <xsl:param name="sourceOfName" select="fnt/forrasnev"/>
    <xsl:param name="script" select="'Latn'"/>

    <GN:GeographicalName>
      <GN:language xsi:nil="true"/>
      <GN:nativeness codeSpace="{$nativenessValueCodeSpace}">
        <xsl:value-of select="$nativeness"/>
      </GN:nativeness>
      <GN:nameStatus codeSpace="{$nameStatusValueCodeSpace}">
        <xsl:value-of select="$nameStatus"/>
      </GN:nameStatus>
      <GN:sourceOfName>
        <xsl:value-of select="$sourceOfName"/>
      </GN:sourceOfName>
      <GN:pronunciation xsi:nil="true" nilReason="other:unpopulated"/>

      <GN:spelling>
        <GN:SpellingOfName>
          <GN:text>
            <xsl:value-of select="$name"/>
          </GN:text>
          <GN:script>
            <xsl:value-of select="$script"/>
          </GN:script>
        </GN:SpellingOfName>
      </GN:spelling>
      <GN:grammaticalGender xsi:nil="true"/>
      <GN:grammaticalNumber xsi:nil="true"/>
    </GN:GeographicalName>
  </xsl:template>

</xsl:stylesheet>
