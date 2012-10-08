<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<!-- Base URI under which all CodeList XML files are contained -->
	<xsl:variable name="codeListURIBase"></xsl:variable>

	<!-- CodeSpace URIs, mainly used for AU and GN -->
	<xsl:variable name="adminHierarchyCodeSpace"><xsl:value-of select="concat($codeListURIBase, 'AdministrativeHierarchyLevel.xml')"/></xsl:variable>
	<xsl:variable name="conditionOfFacilityValueCodeSpace"><xsl:value-of select="concat($codeListURIBase, 'ConditionOfFacilityValue.xml')"/></xsl:variable>
	<xsl:variable name="namedPlaceTypeValueCodeSpace"><xsl:value-of select="concat($codeListURIBase, 'NamedPlaceTypeValue.xml')"/></xsl:variable>
	<xsl:variable name="nameStatusValueCodeSpace"><xsl:value-of select="concat($codeListURIBase, 'NameStatusValue.xml')"/></xsl:variable>
	<xsl:variable name="nativenessValueCodeSpace"><xsl:value-of select="concat($codeListURIBase, 'NativenessValue.xml')"/></xsl:variable>

	<xsl:variable name="gmlIdentifierCS">http://inspire.jrc.ec.europa.eu/</xsl:variable>
	<xsl:variable name="gmlIdentifierPrefix">urn:x-inspire:object:id:</xsl:variable>
	<xsl:variable name="countryCodeList"><xsl:value-of select="concat($codeListURIBase, 'CountryCode.xml')"/></xsl:variable>
	<xsl:variable name="countryCodeValue">HU</xsl:variable>
	<xsl:variable name="locale">HU</xsl:variable>
	<xsl:variable name="srsName">urn:ogc:def:crs:EPSG::4258</xsl:variable>
	<xsl:variable name="srsDimension">2</xsl:variable>
	<xsl:variable name="areaUOM">m2</xsl:variable>
	<xsl:variable name="lengthUOM">m</xsl:variable>
</xsl:stylesheet>
