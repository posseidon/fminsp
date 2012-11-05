<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:base="urn:x-inspire:specification:gmlas:BaseTypes:3.2"
				xmlns:gml="http://www.opengis.net/gml/3.2"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:CP="urn:x-inspire:specification:gmlas:CadastralParcels:3.0">
<xsl:include href="common.xsl"/>
	<!-- Generate CadastralParcel element -->
	<xsl:template name="CP.CadastralParcel" priority="1" match="/">
		<xsl:param name="idPrefix"/>
		<xsl:param name="localId"/>
		<xsl:param name="areaValue"/>

		<!-- Replace the space in the national Id, e.g.  LNK00D 2377 becomes LNK00D.2377 -->
		<xsl:variable name="localIdDotted"><xsl:value-of select="cadastral/localid"/></xsl:variable>

		<!-- Create gml Id by concatenating idPrefix and local id -->
		<xsl:variable name="gmlId"><xsl:value-of select="concat('HU.FOMI.CP','.',cadastral/natref)"/></xsl:variable>

			<CP:CadastralParcel gml:id="{$gmlId}">

				<xsl:call-template name="GML.Identifier">
					<xsl:with-param name="id">
						<xsl:value-of select="cadastral/id"/>
					</xsl:with-param>
				</xsl:call-template>

				<CP:areaValue uom="{$areaUOM}"><xsl:value-of select="cadastral/area"/></CP:areaValue>
				<CP:beginLifespanVersion xsi:nil="true" nilReason="other:unpopulated"/>
				<CP:endLifespanVersion xsi:nil="true" nilReason="other:unpopulated"/>

				<CP:geometry>
					<xsl:copy-of select="cadastral/geometria/*"/>
				</CP:geometry>

				<!-- Generate INSPIRE id -->
				<CP:inspireId>
					<xsl:call-template name="Base.InspireId">
						<xsl:with-param name="localId">
							<xsl:value-of select="$localIdDotted"/>
						</xsl:with-param>
						<xsl:with-param name="idPrefix">
							<xsl:value-of select="$idPrefix"/>
						</xsl:with-param>
					</xsl:call-template>
				</CP:inspireId>

				<!-- label   -->
				<CP:label>
					<xsl:value-of select="cadastral/label"/>
				</CP:label>


				<!-- Local id  -->
				<CP:nationalCadastralReference>
					<xsl:value-of select="cadastral/natref"/>
				</CP:nationalCadastralReference>

			</CP:CadastralParcel>
	</xsl:template>

</xsl:stylesheet>
