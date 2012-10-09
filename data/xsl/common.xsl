<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
				xmlns:base="urn:x-inspire:specification:gmlas:BaseTypes:3.2"
				xmlns:gmd="http://www.isotc211.org/2005/gmd"
				xmlns:gml="http://www.opengis.net/gml/3.2/3.2"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="constants-hu.xsl"/>
	<!-- Replace one string with another in specified string. -->
	<xsl:template name="globalReplace">
		<xsl:param name="outputString"/>
		<xsl:param name="target"/>
		<xsl:param name="replacement"/>
		<xsl:choose>
			<xsl:when test="contains($outputString,$target)">

				<xsl:value-of select=
						"concat(substring-before($outputString,$target),
				   $replacement)"/>
				<xsl:call-template name="globalReplace">
					<xsl:with-param name="outputString"
									select="substring-after($outputString,$target)"/>
					<xsl:with-param name="target" select="$target"/>
					<xsl:with-param name="replacement"
									select="$replacement"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$outputString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Remove the third dimension (every third coordinate) from space-separated (posList) coordinates. -->
	<xsl:template name="remove3D">
		<xsl:param name="outputString"/>
		<xsl:param name="sep"/>
		<xsl:choose>
			<xsl:when test="contains($outputString,$sep)">

				<!-- Output x,y -->
				<xsl:value-of select="substring-before($outputString,$sep)"/>
				<xsl:value-of select="' '"/>
				<xsl:value-of select="substring-before( substring-after($outputString,$sep), $sep)"/>
				<xsl:value-of select="' '"/>

				<!-- RECURSE: Skip current x,y,z-coordinate and proceed with remaining string (that starts with next x,y) -->
				<xsl:call-template name="remove3D">
					<xsl:with-param name="outputString"
									select="substring-after( substring-after( substring-after( $outputString, $sep), $sep), $sep)"/>
					<xsl:with-param name="sep" select="$sep"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- Generate InspireId element -->
	<xsl:template name="Base.InspireId" priority="1">
		<xsl:param name="localId"/>
		<xsl:param name="idPrefix"/>

		<base:Identifier>
			<base:localId>
				<xsl:value-of select="$localId"/>
			</base:localId>
			<base:namespace>
				<xsl:value-of select="$idPrefix"/>
			</base:namespace>
		</base:Identifier>
	</xsl:template>

	<!-- Generate gml:identifier element -->
	<xsl:template name="GML.Identifier" priority="1">
		<xsl:param name="id"/>

		<gml:identifier codeSpace="{$gmlIdentifierCS}"><xsl:value-of select="concat($gmlIdentifierPrefix ,$id)"/></gml:identifier>

	</xsl:template>

	<!-- Generate gmd:Country element -->
	<xsl:template name="GMD.Country" priority="1">
		<gmd:Country codeList="{$countryCodeList}" codeListValue="{$countryCodeValue}">
			<xsl:value-of select="$countryCodeValue"/>
		</gmd:Country>
	</xsl:template>

	<!-- Generate gmd:LocalisedCharacterString element -->
	<xsl:template name="GMD.LocalisedCharacterString" priority="1">
		<xsl:param name="value"/>

		<gmd:LocalisedCharacterString locale="{$locale}">
			<xsl:value-of select="$value"/>
		</gmd:LocalisedCharacterString>

	</xsl:template>
	
	<xsl:template match="adminunits/geometria" name="LOFASZ">
		<xsl:copy>
		  <xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

					<xsl:template match="gml:MultiSurface" name="LOFASZOK">
						<xsl:param name="id"/>
				  		<xsl:attribute name="gml:id" select="$id"/>
					</xsl:template>

	<xsl:template name="swapCoords">
		<xsl:param name="coordString"/>
		<xsl:param name="sep"/>
		<xsl:choose>
			<xsl:when test="contains($coordString,$sep)">

				<xsl:choose>

					<!-- Cater for last pair -->
					<xsl:when test="substring-before(substring-after($coordString,$sep), $sep) = ''">
						<xsl:value-of select="substring-after($coordString,$sep)"/>
					</xsl:when>

					<xsl:otherwise><xsl:value-of select="substring-before(substring-after($coordString,$sep), $sep)"/></xsl:otherwise>
				</xsl:choose>

				<!-- Output y,x -->
				<xsl:value-of select="' '"/>
				<xsl:value-of select="substring-before($coordString,$sep)"/>
				<xsl:value-of select="' '"/>

				<!-- RECURSE: Skip current x,y-coordinate and proceed with remaining string (that starts with next x,y) -->
				<xsl:call-template name="swapCoords">
					<xsl:with-param name="coordString"
									select="substring-after( substring-after( $coordString, $sep), $sep)"/>
					<xsl:with-param name="sep" select="$sep"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- Callable Template: create Point element -->
	<xsl:template name="createPoint" priority="1">
		<xsl:param name="pointId"/>
		<xsl:param name="point"/>
		<gml:Point srsName="urn:ogc:def:crs:EPSG::4258" gml:id="{$pointId}">
			<gml:pos>
				<!-- Swap x,y to y,x from space-separated (posList) coordinates -->
				<xsl:call-template name="swapCoords">
					<xsl:with-param name="coordString" select="translate(normalize-space($point),',',' ')"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
			</gml:pos>
		</gml:Point>
	</xsl:template>
</xsl:stylesheet>
