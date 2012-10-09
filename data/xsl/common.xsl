<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2010  Het Kadaster - The Netherlands
  ~
  ~ This program is free software: you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation, either version 3 of the License, or
  ~ (at your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program.  If not, see <http://www.gnu.org/licenses/>.
  -->

<!--

Generate common elements for INSPIRE BaseTypes, GMD Metadata etc.

Author:  Just van den Broecke, Just Objects B.V. for Dutch Kadaster

Requires local constants like "$countryCodeValue", for example:
	<xsl:include href="constants.xsl"/>
-->
<xsl:stylesheet version="1.0"
				xmlns:base="urn:x-inspire:specification:gmlas:BaseTypes:3.2"
				xmlns:gmd="http://www.isotc211.org/2005/gmd"
				xmlns:gml="http://www.opengis.net/gml/3.2"
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

	<!-- Callable Template: Transform MultiPolygon to MultiSurface element -->
	<xsl:template name="createMultiSurface" priority="1">
		<xsl:param name="id"/>
		<xsl:apply-templates select="ogr:geometryProperty">
			<xsl:with-param name="id">
				<xsl:value-of select="$id"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Callable Template: Transform Point or Linestring element to GML3 Points/Curves-->
	<xsl:template name="createGeom" priority="1" mode="Single">
		<xsl:param name="id"/>
		<xsl:apply-templates select="ogr:geometryProperty" mode="Single">
			<xsl:with-param name="id">
				<xsl:value-of select="$id"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Transform Polygon to nested Surface -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:Point" mode="Single">
		<xsl:param name="id"/>

		<gml:Point gml:id="{concat('Point_',$id)}" srsName="{$srsName}">
			<xsl:apply-templates select="gml2:coordinates" mode="Point"/>
		</gml:Point>
	</xsl:template>

	<!-- Transform Polygon to nested Surface -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:Polygon" mode="Single">
		<xsl:param name="id"/>

		<!-- see http://xml.fmi.fi/namespace/meteorology/conceptual-model/meteorological-objects/2009/03/26/docindex146.html#id541 -->
		<gml:Surface gml:id="{concat('Surface_',$id)}" srsName="{$srsName}">
			<gml:patches>
				<gml:PolygonPatch interpolation="planar">
					<xsl:apply-templates>
						<xsl:with-param name="id" select="$id"/>
					</xsl:apply-templates>
				</gml:PolygonPatch>
			</gml:patches>

		</gml:Surface>
	</xsl:template>

	<!-- Transform MultiPolygon to nested MultiSurface -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:MultiPolygon">
		<xsl:param name="id"/>

		<!-- see http://xml.fmi.fi/namespace/meteorology/conceptual-model/meteorological-objects/2009/03/26/docindex146.html#id541 -->
		<gml:MultiSurface gml:id="{concat('MultiSurface_',$id)}" srsName="{$srsName}">
			<xsl:apply-templates>
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</gml:MultiSurface>
	</xsl:template>

	<!-- Transform polygonMember to nested surfaceMember/Surface/patches -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:polygonMember">
		<xsl:param name="id"/>

		<gml:surfaceMember>
			<gml:Surface gml:id="{concat('Surface_',$id, '.', position())}" srsName="{$srsName}">
				<gml:patches>
					<xsl:apply-templates mode="MultiSurface"/>
				</gml:patches>
			</gml:Surface>
		</gml:surfaceMember>
	</xsl:template>

	<!-- Transform Polygon to PolygonPatch (within MultiSurface) -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:Polygon" mode="MultiSurface">
		<gml:PolygonPatch interpolation="planar">
			<xsl:apply-templates/>
		</gml:PolygonPatch>
	</xsl:template>

	<!-- Transform innerBoundaryIs to interior -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:innerBoundaryIs">
		<gml:interior>
			<gml:LinearRing>
				<xsl:apply-templates/>
			</gml:LinearRing>
		</gml:interior>
	</xsl:template>

	<!-- Transform outerBoundaryIs to exterior -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:outerBoundaryIs">
		<gml:exterior>
			<gml:LinearRing>
				<xsl:apply-templates/>
			</gml:LinearRing>
		</gml:exterior>
	</xsl:template>

	<!-- Transform Polygon to PolygonPatch (within MultiSurface) -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:LineString" mode="Single">
		<xsl:param name="id"/>

		<gml:Curve gml:id="{concat('Curve',$id)}" srsName="{$srsName}">
			<gml:segments>
				<gml:LineStringSegment interpolation="linear">
					<xsl:apply-templates/>
				</gml:LineStringSegment>
			</gml:segments>
		</gml:Curve>
	</xsl:template>


	<!-- Transform coordinate list to poslist -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:coordinates">
		<gml:posList srsName="{$srsName}" srsDimension="{$srsDimension}">
			<!-- Swap x,y to y,x from space-separated (posList) coordinates -->
			<xsl:call-template name="swapCoords">
				<xsl:with-param name="coordString" select="translate(normalize-space(.),',',' ')"/>
				<xsl:with-param name="sep" select="' '"/>
			</xsl:call-template>
			<!-- <xsl:value-of select="translate(normalize-space(.),',',' ')"/>  -->
		</gml:posList>
	</xsl:template>

	<!-- Transform coordinate list to poslist -->
	<xsl:template xmlns:gml2="http://www.opengis.net/gml" match="gml2:coordinates" mode="Point">
		<gml:pos>
			<!-- Swap x,y to y,x from space-separated (posList) coordinates -->
			<xsl:call-template name="swapCoords">
				<xsl:with-param name="coordString" select="translate(normalize-space(.),',',' ')"/>
				<xsl:with-param name="sep" select="' '"/>
			</xsl:call-template>
			<!-- <xsl:value-of select="translate(normalize-space(.),',',' ')"/>    -->
		</gml:pos>
	</xsl:template>


</xsl:stylesheet>
