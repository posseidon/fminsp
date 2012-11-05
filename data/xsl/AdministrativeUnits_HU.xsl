<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gml="http://www.opengis.net/gml/3.2"
	xmlns:base="urn:x-inspire:specification:gmlas:BaseTypes:3.2"
	xmlns:AU="urn:x-inspire:specification:gmlas:AdministrativeUnits:3.0"
	exclude-result-prefixes="base gml xsl AU">
	<xsl:strip-space elements="*"/>
	<!-- Reuse GN XSLT -->
	<xsl:include href="GeographicalNames_HU.xsl"/>


	<!-- Generate AdministrativeUnit element -->
	<xsl:template name="AU.AdministrativeUnit" priority="1" match="/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

		<!-- Create gml Id by concatenating idPrefix and local id -->
		<xsl:variable name="gmlId"><xsl:value-of select="concat('HU.FOMI.AU','.',adminunits/id)"/></xsl:variable>
			<AU:AdministrativeUnit gml:id="{$gmlId}">

			<xsl:call-template name="GML.Identifier">
				<xsl:with-param name="id">
					<xsl:value-of select="$gmlId"/>
				</xsl:with-param>
			</xsl:call-template>

			<AU:geometry>
				<xsl:copy-of select="adminunits/geometria/*"/>
			</AU:geometry>

			<!-- Local code e.g. numeric code for municipality-->
			<AU:nationalCode>
				<xsl:value-of select="adminunits/natcode"/>
			</AU:nationalCode>

			<!-- Generate INSPIRE id -->
			<AU:inspireId>
				<xsl:call-template name="Base.InspireId">
					<xsl:with-param name="localId">
						<xsl:value-of select="adminunits/natcode"/>
					</xsl:with-param>
					<xsl:with-param name="idPrefix">HU.FOMI.AU</xsl:with-param>
				</xsl:call-template>
			</AU:inspireId>

			<!-- nationalLevel is one of {1thOrder, 2ndOrder, ...} -->
			<AU:nationalLevel codeSpace="{$adminHierarchyCodeSpace}">
				<xsl:value-of select="adminunits/level"/>
			</AU:nationalLevel>

			<!-- Local name for nationalLevel e.g. "gemeente", "provincie"-->
			<AU:nationalLevelName>
				<xsl:call-template name="GMD.LocalisedCharacterString">
					<xsl:with-param name="value">
						<xsl:value-of select="adminunits/levelname"/>
					</xsl:with-param>
				</xsl:call-template>
			</AU:nationalLevelName>

			<!-- Use globally defined country code -->
			<AU:country>
				<xsl:call-template name="GMD.Country"/>
			</AU:country>

			<AU:name>
				<!-- Generate minimal GeographicalName -->
				<xsl:call-template name="GN.GeographicalName.Minimal">
					<xsl:with-param name="name">
						<xsl:value-of select="adminunits/name"/>
					</xsl:with-param>
				</xsl:call-template>
			</AU:name>

			<!-- Keep nil for now. -->
			<AU:residenceOfAuthority xsi:nil="true" />
			<AU:beginLifespanVersion xsi:nil="true" />
			<AU:endLifespanVersion xsi:nil="true" />
			<AU:NUTS xsi:nil="true" />
			<!-- <AU:condominium xsi:nil="true"/>    -->
			<AU:lowerLevelUnit xsi:nil="true" />
			<AU:upperLevelUnit xsi:nil="true" />
			<AU:administeredBy xsi:nil="true" />
			<AU:coAdminister xsi:nil="true" />
			<AU:boundary xsi:nil="true" />
		</AU:AdministrativeUnit>
	</xsl:template>
</xsl:stylesheet>
