<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xal="http://xml.apache.org/xalan"
 xmlns:x="http://exslt.org/common" exclude-result-prefixes="x">
<xsl:output method="html"/>

	<!-- These are the files required to put a Product Finder on an SYI page -->

	<!-- DEBUG INFO: Start build include:  -->
	<!--******************************************************************************
DT:  Do not Pretty Print this file or change the format in anyway.
I've removed the carraige returns for each row so the cells are in a line.
This will remove noticeable white space from PF.
***********************************************************************************-->
	<!-- Usage documentation
		<template match="Attribute">
		
			The template is to generate HTML elements of the currently parsed attribute such as label and input field.
			
			<param name="attrId">Attribute id</param>
			<param name="widgetType">
				Type of widget to be generated..
				<enum>
					<value>normal<note>represents a widget that can have label and input box</note></value>
					<value>text_message<note>represents a simple text message that needs to be displayed</note></value>
					<value>date<note>represents a date widget</note></value>
				</enum>				
			</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
		</template>
	-->
	<xsl:variable name="CatalogEnabled" select="(/ebay/Sale/Item/Attributes/AttributeSet/CatalogEnabled or /ebay/V2CatalogEnabled)"/>
	<xsl:variable name="IsPassVehicles" select="boolean(/ebay/Sale/Item/Properties/IsAutosCar)"/>
	<xsl:variable name="IsSiteAutos" select="boolean(/ebay/Environment/@siteId='100')"/>
	<xsl:variable name="IsVehicles" select="boolean(/ebay/Sale/Item/Properties[IsAutosCar or IsAutosMotorcycle or IsAutosPowersports])"/>
	<xsl:variable name="IsColPad">
		<xsl:choose>
			<xsl:when test="$IsVehicles">
				<xsl:value-of select="true()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="ColSpan">
		<xsl:choose>
			<xsl:when test="$IsVehicles">
				<xsl:value-of select="'1'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'2'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="Attribute">
		<xsl:param name="attrId" select="@id"/>
		<xsl:param name="widgetType"/>
		<xsl:param name="attrMessagePFTop" select="../Message[@quadrant='top']"/>
		<xsl:param name="attrMessagePFBottom" select="../Message[@quadrant='bottom' and .!='&amp;nbsp;']"/>
		<xsl:param name="attrMessagePFLeft" select="../Message[@quadrant='left']"/>
		<xsl:param name="attrMessagePFRight" select="../Message[@quadrant='right']"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:variable name="attrMessageTop" select="normalize-space($CurrentAttributeXPath[@id = $attrId]/MessageTop)"/>
		<xsl:variable name="attrMessageBottom" select="normalize-space($CurrentAttributeXPath[@id = $attrId]/MessageBottom)"/>
		<xsl:variable name="attrMessageLeft" select="normalize-space($CurrentAttributeXPath[@id = $attrId]/MessageLeft)"/>
		<xsl:variable name="attrMessageRight" select="normalize-space($CurrentAttributeXPath[@id = $attrId]/MessageRight)"/>
		<xsl:variable name="isLabelVisible" select="boolean($CurrentAttributeXPath[@id=$attrId and @labelVisible = 'true'])"/>
		<xsl:variable name="VCSID" select="../../../../../@id"/>
		<xsl:if test="$subPage = 'API' and $CurrentAttributeXPath/Dependency[@childAttrId=$attrId and @type='5'] ">
			<input type="hidden" name="attr_required_{$VCSID}_{$attrId}" value="true"/>
		</xsl:if>
		<!-- BUGDB00146474 remove messages from API -->
		<xsl:variable name="ShowMessage">
			<xsl:choose>
				<xsl:when test=" $SelectedAttributeXPath[@id=$attrId]/@removeMsg != '' and $SelectedAttributeXPath[@id=$attrId]/@removeMsg = 'true' ">
					<xsl:value-of select="false()" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="true()" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<!-- Changed for SYI Motors conversion -->
			<!-- Display a textbox for all/other models: -16 -->
			<xsl:when test="$attrId=$Attr.Model and $IsPassVehicles and /ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/@id=-16">
				<tr>
					<td>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<!-- If RYI and item has a bid, or has less than 12 hours left, the model is displayed as non-editable 
									I need the model here because some files do not use SyiGlobal.xsl
									-->
									<xsl:choose>
										<xsl:when test="/ebay/SellerOptions/HasBidsOrPurchases or /ebay/SellerOptions/IsLessThan12Hours">
											<font face="Arial, Helvetica, sans-serif" size="2">
											Model: 	<xsl:value-of select="/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/DisplayName"/>
												<input type="hidden" name="{concat('attr_s',$VCSID, '_', $attrId)}" value="{/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/DisplayName}"/>
											</font>
										</xsl:when>
										<xsl:otherwise>
											<table border="0" cellpadding="0" cellspacing="0">
												<xsl:call-template name="AttributeQuadrantTop">
													<xsl:with-param name="attrId" select="$attrId"/>
													<xsl:with-param name="VCSID" select="$VCSID"/>
													<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
													<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
												</xsl:call-template>
												<!-- Add the error message for this text box -->
												<xsl:if test="boolean(/ebay/Errors/Error[@id='SYI.BIZ.802'])">
												<tr class="Error">
													<td width="150"></td>
													<td><font id="Error" face="Arial, Helvetica, sans-serif" size="2" color="#CC0000">
													Please enter no more than 40 characters.</font></td>
												</tr>
												</xsl:if>
											</table>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</xsl:when>
			<xsl:when test="$SelectedAttributeXPath[@id=$attrId and @noEdit='true'] and $CurrentAttributeXPath[@id=$attrId and (EditType = 1 or EditType = 2)]">
				<xsl:choose>
					<!-- Changed for SYI Motors conversion -->
					<!-- Manufacturer and model are to be passed only as hidden, the hardcoding is required becuase the PI does not support the dynamic change -->
					<xsl:when test="not($attrId = $Attr.Manufacturer or $attrId = $Attr.Model) ">
						<tr>
							<td nowrap="nowrap" width="80" valign="top">
								<xsl:if test="$thisPage='SYI' and ($SelectedAttributeXPath[@id=$attrId]/Value[@id > 0] or $SelectedAttributeXPath[@id=$attrId]/Value[@id = -6 or @id = -3])">
									<input type="hidden" name="{concat('attr_h',$VCSID, '_', $attrId)}">
										<xsl:attribute name="value"><xsl:for-each select="$SelectedAttributeXPath[@id=$attrId]/Value"><xsl:value-of select="@id"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each></xsl:attribute>
									</input>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="$isLabelVisible">
										<xsl:apply-templates select="Label" mode="ryi">
											<xsl:with-param name="attrId" select="$attrId"/>
											<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td width="10">&#160;&#160;</td>
							<td valign="top">
								<xsl:apply-templates select="Input" mode="ryi">
									<xsl:with-param name="attrId" select="$attrId"/>
									<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
								</xsl:apply-templates>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<!-- Changed for SYI motors conversion -->
						<!-- Display Year Make: Model -->
						<xsl:if test="$attrId=$Attr.Manufacturer and $CatalogEnabled">
							<tr>
								<td>
									<b>
										<xsl:value-of select="/ebay/SYI.Data/ProductAttributes/Attribute[@id=$Attr.Year]/ValueList/Value/Name"/>&#160;<xsl:value-of select="/ebay/SYI.Data/ProductAttributes/Attribute[@id=$Attr.Manufacturer]/ValueList/Value/Name"/>
										<xsl:if test="boolean(/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$Attr.Model])">
										&#160;:&#160;<xsl:value-of select="/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$Attr.Model]/Value/Name"/>
										</xsl:if>
									</b>
								</td>
							</tr>
						</xsl:if>
						<!-- Changed for SYI motors conversion -->
						<!-- Send a hidden variable for all attributes which are hidden -->
						<input type="hidden" name="{concat('attr_h',$VCSID,'_',$attrId)}" value="{/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/@id}"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$SelectedAttributeXPath[@id=$attrId and @noEdit='true'] and not($IsSiteAutos)">
				<xsl:if test="Label[.!='&#160;' or .!='spacer'] or $isLabelVisible">
					<tr>
						<td nowrap="nowrap" valign="top">
							<xsl:apply-templates select="Label" mode="ryi">
								<xsl:with-param name="attrId" select="$attrId"/>
								<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
							</xsl:apply-templates>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<td valign="top">
						<xsl:if test="$thisPage='SYI' and ($SelectedAttributeXPath[@id=$attrId]/Value[@id > 0] or $SelectedAttributeXPath[@id=$attrId]/Value[@id = -6 or @id = -3])">
							<input type="hidden" name="{concat('attr_h',$VCSID, '_', $attrId)}">
								<xsl:attribute name="value"><xsl:for-each select="$SelectedAttributeXPath[@id=$attrId]/Value"><xsl:value-of select="@id"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each></xsl:attribute>
							</input>
						</xsl:if>
						<xsl:apply-templates select="Input" mode="ryi">
							<xsl:with-param name="attrId" select="$attrId"/>
							<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
							<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
						</xsl:apply-templates>
					</td>
				</tr>
			</xsl:when>
			<xsl:when test="$SelectedAttributeXPath[@id=$attrId and @noEdit='true'] and $IsSiteAutos">
				<tr>
					<xsl:choose>
						<xsl:when test="$attrId=$Attr.StandardEqp or $attrId=$Attr.OptionalEqp or $attrId=$Attr.Options or $attrId=$Attr.SafetyFeatures or $attrId=$Attr.PowerOptions and (/ebay/SellerOptions/HasBidsOrPurchases or /ebay/SellerOptions/IsLessThan12Hours)">
							<xsl:if test="Label[.!='&#160;' or .!='spacer'] or $isLabelVisible">
								<td nowrap="nowrap" valign="top" width="160">
									<xsl:apply-templates select="Label" mode="ryi">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:apply-templates>
								</td>
							</xsl:if>
							<td>
								<xsl:if test="$thisPage='SYI' and ($SelectedAttributeXPath[@id=$attrId]/Value[@id > 0] or $SelectedAttributeXPath[@id=$attrId]/Value[@id = -6 or @id = -3])">
									<input type="hidden" name="{concat('attr_h',$VCSID, '_', $attrId)}">
										<xsl:attribute name="value"><xsl:for-each select="$SelectedAttributeXPath[@id=$attrId]/Value"><xsl:value-of select="@id"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each></xsl:attribute>
									</input>
								</xsl:if>
								<xsl:apply-templates select="Input" mode="attributes">
									<xsl:with-param name="attrId" select="$attrId"/>
									<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
								</xsl:apply-templates>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="Label[.!='&#160;' or .!='spacer'] or $isLabelVisible">
								<td nowrap="nowrap" valign="top" width="160">
									<xsl:apply-templates select="Label" mode="ryi">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:apply-templates>
								</td>
							</xsl:if>
							<td>
								<xsl:if test="$thisPage='SYI' and ($SelectedAttributeXPath[@id=$attrId]/Value[@id > 0] or $SelectedAttributeXPath[@id=$attrId]/Value[@id = -6 or @id = -3])">
									<input type="hidden" name="{concat('attr_h',$VCSID, '_', $attrId)}">
										<xsl:attribute name="value"><xsl:for-each select="$SelectedAttributeXPath[@id=$attrId]/Value"><xsl:value-of select="@id"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each></xsl:attribute>
									</input>
								</xsl:if>
								<xsl:apply-templates select="Input" mode="ryi">
									<xsl:with-param name="attrId" select="$attrId"/>
									<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
								</xsl:apply-templates>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
			</xsl:when>
			<xsl:when test="$widgetType='normal'">
				<xsl:if test="($attrMessageTop != '' and $ShowMessage = 'true' ) or $attrMessagePFTop">
					<tr>
						<td>
							<xsl:attribute name="colspan"><xsl:if test="$attrMessagePFTop and $thisPage='PF'">3</xsl:if></xsl:attribute>
							<xsl:call-template name="DisplayMessage">
								<xsl:with-param name="attrId" select="$attrId"/>
								<xsl:with-param name="attrMessage" select="$attrMessageTop"/>
								<xsl:with-param name="messageStyle" select="../MessageTop"/>
								<xsl:with-param name="attrMessagePF" select="$attrMessagePFTop"/>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:if>
				<!-- changed for SYI Motors -->
				<xsl:choose>
					<xsl:when test="$IsSiteAutos">
						<tr>
							<td>
								<table border="0" cellpadding="0" cellspacing="0">
									<tr>
										<xsl:if test="($attrMessageLeft!= '' and $ShowMessage = 'true' ) or $attrMessagePFLeft">
											<td>
												<xsl:call-template name="DisplayMessage">
													<xsl:with-param name="attrId" select="$attrId"/>
													<xsl:with-param name="attrMessage" select="$attrMessageLeft"/>
													<xsl:with-param name="messageStyle" select="../MessageLeft"/>
													<xsl:with-param name="attrMessagePF" select="$attrMessagePFLeft"/>
												</xsl:call-template>
											</td>
										</xsl:if>
										<td>
											<!-- output input and label -->
											<table border="0" cellpadding="0" cellspacing="0">
												<xsl:choose>
													<xsl:when test="@quadrant = 'bottom'">
														<xsl:call-template name="AttributeQuadrantBottom">
															<xsl:with-param name="attrId" select="$attrId"/>
															<xsl:with-param name="VCSID" select="$VCSID"/>
															<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
															<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:when test="@quadrant = 'top'">
														<xsl:call-template name="AttributeQuadrantTop">
															<xsl:with-param name="attrId" select="$attrId"/>
															<xsl:with-param name="VCSID" select="$VCSID"/>
															<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
															<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
															<xsl:with-param name="MessageRight" select="../MessageRight"/>
														</xsl:call-template>
														<xsl:if test="$thisPage='SYI' and NoJS">
															<noscript>
																<tr>
																	<td>
																		<xsl:copy-of select="$Image.ArrowMaroon"/>
																		<font size="2" face="Arial, Helvetica, sans-serif">Click Update below to see relevant choices</font>
																	</td>
																</tr>
															</noscript>
														</xsl:if>
													</xsl:when>
													<xsl:when test="@quadrant = 'left'">
														<xsl:call-template name="AttributeQuadrantLeft">
															<xsl:with-param name="attrId" select="$attrId"/>
															<xsl:with-param name="VCSID" select="$VCSID"/>
															<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
															<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:when test="@quadrant = 'right'">
														<xsl:call-template name="AttributeQuadrantRight">
															<xsl:with-param name="attrId" select="$attrId"/>
															<xsl:with-param name="VCSID" select="$VCSID"/>
															<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
															<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:otherwise>
														<tr>
															<td>
																<xsl:choose>
																	<xsl:when test="$thisPage!='PF'">
																		<xsl:attribute name="nowrap"><xsl:value-of select="'nowrap'"/></xsl:attribute>
																	</xsl:when>
																	<xsl:otherwise/>
																</xsl:choose>
																<xsl:apply-templates select="Label">
																	<xsl:with-param name="attrId" select="$attrId"/>
																	<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
																</xsl:apply-templates>
															</td>
														</tr>
													</xsl:otherwise>
												</xsl:choose>
											</table>
											<!-- end input and label -->
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</xsl:when>
					<!-- changed so that SYI Motors cases don;t affect the other sites -->
					<xsl:otherwise>
						<tr>
							<td>
								<table border="0" cellpadding="0" cellspacing="0">
									<tr>
										<xsl:if test="($attrMessageLeft!= '' and $ShowMessage = 'true' ) or $attrMessagePFLeft">
											<td>
												<xsl:call-template name="DisplayMessage">
													<xsl:with-param name="attrId" select="$attrId"/>
													<xsl:with-param name="attrMessage" select="$attrMessageLeft"/>
													<xsl:with-param name="messageStyle" select="../MessageLeft"/>
													<xsl:with-param name="attrMessagePF" select="$attrMessagePFLeft"/>
												</xsl:call-template>
											</td>
										</xsl:if>
										<td>
											<!-- output input and label -->
											<table border="0" cellpadding="0" cellspacing="0">
												<xsl:choose>
													<xsl:when test="@quadrant = 'bottom'">
														<xsl:call-template name="AttributeQuadrantBottom">
															<xsl:with-param name="attrId" select="$attrId"/>
															<xsl:with-param name="VCSID" select="$VCSID"/>
															<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
															<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:when test="@quadrant = 'top'">
														<xsl:call-template name="AttributeQuadrantTop">
															<xsl:with-param name="attrId" select="$attrId"/>
															<xsl:with-param name="VCSID" select="$VCSID"/>
															<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
															<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
														</xsl:call-template>
														<xsl:if test="$thisPage='SYI' and NoJS">
															<noscript>
																<tr>
																	<td>
																		<xsl:copy-of select="$Image.ArrowMaroon"/>
																		<font size="2" face="Arial, Helvetica, sans-serif">Click Update below to see relevant choices</font>
																	</td>
																</tr>
															</noscript>
														</xsl:if>
													</xsl:when>
													<xsl:when test="@quadrant = 'left'">
														<xsl:call-template name="AttributeQuadrantLeft">
															<xsl:with-param name="attrId" select="$attrId"/>
															<xsl:with-param name="VCSID" select="$VCSID"/>
															<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
															<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:when test="@quadrant = 'right'">
														<xsl:call-template name="AttributeQuadrantRight">
															<xsl:with-param name="attrId" select="$attrId"/>
															<xsl:with-param name="VCSID" select="$VCSID"/>
															<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
															<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
														</xsl:call-template>
													</xsl:when>
													<xsl:otherwise>
														<tr>
															<td>
																<xsl:choose>
																	<xsl:when test="$thisPage!='PF'">
																		<xsl:attribute name="nowrap"><xsl:value-of select="'nowrap'"/></xsl:attribute>
																	</xsl:when>
																	<xsl:otherwise/>
																</xsl:choose>
																<xsl:apply-templates select="Label">
																	<xsl:with-param name="attrId" select="$attrId"/>
																	<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
																</xsl:apply-templates>
															</td>
														</tr>
													</xsl:otherwise>
												</xsl:choose>
											</table>
											<!-- end input and label -->
										</td>
										<xsl:if test="($attrMessageRight!= '' and $ShowMessage = 'true' ) or $attrMessagePFRight">
											<td valign="top">
												<xsl:call-template name="DisplayMessage">
													<xsl:with-param name="attrId" select="$attrId"/>
													<xsl:with-param name="attrMessage" select="$attrMessageRight"/>
													<xsl:with-param name="messageStyle" select="../MessageRight"/>
													<xsl:with-param name="attrMessagePF" select="$attrMessagePFRight"/>
												</xsl:call-template>
											</td>
										</xsl:if>
									</tr>
								</table>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
				<!-- changed for SYI Motors as message at bottom is shown differently -->
				<xsl:if test="($attrMessageBottom != '' and $ShowMessage = 'true' ) or $attrMessagePFBottom">
					<xsl:choose>
						<!-- Suppress the VIN message for Motors flow. BUGDB00170660 -->
						<xsl:when test="$IsSiteAutos and  $attrId = $Attr.VIN">
					</xsl:when>
						<xsl:when test="$IsSiteAutos and  not($attrId = $Attr.VIN and $CatalogEnabled)">
							<tr valign="top">
								<td valign="top">
									<xsl:attribute name="colspan"><xsl:if test="$attrMessagePFBottom and $thisPage='PF'">3</xsl:if></xsl:attribute>
									<table width="100%">
										<tr valign="top">
											<xsl:if test="$IsColPad">
												<td width="150" valign="top">&#160;</td>
											</xsl:if>
											<td valign="top">
												<xsl:call-template name="DisplayMessage">
													<xsl:with-param name="attrId" select="$attrId"/>
													<xsl:with-param name="attrMessage" select="$attrMessageBottom"/>
													<xsl:with-param name="messageStyle" select="../MessageBottom"/>
													<xsl:with-param name="attrMessagePF" select="$attrMessagePFBottom"/>
												</xsl:call-template>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</xsl:when>
						<xsl:when test="not($IsSiteAutos)">
							<tr>
								<td>
									<xsl:attribute name="colspan"><xsl:if test="$attrMessagePFBottom and $thisPage='PF'">3</xsl:if></xsl:attribute>
									<xsl:call-template name="DisplayMessage">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="attrMessage" select="$attrMessageBottom"/>
										<xsl:with-param name="messageStyle" select="../MessageBottom"/>
										<xsl:with-param name="attrMessagePF" select="$attrMessagePFBottom"/>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<!-- end widget type = "normal" -->
			<xsl:otherwise>
				<td>
					<!--  valign="top" -->
					<table border="0" cellpadding="0" cellspacing="0">
						<!-- BUGDB00146474 remove messages from API -->
						<xsl:if test="$attrMessageTop != ''  and $ShowMessage = 'true' ">
							<tr>
								<td>
									<xsl:call-template name="DisplayMessage">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="attrMessage" select="$attrMessageTop"/>
										<xsl:with-param name="messageStyle" select="../MessageTop"/>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<!-- 
						<td>
								<table border="0" cellpadding="0" cellspacing="0">
									<tr>			
						-->
							<!-- BUGDB00146474 remove messages from API -->
							<xsl:if test="$attrMessageLeft!= ''  and $ShowMessage = 'true' ">
								<td>
									<xsl:call-template name="DisplayMessage">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="attrMessage" select="$attrMessageLeft"/>
										<xsl:with-param name="messageStyle" select="../MessageLeft"/>
									</xsl:call-template>
								</td>
							</xsl:if>
							<td>
								<table border="0" cellpadding="0" cellspacing="0">
									<!-- display label and input -->
									<xsl:choose>
										<xsl:when test="@quadrant = 'bottom'">
											<xsl:call-template name="AttributeQuadrantBottom">
												<xsl:with-param name="attrId" select="$attrId"/>
												<xsl:with-param name="VCSID" select="$VCSID"/>
												<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
												<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="@quadrant = 'top'">
											<xsl:call-template name="AttributeQuadrantTop">
												<xsl:with-param name="attrId" select="$attrId"/>
												<xsl:with-param name="VCSID" select="$VCSID"/>
												<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
												<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="@quadrant = 'left'">
											<xsl:call-template name="AttributeQuadrantLeft">
												<xsl:with-param name="attrId" select="$attrId"/>
												<xsl:with-param name="VCSID" select="$VCSID"/>
												<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
												<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="@quadrant = 'right'">
											<xsl:call-template name="AttributeQuadrantRight">
												<xsl:with-param name="attrId" select="$attrId"/>
												<xsl:with-param name="VCSID" select="$VCSID"/>
												<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
												<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td>
													<xsl:apply-templates select="Label">
														<xsl:with-param name="attrId" select="$attrId"/>
														<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
													</xsl:apply-templates>&#160;
															</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!-- end display label and input -->
								</table>
							</td>
							<xsl:if test="$attrMessageRight!= '' and $ShowMessage = 'true'">
								<td>
									<xsl:call-template name="DisplayMessage">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="attrMessage" select="$attrMessageRight"/>
										<xsl:with-param name="messageStyle" select="../MessageRight"/>
									</xsl:call-template>
								</td>
							</xsl:if>
							<!-- 		
									</tr>
								</table>
							</td>
							-->
						</tr>
						<!-- BUGDB00146474 remove messages from API -->
						<xsl:if test="$attrMessageBottom != ''  and $ShowMessage = 'true' ">
							<tr>
								<td>
									<xsl:call-template name="DisplayMessage">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="attrMessage" select="$attrMessageBottom"/>
										<xsl:with-param name="messageStyle" select="../MessageBottom"/>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
					</table>
				</td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- =================================================================
		Attribute Quadrant Bottom
	================================================================== -->
	<!-- 
		<template name="AttributeQuadrantBottom">
		
			The template is used to generate attribute with label arranged below the input box.
			
			<param name="attrId">Attribute id</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
		</template>
	-->
	<xsl:template name="AttributeQuadrantBottom">
		<xsl:param name="attrId"/>
		<xsl:param name="VCSID"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:variable name="isLabelVisible">
			<xsl:choose>
				<xsl:when test="$thisPage!='PF'">
					<xsl:value-of select="$CurrentAttributeXPath[@id=$attrId]/@labelVisible"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'true'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="IsOtherSelected">
			<xsl:if test="$subPage='API' ">
				<xsl:apply-templates mode="IsOtherSelected" select="Input">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:variable>
		<tr>
			<td>
				<xsl:apply-templates select="Input" mode="attributes">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
				</xsl:apply-templates>
				<xsl:if test="$IsOtherSelected = 'selected' ">
					<xsl:apply-templates mode="API.Other" select="$CurrentAttributeXPath/../../Other/Attribute[@id = $attrId]">
						<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
						<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					</xsl:apply-templates>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="$thisPage!='PF'">
						<xsl:attribute name="nowrap"><xsl:value-of select="'nowrap'"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$CurrentAttributeXPath[@id=$attrId]">
						<xsl:apply-templates select="Label">
							<xsl:with-param name="attrId" select="$attrId"/>
							<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="Label">&#160;</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</td>
		</tr>
		<xsl:call-template name="AttributeError">
			<xsl:with-param name="InputId" select="$attrId"/>
			<xsl:with-param name="VCSID" select="$VCSID"/>
		</xsl:call-template>
	</xsl:template>
	<!-- =================================================================
		Attribute Quadrant Top
	================================================================== -->
	<!-- 
		<template name="AttributeQuadrantTop">
		
			The template is used to generate attribute with label arranged above the input box.
			
			<param name="attrId">Attribute id</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
		</template>
	-->
	<xsl:template name="AttributeQuadrantTop">
		<xsl:param name="attrId"/>
		<xsl:param name="VCSID"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:param name="MessageRight"/>
		<xsl:variable name="isLabelVisible">
			<xsl:choose>
				<xsl:when test="$thisPage!='PF'">
					<xsl:value-of select="$CurrentAttributeXPath[@id=$attrId]/@labelVisible"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'true'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="IsOtherSelected">
			<xsl:if test="$subPage='API' ">
				<xsl:apply-templates mode="IsOtherSelected" select="Input">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:variable>
		<!-- Changed for SYI motors conversion
		Motors Item specific display needs to be in the V2 format 
		Hence a special check is required
		-->
		<xsl:if test="not($IsSiteAutos)">
			<tr align="{@align}">
				<td valign="top">
					<xsl:choose>
						<xsl:when test="$thisPage!='PF'">
							<xsl:attribute name="nowrap"><xsl:value-of select="'nowrap'"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$CurrentAttributeXPath[@id=$attrId]">
							<xsl:apply-templates select="Label">
								<xsl:with-param name="attrId" select="$attrId"/>
								<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="Label">&#160;</xsl:when>
						<xsl:otherwise/>
					</xsl:choose><img height="2" src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="5"/>
				</td>
			</tr>
			<tr align="{@align}">
				<td>
					<xsl:apply-templates select="Input" mode="attributes">
						<xsl:with-param name="attrId" select="$attrId"/>
						<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
						<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
					</xsl:apply-templates>
					<xsl:if test="$IsOtherSelected = 'selected'">
						<xsl:apply-templates mode="API.Other" select="$CurrentAttributeXPath/../../Other/Attribute[@id = $attrId]">
							<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
							<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
						</xsl:apply-templates>
					</xsl:if><img height="2" src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="5"/>
				</td>
			</tr>
		</xsl:if>
		<!-- 
		Changed for SYI Motors conversion.
		Some attributes need the current form generator fields. 
		They are hardcoded. Some don't! -->
		<xsl:if test="$IsSiteAutos">
			<xsl:choose>
				<xsl:when test="$attrId=$Attr.StandardEqp or $attrId=$Attr.OptionalEqp">
					<tr align="{@align}">
						<td valign="top">
							<xsl:choose>
								<xsl:when test="$thisPage!='PF'">
									<xsl:attribute name="nowrap"><xsl:value-of select="'nowrap'"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="$CurrentAttributeXPath[@id=$attrId]">
									<xsl:apply-templates select="Label">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:apply-templates>
								</xsl:when>
								<xsl:when test="Label">&#160;</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</td><img height="2" src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="5"/>
					</tr>
					<tr align="{@align}">
						<td>
							<xsl:apply-templates select="Input" mode="attributes">
								<xsl:with-param name="attrId" select="$attrId"/>
								<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
								<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
							</xsl:apply-templates>
							<xsl:if test="$IsOtherSelected = 'selected'">
								<xsl:apply-templates mode="API.Other" select="$CurrentAttributeXPath/../../Other/Attribute[@id = $attrId]">
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
								</xsl:apply-templates>
							</xsl:if><img height="2" src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="5"/>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr align="{@align}">
						<!-- Dirty motors code to show the attributes in v2 format -->
						<td valign="top" width="160">
							<xsl:choose>
								<xsl:when test="$thisPage!='PF'">
									<xsl:attribute name="nowrap"><xsl:value-of select="'nowrap'"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="$CurrentAttributeXPath[@id=$attrId]">
									<xsl:apply-templates select="Label">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:apply-templates>
								</xsl:when>
								<xsl:when test="Label">&#160;</xsl:when>
								<xsl:otherwise/>
							</xsl:choose><img height="2" src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="5"/>
						</td>
						<xsl:variable name="attrMsgRight" select="normalize-space($CurrentAttributeXPath[@id = $attrId]/MessageRight)"/>
						<td>
							<!-- <xsl:choose>
								<xsl:when test="(/ebay/SellerOptions/HasBidsOrPurchases or /ebay/SellerOptions/IsLessThan12Hours) and $SelectedAttributeXPath[@id=$attrId]/Value/@id != -10">
									<xsl:apply-templates select="Input" mode="ryi">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:apply-templates>
								</xsl:when>	
								<xsl:otherwise> -->
									<xsl:apply-templates select="Input" mode="attributes">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:apply-templates>
							<!-- 	</xsl:otherwise>	
							</xsl:choose> -->
							<xsl:if test="$IsOtherSelected = 'selected'">
								<xsl:apply-templates mode="API.Other" select="$CurrentAttributeXPath/../../Other/Attribute[@id = $attrId]">
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
								</xsl:apply-templates>
							</xsl:if>
							<xsl:if test="$attrMsgRight != ''">
								<xsl:call-template name="DisplayMessage">
									<xsl:with-param name="attrId" select="$attrId"/>
									<xsl:with-param name="attrMessage" select="$attrMsgRight"/>
									<xsl:with-param name="messageStyle" select="$MessageRight"/>
									<xsl:with-param name="attrMessagePF" select="true()"/>
								</xsl:call-template>
						</xsl:if><img height="2" src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="5"/>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:call-template name="AttributeError">
			<xsl:with-param name="InputId" select="$attrId"/>
			<xsl:with-param name="VCSID" select="$VCSID"/>
			<xsl:with-param name="Col" select="$ColSpan"/>
			<xsl:with-param name="ColPad" select="$IsColPad"/>
		</xsl:call-template>
	</xsl:template>
	<!-- =================================================================
		Attribute Quadrant Left
	================================================================== -->
	<!-- 
		<template name="AttributeQuadrantLeft">
		
			The template is used to generate attribute with label arranged on the left of the input box.
			
			<param name="attrId">Attribute id</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
		</template>
	-->
	<xsl:template name="AttributeQuadrantLeft">
		<xsl:param name="attrId"/>
		<xsl:param name="VCSID"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:variable name="isLabelVisible">
			<xsl:choose>
				<xsl:when test="$thisPage!='PF'">
					<xsl:value-of select="$CurrentAttributeXPath[@id=$attrId]/@labelVisible"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'true'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="IsOtherSelected">
			<xsl:if test="$subPage='API' ">
				<xsl:apply-templates mode="IsOtherSelected" select="Input">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:variable>
		<tr align="{@align}">
			<td valign="middle">
				<xsl:choose>
					<xsl:when test="$thisPage!='PF'">
						<xsl:attribute name="nowrap"><xsl:value-of select="'nowrap'"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$CurrentAttributeXPath[@id=$attrId]">
						<xsl:apply-templates select="Label">
							<xsl:with-param name="attrId" select="$attrId"/>
							<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>&#160;</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:apply-templates select="Input" mode="attributes">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
				</xsl:apply-templates>
				<xsl:if test="$IsOtherSelected = 'selected'">
					<xsl:apply-templates mode="API.Other" select="$CurrentAttributeXPath/../../Other/Attribute[@id = $attrId]">
						<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
						<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					</xsl:apply-templates>
				</xsl:if>
			</td>
		</tr>
		<xsl:call-template name="AttributeError">
			<xsl:with-param name="InputId" select="$attrId"/>
			<xsl:with-param name="VCSID" select="$VCSID"/>
			<xsl:with-param name="Col" select="'2'"/>
		</xsl:call-template>
	</xsl:template>
	<!-- =================================================================
		Attribute Quadrant Right
	================================================================== -->
	<!-- 
		<template name="AttributeQuadrantRight">
		
			The template is used to generate attribute with label arranged on the right of the input box.
			
			<param name="attrId">Attribute id</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
		</template>
	-->
	<xsl:template name="AttributeQuadrantRight">
		<xsl:param name="attrId"/>
		<xsl:param name="VCSID"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:variable name="isLabelVisible">
			<xsl:choose>
				<xsl:when test="$thisPage!='PF'">
					<xsl:value-of select="$CurrentAttributeXPath[@id=$attrId]/@labelVisible"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'true'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="IsOtherSelected">
			<xsl:if test="$subPage='API' ">
				<xsl:apply-templates mode="IsOtherSelected" select="Input">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:variable>
		<tr>
			<td align="{@align}">
				<xsl:apply-templates select="Input" mode="attributes">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
				</xsl:apply-templates>
				<xsl:if test="$IsOtherSelected = 'selected'">
					<xsl:apply-templates mode="API.Other" select="$CurrentAttributeXPath/../../Other/Attribute[@id = $attrId]">
						<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
						<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
					</xsl:apply-templates>
				</xsl:if>
			</td>
			<td valign="middle">
				<xsl:choose>
					<xsl:when test="$thisPage!='PF'">
						<xsl:attribute name="nowrap"><xsl:value-of select="'nowrap'"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$CurrentAttributeXPath[@id=$attrId]">
						<xsl:apply-templates select="Label">
							<xsl:with-param name="attrId" select="$attrId"/>
							<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>&#160;</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<xsl:call-template name="AttributeError">
			<xsl:with-param name="InputId" select="$attrId"/>
			<xsl:with-param name="VCSID" select="$VCSID"/>
			<xsl:with-param name="Col" select="'2'"/>
		</xsl:call-template>
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/attr_attribute.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<!-- 
		<template name="CheckboxRadio">
		
			The template is to generate attribute as a set of checboxes or radioboxes, based on the parameter type passed..
			
			<param name="attrId">Attribute id</param>
			<param name="columns">Number of columns per row to be used to arrange input boxes.</param>
			<param name="type">
				Type of the input box.
				<enum>
					<value>checkbox<note>to generate checkbox element</note></value>
					<value>radio<note>to generate radiobox element</note></value>
				</enum>
			</param>
			<param name="inputName">Name of the input box that.</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="CheckboxRadio">
		<xsl:param name="attrId"/>
		<xsl:param name="columns"/>
		<xsl:param name="type"/>
		<xsl:param name="inputName"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:param name="VCSID"/>
		<xsl:variable name="IsSiteAutos" select="boolean(/ebay/Environment/@siteId='100')"/>
		<table cellpadding="0" cellspacing="0" border="0">
			<xsl:variable name="syiParentAttrId" select="$CurrentAttributeXPath[Dependency/@childAttrId=$attrId]/@id"/>
			<xsl:variable name="syiParentValueId" select="$SelectedAttributeXPath[@id=$syiParentAttrId]/Value/@id[. = $CurrentAttributeXPath/Dependency[@childAttrId=$attrId]/@parentValueId]"/>
			<xsl:variable name="dependentAttrValues" select="$CurrentAttributeXPath[@id=$syiParentAttrId]/Dependency[@parentValueId=$syiParentValueId and @childAttrId=$attrId]/Value[count(. | key('attrByIDs', concat($VCSID, '_', key('selectedAttrByIDs', concat($VCSID, '_', ../../../@id, '_', ../@parentValueId))/@id, '_', @id))[1])=1]"/>
			<xsl:variable name="attrValues" select="$CurrentAttributeXPath[@id=$attrId]/ValueList/Value"/>
			<xsl:variable name="attrs" select="$attrValues | $dependentAttrValues[@id != 0] | $CurrentAttributeXPath[@id=$syiParentAttrId and $subPage != 'API']/Dependency[@childAttrId=$attrId]/Value"/>
			<xsl:for-each select="$attrs">
				<xsl:variable name="position" select="position()"/>
				<xsl:variable name="last" select="last()"/>
				<xsl:if test="(($position mod $columns) = 1) or $columns=1">
					<xsl:variable name="cols">
						<xsl:choose>
							<xsl:when test="$position + $columns &gt; $last">
								<xsl:value-of select="$last - $position + 1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$columns"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr>
						<xsl:call-template name="WidgetGroupTableCell">
							<xsl:with-param name="attrs" select="$attrs[position() &gt;= $position]"/>
							<xsl:with-param name="cols" select="$cols"/>
							<xsl:with-param name="max" select="$cols"/>
							<xsl:with-param name="inputName" select="$inputName"/>
							<xsl:with-param name="attrId" select="$attrId"/>
							<xsl:with-param name="WidgetType" select="$type"/>
							<xsl:with-param name="IsEmpty" select="not($SelectedAttributeXPath[@id=$attrId]/Value)"/>
							<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
							<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
							<xsl:with-param name="VCSID" select="$VCSID"/>
							<xsl:with-param name="isDefault" select="@isDefault"/>
						</xsl:call-template>
						<!-- IF LAST ROW IS INCOMPLETE, FINISH IT -->
						<xsl:if test="((last()-position()) &lt; $columns) and ((last() mod $columns) != 0)">
							<td>
								<xsl:attribute name="colspan"><xsl:value-of select="$columns - (last() mod $columns)"/></xsl:attribute>
							</td>
						</xsl:if>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</table>
	</xsl:template>
	<!-- 
		<template name="WidgetGroupTableCell">
		
			The template is to generate a row of check/radiobox elements for the attribute. It's used by the template with the name="CheckboxRadio".			
			<param name="attrs">A subset of attribute values that follow the value already parsed or the full set if it's a starting point</param>
			<param name="cols">Number of columns left to generate in the row. Used in decremental order. The template is recursively called until cols is 0</param>
			<param name="max">Number of columns to generate, used to keep track of how many needs to be generated during recursive calls</param>
			<param name="inputName">Name of the input box that.</param>
			<param name="attrId">Attribute id</param>
			<param name="WidgetType">
				Type of the input box.
				<enum>
					<value>checkbox<note>to generate checkbox element</note></value>
					<value>radio<note>to generate radiobox element</note></value>
				</enum>
			</param>
			<param name="IsEmpty">Says if the attribute has no values currently selected</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="WidgetGroupTableCell">
		<xsl:param name="attrs"/>
		<xsl:param name="cols"/>
		<xsl:param name="max"/>
		<!-- This template is used by radio buttons and check boxes. -->
		<xsl:param name="inputName"/>
		<xsl:param name="attrId"/>
		<xsl:param name="WidgetType"/>
		<xsl:param name="IsEmpty"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:param name="VCSID"/>
		<xsl:param name="isDefault"/>
		<xsl:variable name="getattrId" select="$attrs[$max - $cols + 1]/../../@id"/>
		<xsl:variable name="getValueId" select="$attrs[$max - $cols + 1]/@id"/>
		<xsl:variable name="hasDisplayName" select="boolean($attrs[$max - $cols + 1]/DisplayName!='')"/>
		<!-- for multi-units: show 'DisplayName' is available, otherwise show 'Name'-->
		<xsl:variable name="WidgetName" select="$attrs[$max - $cols + 1]/DisplayName[$hasDisplayName] | $attrs[$max - $cols + 1]/Name[not($hasDisplayName)]"/>
		<xsl:variable name="IsDefault" select="$attrs[$max - $cols + 1]/IsDefault"/>
		<!-- DT...Need further refactoring once Dependencies are consistent -->
		<xsl:if test="$cols &gt; 0">
			<td valign="top">
				<xsl:choose>
					<xsl:when test="$thisPage='SYI'">
						<xsl:variable name="CBValue">
							<!-- This is the check to show the Option String instead of attribute value, when the attribute value = -3 -->
							<xsl:choose>
								<xsl:when test="$getValueId = -3">
									<xsl:value-of select="$WidgetName"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$getValueId"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="FieldName" select="concat('attr',$VCSID,'_',$attrId)"/>
						<xsl:choose>
							<xsl:when test="$SelectedAttributeXPath[@id=$attrId and @noEdit='true'] and $IsSiteAutos and ($attrId=$Attr.Options or $attrId=$Attr.SafetyFeatures or $attrId=$Attr.PowerOptions and (/ebay/SellerOptions/HasBidsOrPurchases or /ebay/SellerOptions/IsLessThan12Hours)) and (($UsePostedFormFields and $getValueId = $FormFields/FormField[@name = $FieldName]/Value) or $SelectedAttributeXPath[@id=$getattrId]/Value[@id=$getValueId] or ($IsEmpty and $IsDefault) or $subPage='API' and $SelectedAttributeXPath[@id=$attrId]/Value[@id=$getValueId])">
								<img src="http://pics.ebaystatic.com/aw/pics/check_14x16.gif" width="14" height="16"/>
								<img src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="6" height="1"/>
								<!-- <input type="hidden" name="{$FieldName}" value="{$CBValue}"/> -->
							</xsl:when>
							<xsl:when test="$SelectedAttributeXPath[@id=$attrId and @noEdit='true'] and $IsSiteAutos and ($attrId=$Attr.StandardEqp or $attrId=$Attr.OptionalEqp) and (/ebay/SellerOptions/HasBidsOrPurchases or /ebay/SellerOptions/IsLessThan12Hours) and /ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]//Name=$WidgetName">
								<img src="http://pics.ebaystatic.com/aw/pics/check_14x16.gif" width="14" height="16"/>
								<img src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="6" height="1"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="{$WidgetType}" value="{$CBValue}">
									<xsl:choose>
										<xsl:when test="$subPage = 'API' and $CurrentAttributeXPath[@id=$attrId]/Dependency[@type='4' or @type='3' or type='5']">
											<xsl:attribute name="onClick">vvc_anyParent('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>','attr<xsl:value-of select="$getValueId"/>'); vvsp_check('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>', this.value);</xsl:attribute>
											<!-- JO: commented out Post for type 4 because conditionally visible attributes are moved over to next page (multi-page flow), SYI only. -->
											<!-- VVSP / Conditional Attribute (VA) -->
										</xsl:when>
										<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='1' or @type='2']">
											<xsl:attribute name="onClick">vvc_anyParent('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>','attr<xsl:value-of select="$getValueId"/>');</xsl:attribute>
											<!-- VVC or VVP -->
										</xsl:when>
										<xsl:when test="$subPage = 'API' and $getValueId ='-6' ">
											<xsl:attribute name="onClick">api_check_on_other('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',-6);</xsl:attribute>
										</xsl:when>
										<xsl:otherwise/>
									</xsl:choose>
									<xsl:attribute name="name"><xsl:value-of select="$FieldName"/></xsl:attribute>
									<xsl:if test="($UsePostedFormFields and $getValueId = $FormFields/FormField[@name = $FieldName]/Value) or $SelectedAttributeXPath[@id=$getattrId]/Value[@id=$getValueId] or ($IsEmpty and $IsDefault) or $subPage='API' and $SelectedAttributeXPath[@id=$attrId]/Value[@id=$getValueId]">
										<!-- Added for motors VIN flow. If an attribute is present in the characteristic set but not present in Item Attributes 
										display that attribute, but do not show it selected. -->
										<xsl:choose>
											<xsl:when test="$IsSiteAutos">
												<xsl:choose>
													<!-- Added for VIN - Optional Equipment-->
													<xsl:when test="$attrId=$Attr.OptionalEqp or $attrId=$Attr.StandardEqp">
														<!-- Second time -->
														<xsl:if test="/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id='10236']">
															<xsl:if test="/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]//Name=$WidgetName">
																<xsl:attribute name="checked">checked</xsl:attribute>
															</xsl:if>
														</xsl:if>
														<!-- Otherwise first time, do not show as prepopulated-->
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="checked">checked</xsl:attribute>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</input>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text> </xsl:text>
						<xsl:variable name="ValueLabelStyle" select="$CurrentAttributeXPath/../../../PresentationInstruction/*/Row/Widget/Attribute[@id = $attrId]/Label"/>
						<font size="2" face="Verdana,Geneva,Arial,Helvetica">
							<xsl:copy-of select="$ValueLabelStyle/@*"/>
							<xsl:choose>
								<xsl:when test="$ValueLabelStyle/@bold='true' and @italic='true'">
									<b>
										<i>
											<xsl:value-of select="$WidgetName"/>
										</i>
									</b>
								</xsl:when>
								<xsl:when test="$ValueLabelStyle/@bold='true'">
									<b>
										<xsl:value-of select="$WidgetName"/>
									</b>
								</xsl:when>
								<xsl:when test="$ValueLabelStyle/@italic='true'">
									<i>
										<xsl:value-of select="$WidgetName"/>
									</i>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$WidgetName"/>
								</xsl:otherwise>
							</xsl:choose>
						</font>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="pfId" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input/Value/@pfId"/>
						<xsl:variable name="pfPageType" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input/Value/@pfPageType"/>
						<input type="{$WidgetType}" value="{$getValueId}">
							<!-- VVC or VVP  -->
							<xsl:if test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='1' or @type='2']">
								<xsl:attribute name="onClick">vvc_anyParent('a<xsl:value-of select="$attrId"/>','a<xsl:value-of select="$getValueId"/>');</xsl:attribute>
							</xsl:if>
							<!-- Default values for PF are contained inside InputFields element.  There's no IsDefault element for PF....there is now for 1.5  -->
							<xsl:choose>
								<xsl:when test="$pfId and $pfPageType and $isDefault='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$SelectedAttributeXPath[@id=$attrId]/InputFields/Input/Value[@id=$getValueId]">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="name"><xsl:value-of select="$inputName"/></xsl:attribute>
						</input>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="$thisPage='SYI'">
				<td width="10">&#160;</td>
			</xsl:if>
			<xsl:if test="$thisPage='PF'">
				<td valign="top">
					<img src="http://pics.ebaystatic.com/aw/pics/spacer.gif" height="3" width="1" alt=""/>
					<br/>
					<font face="{$thisPI[@id=$attrId]/Input/@face}" size="{$thisPI[@id=$attrId]/Input/@size}" color="{$thisPI[@id=$attrId]/Input/@color}">
						<xsl:value-of select="$WidgetName"/>
					</font>
				</td>
			</xsl:if>
			<xsl:call-template name="WidgetGroupTableCell">
				<xsl:with-param name="attrs" select="$attrs"/>
				<xsl:with-param name="cols" select="$cols - 1"/>
				<xsl:with-param name="max" select="$max"/>
				<xsl:with-param name="inputName" select="$inputName"/>
				<xsl:with-param name="attrId" select="$attrId"/>
				<xsl:with-param name="WidgetType" select="$WidgetType"/>
				<xsl:with-param name="IsEmpty" select="$IsEmpty"/>
				<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
				<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
				<xsl:with-param name="VCSID" select="$VCSID"/>
				<xsl:with-param name="isDefault" select="following-sibling::Value/@isDefault"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/attr_checkbox_radio.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<!-- 
		<template name="date_options">
		
			The template is to generate a HTML option elements for the specified part of the date.
			
			<param name="date_part">
				Specifies the part of date to generate option list for
				<enum>
					<value>Day<note>specifies to generate the day of the month</note></value>
					<value>Month<note>specifies to generate month</note></value>
					<value>Year<note>specifies to generate year</note></value>
				</enum>
			</param>
			<param name="attr_id">Attribute id</param>
			<param name="date_sort">
				Specifies the sorting order and the format of the date part
				<enum>
					<value>ascending<note>descending order</note></value>
					<value>descending<note>ascending order</note></value>
				</enum>
			</param>
			<param name="pi_node_set">Options definded in the Presentation Instructions</param>
			<param optional="true" name="range_type">Only needed for PF date ranges</param>
			<param optional="true" name="FieldName">Field name only needed for SYI (to pull data from PostedFormFields section</param> 
		</template>
	-->

	<xsl:template name="date_options">
		<xsl:param name="format"/>
		<xsl:param name="date_part"/>
		<!-- REQUIRED: 'Day' | 'Month' | 'Year' -->
		<xsl:param name="attr_id"/>
		<!-- REQUIRED -->
		<xsl:param name="date_sort"/>
		<!-- REQUIRED FOR DAYS AND MONTHS: 'DayAscending' | 'DayDescending' | ... etc ... -->
		<xsl:param name="pi_node_set"/>
		<!-- REQUIRED FOR YEARS: options definded in the PI -->
		<xsl:param name="range_type"/>
		<!-- OPTIONAL: only needed for PF date ranges -->
		<xsl:param name="FieldName"/>
		<!-- OPTIONAL: only needed for SYI (to pull data from PostedFormFields section -->
		<xsl:param name="SelectedAttributeXPath"/>
		<!-- OPTIONAL: Needed for SYI when Listing in 2 categories -->
		<xsl:param name="VCSID"/>
		<!-- GET THE DEFAULT DATE -->
		<xsl:variable name="default_val">
			<xsl:call-template name="get_default_val">
				<xsl:with-param name="date_part" select="$date_part"/>
				<xsl:with-param name="attr_id" select="$attr_id"/>
				<xsl:with-param name="range_type" select="$range_type"/>
				<xsl:with-param name="FieldName" select="$FieldName"/>
				<xsl:with-param name="VCSID" select="$VCSID"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- GET SPECIFIC DATE STRINGS -->
		<xsl:variable name="primary_match">
			<xsl:choose>
				<xsl:when test="$pi_node_set"><xsl:value-of select="$pi_node_set"/></xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_date_strings">
						<xsl:with-param name="date_sort" select="$date_sort"/>
						<xsl:with-param name="date_part" select="$date_part"/>
						<xsl:with-param name="match" select=" 'primary' "/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="date_text">
			<xsl:choose>
				<xsl:when test="$pi_node_set"><xsl:value-of select="$pi_node_set"/></xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_date_strings">
						<xsl:with-param name="date_sort" select="$date_sort"/>
						<xsl:with-param name="date_part" select="$date_part"/>
						<xsl:with-param name="format" select="$format"/>
						<!--<xsl:with-param name="match" select=" 'text' "/>-->
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- CREATE THE DATE OPTIONS -->
		<xsl:if test="not($pi_node_set)">
			<xsl:variable name="blankValue">
				<xsl:choose>
					<xsl:when test="$date_part = 'Day'"><xsl:value-of select="$thisPI[@id=$attr_id]/DayInitialValue"/></xsl:when>
					<xsl:when test="$date_part = 'Month'"><xsl:value-of select="$thisPI[@id=$attr_id]/MonthInitialValue"/></xsl:when>
					<xsl:when test="$date_part = 'Year'"><xsl:value-of select="$thisPI[@id=$attr_id]/YearInitialValue"/></xsl:when>
					<xsl:when test="$thisPage='PF'"></xsl:when>
					<xsl:otherwise>--</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$thisPage='PF'"><option value="-24"><xsl:value-of select="$blankValue"/></option></xsl:when>
				<xsl:otherwise><option value="-10"><xsl:value-of select="$blankValue"/></option></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:call-template name="create_date_options">
			<xsl:with-param name="attr_id" select="$attr_id"/>
			<xsl:with-param name="default_val" select="$default_val"/>
			<xsl:with-param name="primary_match" select="$primary_match"/>
			<xsl:with-param name="date_text" select="$date_text"/>
			<xsl:with-param name="delim" select=" ';' "/>
			<xsl:with-param name="VCSID" select="$VCSID"/>
			<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
		</xsl:call-template>
		<!--This is for Value Carry Forward.  If the value in the inputfield of this attribute is not present in the Years node set, then add it to the bottom of the dropdown and make it selected -->
		<xsl:if test="$date_part='Year'">
		<xsl:variable name="vcf_year" select="$returnAttr[@id=$attr_id]/InputFields/Input[@dataType='Y' and @rangeType=$range_type]/Value/Name"/>
			<xsl:if test="contains($pi_node_set,$vcf_year)=false() and $vcf_year!='-24'">
				<option value="{$returnAttr[@id=$attr_id]/InputFields/Input[@dataType='Y' and @rangeType=$range_type]/Value/Name}" selected="selected">
					<xsl:value-of select="$returnAttr[@id=$attr_id]/InputFields/Input[@dataType='Y' and @rangeType=$range_type]/Value/Name"/>
				</option>				
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!-- 
		<template name="create_date_options">
		
			The template generates date HTML option elements from the provided strings of date parts 
			in three possible formats and based on user selelcted values and default.

			<param name="default_val">Default value</param>
			<param name="primary_match">Set of date parts (number format) arranged as a string of values with delimiters.</param>
			<param name="date_text">Set of date parts (long format) arranged as a string of values with delimiters.</param>
			<param name="delim">Delimiter string used</param>
			
		</template>
	-->
	<xsl:template name="create_date_options">
		<xsl:param name="attr_id"/>
		<xsl:param name="default_val"/>
		<xsl:param name="primary_match"/>
		<xsl:param name="date_text"/>
		<xsl:param name="delim" select=" ';' "/>
		<xsl:param name="VCSID"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<!-- GET THE NEXT SUBSTRING -->
		<xsl:variable name="primary" select="substring-before($primary_match,$delim)"/>
		<xsl:variable name="text" select="substring-before($date_text,$delim)"/>
		<!-- WRITE THE OPTIONS -->
		<xsl:choose>
			<xsl:when test="$thisPage='PF'">
				<option>
					<xsl:attribute name="value"><xsl:choose><xsl:when test="$primary='--' or $primary='Any' or $primary=''">-24</xsl:when><xsl:otherwise><xsl:value-of select="$primary"/></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:if test="number($default_val) = number($primary)">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$text"/>
				</option>
			</xsl:when>
			<xsl:otherwise>
				<option>
					<xsl:attribute name="value"><xsl:choose><xsl:when test="$primary='-' or $primary='--' or $primary='Any' or $primary=''">-10</xsl:when><xsl:otherwise><xsl:value-of select="$primary"/></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:if test="number($default_val) = number($primary)">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$text"/>
				</option>
			</xsl:otherwise>
		</xsl:choose>
		<!-- RECURSION, IF THERE ARE MORE SUBSTRINGS -->
		<xsl:if test="string-length(substring-after($primary_match,$delim)) &gt; 0">
			<xsl:call-template name="create_date_options">
				<xsl:with-param name="attr_id" select="$attr_id"/>
				<xsl:with-param name="default_val" select="$default_val"/>
				<xsl:with-param name="primary_match" select="substring-after($primary_match,$delim)"/>
				<xsl:with-param name="date_text" select="substring-after($date_text,$delim)"/>
				<xsl:with-param name="delim" select="$delim"/>
				<xsl:with-param name="VCSID" select="$VCSID"/>
				<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- 
		<template name="get_default_val">
		
			The template generates the values that should be selected in the date option list based on user selections, current values and initial values.

			<param required="true" name="date_part">
				Specifies the part of date to generate option list for
				<enum>
					<value>Day<note>specifies to generate the day of the month</note></value>
					<value>Month<note>specifies to generate month</note></value>
					<value>Year<note>specifies to generate year</note></value>
				</enum>
			</param>
			<param name="attr_id">Attribute id.</param>
			<param name="range_type">Only needed for PF date ranges</param>
			<param optional="true" name="FieldName">Field name only needed for SYI (to pull data from PostedFormFields section</param> 
			
		</template>
	-->
	<xsl:template name="get_default_val">
		<xsl:param name="date_part"/>
		<xsl:param name="attr_id"/>
		<xsl:param name="range_type"/>
		<xsl:param name="FieldName"/>
		<xsl:param name="VCSID"/>
		<xsl:variable name="pi" select="$thisPI[@id=$attr_id]"/>
		<!-- GET THE POSSIBLE DEFAULT VALUES -->
		<xsl:variable name="users_val">
			<xsl:choose>
				<xsl:when test="$thisPage!='PF'">
					<xsl:choose>
						<xsl:when test="$UsePostedFormFields">
							<xsl:value-of select="$FormFields/FormField[@name = $FieldName]/Value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$returnAttr[../@id=$VCSID and @id=$attr_id]/Value/*[name() = $date_part]"/>
						</xsl:otherwise>
					</xsl:choose>					
				</xsl:when>
				<xsl:when test="$subPage='API'">
					<xsl:value-of select="$returnAttr[../@id=$VCSID and @id=$attr_id]/Value/*[name() = $date_part]"/>
				</xsl:when>
				<xsl:when test="$range_type!=''">
					<xsl:value-of select="$returnAttr[@id=$attr_id]/InputFields/Input[@dataType=substring($date_part,1,1) and @rangeType=$range_type]/Value/Name" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$returnAttr[@id=$attr_id]/InputFields/Input[@dataType=substring($date_part,1,1)]/Value/Name" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="current_val">
			<xsl:if test="$pi/CurrentDate">
				<xsl:call-template name="get_current_date_string">
					<xsl:with-param name="date_part" select="$date_part"/>
					<xsl:with-param name="date" select="$attrData[@id=$attr_id]/CurrentTime/DateMedium"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="initial_val">
			<xsl:choose>
				<xsl:when test="$date_part = 'Day'"><xsl:value-of select="$pi/DayInitialValue"/></xsl:when>
				<xsl:when test="$date_part = 'Month'"><xsl:value-of select="$pi/MonthInitialValue"/></xsl:when>
				<xsl:when test="$date_part = 'Year'"><xsl:value-of select="$pi/YearInitialValue"/></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- RETURN THE RIGHT DEFAULT VALUE -->
		<xsl:choose>
			<xsl:when test="string-length($users_val) &gt; 0">
				<xsl:value-of select="$users_val"/>
			</xsl:when>
			<xsl:when test="string-length($current_val) &gt; 0">
				<xsl:value-of select="$current_val"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$initial_val"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 
		<template name="get_current_date_string">
		
			The template generates part of the date based on passed parameters.

			<param required="true" name="date_part">
				Specifies the part of date to generate option list for
				<enum>
					<value>Day<note>specifies to generate the day of the month</note></value>
					<value>Month<note>specifies to generate month</note></value>
					<value>Year<note>specifies to generate year</note></value>
				</enum>
			</param>
			<param name="date">The date delimited with '-'</param>
			
		</template>
	-->
	<xsl:template name="get_current_date_string">
		<xsl:param name="date_part"/>
		<xsl:param name="date"/>
		<xsl:variable name="month" select="substring-before($date,'-')"/>
		<xsl:variable name="day_year" select="substring-after($date,'-')"/>
		<xsl:variable name="day" select="substring-before($day_year,'-')"/>
		<xsl:variable name="year" select="substring-after($day_year,'-')"/>
		<xsl:choose>
			<xsl:when test="$date_part = 'Day'"><xsl:value-of select="$day"/></xsl:when>
			<xsl:when test="$date_part = 'Month'"><xsl:value-of select="$month"/></xsl:when>
			<xsl:when test="$date_part = 'Year' and $year"><xsl:value-of select=" concat('20',$year) "/></xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- 
		<template name="get_date_strings">
		
			The template returns the required one string of 10 possible date sets with values delimited with ';'

			<param name="date_sort">
				Specifies the sorting order and the format of the date part
				<enum>
				<enum>
					<value>ascending<note>descending order</note></value>
					<value>descending<note>ascending order</note></value>
				</enum>
				</enum>
			</param>
			<param required="true" name="date_part">
				Specifies the part of date to generate option list for
				<enum>
					<value>Day<note>specifies to generate the day of the month</note></value>
					<value>Month<note>specifies to generate month</note></value>
					<value>Year<note>specifies to generate year</note></value>
				</enum>
			</param>
			<param name="match">
				Specifies the format of the date value set to return
				<enum>
					<values>primary<note>specifies number format, i.e. date part will be returned as a number</note></values>
					<values>secondary<note>specifies number format, i.e. date part will be returned as a number</note></values>
					<values>text<note>specifies number format, i.e. date part will be returned as a number</note></values>
				</enum>
			</param>

		</template>
	-->
	<xsl:template name="get_date_strings">
		<xsl:param name="format"/>
		<xsl:param name="date_sort"/>
		<xsl:param name="date_part"/>
		<xsl:param name="match"/>
		
		<!-- ALL THE POSSIBLE DATE STRINGS -->
		<xsl:variable name="day_ascending">01;02;03;04;05;06;07;08;09;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;</xsl:variable>
		<xsl:variable name="day_descending">31;30;29;28;27;26;25;24;23;22;21;20;19;18;17;16;15;14;13;12;11;10;09;08;07;06;05;04;03;02;01;</xsl:variable>
		<xsl:variable name="month_ascending_short">Jan;Feb;Mar;Apr;May;Jun;Jul;Aug;Sep;Oct;Nov;Dec;</xsl:variable>
		<xsl:variable name="month_descending_short">Dec;Nov;Oct;Sep;Aug;Jul;Jun;May;Apr;Mar;Feb;Jan;</xsl:variable>
		<!--
		<xsl:variable name="month_ascending_long">January;February;March;April;May;June;July;August;September;October;November;December;</xsl:variable>
		<xsl:variable name="month_descending_long">December;November;October;September;August;July;June;May;April;March;February;January;</xsl:variable>
		-->
		<xsl:variable name="month_ascending_number">01;02;03;04;05;06;07;08;09;10;11;12;</xsl:variable>
		<xsl:variable name="month_descending_number">12;11;10;09;08;07;06;05;04;03;02;01;</xsl:variable>
		<!--<xsl:variable name="year_ascending">2001;2002;2003;2004;2005;2006;</xsl:variable>
		<xsl:variable name="year_descending">2006;2005;2004;2003;2002;2001;</xsl:variable>-->
		
		<!-- LOGIC FOR RETURNING DATE STRINGS -->
		<xsl:choose>
			<xsl:when test=" $date_part = 'Day' ">
				<xsl:choose>
					<xsl:when test=" $date_sort = 'descending' ">
						<xsl:value-of select="$day_descending"/>
					</xsl:when>
					<xsl:when test=" $date_sort = 'ascending' ">
						<xsl:value-of select="$day_ascending"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test=" $date_part = 'Month' ">
				<xsl:choose>
					<xsl:when test="($date_sort = 'ascending') and contains($format,'M')">
						<xsl:call-template name="month_ascending_short"/>
					</xsl:when>
					<xsl:when test="($date_sort = 'descending') and contains($format,'M')">
						<xsl:call-template name="month_descending_short"/>
					</xsl:when>
					<xsl:when test="($date_sort = 'ascending') and  $match = 'primary' ">
							<xsl:value-of select="$month_ascending_number"/>
					</xsl:when>
					<xsl:when test="($date_sort = 'descending') and  $match = 'primary' ">
							<xsl:value-of select="$month_descending_number"/>
					</xsl:when>
					<!--<xsl:when test=" $date_sort = 'MonthAscendingLong' ">
						<xsl:choose>
							<xsl:when test=" $match = 'primary' ">
								<xsl:value-of select="$month_ascending_number"/>
							</xsl:when>
							<xsl:when test=" $match = 'secondary' ">
								<xsl:call-template name="month_ascending_short"/>
							</xsl:when>
							<xsl:when test=" $match = 'text' ">
								<xsl:call-template name="month_ascending_long"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test=" $date_sort = 'MonthDescendingLong' ">
						<xsl:choose>
							<xsl:when test=" $match = 'primary' ">
								<xsl:value-of select="$month_descending_number"/>
							</xsl:when>
							<xsl:when test=" $match = 'secondary' ">
								<xsl:call-template name="month_descending_short"/>
							</xsl:when>
							<xsl:when test=" $match = 'text' ">
								<xsl:call-template name="month_descending_long"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>-->
					<xsl:when test="($date_sort = 'ascending') and contains($format,'m')">
						<xsl:value-of select="$month_ascending_number"/>
					</xsl:when>
					<xsl:when test="($date_sort = 'descending') and contains($format,'m')">
						<xsl:value-of select="$month_descending_number"/>
					</xsl:when>
					<!--<xsl:when test="($date_sort = 'ascending') and $match = 'text'">
						<xsl:value-of select="$month_ascending_short"/>
					</xsl:when>
					<xsl:when test="($date_sort = 'descending') and $match = 'text'">
						<xsl:value-of select="$month_descending_short"/>
					</xsl:when>-->
				</xsl:choose>
			</xsl:when>
			<!--<xsl:when test=" $date_part = 'Year' ">

				<xsl:choose>
					<xsl:when test=" $date_sort = 'YearDescending' ">
						<xsl:value-of select="$year_descending"/>
					</xsl:when>
					<xsl:when test=" $date_sort = 'YearAscending' ">
						<xsl:value-of select="$year_ascending"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>-->
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="month_ascending_short">
		<xsl:choose>
			<xsl:when test="$subPage = 'API' and /eBay/GlobalSettings/MonthAscendingShort"><xsl:value-of select="/eBay/GlobalSettings/MonthAscendingShort"/></xsl:when>
			<xsl:otherwise>Jan<xsl:value-of select="';'"/>Feb<xsl:value-of select="';'"/>Mar<xsl:value-of select="';'"/>Apr<xsl:value-of select="';'"/>May<xsl:value-of select="';'"/>Jun<xsl:value-of select="';'"/>Jul<xsl:value-of select="';'"/>Aug<xsl:value-of select="';'"/>Sep<xsl:value-of select="';'"/>Oct<xsl:value-of select="';'"/>Nov<xsl:value-of select="';'"/>Dec<xsl:value-of select="';'"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="month_descending_short">
		<xsl:choose>
			<xsl:when test="$subPage = 'API' and /eBay/GlobalSettings/MonthDescendingShort "><xsl:value-of select="/eBay/GlobalSettings/MonthDescendingShort"/></xsl:when>
			<xsl:otherwise>Dec<xsl:value-of select="';'"/>Nov<xsl:value-of select="';'"/>Oct<xsl:value-of select="';'"/>Sep<xsl:value-of select="';'"/>Aug<xsl:value-of select="';'"/>Jul<xsl:value-of select="';'"/>Jun<xsl:value-of select="';'"/>May<xsl:value-of select="';'"/>Apr<xsl:value-of select="';'"/>Mar<xsl:value-of select="';'"/>Feb<xsl:value-of select="';'"/>Jan<xsl:value-of select="';'"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="month_ascending_long">
		<xsl:choose>
			<xsl:when test="$subPage = 'API' and /eBay/GlobalSettings/MonthDescendingLong"><xsl:value-of select="/eBay/GlobalSettings/MonthDescendingShort"/></xsl:when>
			<xsl:otherwise>January<xsl:value-of select="';'"/>February<xsl:value-of select="';'"/>March<xsl:value-of select="';'"/>April<xsl:value-of select="';'"/>May<xsl:value-of select="';'"/>June<xsl:value-of select="';'"/>July<xsl:value-of select="';'"/>August<xsl:value-of select="';'"/>September<xsl:value-of select="';'"/>October<xsl:value-of select="';'"/>November<xsl:value-of select="';'"/>December<xsl:value-of select="';'"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="month_descending_long">
		<xsl:choose>
			<xsl:when test="$subPage = 'API' and /eBay/GlobalSettings/MonthDescendingLong"><xsl:value-of select="/eBay/GlobalSettings/MonthDescendingShort"/></xsl:when>
			<xsl:otherwise>December<xsl:value-of select="';'"/>November<xsl:value-of select="';'"/>October<xsl:value-of select="';'"/>September<xsl:value-of select="';'"/>August<xsl:value-of select="';'"/>July<xsl:value-of select="';'"/>June<xsl:value-of select="';'"/>May<xsl:value-of select="';'"/>April<xsl:value-of select="';'"/>March<xsl:value-of select="';'"/>February<xsl:value-of select="';'"/>January<xsl:value-of select="';'"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/attr_dates.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<!-- 
		<template name="date_options_old">
		
			The template is to generate a HTML option elements for the specified part of the date.
			
			<param name="date_part">
				Specifies the part of date to generate option list for
				<enum>
					<value>Day<note>specifies to generate the day of the month</note></value>
					<value>Month<note>specifies to generate month</note></value>
					<value>Year<note>specifies to generate year</note></value>
				</enum>
			</param>
			<param name="attr_id">Attribute id</param>
			<param name="date_sort">
				Specifies the sorting order and the format of the date part
				<enum>
					<value>DayDescending<note>days - descending order</note></value>
					<value>DayAscending<note>days - ascending order</note></value>
					<value>MonthAscendingShort<note>month short format (i.e. Jun) - ascending order</note></value>
					<value>MonthDescendingShort<note>month short format - descending order</note></value>
					<value>MonthAscendingLong<note>month long format (January) - ascending order</note></value>
					<value>MonthDescendingLong<note>month long format - descending order</note></value>
					<value>MonthAscendingNumber<note>month number format (01) - ascending order</note></value>
					<value>MonthDescendingNumber<note>month number format (01) - descending order</note></value>
					<value>YearDescending<note>year - descending order</note></value>
					<value>YearAscending<note>year - descending order</note></value>
				</enum>
			</param>
			<param name="pi_node_set">Options definded in the Presentation Instructions</param>
			<param optional="true" name="range_type">Only needed for PF date ranges</param>
			<param optional="true" name="FieldName">Field name only needed for SYI (to pull data from PostedFormFields section</param> 
		</template>
	-->
	<xsl:template name="date_options_old">
		<xsl:param name="date_part"/>
		<!-- REQUIRED: 'Day' | 'Month' | 'Year' -->
		<xsl:param name="attr_id"/>
		<!-- REQUIRED -->
		<xsl:param name="date_sort"/>
		<!-- REQUIRED FOR DAYS AND MONTHS: 'DayAscending' | 'DayDescending' | ... etc ... -->
		<xsl:param name="pi_node_set"/>
		<!-- REQUIRED FOR YEARS: options definded in the PI -->
		<xsl:param name="range_type"/>
		<!-- OPTIONAL: only needed for PF date ranges -->
		<xsl:param name="FieldName"/>
		<!-- OPTIONAL: only needed for SYI (to pull data from PostedFormFields section -->
		<xsl:param name="SelectedAttributeXPath"/>
		<!-- OPTIONAL: Needed for SYI when Listing in 2 categories -->
		<xsl:param name="VCSID"/>
		<!-- GET THE DEFAULT DATE -->
		<xsl:variable name="default_val">
			<xsl:call-template name="get_default_val_old">
				<xsl:with-param name="date_part" select="$date_part"/>
				<xsl:with-param name="attr_id" select="$attr_id"/>
				<xsl:with-param name="range_type" select="$range_type"/>
				<xsl:with-param name="FieldName" select="$FieldName"/>
				<xsl:with-param name="VCSID" select="$VCSID"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- GET SPECIFIC DATE STRINGS -->
		<xsl:variable name="primary_match">
			<xsl:choose>
				<xsl:when test="$pi_node_set">
					<xsl:value-of select="$pi_node_set"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_date_strings_old">
						<xsl:with-param name="date_sort" select="$date_sort"/>
						<xsl:with-param name="date_part" select="$date_part"/>
						<xsl:with-param name="match" select=" 'primary' "/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="secondary_match">
			<xsl:choose>
				<xsl:when test="$pi_node_set">
					<xsl:value-of select="$pi_node_set"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_date_strings_old">
						<xsl:with-param name="date_sort" select="$date_sort"/>
						<xsl:with-param name="date_part" select="$date_part"/>
						<xsl:with-param name="match" select=" 'secondary' "/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="date_text">
			<xsl:choose>
				<xsl:when test="$pi_node_set">
					<xsl:value-of select="$pi_node_set"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_date_strings_old">
						<xsl:with-param name="date_sort" select="$date_sort"/>
						<xsl:with-param name="date_part" select="$date_part"/>
						<xsl:with-param name="match" select=" 'text' "/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- CREATE THE DATE OPTIONS -->
		<xsl:if test="not($pi_node_set)">
			<xsl:choose>
				<xsl:when test="$thisPage='PF'">
					<option value="-24"/>
				</xsl:when>
				<xsl:otherwise>
					<option value="-10">--</option>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:call-template name="create_date_options_old">
			<xsl:with-param name="attr_id" select="$attr_id"/>
			<xsl:with-param name="default_val" select="$default_val"/>
			<xsl:with-param name="primary_match" select="$primary_match"/>
			<xsl:with-param name="secondary_match" select="$secondary_match"/>
			<xsl:with-param name="date_text" select="$date_text"/>
			<xsl:with-param name="delim" select=" ';' "/>
			<xsl:with-param name="VCSID" select="$VCSID"/>
			<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
		</xsl:call-template>
		<!--This is for Value Carry Forward.  If the value in the inputfield of this attribute is not present in the Years node set, then add it to the bottom of the dropdown and make it selected -->
		<xsl:if test="$date_part='Year'">
		<xsl:variable name="vcf_year" select="$returnAttr[@id=$attr_id]/InputFields/Input[@dataType='Y' and @rangeType=$range_type]/Value/Name"/>
			<xsl:if test="contains($pi_node_set,$vcf_year)=false() and $vcf_year!='-24'">
				<option value="{$returnAttr[@id=$attr_id]/InputFields/Input[@dataType='Y' and @rangeType=$range_type]/Value/Name}" selected="selected">
					<xsl:value-of select="$returnAttr[@id=$attr_id]/InputFields/Input[@dataType='Y' and @rangeType=$range_type]/Value/Name"/>
				</option>				
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- 
		<template name="create_date_options_old">
		
			The template generates date HTML option elements from the provided strings of date parts 
			in three possible formats and based on user selelcted values and default.

			<param name="default_val">Default value</param>
			<param name="primary_match">Set of date parts (number format) arranged as a string of values with delimiters.</param>
			<param name="secondary_match">Set of date parts (short format) arranged as a string of values with delimiters.</param>
			<param name="date_text">Set of date parts (long format) arranged as a string of values with delimiters.</param>
			<param name="delim">Delimiter string used</param>
			
		</template>
	-->
	<xsl:template name="create_date_options_old">
		<xsl:param name="attr_id"/>
		<xsl:param name="default_val"/>
		<xsl:param name="primary_match"/>
		<xsl:param name="secondary_match"/>
		<xsl:param name="date_text"/>
		<xsl:param name="delim" select=" ';' "/>
		<xsl:param name="VCSID"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<!-- GET THE NEXT SUBSTRING -->
		<xsl:variable name="primary" select="substring-before($primary_match,$delim)"/>
		<xsl:variable name="secondary" select="substring-before($secondary_match,$delim)"/>
		<xsl:variable name="text" select="substring-before($date_text,$delim)"/>
		<!-- WRITE THE OPTIONS -->
		<xsl:choose>
			<xsl:when test="$thisPage='PF'">
				<option>
					<xsl:attribute name="value"><xsl:choose><xsl:when test="$primary='--' or $primary='Any' or $primary=''">-24</xsl:when><xsl:otherwise><xsl:value-of select="$primary"/></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:if test="number($default_val) = number($primary) or number($default_val) = number($secondary)">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$text"/>
				</option>
			</xsl:when>
			<xsl:otherwise>
				<option>
					<xsl:attribute name="value"><xsl:choose><xsl:when test="$primary='--' or $primary='Any' or $primary=''">-10</xsl:when><xsl:otherwise><xsl:value-of select="$primary"/></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:if test="(number($default_val) = number($primary) or number($default_val) = number($secondary)) and $SelectedAttributeXPath[@id=$attr_id]">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$text"/>
				</option>
			</xsl:otherwise>
		</xsl:choose>
		<!-- RECURSION, IF THERE ARE MORE SUBSTRINGS -->
		<xsl:if test="string-length(substring-after($primary_match,$delim)) &gt; 0">
			<xsl:call-template name="create_date_options_old">
				<xsl:with-param name="attr_id" select="$attr_id"/>
				<xsl:with-param name="default_val" select="$default_val"/>
				<xsl:with-param name="primary_match" select="substring-after($primary_match,$delim)"/>
				<xsl:with-param name="secondary_match" select="substring-after($secondary_match,$delim)"/>
				<xsl:with-param name="date_text" select="substring-after($date_text,$delim)"/>
				<xsl:with-param name="delim" select="$delim"/>
				<xsl:with-param name="VCSID" select="$VCSID"/>
				<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- 
		<template name="get_default_val_old">
		
			The template generates the values that should be selected in the date option list based on user selections, current values and initial values.

			<param required="true" name="date_part">
				Specifies the part of date to generate option list for
				<enum>
					<value>Day<note>specifies to generate the day of the month</note></value>
					<value>Month<note>specifies to generate month</note></value>
					<value>Year<note>specifies to generate year</note></value>
				</enum>
			</param>
			<param name="attr_id">Attribute id.</param>
			<param name="range_type">Only needed for PF date ranges</param>
			<param optional="true" name="FieldName">Field name only needed for SYI (to pull data from PostedFormFields section</param> 
			
		</template>
	-->
	<xsl:template name="get_default_val_old">
		<xsl:param name="date_part"/>
		<xsl:param name="attr_id"/>
		<xsl:param name="range_type"/>
		<xsl:param name="FieldName"/>
		<xsl:param name="VCSID"/>
		<xsl:variable name="pi" select="$thisPI[@id=$attr_id]"/>
		<!-- GET THE POSSIBLE DEFAULT VALUES -->
		<xsl:variable name="users_val">
			<xsl:choose>
				<xsl:when test="$thisPage!='PF'">
					<xsl:choose>
						<xsl:when test="$UsePostedFormFields">
							<xsl:value-of select="$FormFields/FormField[@name = $FieldName]/Value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$returnAttr[@id=$attr_id and ../@id=$VCSID]/Value/*[name() = $date_part]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$subPage='API'">
					<xsl:value-of select="$returnAttr[@id=$attr_id]/Value/*[name() = $date_part]"/>
				</xsl:when>
				<xsl:when test="$range_type!=''">
					<xsl:value-of select="$returnAttr[@id=$attr_id]/InputFields/Input[@dataType=substring($date_part,1,1) and @rangeType=$range_type]/Value/Name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$returnAttr[@id=$attr_id]/InputFields/Input[@dataType=substring($date_part,1,1)]/Value/Name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="current_val">
			<xsl:if test="$pi/CurrentDate">
				<xsl:call-template name="get_current_date_string_old">
					<xsl:with-param name="date_part" select="$date_part"/>
					<xsl:with-param name="date" select="$attrData[@id=$attr_id]/CurrentTime/DateMedium"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="initial_val">
			<xsl:choose>
				<xsl:when test="$date_part = 'Day'">
					<xsl:value-of select="$pi/DayInitialValue"/>
				</xsl:when>
				<xsl:when test="$date_part = 'Month'">
					<xsl:value-of select="$pi/MonthInitialValue"/>
				</xsl:when>
				<xsl:when test="$date_part = 'Year'">
					<xsl:value-of select="$pi/YearInitialValue"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- RETURN THE RIGHT DEFAULT VALUE -->
		<xsl:choose>
			<xsl:when test="string-length($users_val) &gt; 0">
				<xsl:value-of select="$users_val"/>
			</xsl:when>
			<xsl:when test="string-length($current_val) &gt; 0">
				<xsl:value-of select="$current_val"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$initial_val"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
		<template name="get_current_date_string_old">
		
			The template generates part of the date based on passed parameters.

			<param required="true" name="date_part">
				Specifies the part of date to generate option list for
				<enum>
					<value>Day<note>specifies to generate the day of the month</note></value>
					<value>Month<note>specifies to generate month</note></value>
					<value>Year<note>specifies to generate year</note></value>
				</enum>
			</param>
			<param name="date">The date delimited with '-'</param>
			
		</template>
	-->
	<xsl:template name="get_current_date_string_old">
		<xsl:param name="date_part"/>
		<xsl:param name="date"/>
		<xsl:variable name="month" select="substring-before($date,'-')"/>
		<xsl:variable name="day_year" select="substring-after($date,'-')"/>
		<xsl:variable name="day" select="substring-before($day_year,'-')"/>
		<xsl:variable name="year" select="substring-after($day_year,'-')"/>
		<xsl:choose>
			<xsl:when test="$date_part = 'Day'">
				<xsl:value-of select="$day"/>
			</xsl:when>
			<xsl:when test="$date_part = 'Month'">
				<xsl:value-of select="$month"/>
			</xsl:when>
			<xsl:when test="$date_part = 'Year' and $year">
				<xsl:value-of select=" concat('20',$year) "/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- 
		<template name="get_date_strings_old">
		
			The template returns the required one string of 10 possible date sets with values delimited with ';'

			<param name="date_sort">
				Specifies the sorting order and the format of the date part
				<enum>
					<value>DayDescending<note>days - descending order</note></value>
					<value>DayAscending<note>days - ascending order</note></value>
					<value>MonthAscendingShort<note>month short format (i.e. Jun) - ascending order</note></value>
					<value>MonthDescendingShort<note>month short format - descending order</note></value>
					<value>MonthAscendingLong<note>month long format (January) - ascending order</note></value>
					<value>MonthDescendingLong<note>month long format - descending order</note></value>
					<value>MonthAscendingNumber<note>month number format (01) - ascending order</note></value>
					<value>MonthDescendingNumber<note>month number format (01) - descending order</note></value>
					<value>YearDescending<note>year - descending order</note></value>
					<value>YearAscending<note>year - descending order</note></value>
				</enum>
			</param>
			<param required="true" name="date_part">
				Specifies the part of date to generate option list for
				<enum>
					<value>Day<note>specifies to generate the day of the month</note></value>
					<value>Month<note>specifies to generate month</note></value>
					<value>Year<note>specifies to generate year</note></value>
				</enum>
			</param>
			<param name="match">
				Specifies the format of the date value set to return
				<enum>
					<values>primary<note>specifies number format, i.e. date part will be returned as a number</note></values>
					<values>secondary<note>specifies number format, i.e. date part will be returned as a number</note></values>
					<values>text<note>specifies number format, i.e. date part will be returned as a number</note></values>
				</enum>
			</param>

		</template>
	-->
	<xsl:template name="get_date_strings_old">
		<xsl:param name="date_sort"/>
		<xsl:param name="date_part"/>
		<xsl:param name="match"/>
		<!-- ALL THE POSSIBLE DATE STRINGS -->
		<xsl:variable name="day_ascending">01;02;03;04;05;06;07;08;09;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;</xsl:variable>
		<xsl:variable name="day_descending">31;30;29;28;27;26;25;24;23;22;21;20;19;18;17;16;15;14;13;12;11;10;09;08;07;06;05;04;03;02;01;</xsl:variable>
		<xsl:variable name="month_ascending_short">
			<xsl:choose>
				<xsl:when test="$subPage = 'API' and /eBay/GlobalSettings/MonthAscendingShort"><xsl:value-of select="/eBay/GlobalSettings/MonthAscendingShort"/></xsl:when>
				<xsl:otherwise>Jan;Feb;Mar;Apr;May;Jun;Jul;Aug;Sep;Oct;Nov;Dec;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="month_descending_short">
			<xsl:choose>
				<xsl:when test="$subPage = 'API' and /eBay/GlobalSettings/MonthDescendingShort"><xsl:value-of select="/eBay/GlobalSettings/MonthDescendingShort"/></xsl:when>
				<xsl:otherwise>Dec;Nov;Oct;Sep;Aug;Jul;Jun;May;Apr;Mar;Feb;Jan;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="month_ascending_long">
			<xsl:choose>
				<xsl:when test="$subPage = 'API' and /eBay/GlobalSettings/MonthAscendingLong"><xsl:value-of select="/eBay/GlobalSettings/MonthAscendingLong"/></xsl:when>
				<xsl:otherwise>Jan;Feb;Mar;Apr;May;Jun;Jul;Aug;Sep;Oct;Nov;Dec;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="month_descending_long">
			<xsl:choose>
				<xsl:when test="$subPage = 'API' and /eBay/GlobalSettings/MonthDescendingLong"><xsl:value-of select="/eBay/GlobalSettings/MonthDescendingLong"/></xsl:when>
				<xsl:otherwise>Dec;Nov;Oct;Sep;Aug;Jul;Jun;May;Apr;Mar;Feb;Jan;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="month_ascending_number">01;02;03;04;05;06;07;08;09;10;11;12;</xsl:variable>
		<xsl:variable name="month_descending_number">12;11;10;09;08;07;06;05;04;03;02;01;</xsl:variable>
		<xsl:variable name="year_ascending">2001;2002;2003;2004;2005;2006;</xsl:variable>
		<xsl:variable name="year_descending">2006;2005;2004;2003;2002;2001;</xsl:variable>
		<!-- LOGIC FOR RETURNING DATE STRINGS -->
		<xsl:choose>
			<xsl:when test=" $date_part = 'Day' ">
				<xsl:choose>
					<xsl:when test=" $date_sort = 'DayDescending' ">
						<xsl:value-of select="$day_descending"/>
					</xsl:when>
					<xsl:when test=" $date_sort = 'DayAscending' ">
						<xsl:value-of select="$day_ascending"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test=" $date_part = 'Month' ">
				<xsl:choose>
					<xsl:when test=" $date_sort = 'MonthAscendingShort' ">
						<xsl:choose>
							<xsl:when test=" $match = 'primary' ">
								<xsl:value-of select="$month_ascending_number"/>
							</xsl:when>
							<xsl:when test=" $match = 'secondary' ">
								<xsl:value-of select="$month_ascending_short"/>
							</xsl:when>
							<xsl:when test=" $match = 'text' ">
								<xsl:value-of select="$month_ascending_short"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test=" $date_sort = 'MonthDescendingShort' ">
						<xsl:choose>
							<xsl:when test=" $match = 'primary' ">
								<xsl:value-of select="$month_descending_number"/>
							</xsl:when>
							<xsl:when test=" $match = 'secondary' ">
								<xsl:value-of select="$month_descending_short"/>
							</xsl:when>
							<xsl:when test=" $match = 'text' ">
								<xsl:value-of select="$month_descending_short"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test=" $date_sort = 'MonthAscendingLong' ">
						<xsl:choose>
							<xsl:when test=" $match = 'primary' ">
								<xsl:value-of select="$month_ascending_number"/>
							</xsl:when>
							<xsl:when test=" $match = 'secondary' ">
								<xsl:value-of select="$month_ascending_short"/>
							</xsl:when>
							<xsl:when test=" $match = 'text' ">
								<xsl:value-of select="$month_ascending_long"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test=" $date_sort = 'MonthDescendingLong' ">
						<xsl:choose>
							<xsl:when test=" $match = 'primary' ">
								<xsl:value-of select="$month_descending_number"/>
							</xsl:when>
							<xsl:when test=" $match = 'secondary' ">
								<xsl:value-of select="$month_descending_short"/>
							</xsl:when>
							<xsl:when test=" $match = 'text' ">
								<xsl:value-of select="$month_descending_long"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test=" $date_sort = 'MonthAscendingNumber' ">
						<xsl:choose>
							<xsl:when test=" $match = 'primary' ">
								<xsl:value-of select="$month_ascending_number"/>
							</xsl:when>
							<xsl:when test=" $match = 'secondary' ">
								<xsl:value-of select="$month_ascending_short"/>
							</xsl:when>
							<xsl:when test=" $match = 'text' ">
								<xsl:value-of select="$month_ascending_number"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test=" $date_sort = 'MonthDescendingNumber' ">
						<xsl:choose>
							<xsl:when test=" $match = 'primary' ">
								<xsl:value-of select="$month_descending_number"/>
							</xsl:when>
							<xsl:when test=" $match = 'secondary' ">
								<xsl:value-of select="$month_descending_short"/>
							</xsl:when>
							<xsl:when test=" $match = 'text' ">
								<xsl:value-of select="$month_descending_number"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test=" $date_part = 'Year' ">
				<xsl:choose>
					<xsl:when test=" $date_sort = 'YearDescending' ">
						<xsl:value-of select="$year_descending"/>
					</xsl:when>
					<xsl:when test=" $date_sort = 'YearAscending' ">
						<xsl:value-of select="$year_ascending"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/attr_dates_old.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<!-- 
		<template name="DateLabels">
		
			The template is to generate date labels based on format provided..
			
			<param name="attrId">Attribute id</param>
			<param name="format">Date format<note>example: m_d_y</note></param>
			<param name="quadrant">Location relatively to the field</param>
		</template>
	-->
	<xsl:template name="DateLabels">
		<xsl:param name="attrId"/>
		<xsl:param name="format"/>
		<xsl:param name="quadrant"/>
		<xsl:if test="string-length($format) &gt; 0">
			<xsl:variable name="char" select="substring($format,1,1)"/>
			<xsl:choose>
				<xsl:when test="$char='Y' or $char='y'"><!--remove 'y' when phase b is stable-->
					<td/>
					<td valign="top">
						<xsl:if test="../Year/@quadrant = $quadrant">
							<font face="{../Year/@face}" size="{../Year/@size}">
								<xsl:value-of select="../Year"/>
							</font>
						</xsl:if>
					</td>
					<td/>
				</xsl:when>
				<xsl:when test="$char='m' or $char='M'">
					<td/>
					<td valign="top">
						<xsl:if test="../Month/@quadrant = $quadrant">
							<font face="{../Month/@face}" size="{../Month/@size}">
								<xsl:value-of select="../Month"/>
							</font>
						</xsl:if>
					</td>
					<td/>
				</xsl:when>
				<xsl:when test="$char='d'">
					<td/>
					<td valign="top">
						<xsl:if test="../Day/@quadrant = $quadrant">
							<font face="{../Day/@face}" size="{../Day/@size}">
								<xsl:value-of select="../Day"/>
							</font>
						</xsl:if>
					</td>
					<td/>
				</xsl:when>
			</xsl:choose>
			<xsl:call-template name="DateLabels">
				<xsl:with-param name="attrId" select="$attrId"/>
				<xsl:with-param name="format">
					<xsl:value-of select="substring($format,2)"/>
				</xsl:with-param>
				<xsl:with-param name="quadrant">
					<xsl:value-of select="$quadrant"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- 
		<template name="DateDropdowns">
		
			The template is to generate date attribute as a dropdown box.
			
			<param name="attrId">Attribute id</param>
			<param name="inputName">Name of the input box that.</param>
			<param name="format">Date format<note>example: m_d_y</note></param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="DateDropdowns">
		<xsl:param name="attrId"/>
		<xsl:param name="inputName"/>
		<xsl:param name="format"/>
		<xsl:param name="VCSID"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:if test="string-length($format) &gt; 0">
			<xsl:variable name="char" select="substring($format,1,1)"/>
			<xsl:choose>
				<xsl:when test="$char='Y' or $char='y'"><!--remove 'y' when phase b is stable-->
					<td valign="middle">
						<xsl:if test="../Year/@quadrant = 'left'">
							<font face="{../Year/@face}" size="{../Year/@size}">
								<xsl:value-of select="../Year"/>
							</font>
						</xsl:if>
					</td>
					<td valign="middle">
						<select>
							<xsl:variable name="FieldNameY" select="concat('attr_d',$VCSID,'_',$attrId,'_y')"/>
							<xsl:attribute name="class"><xsl:choose><xsl:when test="$thisPage='PF'"><xsl:value-of select="$inputName"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:attribute>
							<xsl:attribute name="name"><xsl:choose><xsl:when test="$thisPage='SYI'"><xsl:value-of select="$FieldNameY"/></xsl:when><xsl:otherwise><xsl:value-of select="$inputName"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:choose>
								<xsl:when test="@format">
									<xsl:call-template name="date_options_old"><!--dt:removed this template when phase b is stable-->
										<xsl:with-param name="attr_id" select="$attrId"/>
										<xsl:with-param name="date_part" select=" 'Year' "/>
										<xsl:with-param name="pi_node_set">
											<xsl:for-each select="../Years"><xsl:value-of select="."/><xsl:text>;</xsl:text></xsl:for-each>
										</xsl:with-param>
										<xsl:with-param name="FieldName" select="$FieldNameY"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
									</xsl:call-template>	
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="date_options">
										<xsl:with-param name="attr_id" select="$attrId"/>
										<xsl:with-param name="date_part" select=" 'Year' "/>
										<xsl:with-param name="pi_node_set">
											<xsl:for-each select="$CurrentAttributeXPath[@id=$attrId]/ValueList/Value"><xsl:value-of select="Name"/><xsl:text>;</xsl:text></xsl:for-each>
										</xsl:with-param>
										<xsl:with-param name="FieldName" select="$FieldNameY"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</select>&#160;
					</td>
					<td valign="middle">
						<xsl:if test="../Year/@quadrant = 'right'">
							<font face="{../Year/@face}" size="{../Year/@size}">
								<xsl:value-of select="../Year"/>
							</font>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:when test="$char='m' or $char='M'">
					<td valign="middle">
						<xsl:if test="../Month/@quadrant = 'left'">
							<font face="{../Month/@face}" size="{../Month/@size}">
								<xsl:value-of select="../Month"/>
							</font>
						</xsl:if>
					</td>
					<td valign="middle">
						<select>
							<xsl:variable name="FieldNameM" select="concat('attr_d',$VCSID,'_',$attrId,'_m')"/>
							<xsl:attribute name="class"><xsl:choose><xsl:when test="$thisPage='PF'"><xsl:value-of select="$inputName"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:attribute>
							<xsl:attribute name="name"><xsl:choose><xsl:when test="$thisPage='SYI'"><xsl:value-of select="$FieldNameM"/></xsl:when><xsl:otherwise><xsl:value-of select="$inputName"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:choose>
								<xsl:when test="@format"><!--dt:removed this template when phase b is stable-->
									<xsl:call-template name="date_options_old">
										<xsl:with-param name="attr_id" select="$attrId"/>
										<xsl:with-param name="date_part" select=" 'Month' "/>
										<xsl:with-param name="date_sort" select=" name(../*[ (string-length(name()) &gt; 5) and contains(name(), 'Month') and not(contains(name(), 'Initial')) ])"/>
										<xsl:with-param name="FieldName" select="$FieldNameM"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise><!--dt:removed this template when phase b is stable-->
									<xsl:call-template name="date_options">
										<xsl:with-param name="attr_id" select="$attrId"/>
										<xsl:with-param name="date_part" select=" 'Month' "/>
										<xsl:with-param name="date_sort" select="../Month/@sort"/>
										<xsl:with-param name="format" select="$format"/>
										<xsl:with-param name="FieldName" select="$FieldNameM"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</select>&#160;
					</td>
					<td valign="middle">
						<xsl:if test="../Month/@quadrant = 'right'">
							<font face="{../Month/@face}" size="{../Month/@size}">
								<xsl:value-of select="../Month"/>
							</font>
						</xsl:if>
					</td>
				</xsl:when>
				<xsl:when test="$char='d'">
					<td valign="middle">
						<xsl:if test="../Day/@quadrant = 'left'">
							<font face="{../Day/@face}" size="{../Day/@size}">
								<xsl:value-of select="../Day"/>
							</font>
						</xsl:if>
					</td>
					<td valign="middle">
						<select>
							<xsl:variable name="FieldNameD" select="concat('attr_d',$VCSID,'_',$attrId,'_d')"/>
							<xsl:attribute name="class"><xsl:choose><xsl:when test="$thisPage='PF'"><xsl:value-of select="$inputName"/></xsl:when><xsl:otherwise/></xsl:choose></xsl:attribute>
							<xsl:attribute name="name"><xsl:choose><xsl:when test="$thisPage='SYI'"><xsl:value-of select="$FieldNameD"/></xsl:when><xsl:otherwise><xsl:value-of select="$inputName"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:choose>
								<xsl:when test="@format"><!--dt:removed this template when phase b is stable-->
									<xsl:call-template name="date_options_old">
										<xsl:with-param name="attr_id" select="$attrId"/>
										<xsl:with-param name="date_part" select=" 'Day' "/>
										<xsl:with-param name="date_sort" select=" name(../*[ (string-length(name()) &gt; 3) and contains(name(), 'Day') and not(contains(name(), 'Initial'))])"/>
										<xsl:with-param name="FieldName" select="$FieldNameD"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise><!--dt:removed this template when phase b is stable-->
									<xsl:call-template name="date_options">
										<xsl:with-param name="attr_id" select="$attrId"/>
										<xsl:with-param name="date_part" select=" 'Day' "/>						
										<xsl:with-param name="date_sort" select="../Day/@sort"/>
										<xsl:with-param name="FieldName" select="$FieldNameD"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</select>&#160;
					</td>
					<td valign="middle">
						<xsl:if test="../Day/@quadrant = 'right'">
							<font face="{../Day/@face}" size="{../Day/@size}">
								<xsl:value-of select="../Day"/>
							</font>
						</xsl:if>
					</td>
				</xsl:when>
			</xsl:choose>
			<xsl:call-template name="DateDropdowns">
				<xsl:with-param name="attrId" select="$attrId"/>
				<xsl:with-param name="inputName" select="$inputName"/>
				<xsl:with-param name="format">
					<xsl:value-of select="substring($format,2)"/>
				</xsl:with-param>
				<xsl:with-param name="VCSID" select="$VCSID"/>
				<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
				<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- 
		<template name="Dropdown">
		
			The template is to generate attribute as a dropdown box.
			
			<param name="attrId">Attribute id</param>
			<param name="inputName">Name of the input box that.</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="Dropdown">
		<xsl:param name="attrId"/>
		<xsl:param name="inputName"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:param name="VCSID"/>
		<xsl:variable name="parentAttrId" select="$CurrentAttributeXPath[Dependency/@childAttrId=$attrId]/@id"/>
		<xsl:choose>
			<xsl:when test="../../@type='date'">
				<xsl:variable name="format">
					<xsl:choose>
						<xsl:when test="@format">
							<xsl:value-of select="@format"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$CurrentAttributeXPath[@id=$attrId]/@dateFormat"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- JO: BUGDB00116454 need to indent if there is text for Day, Month, Year labels -->
				<xsl:variable name="isIndent" select="boolean((../Day and ../Day != '') or (../Month and ../Month != '') or (../Year and ../Year != ''))"/>
				
				<table cellpadding="0" cellspacing="0" border="0" summary="">
					<xsl:if test="../*/@quadrant='top'">
						<tr>
							<xsl:if test="$isIndent = true()"><td>&#160;</td></xsl:if>
							<xsl:call-template name="DateLabels">
								<xsl:with-param name="attrId" select="$attrId"/>
								<xsl:with-param name="format" select="$format"/>
								<xsl:with-param name="quadrant">top</xsl:with-param>
							</xsl:call-template>
						</tr>
					</xsl:if>
					<tr>
						<xsl:if test="$isIndent = true()"><td>&#160;</td></xsl:if>
						<xsl:call-template name="DateDropdowns">
							<xsl:with-param name="attrId" select="$attrId"/>
							<xsl:with-param name="inputName" select="$inputName"/>
							<xsl:with-param name="format" select="$format"/>
							<xsl:with-param name="VCSID" select="$VCSID"/>
							<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
							<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
						</xsl:call-template>
					</tr>
					<xsl:if test="../*/@quadrant='bottom'">
						<tr>
							<xsl:if test="$isIndent = true()"><td>&#160;</td></xsl:if>
							<xsl:call-template name="DateLabels">
								<xsl:with-param name="attrId" select="$attrId"/>
								<xsl:with-param name="format" select="$format"/>
								<xsl:with-param name="quadrant">bottom</xsl:with-param>
							</xsl:call-template>
						</tr>
					</xsl:if>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<!--DT...this needs to be refactored more when dependencies between syi and pf are made more consistent -->
				<xsl:choose>
					<xsl:when test="$thisPage='SYI'">
						<select>
							<xsl:choose>
								<!-- JO: commented out Post for type 4 because conditionally visible attributes are moved over to next page (multi-page flow). -->
								<!--
								<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='4' or (@type='3' and @type='4')]">
									<xsl:attribute name="onChange">aus_set_parent('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>', this.value); vvsp_check('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>', this.value);</xsl:attribute>
								</xsl:when>
								-->
								<xsl:when test="$subPage = 'API' and $CurrentAttributeXPath[@id=$attrId]/Dependency[@type = '4' or @type = '5']">
									<xsl:attribute name="onChange"><xsl:if test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='1']">attr_onchange('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>'); </xsl:if> vvsp_check('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>', this.value);</xsl:attribute>
								</xsl:when>
								<!-- DT: Type=3 (VVSP) no longer exist-->
								<!--
								<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='3']">
									<xsl:attribute name="onChange">aus_set_parent('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',1); vvsp_post('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>', this.value);</xsl:attribute>
								</xsl:when>
								-->
								<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='1']">
									<xsl:attribute name="onChange">attr_onchange('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>');<xsl:if test="$subPage = 'API' ">api_check_on_other('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',this.value);</xsl:if></xsl:attribute>
								</xsl:when>
								<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='2']">
									<xsl:attribute name="onChange">attr_onchange('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',this.options[this.selectedIndex].value);<xsl:if test="$subPage = 'API' ">api_check_on_other('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',this.value);</xsl:if></xsl:attribute>
								</xsl:when>
								<xsl:when test="$subPage = 'API' ">
									<xsl:attribute name="onChange">api_check_on_other('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',this.value);</xsl:attribute>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
							<xsl:variable name="FieldName" select="concat('attr',$VCSID,'_',$attrId)"/>
							<xsl:attribute name="name"><xsl:value-of select="$FieldName"/></xsl:attribute>
							<xsl:choose>
								<xsl:when test="$parentAttrId">
								<xsl:choose>
										<xsl:when test="$CurrentAttributeXPath[@id=$parentAttrId]/*[@isVisible='true']">
											<xsl:apply-templates select="$CurrentAttributeXPath[@id=$parentAttrId]/Dependency[(@type='1' or @type='2') and @childAttrId=$attrId and @isVisible='true']" mode="isVisible">
												<xsl:with-param name="attrId" select="$attrId"/>
											</xsl:apply-templates>
											<xsl:apply-templates select="$CurrentAttributeXPath[@id=$parentAttrId]/Dependency[(@type='1' or @type='2') and @childAttrId=$attrId and @isVisible='true']" mode="isVisible">
												<xsl:with-param name="attrId" select="$attrId"/>
												<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
												<xsl:with-param name="FieldName" select="$FieldName"/>
											</xsl:apply-templates>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="ParentFieldName">
												<xsl:if test="$UsePostedFormFields">
													<xsl:value-of select="concat('attr',$VCSID,'_',$parentAttrId)"/>
												</xsl:if>
											</xsl:variable>
											<xsl:variable name="SelectedParentValueId" select="$FormFields/FormField[$ParentFieldName!='' and @name = $ParentFieldName]/Value | $SelectedAttributeXPath[@id=$parentAttrId]/Value/@id"/>
											<xsl:variable name="syiParentValueId" select="$SelectedParentValueId | $CurrentAttributeXPath[not($SelectedParentValueId) and @id=$parentAttrId]/ValueList/Value[1]/@id"/>
											<xsl:choose>
												<xsl:when test="$subPage='API' and $CurrentAttributeXPath[@id=$parentAttrId]/Dependency[(@type='3' or @type='4' or @type='5') and @parentValueId=$syiParentValueId and @childAttrId=$attrId]">
													<xsl:variable name="values" select="$CurrentAttributeXPath[@id=$attrId]/ValueList/Value | $CurrentAttributeXPath[@id=$parentAttrId]/Dependency[@parentValueId=$syiParentValueId and @childAttrId=$attrId]/Value[count(. | key('attrByIDs', concat($VCSID, '_', key('selectedAttrByIDs', concat($VCSID, '_', $parentAttrId, '_', $syiParentValueId))/@id, '_', @id))[1])=1]"/>
													<xsl:apply-templates select="$values">
														<xsl:sort select="@id"/>
														<xsl:with-param name="attrId" select="$attrId"/>
														<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
														<xsl:with-param name="FieldName" select="$FieldName"/>
													</xsl:apply-templates>
												</xsl:when>
												<xsl:when test="($SelectedParentValueId = '-10') or (not($SelectedParentValueId) and ($CurrentAttributeXPath[@id=$parentAttrId]/ValueList/Value[1]/@id = '-10' or not($CurrentAttributeXPath[@id=$parentAttrId]/ValueList)))">
												<!--  (When the selected attribute = -10) or (There is no selected attribute in the sale/item and the first value inside the parent has an id of -10)
													Lets give our Netscape viewers the courtesy of not having a squashed dropdown.  Go NS 4.7!!!!!
												-->
														<script LANGUAGE="JavaScript1.1">
														var thisChild = "<xsl:value-of select="$FieldName"/>"; //if child does not have dep valuelist, then disable it.
														attr_disable(thisChild);
													</script>
													<xsl:call-template name="EmptyDropdown"/>						
												</xsl:when>												
												<xsl:when test="$syiParentValueId and $CurrentAttributeXPath[@id=$parentAttrId]/Dependency[@type='1' or @type='2']">
													<xsl:variable name="values" select="$CurrentAttributeXPath[@id=$parentAttrId]/Dependency[ (@parentValueId=$syiParentValueId) and (@childAttrId = $attrId) ]"/>
													<xsl:choose>
													<xsl:when test="not($values)">
														<script LANGUAGE="JavaScript1.1">
														var thisChild = "<xsl:value-of select="$FieldName"/>"; //if child does not have dep valuelist, then disable it.
														attr_disable(thisChild);
													</script>
													<xsl:call-template name="EmptyDropdown"/>	
													</xsl:when>
													<xsl:otherwise>
													<xsl:apply-templates select="$values" mode="dep">
														<xsl:with-param name="attrId" select="$attrId"/>
														<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
														<xsl:with-param name="FieldName" select="$FieldName"/>
													</xsl:apply-templates>
													</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="$CurrentAttributeXPath[@id=$attrId]/ValueList/Value">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
										<xsl:with-param name="FieldName" select="$FieldName"/>
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</select>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="pfId" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input/Value/@pfId"/>
						<xsl:variable name="pfPageType" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input/Value/@pfPageType"/>
						<xsl:variable name="selectedValue" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input/Value/@id"/>
						<select>
							<xsl:if test="$attrData[@id=$attrId]/Dependency[@type='1'] or (/ebay/SYI.Data and $attrData[@id=$attrId]/Dependency[@type='2' or @type='4'])">
								<xsl:attribute name="onChange">attr_onchange('<xsl:value-of select="$inputName"/>',this.form.name);</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="name"><xsl:value-of select="$inputName"/></xsl:attribute>
							<xsl:attribute name="class"><xsl:value-of select="$inputName"/></xsl:attribute>
							<xsl:choose>
								<xsl:when test="$parentAttrId">
									<xsl:variable name="parentValueId" select="$returnAttr[@id=$parentAttrId]/InputFields/Input/Value/@id"/>
									<xsl:choose>
										<xsl:when test="$parentValueId != '-24'">
											<xsl:choose>
												<xsl:when test="$attrData[@id=$parentAttrId]/Dependency[@parentValueId=$parentValueId and @childAttrId=$attrId]">
													<xsl:apply-templates select="$attrData[@id=$parentAttrId]/Dependency[@parentValueId=$parentValueId and @childAttrId=$attrId]/Value" mode="dep"/>
												</xsl:when>
												<xsl:when test="$subPage='APIPF'">
												</xsl:when>
												<xsl:otherwise>
													<script LANGUAGE="JavaScript1.1">
														var thisChild = "a<xsl:value-of select="$attrId"/>"; //if child does not have dep valuelist, then disable it.
														attr_disable(thisChild);
													</script>
													<xsl:call-template name="EmptyDropdown"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="EmptyDropdown"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="$attrData[@id=$attrId]/ValueList/Value">
										<xsl:with-param name="selectedValue" select="$selectedValue"/>
										<xsl:with-param name="pfId" select="$pfId"/>
										<xsl:with-param name="pfPageType" select="$pfPageType"/>
									</xsl:apply-templates>
									<xsl:if test="$pfId and $pfPageType">
										<xsl:choose>
										<!-- Attribute values - -3 -->
											<xsl:when test="$selectedValue='-3'">	
												<option value="{$attrData[@id=$attrId]/InputFields/Input/Value/DisplayName}" selected="selected">
													<xsl:choose>
														<xsl:when test="$attrData[@id=$attrId]/InputFields/Input/Value[DisplayName!='']">
															<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input/Value/DisplayName"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input/Value/Name"/>
														</xsl:otherwise>
													</xsl:choose>
												</option>
											</xsl:when>
											<xsl:otherwise>
											<xsl:value-of select="$attrId"/>
												<option value="{$selectedValue}" selected="selected">
													<xsl:choose>
														<xsl:when test="$attrData[@id=$attrId]/InputFields/Input/Value[DisplayName!='']">
															<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input/Value/DisplayName"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input/Value/Name"/>
														</xsl:otherwise>
													</xsl:choose>
												</option>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</select>
						<xsl:if test="$pfId and $pfPageType">
							<input type="hidden">
								<xsl:attribute name="name">sovcf_<xsl:value-of select="$attrId"/>_<xsl:value-of select="$selectedValue"/></xsl:attribute>
								<xsl:attribute name="value"><xsl:value-of select="$pfId"/>_<xsl:value-of select="$pfPageType"/></xsl:attribute>
							</input>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/attr_dropdown.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<!-- DEBUG INFO: Start build include:  -->
	<!-- Attribute Id - Variable mapping -->
	<xsl:variable name="Attr.Year" select="'38'"/>
	<xsl:variable name="Attr.Manufacturer" select="'39'"/>
	<xsl:variable name="Attr.Model" select="'41'"/>
	<xsl:variable name="Attr.Mileage" select="'85'"/>
	<xsl:variable name="Attr.VIN" select="'10236'"/>
	<xsl:variable name="Attr.TransMission" select="'10239'"/>
	<xsl:variable name="Attr.NumberOfDoors" select="'10240'"/>
	<xsl:variable name="Attr.NumberOfCylinders" select="'10718'"/>
	<xsl:variable name="Attr.SubModel" select="'10241'"/>
	<xsl:variable name="Attr.Warranty" select="'10242'"/>
	<xsl:variable name="Attr.ExistingWarranty" select="'26738'"/>
	<xsl:variable name="Attr.TypeOfTitle" select="'10243'"/>
	<xsl:variable name="Attr.Condition" select="'10244'"/>
	<xsl:variable name="Attr.SubTitle" select="'10246'"/>
	<xsl:variable name="Attr.StandardEqp" select="'10247'"/>
	<xsl:variable name="Attr.OptionalEqp" select="'10248'"/>
	<xsl:variable name="Attr.ExteriorColor" select="'10719'"/>
	<xsl:variable name="Attr.InteriorColor" select="'10720'"/>
	<xsl:variable name="Attr.DepositAmount" select="'10733'"/>
	<xsl:variable name="Attr.DepositType" select="'10734'"/>
	<xsl:variable name="Attr.Engine" select="'25846'"/>
	<xsl:variable name="Attr.DriveTrain" select="'25839'"/>
	<xsl:variable name="Attr.Series" select="'25436'"/>
	<xsl:variable name="Attr.AirBag" select="'25842'"/>
	<xsl:variable name="Attr.Roofs" select="'25840'"/>
	<xsl:variable name="Attr.Package" select="'25843'"/>
	<xsl:variable name="Attr.EngineType" select="'10238'"/>
	<xsl:variable name="Attr.PowerSeat" select="'25841'"/>	
	<xsl:variable name="Attr.Options" select="'10446'"/>	
	<xsl:variable name="Attr.SafetyFeatures" select="'25919'"/>	
	<xsl:variable name="Attr.PowerOptions" select="'25918'"/>	

<!-- DEBUG INFO: End build include: ..\XSL\en-US\NotLocalized\Shared\attr_ids.xsl -->
	<!-- 
		<template match="Input">
		
			The template is a starting point to generate input HTML elements, like radiobox, checkbox, combobox, list box, text field, textarea field..

			<param name="attrId">Attribute id of the input field</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
			<param name="inputName">Name of the input field</param>
			
		</template>
	-->
	<xsl:template match="Input" mode="attributes">
		<xsl:param name="attrId"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:param name="inputName" select="$returnAttr[@id=$attrId]/InputFields/Input/@name"/>
		<xsl:variable name="VCSID" select="../../../../../../@id"/>
		<!-- Added for SYI motors conversion
		Common variables used in attribute flow -->
		<xsl:variable name="IsSiteAutos" select="boolean(/ebay/Environment/@siteId='100')"/>
		<xsl:variable name="Attr_ProductAttributes" select="/ebay/Sale/Item/Attributes/AttributeSet"/>
		<xsl:variable name="CatalogEnabled" select="boolean($Attr_ProductAttributes/CatalogEnabled or /ebay/V2CatalogEnabled)"/>
		<xsl:variable name="CurrentWidgetPI" select="../../../../../../PresentationInstruction/Initial/Row/Widget/Attribute[@id=$attrId]/.."/>
		<xsl:variable name="ChoiceCount" select="count(/ebay/SYI.Data/Characteristics/CharacteristicsSet/CharacteristicsList/Initial/Attribute[@id=$attrId]/ValueList/Value)"/>
		<xsl:variable name="AttributesCount" select="/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/@count"/>
		<xsl:variable name="ProductAttributesCount" select="count(/ebay/SYI.Data/ProductAttributes/Attribute[@id=$attrId]/ValueList/Value)"/>
		<!--
		Changed for SYI motors conversion
		One more check to handle the common PI issue for both catalog and non-catalog flow in SYI motors.
		For motors, there is a common PI for catalog and non catalog flow. We interpret it as follows:
		<Widget type="normal" isVisible='c'> - Visible in VIN flow only: check for CatalogEnabled
		<Widget type="normal" isVisible='nc'> - Visible in non-VIN flow only: check for the absence of CatalogEnabled tag
		<Widget type="normal" isVisible='y'> - Always visible in both the flows.
		<Widget type="normal" isVisible='n'> - Never visible in any flow
		-->
		<xsl:variable name="ShowWidgetInFlowAndSite">
			<xsl:choose>
				<xsl:when test="not($IsSiteAutos)">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:when test="$IsSiteAutos and not(/ebay/Sale/Item/Properties/IsAutosCar)">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="($CatalogEnabled) and ($CurrentWidgetPI[@isVisible='c'] or $CurrentWidgetPI[@isVisible='y'])">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:when test="($CatalogEnabled) and ($CurrentWidgetPI[@isVisible='nc'] or $CurrentWidgetPI[@isVisible='n'])">
							<xsl:value-of select="false()"/>
						</xsl:when>
						<xsl:when test="not($CatalogEnabled) and ($CurrentWidgetPI[@isVisible='nc'] or $CurrentWidgetPI[@isVisible='y'])">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:when test="not($CatalogEnabled) and ($CurrentWidgetPI[@isVisible='c'] or $CurrentWidgetPI[@isVisible='n'])">
							<xsl:value-of select="false()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="false()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- All this hardcoding is ugly. I was asked to use this because the current form generator framework does not support
		the v3 motors requirements. The requirement was that the UI should look exactly like the v2 motors UI. I was asked by Darren S.,
		Vijay R. And Brain G. to do this hardcoding -->
		<xsl:if test="$ShowWidgetInFlowAndSite='true'">			
			<xsl:choose>
				<!-- Changed for SYI motors conversion
				Non Catalog flow, and attribute= Engine, Drive Train or Series - do not show the empty drop down -->
				<xsl:when test="not($CatalogEnabled) and ($attrId=$Attr.Engine or $attrId=$Attr.DriveTrain or $attrId=$Attr.Series) and $IsSiteAutos">
					<!-- Do nothing - Do not display an empty dropdown -->
				</xsl:when>
				<!-- Hardcoding for Engine -->
				<xsl:when test="$CatalogEnabled and $attrId=$Attr.Engine and $ProductAttributesCount&gt;1">
					<xsl:call-template name="Dropdown">
						<xsl:with-param name="attrId" select="$attrId"/>
						<xsl:with-param name="inputName" select="$inputName"/>
						<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
						<xsl:with-param name="CurrentAttributeXPath" select="/ebay/SYI.Data/ProductAttributes/Attribute[@id=$attrId]"/>
						<xsl:with-param name="VCSID" select="$VCSID"/>
					</xsl:call-template>
				</xsl:when>
				<!-- Hardcoding for DriveTrain -->
				<xsl:when test="$CatalogEnabled and $attrId=$Attr.DriveTrain and $ProductAttributesCount&gt;1">
					<xsl:call-template name="Dropdown">
						<xsl:with-param name="attrId" select="$attrId"/>
						<xsl:with-param name="inputName" select="$inputName"/>
						<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
						<xsl:with-param name="CurrentAttributeXPath" select="/ebay/SYI.Data/ProductAttributes/Attribute[@id=$attrId]"/>
						<xsl:with-param name="VCSID" select="$VCSID"/>
					</xsl:call-template>
				</xsl:when>
				<!-- Hardcoding for Transmission -->
				<xsl:when test="$CatalogEnabled and $attrId=$Attr.TransMission and $ProductAttributesCount&gt;1">
					<xsl:call-template name="Dropdown">
						<xsl:with-param name="attrId" select="$attrId"/>
						<xsl:with-param name="inputName" select="$inputName"/>
						<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
						<xsl:with-param name="CurrentAttributeXPath" select="/ebay/SYI.Data/ProductAttributes/Attribute[@id=$attrId]"/>
						<xsl:with-param name="VCSID" select="$VCSID"/>
					</xsl:call-template>
				</xsl:when>
				<!-- Changed for SYI motors conversion
				Convert stuff into labels. Exclusions apply. -->
				<xsl:when test="$ChoiceCount&lt;1 and $AttributesCount=1 and ($CatalogEnabled) and ($attrId!=$Attr.Mileage and $attrId!=$Attr.VIN and $attrId!=$Attr.StandardEqp and $attrId!=$Attr.OptionalEqp and $attrId!=$Attr.SubModel)  and not($attrId=$Attr.PowerSeat or $attrId=$Attr.Package or $attrId=$Attr.Roofs or $attrId=$Attr.AirBag or $attrId=$Attr.Series and $ProductAttributesCount &gt; 1) and $IsSiteAutos">				
					<font face="Arial, Helvetica, sans-serif" size="2">
						<xsl:value-of select="/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/Name"/>
					</font>
				</xsl:when>
				<!-- Changed for SYI motors conversion
				Some other set of attributes behave differently. These are the ones that come from AutoDAQ
				They are available in ProductAttributes - ProductAttributeCount comes 0
				Convert into a label again
				1. Power Seat
				2. Package
				-->
				<xsl:when test="$ProductAttributesCount=1 and $CatalogEnabled and ($attrId=$Attr.PowerSeat or $attrId=$Attr.Package or $attrId=$Attr.Roofs or $attrId=$Attr.AirBag or $attrId=$Attr.Series) and $IsSiteAutos">				
					<font face="Arial, Helvetica, sans-serif" size="2">
						<xsl:value-of select="/ebay/SYI.Data/ProductAttributes/Attribute[@id=$attrId]/ValueList/Value/Name"/>
						
					</font>
				</xsl:when>
				<xsl:when test="$ProductAttributesCount=0 and $CatalogEnabled and ($attrId=$Attr.PowerSeat or $attrId=$Attr.Package or $attrId=$Attr.Roofs or $attrId=$Attr.AirBag or $attrId=$Attr.Series) and $IsSiteAutos">
					<!-- Hide -->
				</xsl:when>
				<!-- Changed for SYI motors conversion
				Catalog flow - turn transmission into a label 
				Another one-off ugly hack for motors
				-->
				<xsl:when test="$attrId=$Attr.TransMission and $CatalogEnabled">				
					<font face="Arial, Helvetica, sans-serif" size="2">
						<xsl:value-of select="/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/Name"/>
					</font>
				</xsl:when>
				<xsl:otherwise>					
					<xsl:choose>
						<xsl:when test="$CurrentAttributeXPath[@id = $attrId][EditType = 1 or EditType = 2] and $SelectedAttributeXPath[@id = $attrId][@source = 1 or @source=3]">
							<!-- If the current attribute is a Type2 or Type1 attribute and it's source is from a Catalog (1) or an AMS default (2) we want to make it read only.  The reason this was put here was because we wanted to build all of the messges/labels etc. around the attribute because it is read only the first time on the T&D page. **This might be removed pending PM
approval/dissaproval** -->
							<font size="2">
								<b>
									<xsl:choose>
										<xsl:when test="$subPage = 'API' and $SelectedAttributeXPath[@id = $attrId]/Value[Month or Day or Year]">
											<xsl:apply-templates mode="API" select="$SelectedAttributeXPath[@id = $attrId]/Value">
												<xsl:with-param name="attrId" select="$attrId"/>
												<xsl:with-param name="PI.Attribute" select="../../node()"/>
												<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
											</xsl:apply-templates>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$SelectedAttributeXPath[@id = $attrId]/Value/Name"/>
										</xsl:otherwise>
									</xsl:choose>
								</b>
							</font>
						</xsl:when>
						<!-- Changed for SYI motors conversion
						Hide the drop down for Year in case of VIN flow for motors -->
						<xsl:when test="@type = 'dropdown'">							
							<xsl:if test="not($attrId=$Attr.Year and $CatalogEnabled)">
								<xsl:choose>
									<xsl:when test="not(/ebay/SYI.Data/Characteristics/CharacteristicsSet/CharacteristicsList/Initial/Attribute[@id=$attrId]/ValueList) and $IsSiteAutos">										
										<xsl:call-template name="Dropdown">
											<xsl:with-param name="attrId" select="$attrId"/>
											<xsl:with-param name="inputName" select="$inputName"/>
											<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
											<xsl:with-param name="CurrentAttributeXPath" select="/ebay/SYI.Data/ProductAttributes/Attribute[@id=$attrId]"/>
											<xsl:with-param name="VCSID" select="$VCSID"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>										
										<xsl:call-template name="Dropdown">
											<xsl:with-param name="attrId" select="$attrId"/>
											<xsl:with-param name="inputName" select="$inputName"/>
											<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
											<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
											<xsl:with-param name="VCSID" select="$VCSID"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="$thisPage='SYI' and $subPage != 'API'">
									<!-- this is to make sure we pass in some value for disabled dropdowns (for VI to read) -->
									<input type="hidden" name="{concat('attr_m',$VCSID,'_',$attrId)}" value="-10"/>
								</xsl:if>
							</xsl:if>
							<!-- Pass the year as a hidden value only for catalog flow -->
							<xsl:if test="$attrId=$Attr.Year and $CatalogEnabled">
								<input type="hidden" name="{concat('attr_d',$VCSID,'_',$attrId,'_y')}" value="{/ebay/SYI.Data/ProductAttributes/Attribute[@id=$attrId]/ValueList/Value/Name}"/>
							</xsl:if>
						</xsl:when>
						<!-- Changed for SYI motors conversion
						Turn the textbox for VIN number into a label if a VIN number is available 
						In that case, add a hidden variable for the VIN number
						-->
						<xsl:when test="@type = 'textfield'">
							<xsl:choose>
								<xsl:when test="not($attrId=$Attr.VIN and $CatalogEnabled and $IsSiteAutos)">
									<xsl:call-template name="TextField">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputName" select="$inputName"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<font face="Arial, Helvetica, sans-serif" size="2">
										<xsl:choose>
											<xsl:when test="/ebay/SYI.WebFlow/CatalogSearchString">
												<xsl:value-of select="/ebay/SYI.WebFlow/CatalogSearchString"/>
												<input type="hidden" name="attr_t1137_10236" value="{/ebay/SYI.WebFlow/CatalogSearchString}"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/Name"/>
												<input type="hidden" name="attr_t1137_10236" value="{/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/Name}"/>
											</xsl:otherwise>
										</xsl:choose>
									</font>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="@type = 'checkbox' or @type = 'radio'">
							<xsl:if test="$thisPage='SYI' and $subPage != 'API'">
								<input type="hidden" name="{concat('attr_m',$VCSID,'_',$attrId)}" value="-10"/>
							</xsl:if>
							<!-- Modified for SYI Motors conversion
							If the ValueList is not found under characteristic set for any attribute, pass the XPath to ProductAttributes as the CurrentAttributeXPath -->
							<xsl:choose>
								<xsl:when test="not(/ebay/SYI.Data/Characteristics/CharacteristicsSet/CharacteristicsList/Initial/Attribute[@id=$attrId]/ValueList) and $IsSiteAutos">
									<xsl:call-template name="CheckboxRadio">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="columns" select="@columns"/>
										<xsl:with-param name="type" select="@type"/>
										<xsl:with-param name="inputName" select="$inputName"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
										<xsl:with-param name="CurrentAttributeXPath" select="/ebay/SYI.Data/ProductAttributes/Attribute[@id=$attrId]"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="CheckboxRadio">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="columns" select="@columns"/>
										<xsl:with-param name="type" select="@type"/>
										<xsl:with-param name="inputName" select="$inputName"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="@type = 'textarea'">
							<xsl:variable name="FieldName">
								<xsl:choose>
									<xsl:when test="$thisPage='SYI'">
										<xsl:value-of select="concat('attr_t',$VCSID,'_',$attrId)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$inputName"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="InputValue">
								<xsl:choose>
									<xsl:when test="$UsePostedFormFields">
										<xsl:value-of select="$FormFields/FormField[@name = $FieldName]/Value"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$SelectedAttributeXPath[@id=$attrId]/Value/Name"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<textarea rows="{@rows}" cols="{@cols}" name="{$FieldName}">
								<xsl:value-of select="$InputValue"/>
							</textarea>
						</xsl:when>
						<xsl:when test="@type = 'single' or @type = 'multiple'">
							<xsl:if test="$thisPage='SYI' and $subPage != 'API'">
								<input type="hidden" name="{concat('attr_m',$VCSID,'_',$attrId)}" value="-10"/>
							</xsl:if>
							<xsl:call-template name="SingleMultiple">
								<xsl:with-param name="attrId" select="$attrId"/>
								<xsl:with-param name="inputName" select="$inputName"/>
								<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
								<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
								<xsl:with-param name="VCSID" select="$VCSID"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<!-- Changed for SYI motors conversion
					Add an extra spacer after the attributes in V3 motors to give the V2 look and feel>
					<xsl:if test="$IsSiteAutos">
						<tr>
							<td valign="top">
								<img src="http://pics.ebaystatic.com/aw/pics/spacer.gif" height="5" width="1" alt="" title=""/>
							</td>
						</tr>
					</xsl:if>
					-->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!-- Changed for SYI motors conversion	
		If ShowWidgetInFlowAndSite at the beginning of the template evaluates to false, do not display the widget in this particular flow -->
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/attr_input.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<!-- 
		<template name="SingleMultiple">
			The template generates Listbox with multiple or single selection.
			<param name="attrId">Attribute id of the input field</param>
			<param name="inputName">Name of the input field</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="SingleMultiple">
		<xsl:param name="attrId"/>
		<xsl:param name="inputName"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:param name="VCSID"/>
		<xsl:choose>
			<xsl:when test="$thisPage='SYI'">
				<xsl:variable name="syiParentAttrId" select="$CurrentAttributeXPath[Dependency/@childAttrId=$attrId]/@id"/>
				<select>
					<xsl:choose>
						<xsl:when test="@size">
							<xsl:attribute name="size"><xsl:value-of select="@size"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="size">4</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@type='multiple'">
						<xsl:attribute name="multiple">multiple</xsl:attribute>
					</xsl:if>
					<!-- onChange-->
					<xsl:choose>
						<!-- JO: commented out Post for type 4 because conditionally visible attributes are moved over to next page (multi-page flow). -->
						<!--
						<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='4' or (@type='3' and @type='4')]">
							<xsl:attribute name="onChange">aus_set_parent('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>', this.value); vvsp_check('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>', this.value);</xsl:attribute>
						</xsl:when>
						-->
						<xsl:when test="$subPage = 'API' and $CurrentAttributeXPath[@id=$attrId]/Dependency[@type = '4' or @type = '5']">
							<xsl:attribute name="onChange"><xsl:if test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='1']">attr_onchange('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>'); </xsl:if> vvsp_check('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>', this.value);</xsl:attribute>
						</xsl:when>
						<!-- DT: Type=3 (VVSP) no longer exist-->
						<!--
						<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='3']">
							<xsl:attribute name="onChange">aus_set_parent('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',1); vvsp_post('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>', this.value);</xsl:attribute>
						</xsl:when>
						-->
						<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='1']">
							<xsl:attribute name="onChange">attr_onchange('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>');<xsl:if test="$subPage = 'API' ">api_check_on_other('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',this.value);</xsl:if></xsl:attribute>
						</xsl:when>
						<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/Dependency[@type='2']">
							<xsl:attribute name="onChange">attr_onchange('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',this.options[this.selectedIndex].value);<xsl:if test="$subPage = 'API' ">api_check_on_other('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',this.value);</xsl:if></xsl:attribute>
						</xsl:when>
						<xsl:when test="$subPage = 'API' ">
							<xsl:attribute name="onChange">api_check_on_other('attr<xsl:value-of select="concat($VCSID,'_',$attrId)"/>',this.value);</xsl:attribute>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
					<xsl:variable name="FieldName" select="concat('attr',$VCSID,'_',$attrId)"/>
					<xsl:attribute name="name"><xsl:value-of select="$FieldName"/></xsl:attribute>
					<xsl:choose>
						<xsl:when test="$syiParentAttrId">
							<xsl:choose>
								<xsl:when test="$CurrentAttributeXPath[@id=$syiParentAttrId]/*[@isVisible='true']">
									<!--<xsl:for-each select="$attrData[@id=$syiParentAttrId]/Dependency[(@type='1' or @type='2' or @type='3') and @childAttrId=$attrId and @isVisible='true']">-->
									<xsl:apply-templates select="$CurrentAttributeXPath[@id=$syiParentAttrId]/Dependency[(@type='1' or @type='2' or @type='3') and @childAttrId=$attrId and @isVisible='true']" mode="isVisible">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
										<xsl:with-param name="FieldName" select="$FieldName"/>
									</xsl:apply-templates>
									<!--</xsl:for-each>-->
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="syiParentValueId" select="$SelectedAttributeXPath[@id=$syiParentAttrId]/Value/@id"/>
									<xsl:choose>
										<xsl:when test="$subPage='API' and $CurrentAttributeXPath[@id=$syiParentAttrId]/Dependency[(@type='3' or @type='4' or @type='5') and @parentValueId=$syiParentValueId and @childAttrId=$attrId]">
											<xsl:apply-templates select="$CurrentAttributeXPath[@id=$attrId]/ValueList/Value | $CurrentAttributeXPath[@id=$syiParentAttrId]/Dependency[@parentValueId=$syiParentValueId and @childAttrId=$attrId]/Value[count(. | key('attrByIDs', concat($VCSID, '_', key('selectedAttrByIDs', concat($VCSID, '_', $syiParentAttrId, '_', $syiParentValueId))/@id, '_', @id))[1])=1]">
												<xsl:sort select="@id"/>
												<xsl:with-param name="attrId" select="$attrId"/>
												<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
												<xsl:with-param name="FieldName" select="$FieldName"/>
											</xsl:apply-templates>
										</xsl:when>
										<xsl:when test="$syiParentValueId and $CurrentAttributeXPath[@id=$syiParentAttrId]/Dependency[@type='1' or @type='2']">
											<xsl:apply-templates select="$CurrentAttributeXPath[@id=$syiParentAttrId]/Dependency[@parentValueId=$syiParentValueId]" mode="dep">
												<xsl:with-param name="attrId" select="$attrId"/>
												<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
												<xsl:with-param name="FieldName" select="$FieldName"/>
											</xsl:apply-templates>
										</xsl:when>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="$CurrentAttributeXPath[@id=$attrId]/ValueList/Value">
								<xsl:with-param name="attrId" select="$attrId"/>
								<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
								<xsl:with-param name="FieldName" select="$FieldName"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</select>
			</xsl:when>
			<xsl:otherwise>
				<!-- This flow is never used by SYI -->
				<xsl:variable name="pfId" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input/Value/@pfId"/>
				<xsl:variable name="pfPageType" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input/Value/@pfPageType"/>
				<xsl:variable name="selectedValue" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input/Value/@id"/>
				<xsl:variable name="parentAttrId" select="$attrData[@id=$attrId]/@parentAttrId"/>
				<select>
					<xsl:choose>
						<xsl:when test="@display_size">
							<xsl:attribute name="size"><xsl:value-of select="@display_size"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="size">4</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@type='multiple'">
						<xsl:attribute name="multiple">multiple</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="name"><xsl:value-of select="$inputName"/></xsl:attribute>
					<xsl:attribute name="class"><xsl:value-of select="$inputName"/></xsl:attribute>
					<xsl:if test="$attrData[@id=$attrId]/Dependency[@type='1'] or (/ebay/SYI.Data and $attrData[@id=$attrId]/Dependency[@type='2' or @type='4'])">
						<xsl:attribute name="onChange">attr_onchange('<xsl:value-of select="$inputName"/>',this.form.name);</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$parentAttrId">
							<xsl:variable name="parentValueId" select="$returnAttr[@id=$parentAttrId]/InputFields/Input/Value/@id"/>
							<xsl:choose>
								<xsl:when test="$parentValueId != '-24'">
									<xsl:choose>
										<xsl:when test="$attrData[@id=$parentAttrId]/Dependency[@parentValueId=$parentValueId and @childAttrId=$attrId]">
											<xsl:apply-templates select="$attrData[@id=$parentAttrId]/Dependency[@parentValueId=$parentValueId and @childAttrId=$attrId]/Value" mode="dep"/>
										</xsl:when>
										<xsl:when test="$subPage='APIPF'">
										</xsl:when>
										<xsl:otherwise>
											<script LANGUAGE="JavaScript1.1">
												var thisChild = "a<xsl:value-of select="$attrId"/>"; //if child does not have dep valuelist, then disable it.
												attr_disable(thisChild);
											</script>
											<xsl:call-template name="EmptyDropdown"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="EmptyDropdown"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="$attrData[@id=$attrId]/ValueList/Value">
								<xsl:with-param name="selectedValue" select="$attrData[@id=$attrId]/InputFields/Input/Value/@id"/>
								<xsl:with-param name="pfId" select="$pfId"/>
								<xsl:with-param name="pfPageType" select="$pfPageType"/>
								<xsl:with-param name="type" select="@type"/>
							</xsl:apply-templates>
							<xsl:if test="@type='single' and $pfId and $pfPageType">
								<option value="{$selectedValue}" selected="selected">
									<xsl:choose>
										<xsl:when test="$attrData[@id=$attrId]/InputFields/Input/Value[DisplayName!='']">
											<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input/Value/DisplayName"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input/Value/Name"/>
										</xsl:otherwise>
									</xsl:choose>
								</option>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</select>
				<xsl:if test="$pfId and $pfPageType">
					<input type="hidden">
						<xsl:attribute name="name">sovcf_<xsl:value-of select="$attrId"/>_<xsl:value-of select="$selectedValue"/></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$pfId"/>_<xsl:value-of select="$pfPageType"/></xsl:attribute>
					</input>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/attr_single_multiple.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<!-- 
		<template name="TextField">
			The template generates text field elements.
			<param name="attrId">Attribute id of the input field</param>
			<param name="inputName">Name of the input field</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="TextField">
		<xsl:param name="attrId"/>
		<xsl:param name="inputName"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:param name="VCSID"/>
		<xsl:choose>
			<xsl:when test="../../@type='date'">
				<xsl:variable name="currentDate" select="$CurrentAttributeXPath[@id=$attrId]/CurrentTime/DateMedium"/>
				<xsl:variable name="currentMonth" select="substring-before($currentDate,'-')"/>
				<xsl:variable name="currentDayYear" select="substring-after($currentDate,'-')"/>
				<xsl:variable name="currentDay" select="substring-before($currentDayYear,'-')"/>
				<xsl:variable name="currentYear" select="concat('20',substring-after($currentDayYear,'-'))"/>
				<xsl:variable name="day">
					<xsl:choose>
						<xsl:when test="../CurrentDate">
							<xsl:value-of select="$currentDay"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$thisPage='PF'">
									<xsl:value-of select="$returnAttr[@id=$attrId]/InputFields/Input[@dataType='D']/Value/Name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$SelectedAttributeXPath[@id=$attrId]/Value/Day"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="month">
					<xsl:choose>
						<xsl:when test="../CurrentDate">
							<xsl:value-of select="$currentMonth"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$thisPage='PF'">
									<xsl:value-of select="$returnAttr[@id=$attrId]/InputFields/Input[@dataType='M']/Value/Name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$SelectedAttributeXPath[@id=$attrId]/Value/Month"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="year">
					<xsl:choose>
						<xsl:when test="../CurrentDate">
							<xsl:value-of select="$currentYear"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$thisPage='PF'">
									<xsl:value-of select="$returnAttr[@id=$attrId]/InputFields/Input[@dataType='Y']/Value/Name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$SelectedAttributeXPath[@id=$attrId]/Value/Year"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="($CurrentAttributeXPath[@id=$attrId][@dateFormat='d-m-Y' or @dateFormat='d-M-Y']) or (@format='d_m_y')">
						<!--Remove @format for all subsequent "when" after phase b rolls out and stable-->
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td/>
								<td>
									<xsl:if test="../Day/@quadrant='top'">
										<font face="{../Day/@face}" size="{../Day/@size}" color="{../Day/@color}">
											<xsl:value-of select="../Day"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Month/@quadrant='top'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Year/@quadrant='top'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td/>
							</tr>
							<tr>
								<td>
									<xsl:if test="../Day/@quadrant='left'">
										<font face="{../Day/@face}" size="{../Day/@size}" color="{../Day/@color}">
											<xsl:value-of select="../Day"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Day">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameDay" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='D']/@name"/>
										<xsl:with-param name="day" select="$day"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Day/@quadrant='right'">
										<font face="{../Day/@face}" size="{../Day/@size}" color="{../Day/@color}">
											<xsl:value-of select="../Day"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="../Month/@quadrant='left'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Month">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameMonth" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='M']/@name"/>
										<xsl:with-param name="month" select="$month"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Month/@quadrant='right'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="../Year/@quadrant='left'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Year">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameYear" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='Y']/@name"/>
										<xsl:with-param name="year" select="$year"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Year/@quadrant='right'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td/>
								<td>
									<xsl:if test="../Day/@quadrant='bottom'">
										<font face="{../Day/@face}" size="{../Day/@size}" color="{../Day/@color}">
											<xsl:value-of select="../Day"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Month/@quadrant='bottom'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Year/@quadrant='bottom'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td/>
							</tr>
						</table>
					</xsl:when>
					<xsl:when test="($CurrentAttributeXPath[@id=$attrId][@dateFormat='m-d-Y' or @dateFormat='M-d-Y']) or (@format='m_d_y')">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td/>
								<td>
									<xsl:if test="../Month/@quadrant='top'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Day/@quadrant='top'">
										<font face="{../Day/@face}" size="{../Day/@size}" color="{../Day/@color}">
											<xsl:value-of select="../Day"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Year/@quadrant='top'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td/>
							</tr>
							<tr>
								<td>
									<xsl:if test="../Month/@quadrant='left'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Month">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameMonth" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='M']/@name"/>
										<xsl:with-param name="month" select="$month"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Month/@quadrant='right'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="../Day/@quadrant='left'">
										<font face="{../Day/@face}" size="{../Day/@size}" color="{../Day/@color}">
											<xsl:value-of select="../Day"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Day">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameDay" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='D']/@name"/>
										<xsl:with-param name="day" select="$day"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Day/@quadrant='right'">
										<font face="{../Day/@face}" size="{../Day/@size}" color="{../Day/@color}">
											<xsl:value-of select="../Day"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="../Year/@quadrant='left'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Year">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameYear" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='Y']/@name"/>
										<xsl:with-param name="year" select="$year"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Year/@quadrant='right'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td/>
								<td>
									<xsl:if test="../Month/@quadrant='bottom'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Day/@quadrant='bottom'">
										<font face="{../Day/@face}" size="{../Day/@size}" color="{../Day/@color}">
											<xsl:value-of select="../Day"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Year/@quadrant='bottom'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td/>
							</tr>
						</table>
					</xsl:when>
					<xsl:when test="($CurrentAttributeXPath[@id=$attrId][@dateFormat='m-Y' or @dateFormat='M-Y']) or (@format='m_y')">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td/>
								<td>
									<xsl:if test="../Month/@quadrant='top'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Year/@quadrant='top'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td/>
							</tr>
							<tr>
								<td>
									<xsl:if test="../Month/@quadrant='left'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Month">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameMonth" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='M']/@name"/>
										<xsl:with-param name="month" select="$month"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Month/@quadrant='right'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="../Year/@quadrant='left'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Year">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameYear" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='Y']/@name"/>
										<xsl:with-param name="year" select="$year"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Year/@quadrant='right'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td/>
								<td>
									<xsl:if test="../Month/@quadrant='bottom'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Year/@quadrant='bottom'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td/>
							</tr>
						</table>
					</xsl:when>
					<xsl:when test="($CurrentAttributeXPath[@id=$attrId][@dateFormat='Y-m' or @dateFormat='Y-M']) or (@format='y_m')">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td/>
								<td>
									<xsl:if test="../Year/@quadrant='top'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Month/@quadrant='top'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td/>
							</tr>
							<tr>
								<td>
									<xsl:if test="../Year/@quadrant='left'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Year">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameYear" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='Y']/@name"/>
										<xsl:with-param name="year" select="$year"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Year/@quadrant='right'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="../Month/@quadrant='left'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Month">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameMonth" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='M']/@name"/>
										<xsl:with-param name="month" select="$month"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Month/@quadrant='right'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td/>
								<td>
									<xsl:if test="../Year/@quadrant='bottom'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td/>
								<td/>
								<td>
									<xsl:if test="../Month/@quadrant='bottom'">
										<font face="{../Month/@face}" size="{../Month/@size}" color="{../Month/@color}">
											<xsl:value-of select="../Month"/>
										</font>
									</xsl:if>
								</td>
								<td/>
							</tr>
						</table>
					</xsl:when>
					<xsl:when test="($CurrentAttributeXPath[@id=$attrId][@dateFormat='Y']) or (@format='y')">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td>
									<xsl:if test="../Year/@quadrant='top'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td>
									<xsl:if test="../Year/@quadrant='left'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
								<td>
									<xsl:call-template name="Textbox_Year">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputNameYear" select="$CurrentAttributeXPath[@id=$attrId]/InputFields/Input[@dataType='Y']/@name"/>
										<xsl:with-param name="year" select="$year"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="../Year/@quadrant='right'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td>
									<xsl:if test="../Year/@quadrant='bottom'">
										<font face="{../Year/@face}" size="{../Year/@size}" color="{../Year/@color}">
											<xsl:value-of select="../Year"/>
										</font>
									</xsl:if>
								</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:when test="($CurrentAttributeXPath[@id=$attrId][@dateFormat='c']) or (@format='c')">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td>
									<xsl:call-template name="Textbox_FullDate">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="inputName" select="$inputName"/>
										<xsl:with-param name="day" select="$day"/>
										<xsl:with-param name="month" select="$month"/>
										<xsl:with-param name="year" select="$year"/>
										<xsl:with-param name="SelectedAttributeXPath" select="$SelectedAttributeXPath"/>
										<xsl:with-param name="VCSID" select="$VCSID"/>
									</xsl:call-template>
								</td>
							</tr>
						</table>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<input type="text">
					<xsl:attribute name="maxlength"><xsl:choose><xsl:when test="@maxlength"><xsl:value-of select="@maxlength"/></xsl:when><xsl:otherwise>300</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="size"><xsl:choose><xsl:when test="@size"><xsl:value-of select="@size"/></xsl:when><xsl:otherwise>20</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:choose>
						<xsl:when test="$thisPage='SYI'">
							<!--Changed for SYI Motors Conversion
							When attribute id = -16, the name of the hidden variable changes to _s.
							This is a ugly motors hack.
							-->
							<xsl:variable name="FieldName">
								<xsl:choose>
									<xsl:when test="$attrId=$Attr.Model and $IsPassVehicles and /ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/@id=-16">
										<xsl:value-of select="concat('attr_s',$VCSID,'_',$attrId)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat('attr_t',$VCSID,'_',$attrId)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!--
							Changed for SYI motors conversion. For -16/model, pick up the value from DisplayName rather than Name.
							-->
							<xsl:variable name="InputValue">
								<xsl:choose>
									<xsl:when test="$attrId=$Attr.Model and $IsPassVehicles and /ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/Value/@id=-16">
										<xsl:value-of select="$SelectedAttributeXPath[@id=$attrId]/Value/DisplayName"/>
									</xsl:when>
									<xsl:when test="$UsePostedFormFields">
										<xsl:value-of select="$FormFields/FormField[@name = $FieldName]/Value"/>
									</xsl:when>
									<xsl:when test="$SelectedAttributeXPath[@id=$attrId]/Value/Name">
										<xsl:value-of select="$SelectedAttributeXPath[@id=$attrId]/Value/Name"/>
									</xsl:when>
									<!--
									Changed for SYI motors conversion.
									For attrId=VIN, pick up the CatalogSearchString for perpopulation.
									-->
									<xsl:otherwise>
										<xsl:if test="$attrId=$Attr.VIN">
											<xsl:value-of select="/ebay/SYI.WebFlow/CatalogSearchString"/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:attribute name="name"><xsl:value-of select="$FieldName"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="$InputValue"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="name"><xsl:value-of select="$inputName"/></xsl:attribute>
							<xsl:attribute name="class"><xsl:value-of select="$inputName"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="normalize-space($SelectedAttributeXPath[@id=$attrId]/InputFields/Input/Value)"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
				<!-- Changed for SYI motors BUGDB00170660 -->
				<xsl:if test="boolean(/ebay/Sale/Item/Properties/IsAutosCar) and $attrId = $Attr.VIN">
					<br/>
					<img src="http://pics.ebaystatic.com/aw/pics/asteriskG_10x10.gif" width="10" height="10"/>
					<font face="Arial, Helvetica, Sans-serif" size="2" color="#666666">Required for all vehicles with a model year of 1981 or later. 17 character limit, not case sensitive.</font>
				</xsl:if>
				<xsl:if test="boolean(/ebay/Sale/Item/Properties/IsAutosMotorcycle) and $attrId = $Attr.VIN">
					<br/>
					<font face="Arial, Helvetica, Sans-serif" size="2" color="#666666">17 character limit.</font>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- =================================================================
		Display Input Box for DAY
	================================================================== -->
	<!-- 
		<template name="Textbox_Day">
			Display Input Box for DAY.
			<param name="attrId">Attribute id of the input field</param>
			<param name="inputName">Name of the input field</param>
			<param name="day">number of the day</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="Textbox_Day">
		<xsl:param name="attrId"/>
		<xsl:param name="inputNameDay"/>
		<xsl:param name="day"/>
		<xsl:param name="VCSID"/>
		<xsl:variable name="FieldNameD" select="concat('attr_d',$VCSID,'_',$attrId,'_d')"/>
		<xsl:variable name="InputValueD">
			<xsl:choose>
				<xsl:when test="$UsePostedFormFields">
					<xsl:value-of select="$FormFields/FormField[@name = $FieldNameD]/Value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not($day='00')  and not($day='99')">
						<xsl:value-of select="$day"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<input type="text" maxlength="2">
			<xsl:attribute name="size"><xsl:choose><xsl:when test="@size"><xsl:value-of select="@size"/></xsl:when><xsl:otherwise>2</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:choose>
				<xsl:when test="$thisPage='SYI'">
					<xsl:attribute name="name"><xsl:value-of select="$FieldNameD"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$InputValueD"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class"><xsl:value-of select="$inputNameDay"/></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="$inputNameDay"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$InputValueD"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</input>
	</xsl:template>
	<!-- =================================================================
		Display Input Box for MONTH
	================================================================== -->
	<!-- 
		<template name="Textbox_Month">
			Display Input Box for MONTH.
			<param name="attrId">Attribute id of the input field</param>
			<param name="inputName">Name of the input field</param>
			<param name="month">number of the month</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="Textbox_Month">
		<xsl:param name="attrId"/>
		<xsl:param name="inputNameMonth"/>
		<xsl:param name="month"/>
		<xsl:param name="VCSID"/>
		<xsl:variable name="FieldNameM" select="concat('attr_d',$VCSID,'_',$attrId,'_m')"/>
		<xsl:variable name="InputValueM">
			<xsl:choose>
				<xsl:when test="$UsePostedFormFields">
					<xsl:value-of select="$FormFields/FormField[@name = $FieldNameM]/Value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not($month='00')  and not($month='99')">
						<xsl:value-of select="$month"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<input type="text" maxlength="2">
			<xsl:attribute name="size"><xsl:choose><xsl:when test="@size"><xsl:value-of select="@size"/></xsl:when><xsl:otherwise>2</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:choose>
				<xsl:when test="$thisPage='SYI'">
					<xsl:attribute name="name"><xsl:value-of select="$FieldNameM"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$InputValueM"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class"><xsl:value-of select="$inputNameMonth"/></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="$inputNameMonth"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$InputValueM"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</input>
	</xsl:template>
	<!-- =================================================================
		Display Input Box for YEAR
	================================================================== -->
	<!-- 
		<template name="Textbox_Year">
			Display Input Box for YEAR.
			<param name="attrId">Attribute id of the input field</param>
			<param name="inputName">Name of the input field</param>
			<param name="year">number of the year</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="Textbox_Year">
		<xsl:param name="attrId"/>
		<xsl:param name="inputNameYear"/>
		<xsl:param name="year"/>
		<xsl:param name="VCSID"/>
		<xsl:variable name="FieldNameY" select="concat('attr_d',$VCSID,'_',$attrId,'_y')"/>
		<xsl:variable name="InputValueY">
			<xsl:choose>
				<xsl:when test="$UsePostedFormFields">
					<xsl:value-of select="$FormFields/FormField[@name = $FieldNameY]/Value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not($year='0000') and not($year='____') and not($year='9999')">
						<xsl:value-of select="$year"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<input type="text" maxlength="4">
			<xsl:attribute name="size"><xsl:choose><xsl:when test="@size"><xsl:value-of select="@size"/></xsl:when><xsl:otherwise>4</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:choose>
				<xsl:when test="$thisPage='SYI'">
					<xsl:attribute name="name"><xsl:value-of select="$FieldNameY"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$InputValueY"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class"><xsl:value-of select="$inputNameYear"/></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="$inputNameYear"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$InputValueY"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</input>
	</xsl:template>
	<!-- =================================================================
		Display Input Box for FULL DATE
	================================================================== -->
	<!-- 
		<template name="Textbox_FullDate">
			Display Input Box for FULL DATE.
			<param name="attrId">Attribute id of the input field</param>
			<param name="inputName">Name of the input field</param>
			<param name="day">number of the day</param>
			<param name="month">number of the month</param>
			<param name="year">number of the year</param>
			<param name="SelectedAttributeXPath">Selected attributes from the previous step based on the current characteristics set ID</param>
			<param name="VCSID">characteristics set ID of the current category being handled</param>
		</template>
	-->
	<xsl:template name="Textbox_FullDate">
		<xsl:param name="attrId"/>
		<xsl:param name="inputName"/>
		<xsl:param name="day"/>
		<xsl:param name="month"/>
		<xsl:param name="year"/>
		<xsl:param name="SelectedAttributeXPath"/>
		<xsl:param name="VCSID"/>
		<xsl:variable name="FieldName" select="concat('attr_d',$VCSID,'_',$attrId,'_c')"/>
		<xsl:variable name="InputValue">
			<xsl:choose>
				<xsl:when test="$UsePostedFormFields">
					<xsl:value-of select="$FormFields/FormField[@name = $FieldName]/Value"/>
				</xsl:when>
				<xsl:when test="$SelectedAttributeXPath[@id=$attrId]/Value[Year or Month or Day]">
					<xsl:choose>
						<xsl:when test="@isEuro='y'">
							<xsl:if test="not($day='00')  and not($day='99')">
								<xsl:value-of select="$day"/>/</xsl:if>
							<xsl:if test="not($month='00')  and not($month='99')">
								<xsl:value-of select="$month"/>/</xsl:if>
							<xsl:if test="not($year='0000') and not($year='____')  and not($year='9999')">
								<xsl:value-of select="$year"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="not($month='00')  and not($month='99')">
								<xsl:value-of select="$month"/>/</xsl:if>
							<xsl:if test="not($day='00')  and not($day='99')">
								<xsl:value-of select="$day"/>/</xsl:if>
							<xsl:if test="not($year='0000') and not($year='____')  and not($year='9999')">
								<xsl:value-of select="$year"/>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of disable-output-escaping="no" select="$SelectedAttributeXPath[@id=$attrId]/Value/Name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<input type="text" maxlength="10">
			<xsl:attribute name="size"><xsl:choose><xsl:when test="@size"><xsl:value-of select="@size"/></xsl:when><xsl:otherwise>20</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:choose>
				<xsl:when test="$thisPage='SYI'">
					<xsl:attribute name="name"><xsl:value-of select="$FieldName"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$InputValue"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class"><xsl:value-of select="$inputName"/></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="$inputName"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$InputValue"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</input>
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/attr_textfield.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<!-- 
		<template match="Label">
			The template generates specified formating for the label based on Presentation Instructions.
			<param name="attrId">Attribute id of the label is generated for.</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
		</template>
	-->
	<xsl:template match="Label">
		<xsl:param name="attrId"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<!-- Added for SYI motors conversion
		Common variables used in attribute flow -->
		<xsl:variable name="IsSiteAutos" select="boolean(/ebay/Environment/@siteId='100')"/>
		<xsl:variable name="CatalogEnabled" select="(/ebay/Sale/Item/Attributes/AttributeSet/CatalogEnabled or /ebay/V2CatalogEnabled)"/>
		<xsl:variable name="CurrentWidgetPI" select="../../../../../../PresentationInstruction/Initial/Row/Widget/Attribute[@id=$attrId]/.."/>
		<xsl:variable name="ChoiceCount" select="count(/ebay/SYI.Data/Characteristics/CharacteristicsSet/CharacteristicsList/Initial/Attribute[@id=$attrId]/ValueList/Value)"/>
		<xsl:variable name="AttributesCount" select="/ebay/Sale/Item/Attributes/AttributeSet/Attribute[@id=$attrId]/@count"/>
		<xsl:variable name="ProductAttributesCount" select="count(/ebay/SYI.Data/ProductAttributes/Attribute[@id=$attrId]/ValueList/Value)"/>
		<!--
		Added for SYI motors conversion
		One more check to handle the common PI issue for both catalog and non-catalog flow in SYI motors.
		For motors, there is a common PI for catalog and non catalog flow. We interpret it as follows:
		<Widget type="normal" isVisible='c'> - Visible in VIN flow only: check for CatalogEnabled
		<Widget type="normal" isVisible='nc'> - Visible in non-VIN flow only: check for the absence of CatalogEnabled tag
		<Widget type="normal" isVisible='y'> - Always visible in both the flows.
		<Widget type="normal" isVisible='n'> - Never visible in any flow
		-->
		<xsl:variable name="ShowWidgetInFlowAndSite">
			<xsl:choose>
				<xsl:when test="not($IsSiteAutos)">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:when test="$IsSiteAutos and not(/ebay/Sale/Item/Properties/IsAutosCar)">
					<xsl:value-of select="true()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="($CatalogEnabled) and ($CurrentWidgetPI[@isVisible='c'] or $CurrentWidgetPI[@isVisible='y'])">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:when test="($CatalogEnabled) and ($CurrentWidgetPI[@isVisible='nc'] or $CurrentWidgetPI[@isVisible='n'])">
							<xsl:value-of select="false()"/>
						</xsl:when>
						<xsl:when test="not($CatalogEnabled) and ($CurrentWidgetPI[@isVisible='nc'] or $CurrentWidgetPI[@isVisible='y'])">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:when test="not($CatalogEnabled) and ($CurrentWidgetPI[@isVisible='c'] or $CurrentWidgetPI[@isVisible='n'])">
							<xsl:value-of select="false()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="false()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$ShowWidgetInFlowAndSite='true'">
			<!-- Changed for SYI motors conversion
			Handle all the one off cases for motors VIN and non-VIN flow -->
			<xsl:if test="not ($attrId=$Attr.Year and $CatalogEnabled)">
				<xsl:choose>
					<xsl:when test="not($CatalogEnabled) and ($attrId=$Attr.Engine or $attrId=$Attr.DriveTrain or $attrId=$Attr.Series ) and $IsSiteAutos">
						<!-- Do not display the label -->
					</xsl:when>
					<!-- Changed for SYI motors conversion
					Show the label when there is just on Item Attribute -->
					<xsl:when test="$ChoiceCount&lt;1 and $AttributesCount=1 and ($CatalogEnabled) and ($attrId!=$Attr.Mileage and  $attrId!=$Attr.VIN) and $IsSiteAutos">
						<xsl:choose>
							<xsl:when test="@bold='true' and @italic='true'">
								<b>
									<i>
										<xsl:call-template name="WriteLabel">
											<xsl:with-param name="attrId" select="$attrId"/>
											<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
										</xsl:call-template>
									</i>
								</b>
							</xsl:when>
							<xsl:when test="@bold='true'">
								<b>
									<xsl:call-template name="WriteLabel">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:call-template>
								</b>
							</xsl:when>
							<xsl:when test="@italic='true'">
								<i>
									<xsl:call-template name="WriteLabel">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:call-template>
								</i>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="WriteLabel">
									<xsl:with-param name="attrId" select="$attrId"/>
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!--Changed for SYI motors conversion -->
					<xsl:when test="$ProductAttributesCount=0 and $CatalogEnabled and ($attrId=$Attr.PowerSeat or $attrId=$Attr.Package or $attrId=$Attr.Roofs or $attrId=$Attr.AirBag or $attrId=$Attr.Series) and $IsSiteAutos">
						<!-- Do not display the label -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="@bold='true' and @italic='true'">
								<b>
									<i>
										<xsl:call-template name="WriteLabel">
											<xsl:with-param name="attrId" select="$attrId"/>
											<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
										</xsl:call-template>
									</i>
								</b>
							</xsl:when>
							<xsl:when test="@bold='true'">
								<b>
									<xsl:call-template name="WriteLabel">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:call-template>
								</b>
							</xsl:when>
							<xsl:when test="@italic='true'">
								<i>
									<xsl:call-template name="WriteLabel">
										<xsl:with-param name="attrId" select="$attrId"/>
										<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
									</xsl:call-template>
								</i>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="WriteLabel">
									<xsl:with-param name="attrId" select="$attrId"/>
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- 
		<template name="WriteLabel">
			The template generates the label and is used by match="Label". template.
			<param name="attrId">Attribute id of the label is generated for.</param>
			<param name="CurrentAttributeXPath">Current set of attributes based on characteristics set ID being parsed</param>
		</template>
	-->
	<xsl:template name="WriteLabel">
		<xsl:param name="attrId"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:variable name="parentAttrIdLabel" select="$CurrentAttributeXPath[Dependency/@childAttrId=$attrId]/@id"/>
		<font>
			<xsl:choose>
				<xsl:when test="$subPage='API'">
					<xsl:copy-of select="@*"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="face"><xsl:value-of select="@face"/></xsl:attribute>
					<xsl:attribute name="size"><xsl:value-of select="@size"/></xsl:attribute>
					<xsl:attribute name="color"><xsl:value-of select="@color"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="../@helpId != ''">
					<a href="http://pages.ebay.com/help/attrhelp/contextual/{../@helpId}.html" onclick="return openContextualHelpWindow(this.href);" target="helpwin">
						<xsl:choose>
							<xsl:when test=".!=''">
								<xsl:value-of select="."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$CurrentAttributeXPath[@id = $attrId]/Label"/>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</xsl:when>
				<xsl:when test="../Link">
					<a href="{../Link}">
						<xsl:choose>
							<xsl:when test=".!=''">
								<xsl:value-of select="."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$CurrentAttributeXPath[@id = $attrId]/Label"/>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</xsl:when>
				<xsl:when test="$CurrentAttributeXPath[@id = $attrId]/HasGlossary">
					<a href="{$CurrentAttributeXPath[@id = $attrId]/HelpText}" onclick="return openContextualHelpWindow(this.href);" target="helpwin">
						<xsl:choose>
							<xsl:when test=".!=''">
								<xsl:value-of select="."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$CurrentAttributeXPath[@id = $attrId]/Label"/>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test=".='spacer'">&#160;</xsl:when>
						<xsl:when test=".!=''">
							<xsl:value-of disable-output-escaping="yes" select="."/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$CurrentAttributeXPath[@id = $attrId][Label!='']">
									<xsl:value-of disable-output-escaping="yes" select="$CurrentAttributeXPath[@id = $attrId]/Label"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$thisPage='SYI'">&#160;</xsl:when>
										<xsl:otherwise/>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Changed for SYI motors conversion
			Display the * for mandatory fields for fields -->
			<xsl:if test="not($attrId=$Attr.VIN or ($attrId=$Attr.Model and not($CatalogEnabled)))">
				<xsl:if test="$CurrentAttributeXPath[@id = $attrId and @IsRequired='true'] or $CurrentAttributeXPath[@id=$parentAttrIdLabel]/Dependency[@childAttrId=$attrId and @type='5']">&#160;<xsl:copy-of select="$attrAsterisk"/>
				</xsl:if>
			</xsl:if>
		</font>
	</xsl:template>
	<!--DT: leave this closing tag on same line as font closing tag, this is to prevent carriage return with the td tag -->

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/attr_label.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
<!--******************************************************************************
DT:  Do not Pretty Print this file or change the format in anyway.
I've removed the carraige returns for each row so the cells are in a line.
This will remove noticeable white space from PF.
***********************************************************************************-->
	<!--
		@name WidgetDate
		
		Formats a single date in a date range.
		Element Level : Widget
	-->
	<xsl:template name="WidgetDate">
		<xsl:param name="attrId"/>
		<xsl:param name="Format"/>
		<xsl:param name="Columns">
			<xsl:value-of select="1"/>
		</xsl:param>
		<xsl:param name="RangeType"/>
		<xsl:param name="InputType"/>
		<xsl:param name="CurrentAttributeXPath"/>
		<xsl:param name="Label"><![CDATA[Label]]></xsl:param>
		<xsl:param name="LabelQuadrant"/>
		<xsl:choose>
			<xsl:when test="string-length($Format) &gt; 0 and $Format!='c'">
				<!-- Compound Input Type ... Parse the format and display properly -->
				<!-- First, if labels are at the top -->
				<tr>
					<td></td>
					<xsl:call-template name="DateFormatLabels">
						<xsl:with-param name="attrId" select="$attrId"/>
						<xsl:with-param name="Format" select="$Format"/>
						<xsl:with-param name="Quadrant"><![CDATA[top]]></xsl:with-param>
					</xsl:call-template>
					<td></td>
				</tr>
				<!-- Now write the input -->
				<tr>
					<td><xsl:if test="$LabelQuadrant='left'">
						<xsl:choose>
							<xsl:when test="$Label='Label1'">
								<font size="{Attribute/Label1/@size}" color="{Attribute/Label1/@color}" font="{Attribute/Label1/@font}"><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label1"/><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font>
							</xsl:when>
							<xsl:when test="$Label='Label2'">
								<font size="{Attribute/Label2/@size}" color="{Attribute/Label2/@color}" font="{Attribute/Label2/@font}"><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label2"/><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="Attribute/Label">
									<xsl:with-param name="attrId" select="$attrId" />
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath" />
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if></td>
					<xsl:call-template name="DateFormatInputs">
						<xsl:with-param name="attrId" select="$attrId"/>
						<xsl:with-param name="Format" select="$Format"/>
						<xsl:with-param name="RangeType" select="$RangeType"/>
						<xsl:with-param name="InputType" select="$InputType"/>
					</xsl:call-template>
					<td><xsl:if test="$LabelQuadrant='right'">
						<xsl:choose>
							<xsl:when test="$Label='Label1'">
								<font size="{Attribute/Label1/@size}" color="{Attribute/Label1/@color}" font="{Attribute/Label1/@font}"><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label1"/><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font>
							</xsl:when>
							<xsl:when test="$Label='Label2'">
								<font size="{Attribute/Label1/@size}" color="{Attribute/Label1/@color}" font="{Attribute/Label1/@font}"><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label2"/><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font>							
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="Attribute/Label">
									<xsl:with-param name="attrId" select="$attrId" />
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath" />
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if></td>
				</tr>
				<!-- Last, if labels are at the bottom -->
				<xsl:if test="Attribute/Year/@quadrant='bottom' or Attribute/Month/@quadrant='bottom' or Attribute/Day/@quadrant='bottom'">
					<tr>
						<td></td>
						<xsl:call-template name="DateFormatLabels">
							<xsl:with-param name="attrId" select="$attrId"/>
							<xsl:with-param name="Format" select="$Format"/>
							<xsl:with-param name="Quadrant"><![CDATA[bottom]]></xsl:with-param>
						</xsl:call-template>
						<td></td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!-- Single Type-In has @format=c -->
				<tr>
					<td><xsl:if test="$LabelQuadrant='left'">
						<xsl:choose>
							<xsl:when test="$Label='Label1'">
								<font size="{Attribute/Label1/@size}" color="{Attribute/Label1/@color}" font="{Attribute/Label1/@font}"><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label1"/><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font>
							</xsl:when>
							<xsl:when test="$Label='Label2'">
								<font size="{Attribute/Label2/@size}" color="{Attribute/Label2/@color}" font="{Attribute/Label2/@font}"><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label2"/><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font>							
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="Attribute/Label">
									<xsl:with-param name="attrId" select="$attrId" />
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath" />
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if></td>
					<xsl:call-template name="DateFormatInputs">
						<xsl:with-param name="attrId" select="$attrId"/>
						<xsl:with-param name="Format"><![CDATA[single]]></xsl:with-param>
						<xsl:with-param name="RangeType" select="$RangeType"/>
						<xsl:with-param name="InputType" select="$InputType"/>
					</xsl:call-template>
					<td><xsl:if test="$LabelQuadrant='right'">
						<xsl:choose>
							<xsl:when test="$Label='Label1'">
								<font size="{Attribute/Label1/@size}" color="{Attribute/Label1/@color}" font="{Attribute/Label1/@font}"><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label1"/><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font>
							</xsl:when>
							<xsl:when test="$Label='Label2'">
								<font size="{Attribute/Label2/@size}" color="{Attribute/Label2/@color}" font="{Attribute/Label2/@font}"><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label2"/><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font>							
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="Attribute/Label">
									<xsl:with-param name="attrId" select="$attrId" />
									<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath" />
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if></td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
		@name WidgetDateRange
		
		Formats date ranges.
		Element Level : Widget
		
		Param "type" : { "single", "double", "span", "none" }
		  "single" implies that two ends of the date range come from the same attribute
		  all other values assume that there is an attribute for each end of a date range,
		  and that the display of that range is specified in the PI.
	-->
	<xsl:template name="WidgetDateRange">
		<xsl:param name="type"><![CDATA[double]]></xsl:param>
		<xsl:param name="CurrentAttributeXPath"/>		
		<xsl:variable name="attrId" select="Attribute/@id"/>
		<xsl:variable name="Format">
			<xsl:choose>
				<!-- default to 'm_y' when it is a dropdown without a format string -->
				<!-- this maintains compatibility with PF's 4, 11, 12, 13 in production, which to not have a format string -->
				<xsl:when test="Attribute/Input/@format"><!--remove this "when" when phase b is stable-->
					<xsl:value-of select="Attribute/Input/@format"/>
				</xsl:when>
				<xsl:when test="$CurrentAttributeXPath[@id=$attrId]/@dateFormat">
					<xsl:value-of select="$CurrentAttributeXPath[@id=$attrId]/@dateFormat"/>
				</xsl:when>
				<xsl:when test="Attribute/Input/@type='dropdown'">
					<xsl:text>m_y</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Columns">
			<!-- there is always a default Format string, there are always underscores in it (ceiling(string-length($Format) div 2), and each field has cols for labels on left and right ( * 3), and the attribute label can go on the left or right ( + 2 )-->
			<xsl:value-of select="(ceiling(string-length($Format) div 2) * 3) + 2"/>
		</xsl:variable>
		<xsl:variable name="LabelQuadrant">
			<xsl:choose>
				<xsl:when test="Attribute/Label/@quadrant"><xsl:value-of select="Attribute/Label/@quadrant" /></xsl:when>
				<xsl:when test="Attribute/@quadrant"><xsl:value-of select="Attribute/@quadrant" /></xsl:when>
				<xsl:otherwise><xsl:text>top</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Outer label .... -->
		<xsl:choose>
			<xsl:when test="$type='single'">
				<!-- 'single' means get low and high date values from a single attribute.  so, do things twice here -->
				<xsl:variable name="Label1Quadrant">
					<xsl:choose>
						<xsl:when test="Attribute/Label1/@quadrant"><xsl:value-of select="Attribute/Label1/@quadrant" /></xsl:when>
						<xsl:when test="Attribute/@quadrant"><xsl:value-of select="Attribute/@quadrant" /></xsl:when>
						<xsl:otherwise><xsl:text>top</xsl:text></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="Label2Quadrant">
					<xsl:choose>
						<xsl:when test="Attribute/Label2/@quadrant"><xsl:value-of select="Attribute/Label2/@quadrant" /></xsl:when>
						<xsl:when test="Attribute/@quadrant"><xsl:value-of select="Attribute/@quadrant" /></xsl:when>
						<xsl:otherwise><xsl:text>top</xsl:text></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Low Value -->
				<xsl:if test="$Label1Quadrant='top'">
					<tr><td colspan="{$Columns}" valign="top"><font color="{Attribute/Label1/@color}" size="{Attribute/Label1/@size}" face="{Attribute/Label1/@face}"><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label1"/><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font></td></tr>
				</xsl:if>
				<xsl:call-template name="WidgetDate">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="Format" select="$Format"/>
					<xsl:with-param name="Columns" select="$Columns"/>
					<xsl:with-param name="RangeType"><![CDATA[L]]></xsl:with-param>
					<xsl:with-param name="InputType" select="Attribute/Input/@type"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
					<xsl:with-param name="Label"><![CDATA[Label1]]></xsl:with-param>
					<xsl:with-param name="LabelQuadrant" select="$Label1Quadrant"/>
				</xsl:call-template>
				<xsl:if test="$Label1Quadrant='bottom'">
					<tr><td colspan="{$Columns}" valign="top"><font color="{Attribute/Label1/@color}" size="{Attribute/Label1/@size}" face="{Attribute/Label1/@face}"><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label1"/><xsl:if test="Attribute/Label1/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font></td></tr>
				</xsl:if>
				<!-- High Value -->
				<xsl:if test="$Label2Quadrant='top'">
					<tr><td colspan="{$Columns}" valign="top"><font color="{Attribute/Label2/@color}" size="{Attribute/Label2/@size}" face="{Attribute/Label2/@face}"><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label2"/><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font></td></tr>
				</xsl:if>
				<xsl:call-template name="WidgetDate">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="Format" select="$Format"/>
					<xsl:with-param name="Columns" select="$Columns"/>
					<xsl:with-param name="RangeType"><![CDATA[H]]></xsl:with-param>
					<xsl:with-param name="InputType" select="Attribute/Input/@type"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
					<xsl:with-param name="Label"><![CDATA[Label2]]></xsl:with-param>
					<xsl:with-param name="LabelQuadrant" select="$Label2Quadrant"/>
				</xsl:call-template>
				<xsl:if test="$Label2Quadrant='bottom'">
					<tr><td colspan="{$Columns}" valign="top"><font color="{Attribute/Label2/@color}" size="{Attribute/Label2/@size}" face="{Attribute/Label2/@face}"><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="Attribute/Label2"/><xsl:if test="Attribute/Label2/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b/&gt;'"/></xsl:if></font></td></tr>
				</xsl:if>
			</xsl:when>

			<xsl:otherwise>
				<!-- all other types get low and high date values from two attributes, which are two rows in the PI, so do things once -->
				<xsl:if test="$LabelQuadrant='top'">
					<tr><td colspan="{$Columns}" valign="top"><xsl:apply-templates select="Attribute/Label">
						<xsl:with-param name="attrId" select="$attrId"/>
						<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath" />
					</xsl:apply-templates></td></tr>
				</xsl:if>
				<xsl:call-template name="WidgetDate">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="Format" select="$Format"/>
					<xsl:with-param name="Columns" select="$Columns"/>
					<xsl:with-param name="InputType" select="Attribute/Input/@type"/>
					<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath"/>
					<xsl:with-param name="LabelQuadrant" select="$LabelQuadrant"/>
				</xsl:call-template>
				<xsl:if test="$LabelQuadrant='bottom'">
					<tr><td colspan="{$Columns}" valign="top"><xsl:apply-templates select="Attribute/Label">
						<xsl:with-param name="attrId" select="$attrId"/>
						<xsl:with-param name="CurrentAttributeXPath" select="$CurrentAttributeXPath" />
					</xsl:apply-templates></td></tr>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
		@name DateFormatInputs
		
		Recursively parses through a format string and creates inputs.
		Element Level : Widget
	-->
	<xsl:template name="DateFormatInputs">
		<xsl:param name="attrId"/>
		<xsl:param name="Format"/>
		<xsl:param name="RangeType"/>
		<xsl:param name="InputType"/>
		<xsl:choose>
			<xsl:when test="$Format='single'">
				<td>
					<xsl:choose>
						<xsl:when test="$RangeType!=''">
							<input type="text" size="10" maxlength="10" name="{$attrData[@id=$attrId]/InputFields/Input[@rangeType=$RangeType]/@name}">
								<xsl:attribute name="value"><xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@rangeType=$RangeType]/Value/Name"/></xsl:attribute>
							</input>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" size="10" maxlength="10" name="{$attrData[@id=$attrId]/InputFields/Input/@name}">
								<xsl:attribute name="value"><xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input/Value/Name"/></xsl:attribute>
							</input>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:when>
			<xsl:when test="string-length($Format) &gt; 0">
				<xsl:variable name="Char" select="translate(substring($Format,1,1),'ymd','YMD')"/>
					<!--<xsl:choose>
						<xsl:when test="$attrData[@id=$attrId]/@dateFormat">
							<xsl:value-of select="substring($Format,1,1)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="translate(substring($Format,1,1),'ymd','YMD')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="upperChar" select="translate(substring($Format,1,1),'ymd','YMD')"/>-->
				<xsl:if test="$Char='Y' or $Char='M' or $Char='D'"><!--DT: remove "D" when phase B is stable -->
					<td><xsl:choose>
						<xsl:when test="$Char='Y' and Attribute/Year/@quadrant='left'"><font color="{Attribute/Year/@color}" size="{Attribute/Year/@size}" face="{Attribute/Year/@face}"><xsl:value-of select="Attribute/Year"/></font></xsl:when>
						<xsl:when test="$Char='M' and Attribute/Month/@quadrant='left'"><font color="{Attribute/Month/@color}" size="{Attribute/Month/@size}" face="{Attribute/Month/@face}"><xsl:value-of select="Attribute/Month"/></font></xsl:when>
						<xsl:when test="$Char='D' and Attribute/Day/@quadrant='left'"><font color="{Attribute/Day/@color}" size="{Attribute/Day/@size}" face="{Attribute/Day/@face}"><xsl:value-of select="Attribute/Day"/></font></xsl:when>
					</xsl:choose>
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="$InputType='textfield'">
								<!-- text input -->
								<xsl:choose>
									<xsl:when test="$RangeType!=''">
										<input type="text" name="{$attrData[@id=$attrId]/InputFields/Input[@dataType=$Char and @rangeType=$RangeType]/@name}">
											<xsl:attribute name="value"><xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@dataType=$Char and @rangeType=$RangeType]/Value/Name"/></xsl:attribute>
											<xsl:attribute name="size">
												<xsl:choose>
													<xsl:when test="$Char='Y'"><xsl:value-of select="4" /></xsl:when>
													<xsl:otherwise><xsl:value-of select="2" /></xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
										</input>
									</xsl:when>
									<xsl:otherwise>
										<input type="text" name="{$attrData[@id=$attrId]/InputFields/Input[@dataType=$Char]/@name}">
											<xsl:attribute name="value"><xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@dataType=$Char]/Value/Name"/></xsl:attribute>
											<xsl:attribute name="size">
												<xsl:choose>
													<xsl:when test="$Char='Y'"><xsl:value-of select="4" /></xsl:when>
													<xsl:otherwise><xsl:value-of select="2" /></xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
										</input>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<!-- dropdown -->
								<xsl:variable name="select_name">
									<xsl:choose>
										<xsl:when test="$RangeType!=''">
											<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@dataType=$Char and @rangeType=$RangeType]/@name"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@dataType=$Char]/@name"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<select>
									<xsl:attribute name="name"><xsl:value-of select="$select_name"/></xsl:attribute>
									<xsl:choose>
										<xsl:when test="$Char='Y'">
											<xsl:choose>
												<xsl:when test="Attribute/Input/@format"><!--dt:removed this template when phase b is stable-->
													<xsl:call-template name="date_options_old">
														<xsl:with-param name="attr_id" select="$attrId"/>
														<xsl:with-param name="date_part" select=" 'Year' "/>
														<xsl:with-param name="range_type" select="$RangeType"/>
														<xsl:with-param name="pi_node_set">
															<xsl:for-each select="Attribute/Years"><xsl:value-of select="."/><xsl:text>;</xsl:text></xsl:for-each>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="date_options">
														<xsl:with-param name="attr_id" select="$attrId"/>
														<xsl:with-param name="date_part" select=" 'Year' "/>
														<xsl:with-param name="range_type" select="$RangeType"/>
														<xsl:with-param name="pi_node_set">
															<xsl:for-each select="$attrData[@id=$attrId]/ValueList/Value"><xsl:value-of select="Name"/><xsl:text>;</xsl:text></xsl:for-each>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:when test="$Char='M'">
											<xsl:choose>
												<xsl:when test="Attribute/Input/@format"><!--dt:removed this template when phase b is stable-->
													<xsl:call-template name="date_options_old">
														<xsl:with-param name="attr_id" select="$attrId"/>
														<xsl:with-param name="date_part" select=" 'Month' "/>
														<xsl:with-param name="range_type" select="$RangeType"/>
														<xsl:with-param name="date_sort" select=" name(Attribute/*[ (string-length(name()) &gt; 5) and contains(name(), 'Month') and not(contains(name(), 'Initial')) ])"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="date_options">
														<xsl:with-param name="attr_id" select="$attrId"/>
														<xsl:with-param name="date_part" select=" 'Month' "/>
														<xsl:with-param name="range_type" select="$RangeType"/>
														<xsl:with-param name="format" select="$Format"/>
														<xsl:with-param name="date_sort" select="Attribute/Month/@sort"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:when test="$Char='D'">
											<xsl:choose>
												<xsl:when test="Attribute/Input/@format"><!--dt:removed this template when phase b is stable-->
													<xsl:call-template name="date_options_old">
														<xsl:with-param name="attr_id" select="$attrId"/>
														<xsl:with-param name="date_part" select=" 'Day' "/>
														<xsl:with-param name="range_type" select="$RangeType"/>
														<xsl:with-param name="date_sort" select=" name(Attribute/*[ (string-length(name()) &gt; 3) and contains(name(), 'Day') and not(contains(name(), 'Initial')) ])"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="date_options">
														<xsl:with-param name="attr_id" select="$attrId"/>
														<xsl:with-param name="date_part" select=" 'Day' "/>
														<xsl:with-param name="range_type" select="$RangeType"/>
														<xsl:with-param name="format" select="$Format"/>
														<xsl:with-param name="date_sort" select="Attribute/Day/@sort"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
								</select>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td><xsl:choose>
						<xsl:when test="$Char='Y' and Attribute/Year/@quadrant='right'"><font color="{Attribute/Year/@color}" size="{Attribute/Year/@size}" face="{Attribute/Year/@face}"><xsl:value-of select="Attribute/Year"/></font></xsl:when>
						<xsl:when test="$Char='M' and Attribute/Month/@quadrant='right'"><font color="{Attribute/Month/@color}" size="{Attribute/Month/@size}" face="{Attribute/Month/@face}"><xsl:value-of select="Attribute/Month"/></font></xsl:when>
						<xsl:when test="$Char='D' and Attribute/Day/@quadrant='right'"><font color="{Attribute/Day/@color}" size="{Attribute/Day/@size}" face="{Attribute/Day/@face}"><xsl:value-of select="Attribute/Day"/></font></xsl:when>
					</xsl:choose>
					</td>
				</xsl:if>
				<xsl:call-template name="DateFormatInputs">
					<xsl:with-param name="attrId" select="$attrId"/>
					<xsl:with-param name="Format">
						<xsl:value-of select="substring($Format,2)"/>
					</xsl:with-param>
					<xsl:with-param name="RangeType" select="$RangeType"/>
					<xsl:with-param name="InputType" select="$InputType"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
		DateFormatLabels template
		
		Recursively parses through a format string and creates labels.
		Element Level : Widget
	-->
	<xsl:template name="DateFormatLabels">
		<xsl:param name="Format"/>
		<xsl:param name="attrId"/>
		<xsl:param name="Quadrant"/>
		<xsl:if test="string-length($Format) &gt; 0">
			<xsl:variable name="Char" select="translate(substring($Format,1,1),'ymd','YMD')"/>
			<xsl:choose>
				<xsl:when test="$Char='Y'">
					<td></td>
					<td valign="top"><xsl:if test="($Quadrant='top' and not(Attribute/Year/@quadrant)) or Attribute/Year/@quadrant = $Quadrant"><font color="{Attribute/Year/@color}" size="{Attribute/Year/@size}" face="{Attribute/Year/@face}"><xsl:value-of select="Attribute/Year"/></font></xsl:if></td>
					<td></td>
				</xsl:when>
				<xsl:when test="$Char='M'">
					<td></td>
					<td valign="top"><xsl:if test="($Quadrant='top' and not(Attribute/Month/@quadrant)) or Attribute/Month/@quadrant = $Quadrant"><font color="{Attribute/Month/@color}" size="{Attribute/Month/@size}" face="{Attribute/Month/@face}"><xsl:value-of select="Attribute/Month"/></font></xsl:if></td>
					<td></td>	
				</xsl:when>
				<xsl:when test="$Char='D'">
					<td></td>
					<td valign="top"><xsl:if test="($Quadrant='top' and not(Attribute/Day/@quadrant)) or Attribute/Day/@quadrant = $Quadrant"><font color="{Attribute/Day/@color}" size="{Attribute/Day/@size}" face="{Attribute/Day/@face}"><xsl:value-of select="Attribute/Day"/></font></xsl:if></td>
					<td></td>
				</xsl:when>
			</xsl:choose>
			<xsl:call-template name="DateFormatLabels">
				<xsl:with-param name="Format">
					<xsl:value-of select="substring($Format,2)"/>
				</xsl:with-param>
				<xsl:with-param name="attrId">
					<xsl:value-of select="$attrId"/>
				</xsl:with-param>
				<xsl:with-param name="Quadrant">
					<xsl:value-of select="$Quadrant"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--
		@match "Attribute"
		@mode "numeric_range_single"
-->
	<xsl:template match="Attribute" mode="numeric_range_single">
		<xsl:variable name="attrId" select="@id"/>
		<xsl:variable name="LabelMinQuadrant">
			<xsl:choose>
				<xsl:when test="LabelMin/@quadrant"><xsl:value-of select="LabelMin/@quadrant"/></xsl:when>
				<xsl:when test="@quadrant"><xsl:value-of select="@quadrant" /></xsl:when>
				<xsl:otherwise>top</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="LabelMaxQuadrant">
			<xsl:choose>
				<xsl:when test="LabelMax/@quadrant"><xsl:value-of select="LabelMax/@quadrant"/></xsl:when>
				<xsl:when test="@quadrant"><xsl:value-of select="@quadrant" /></xsl:when>
				<xsl:otherwise>top</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- labels at top -->
		<tr>
			<td></td>
			<td valign="top"><xsl:if test="$LabelMinQuadrant='top'"><font color="{LabelMin/@color}" size="{LabelMin/@size}" face="{LabelMin/@face}"><xsl:if test="LabelMin/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="LabelMin"/><xsl:if test="LabelMin/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;/b&gt;'"/></xsl:if></font></xsl:if></td>
			<td></td>
			<td/>
			<td></td>
			<td valign="top"><xsl:if test="$LabelMaxQuadrant='top'"><font color="{LabelMax/@color}" size="{LabelMax/@size}" face="{LabelMax/@face}"><xsl:if test="LabelMax/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="LabelMax"/><xsl:if test="LabelMax/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;/b&gt;'"/></xsl:if></font></xsl:if></td>
			<td></td>
			<td/>
		</tr>
		<tr>
			<td><xsl:if test="$LabelMinQuadrant='left'"><font color="{LabelMin/@color}" size="{LabelMin/@size}" face="{LabelMin/@face}"><xsl:if test="LabelMin/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="LabelMin"/><xsl:if test="LabelMin/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;/b&gt;'"/></xsl:if></font></xsl:if></td>
			<td align="left">
				<xsl:choose>
					<xsl:when test="Input/@type='dropdown' or Input/@type='single'">
						<select>
							<xsl:attribute name="class">a<xsl:value-of select="$attrId"/></xsl:attribute>
							<xsl:attribute name="size"><xsl:choose><xsl:when test="Input/@type='single'"><xsl:value-of select="Input/@size"/></xsl:when><xsl:otherwise><xsl:value-of select="1"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="name"><xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@rangeType='L']/@name"/></xsl:attribute>
							<xsl:choose>
								<xsl:when test="$attrData[@id=$attrId]/@parentAttrId"><!-- Check for VA -->
								<xsl:variable name="parentAttrId" select="$attrData[@id=$attrId]/@parentAttrId"/>
									<xsl:for-each select="$attrData[@id=$parentAttrId]/Dependency[@childAttrId=$attrId]/Value">
									<option value="{@id}">
										<xsl:if test="$attrData[@id=$attrId]/InputFields/Input[@rangeType='L']/Value/@id = @id">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="DisplayName!=''">
												<xsl:value-of select="DisplayName"  />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="Name"  />
											</xsl:otherwise>
										</xsl:choose>
									</option>
								</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
								<xsl:for-each select="$attrData[@id=$attrId]/ValueList/Value">
									<option value="{@id}">
										<xsl:if test="../../InputFields/Input[@rangeType='L']/Value/@id = @id">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="DisplayName!=''">
												<xsl:value-of select="DisplayName"  />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="Name"  />
											</xsl:otherwise>
										</xsl:choose>
									</option>
								</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</select>
					</xsl:when>
					<xsl:otherwise>
						<input type="text" size="5" name="{$attrData[@id=$attrId]/InputFields/Input[@rangeType='L']/@name}">
							<xsl:attribute name="class">a<xsl:value-of select="$attrId"/></xsl:attribute>
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="$attrData[@id=$attrId]/InputFields/Input[@rangeType='L']/Value/DisplayName!=''">
										<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@rangeType='L']/Value/DisplayName" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@rangeType='L']/Value/Name"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td><xsl:if test="$LabelMinQuadrant='right'"><font color="{LabelMin/@color}" size="{LabelMin/@size}" face="{LabelMin/@face}"><xsl:if test="LabelMin/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="LabelMin"/><xsl:if test="LabelMin/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;/b&gt;'"/></xsl:if></font></xsl:if></td>
			<td align="center"><img src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="2" height="1" alt=""/><font face="arial" size="1">to</font><img src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="2" height="1" alt=""/></td>
			<td><xsl:if test="$LabelMaxQuadrant='left'"><font color="{LabelMax/@color}" size="{LabelMax/@size}" face="{LabelMax/@face}"><xsl:if test="LabelMax/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="LabelMax"/><xsl:if test="LabelMax/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;/b&gt;'"/></xsl:if></font></xsl:if></td>
			<td align="left">
				<xsl:choose>
					<xsl:when test="Input/@type='dropdown' or Input/@type='single'">
						<select>
							<xsl:attribute name="class">a<xsl:value-of select="$attrId"/></xsl:attribute>
							<xsl:attribute name="size"><xsl:choose><xsl:when test="Input/@type='single'"><xsl:value-of select="Input/@size"/></xsl:when><xsl:otherwise><xsl:value-of select="1"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:attribute name="name"><xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@rangeType='H']/@name"/></xsl:attribute>
							<!-- write the Values, and make sure default values work -->
							<xsl:choose>
							<xsl:when test="$attrData[@id=$attrId]/@parentAttrId"><!-- Check for VA -->
								<xsl:variable name="parentAttrId" select="$attrData[@id=$attrId]/@parentAttrId"/>
									<xsl:for-each select="$attrData[@id=$parentAttrId]/Dependency[@childAttrId=$attrId]/Value">
									<option value="{@id}">
										<xsl:if test="$attrData[@id=$attrId]/InputFields/Input[@rangeType='H']/Value/@id = @id">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="DisplayName!=''">
												<xsl:value-of select="DisplayName"  />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="Name"  />
											</xsl:otherwise>
										</xsl:choose>
									</option>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
							<xsl:for-each select="$attrData[@id=$attrId]/ValueList/Value">
								<option value="{@id}">
									<xsl:if test="../../InputFields/Input[@rangeType='H']/Value/@id = @id">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:choose>
										<xsl:when test="DisplayName!=''">
											<xsl:value-of select="DisplayName"  />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="Name"  />
										</xsl:otherwise>
									</xsl:choose>
								</option>
							</xsl:for-each>
							</xsl:otherwise>
							</xsl:choose>
						</select>
					</xsl:when>
					<xsl:otherwise>
						<input type="text" size="5" name="{$attrData[@id=$attrId]/InputFields/Input[@rangeType='H']/@name}">
							<xsl:attribute name="class">a<xsl:value-of select="$attrId"/></xsl:attribute>
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="$attrData[@id=$attrId]/InputFields/Input[@rangeType='H']/Value/DisplayName!=''">
										<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@rangeType='H']/Value/DisplayName" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input[@rangeType='H']/Value/Name"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td><xsl:if test="$LabelMaxQuadrant='right'"><font color="{LabelMax/@color}" size="{LabelMax/@size}" face="{LabelMac/@face}"><xsl:if test="LabelMax/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="LabelMax"/><xsl:if test="LabelMax/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;/b&gt;'"/></xsl:if></font></xsl:if></td>
			<td width="40%" align="left"/>
		</tr>
		<!-- labels at bottom -->
		<xsl:if test="$LabelMinQuadrant='bottom' or $LabelMaxQuadrant='bottom'">
			<tr>
				<td></td>
				<td valign="top"><xsl:if test="$LabelMinQuadrant='bottom'"><font color="{LabelMin/@color}" size="{LabelMin/@size}" face="{LabelMin/@face}"><xsl:if test="LabelMin/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="LabelMin"/><xsl:if test="LabelMin/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;/b&gt;'"/></xsl:if></font></xsl:if></td>
				<td></td>
				<td/>
				<td></td>
				<td valign="top"><xsl:if test="$LabelMaxQuadrant='bottom'"><font color="{LabelMax/@color}" size="{LabelMax/@size}" face="{LabelMax/@face}"><xsl:if test="LabelMax/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/></xsl:if><xsl:value-of select="LabelMax"/><xsl:if test="LabelMax/@bold='true'"><xsl:value-of disable-output-escaping="yes" select="'&lt;/b&gt;'"/></xsl:if></font></xsl:if></td>
				<td></td>
				<td/>
			</tr>
		</xsl:if>
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/pf_date_ranges.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<!--
		@match "Row"
	-->
	<xsl:template match="Row">
		<!-- The row template generates each row, iterating through the modules -->
		<table border="0" cellpadding="1" cellspacing="0">
			<tr>
				<xsl:if test="not(/ebay/Environment/@commandName='DynamicCategory' or /ebay/SYI.Data)">
					<td>
						<img src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="4" height="1"/>
					</td>
				</xsl:if>
				<xsl:apply-templates select="Widget"/>
			</tr>
			<xsl:if test="/ebay/SYI.Data">
				<tr>
					<td>
						<img src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="1" height="10"/>
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>
	<!--
		@match "Widget"
	-->
	<xsl:template match="Widget">
	<xsl:param name="attrId" select="Attribute/@id"/>
	<xsl:choose>
		<xsl:when test="$attrData[@id=$attrId and not(@hide)]">
		<td valign="top">
			<xsl:choose>
				<xsl:when test="$subPage='APIPF'">
					<!--
					1. find out if this attr is in a type="4" dependency
					2. if yes, create a DIV.  find out current visibility
					-->
					<xsl:variable name="parentId" select="$attrData[@id=$attrId]/@parentAttrId" />
					<xsl:choose>
						<xsl:when test="$parentId and $attrData[@id=$parentId]/Dependency[ @type='4' and @childAttrId=$attrId]">
							<div class="a{$attrId}">
								<xsl:apply-templates select="." mode="create-widget">
									<xsl:with-param name="attrId" select="$attrId" />
								</xsl:apply-templates>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." mode="create-widget">
								<xsl:with-param name="attrId" select="$attrId" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="create-widget">
						<xsl:with-param name="attrId" select="$attrId" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="@type = 'text_message'">
				<xsl:apply-templates select="TextMessage"/>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	<xsl:template match="Widget" mode="create-widget">
	<xsl:param name="attrId" select="Attribute/@id"/>
	<!--<xsl:choose>
		<xsl:when test="$attrData[@id=$attrId and not(@hide)]">
		<td valign="top">-->
			<table border="0" cellpadding="0" cellspacing="0">
				<!--<xsl:attribute name="cellspacing"><xsl:choose><xsl:when test="@type='normal' and (following-sibling::Widget/@type='normal' or preceding-sibling::Widget/@type='normal')">2</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:attribute> -->
				<xsl:choose>
					<xsl:when test="@type = 'normal'">
						<xsl:apply-templates select="Attribute">
							<xsl:with-param name="widgetType" select="@type"/>
							<xsl:with-param name="SelectedAttributeXPath" select="$returnAttr"/>
							<xsl:with-param name="CurrentAttributeXPath" select="$attrData"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="@type = 'combine'">
						<xsl:call-template name="CombineCheckbox">
							<xsl:with-param name="attrId" select="Attribute/@id"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@type = 'date_range_double'">
						<xsl:call-template name="WidgetDateRange">
							<xsl:with-param name="type">double</xsl:with-param>
							<xsl:with-param name="CurrentAttributeXPath" select="$attrData"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@type = 'date_range_single_hide'">
						<xsl:call-template name="WidgetDateRange">
							<xsl:with-param name="type">span</xsl:with-param>
							<xsl:with-param name="CurrentAttributeXPath" select="$attrData"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@type = 'date_range_single'">
						<xsl:call-template name="WidgetDateRange">
							<xsl:with-param name="type">single</xsl:with-param>
							<xsl:with-param name="CurrentAttributeXPath" select="$attrData"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@type = 'date_range_span'">
						<xsl:call-template name="WidgetDateRange">
							<xsl:with-param name="type">span</xsl:with-param>
							<xsl:with-param name="CurrentAttributeXPath" select="$attrData"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@type = 'date_range_none'">
						<xsl:call-template name="WidgetDateRange">
							<xsl:with-param name="type">none</xsl:with-param>
							<xsl:with-param name="CurrentAttributeXPath" select="$attrData"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@type = 'numeric_range_single'">
						<xsl:apply-templates select="Attribute" mode="numeric_range_single"/>
					</xsl:when>
					<xsl:when test="@type = 'text_message'">
						<xsl:apply-templates select="TextMessage"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="Message/@quadrant='top'">
							<tr>
								<td>
									<xsl:value-of select="Message"/>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td valign="top">
								<table>
									<tr>
										<xsl:apply-templates select="Attribute">
											<xsl:with-param name="widgetType" select="@type"/>
											<xsl:with-param name="attrMessage" select="Message"/>
											<xsl:with-param name="SelectedAttributeXPath" select="$returnAttr"/>
											<xsl:with-param name="CurrentAttributeXPath" select="$attrData"/>
										</xsl:apply-templates>
									</tr>
								</table>
							</td>
						</tr>
						<xsl:if test="Message/@quadrant='bottom'">
							<tr>
								<td>
									<xsl:value-of select="Message"/>
								</td>
							</tr>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</table>
			<!--</td>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="@type = 'text_message'">
				<xsl:apply-templates select="TextMessage"/>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>-->
	</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/pf_attr_row.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<xsl:template name="DisplayMessage">
		<xsl:param name="attrMessage"/>
		<xsl:param name="messageStyle"/>
		<xsl:param name="attrMessagePF"/>
		<xsl:param name="attrId"/>
		<font size="{$attrMessagePF/@size}" face="{$attrMessagePF/@face}" color="{$attrMessagePF/@color}">
			<xsl:value-of select="$attrMessagePF" disable-output-escaping="yes"/>
		</font>
	</xsl:template>
	<xsl:template match="TextMessage">
		<tr>
			<td>
				<font face="Arial, Helvetica, sans-serif" size="2">
					<xsl:value-of disable-output-escaping="yes" select="."/>
				</font>
			</td>
		</tr>
		<tr>
			<td>
				<img src="http://pics.ebaystatic.com/aw/pics/spacer.gif" width="1" height="10"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="Value">
		<xsl:param name="pfId"/>
		<xsl:param name="pfPageType"/>
		<xsl:param name="selectedValue"/>
		<xsl:param name="type"/>
		<option value="{@id}">
			<xsl:choose>
				<xsl:when test="$type='multiple' and not($selectedValue) and @isDefault='true'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:when>
				<xsl:otherwise>
				<xsl:if test="@id=$selectedValue and not($pfId and $pfPageType)">
				<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="DisplayName!=''">
					<xsl:value-of select="DisplayName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="Name"/>
				</xsl:otherwise>
			</xsl:choose>
		</option>
	</xsl:template>
	<xsl:template match="Value" mode="dep">
		<xsl:variable name="childAttrId" select="../@childAttrId"/>
		<xsl:variable name="childValueId" select="$attrData[@id=$childAttrId]/InputFields/Input/Value/@id"/>
		<option value="{@id}">
			<xsl:if test="@id=$childValueId">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="DisplayName!=''">
					<xsl:value-of select="DisplayName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="Name"/>
				</xsl:otherwise>
			</xsl:choose>
		</option>
	</xsl:template>
	<xsl:template name="CombineCheckbox">
		<xsl:param name="attrId"/>
			<tr>
				<td valign="top">
					<input name="combinetmp" type="checkbox" value="y" >
						<xsl:if test="$pfKeywords and $pfKeywords!=''">
							<xsl:attribute name="checked">y</xsl:attribute>
						</xsl:if>
					</input>
					<input name="combine" type="hidden">
						<xsl:attribute name="value"><xsl:choose><xsl:when test="not($pfKeywords) or $pfKeywords=''">n</xsl:when><xsl:otherwise>y</xsl:otherwise></xsl:choose></xsl:attribute>
					</input>
					<input type="hidden">
						<xsl:attribute name="name"><xsl:value-of select="$returnAttr[@id=$attrId]/InputFields/Input/@name"/></xsl:attribute>
						<xsl:attribute name="value">
							<xsl:if test="$pfKeywords!=''">
								<xsl:value-of select="$attrData[@id=$attrId]/InputFields/Input/Value/Name"/>
							</xsl:if>
						</xsl:attribute>
					</input>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="not($pfKeywords) or $pfKeywords=''"><font face="arial" size="1">Combine with Basic Search</font></xsl:when>
						<xsl:otherwise><font face="verdana" size="1">only show items containing <b><xsl:value-of disable-output-escaping="yes" select="$pfKeywords"/></b></font></xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
	</xsl:template>
	<xsl:template name="EmptyDropdown">
		<option value="-24">Any</option>
		<option value="">---------------</option>
		<option value="">---------------</option>
		<option value="">---------------</option>
		<option value="">---------------</option>
	</xsl:template>
	<xsl:template name="AttributeError">
		<xsl:param name="InputId"/>
		<xsl:param name="VCSID"/>
		<xsl:param name="Col"/>
		<xsl:param name="ColPad"/>
	</xsl:template><!--Since SYI has it-->

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/pf_attr_templates.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
	<xsl:template name="JS">
		<script language="Javascript">
<xsl:comment><![CDATA[
aus_useragent = navigator.userAgent.toLowerCase();
aus_is_opera = (aus_useragent.indexOf("opera") != -1);
aus_is_net60 = (aus_useragent.indexOf("netscape6/6.0") != -1);

function vvc_anyParent(parent_name, parent_value) {
 var child_name = aus_parent_child2[parent_name];
 var len=child_name.length;
 if (child_name == null) return;
	for (var k=0; k<len; k++){
		this_child_name=child_name[k];
	 	var data = aus_dependent_choices[this_child_name];
 		if (data == null) return;
 		aus_load_child(parent_name, this_child_name, 1);
 		if (len==1) {cascade(this_child_name, 1);} //this is for cascading VVC, note that parent to multi childs will not work with cascading VVC.
 	}
}

function aus_set_parent(parent_name, is_sell) {
 var child_name = aus_parent_child2[parent_name];
 var len=child_name.length;
 if (child_name == null) return;
	for (var k=0; k<len; k++){
		this_child_name=child_name[k];
	 	var data = aus_dependent_choices[this_child_name];
 		if (data == null) return;
 		aus_load_child(parent_name, this_child_name, is_sell);
 		if (len==1) {cascade(this_child_name, is_sell);} //this is for cascading VVC, note that parent to multi childs will not work with cascading VVC.
 	}
}

function cascade(parent_name, is_sell) {
 var child_name = aus_parent_child2[parent_name];
 if (child_name == null) return;
   var data = aus_dependent_choices[child_name];
   if (data == null) return;
   aus_load_child(parent_name, child_name, is_sell);
   cascade(child_name, is_sell); //for n-tier cascades
}

function hasValue(select, value) {
	// DM - ONLY FOR SELECT OBJECTS
	if (!select.options) return false;
	for (var i=0; i< select.options.length; i++) {
		if (select.options[i].value == value) return true;
	}
	return false;
}

function aus_load_child(parent_name, child_name, is_sell) {                         
    // first, check to see if parent_value is '' (meaning - or Any)
    var parent_values = get_object_values(parent_name);
    if  ((parent_values == null) || (parent_values[0] == "Other")) {
        aus_disable_children(parent_name);
        return;
    }
    var child_select = aus_get_form_object_from_name(child_name);
    if (!child_select) return;
    
    var inf_array = aus_influencers[child_name];
    if (!inf_array) return;
    
    var child_option_data = aus_dependent_choices[child_name];
    if (child_option_data == null) return;
      
    var influencer_values = aus_get_influencer_value_string(child_name);
    //if (influencer_values == null) return;
    
    var ptr = child_option_data["a" + influencer_values];
	if (!ptr) {
		var disabled_children = aus_disable_children_conditionally(child_name);
		if (disabled_children) return;
	}
    if (ptr == null) return;  // this is different from ptr.length == 0
    
    if (ptr.length == 0) { // no options for this child
        var disabled_children = aus_disable_children_conditionally(child_name);
        if (disabled_children) return;
    }       
    // reset options     
    var child_options = child_select.options;
    child_options.length = 0; // clear previous options
        
    var other_option = null;
    if (! is_sell) {child_options.length = ptr.length + 1;} // new length = num options +1 ('-' or 'Any')
    else {
        var allow_other = aus_allow_other[child_name];
        if (allow_other) {
            other_option = new Option("Other", "OTHER");
            child_options.length = ptr.length + 2;
        }
    }
    child_select.disabled = false;
    child_select.className = "fieldenabled";    
    var j = 0; // start adding Options at 0
    for (var i in ptr) {
        var option_name = ptr[i][0];
        if (is_sell) {
            var option_id = ptr[i][1];
            child_select.options[j] = new Option(option_name, option_id);
        } else {
            child_select.options[j] = new Option(option_name, option_name);
        }
        j++;
    }
    child_select.className=child_select.name; //change class name to use css    
    if (other_option) child_select.options[j] = other_option;    
    child_select.options[0].selected=true;
    aus_disable_children(child_name);
}

function aus_get_form_object_from_name(object_name) {
	var aus_form = document.product_finder;
	var object = aus_form[object_name];
	return object;
}

function aus_get_object_value(select_name) {
	var form_object = aus_get_form_object_from_name(select_name);
	if (! form_object) return null;
	var select_options = form_object.options;
	if (! select_options) {
		if (form_object.value != null) return form_object.value; // may be a hidden field
		else return null;
	}
	var selected_index = form_object.selectedIndex;
	if ( (selected_index==null) || (selected_index < 0)) return null;
	
	var selected_option = form_object.options[selected_index];
	if (! selected_option) return null;
	
	var select_value = selected_option.value;
	return select_value;
}

// DM - UPDATED FOR VVMC, RADIO BUTTONS AND CHECKBOXES
// DM - RETURNS AN ARRAY OF THE SELECTED VALUES FOR A NAMED FORM OBJECT
function get_object_values(select_name) {
	var selected_values;
	var form_object = aus_get_form_object_from_name(select_name);
	if (!form_object) return null;

	// check for hidden fields and unknown conditions
	if (!form_object.options && !form_object.length) {
		if( form_object.type == "checkbox" ) {
			if( form_object.checked ) return new Array( form_object.value );
			else return null;
		} else if (form_object.value != null) return new Array( form_object.value );// may be a hidden field
		else return null;
	}

	// get number of selected values
	var num_selected_values = 0;
	var len = (form_object.options) ? form_object.options.length : form_object.length;
	for( var i=0; i < len; i++ ) {
		if ( form_object.options ) {
			if( form_object.options[i].selected ) num_selected_values++;
		} else {
			if( form_object[i].checked ) num_selected_values++;
		}
	}

	// load the array of selected values or return null
	if ( num_selected_values == 0 ) return null;
	else {
		selected_values = new Array( num_selected_values );
		var tmpindex = 0;
		for( var i=0; i < len; i++ ) {
			if ( form_object.options ) {
				if ( form_object.options[i].selected ) selected_values[tmpindex++] = form_object.options[i].value;
			} else {
				if ( form_object[i].checked ) selected_values[tmpindex++] = form_object[i].value;
			}
		}
	}
	return selected_values;
}

function aus_disable_children(parent_name) {
	// DM - UPDATED FOR VVMC, RADIO BUTTONS AND CHECKBOXES
    	var child_name = aus_parent_child[parent_name];
    	if(child_name==null){return;}
     var len = child_name.length;
    	var infinite_break = 100;
    	var i = 0;
    	for(var k=0; k<len; k++){
     //while (child_name) {
         var parent_values = get_object_values(parent_name);
         if (parent_values) {
          for (var j=0; j<parent_values.length; j++) {
          if ((parent_values[j] != "") && (parent_values[j] != null) && (parent_values[j].indexOf("-")<0 )) return;
          }
         }
         aus_disable_child(child_name[k]); // disable the immediate child...
         parent_name = child_name[k];      // ..and repeat disabling from here
//         child_name[k] = aus_parent_child[parent_name];
         i++;
         if (i > infinite_break) break;
     //}
    }    
    	return;
}
 
function aus_disable_children_conditionally(child_name) {
	//var child_name = aus_parent_child[parent_name];
	var infinite_break = 100;
	var i = 0;
	var disabled_children = 0;
	while (child_name) {
		if (disabled_children || aus_disabled_if_empty[child_name] || !aus_allow_other[child_name]) {
			aus_disable_child(child_name);
			disabled_children = 1;
		}
		//parent_name = child_name;      // ..and repeat disabling from here
		//child_name = aus_parent_child[parent_name];
		i++;
		if (i > infinite_break) break;
	}
	return disabled_children;
}

function aus_disable_child(child_name) {
	var child_select = aus_get_form_object_from_name(child_name);
	if (! child_select) return;
	var disabled_label = aus_disabled_labels[child_name];

	// This is causing some visual problems with dropdowns in Moz.  Don't do it there.
	if ( child_select.size > 1 ||  (!document.getElementById || document.all) ) child_select.options.length = 1;
	child_select.options[0] = new Option(disabled_label, "");
	child_select.options[0].selected=true;
	
	if (!aus_is_net60) {
		child_select.disabled = true;
		child_select.className = "fielddisabled";
	}
	return;
}

function aus_get_influencer_value_string(child_name) {
    	// DM - UPDATED FOR VVMC, RADIO BUTTONS AND CHECKBOXES
    	// THIS RETURNS THE SELECTED VALUES FOR A PARENT AS A STRING
    	// WE SHOULD NOT NEED THIS FUNCTION ANY MORE
    	var inf_array = aus_influencers[child_name];
   	if (! inf_array)  return null;
    	var influencer_values;
    	if (inf_array.length) {
        	for (var i=0; i<inf_array.length; i++) {
            	var values = get_object_values(inf_array[i]);
            	if (values) for (var i=0; i<values.length; i++ ) influencer_values = aus_add_influencer_value(influencer_values, values[i]);
        	}
    	} else {
        	return null;
    	}
    	return influencer_values;
}

function aus_add_influencer_value(value_string, influencer_value) {
	if (influencer_value) {
		if (value_string) value_string = value_string + "," + influencer_value;
		else {value_string = influencer_value;}
	}
	return value_string;
}

function aus_init_cascades(parent_name, is_sell) {
	// UPDATED FOR VVMC, RADIO BUTTONS AND CHECKBOXES
	if (aus_is_opera) 	return;
	
	//var parent_select = aus_get_form_object_from_name(parent_name);
	//if (parent_select == null) return;
	
	//var parent_value = aus_get_object_value(parent_name);
	var values = get_object_values(parent_name);
	if (!values) {
		aus_disable_children(parent_name);
		return;
	}
    	for (var i=0; i< values.length; i++) {
    		if  ((values[i] == null) || (values[i] == "") || (values[i].indexOf("-")>-1)) {
        		aus_disable_children(parent_name);
    		} else {
        		var child_name = aus_parent_child[parent_name];
        		if (child_name) {
            		var child_select = aus_get_form_object_from_name(child_name);
            		if (child_select == null) return;
               	var child_selected_index = child_select.selectedIndex;
                	aus_load_child(parent_name, child_name, is_sell);
            		aus_init_cascades(child_name, is_sell);     // recurse 
        		}
        	}
    	}
}

function reset_select( form_element ) {
	for(var i=0; i < form_element.options.length; i++ ) {
		var opt = form_element.options[i];
		if( opt.defaultSelected ) {
			form_element.selectedIndex = i;
		}
	}
}
function reset_pf () {
	var the_form = document.product_finder;
	for(var i=0; i < the_form.elements.length; i++ ) {
		var thetype = the_form.elements[i].type;
		if ( thetype.indexOf("select") >= 0 ){
			reset_select( the_form.elements[i] );
		} 
	}
}


]]>
//</xsl:comment>
</script>
</xsl:template>

<!-- DEBUG INFO: End build include: ..\XSL\en-US\Global\shared/pf_attr_js.xsl -->
	<!-- DEBUG INFO: Start build include:  -->
<!-- These two JS array templates will be combined to one when dependency logic is the same-->
	<!-- 
		<template name="JS_Arrays">
			The template generates JavaScript  variables that are needed to handle dependencies between attributes.
		</template>
	-->
	<xsl:template name="JS_Arrays">
var attr_formname = '<xsl:value-of select="$formName"/>';

var attr_dependencies = {
	<xsl:for-each select="$attrList/Attribute[ Dependency or @parentAttrId!='' ]">
		<xsl:apply-templates select="." mode="js-write-dependency">
			<xsl:with-param name="prefix">attr<xsl:value-of select="../../../@id"/>_</xsl:with-param>
		</xsl:apply-templates><xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>
}
	</xsl:template>
	
	<xsl:template name="JS_Arrays_pf">
	<STYLE TYPE="text/css">
<![CDATA[.fielddisabled { BACKGROUND-COLOR: lightgrey; width:}
.fieldenabled { BACKGROUND-COLOR: white }]]>
	</STYLE>
	<script LANGUAGE="JavaScript1.1">
var attr_formname = '<xsl:value-of select="$formName"/>';

var attr_dependencies = {
	<xsl:for-each select="$attrList/Attribute[ Dependency or @parentAttrId!='' ]">
		<xsl:apply-templates select="." mode="js-write-dependency">
			<xsl:with-param name="prefix">a</xsl:with-param>
			<xsl:with-param name="pf" select="'true'"></xsl:with-param>
		</xsl:apply-templates><xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>
}
	</script>
	</xsl:template>
	

	<xsl:template match="Attribute" mode="js-write-dependency">
		<xsl:param name="prefix" select="'a'"/>
		<xsl:param name="pf" select="'false'"/>

		<xsl:variable name="children">
			<xsl:apply-templates select="." mode="js-get-children"/>
		</xsl:variable>

	"<xsl:value-of select="$prefix"/><xsl:value-of select="@id"/>":{
		parents: [ <xsl:if test="@parentAttrId">"<xsl:value-of select="$prefix"/><xsl:value-of select="@parentAttrId"/>"</xsl:if>],
		children: [ <xsl:apply-templates select="." mode="js-list-children"><xsl:with-param name="children" select="$children"/><xsl:with-param name="prefix" select="$prefix"/></xsl:apply-templates> ],
		vvp: [ <xsl:apply-templates select="." mode="js-list-vvp"/> ],
		vvpselected: [ <xsl:apply-templates select="." mode="js-list-vvp-selected"><xsl:with-param name="pf" select="$pf"/></xsl:apply-templates> ],
		disabledlabel: <xsl:apply-templates select="." mode="js-initial-value"/><xsl:if test="Dependency/@type='1'">,
			<xsl:apply-templates select="." mode="js-vvc-children"><xsl:with-param name="children" select="$children"/><xsl:with-param name="prefix" select="$prefix"/></xsl:apply-templates>
		</xsl:if>
	}</xsl:template>
	
	<xsl:template match="Attribute" mode="js-initial-value"><xsl:variable name="this-id" select="@id"/>"<xsl:choose>
			<xsl:when test="$thisPI[@id=$this-id]/InitialValue"><xsl:value-of select="$thisPI[@id=$this-id]/InitialValue"/></xsl:when>
			<xsl:otherwise><xsl:text><![CDATA[            ]]></xsl:text></xsl:otherwise>
		</xsl:choose>"
	</xsl:template>
	
	<xsl:template match="Attribute" mode="js-list-children">
		<xsl:param name="children"/>
		<xsl:param name="prefix"/>
		<xsl:variable name="thisone" select="substring-before($children,';')"/>
		<xsl:variable name="therestofthem" select="substring-after($children,';')"/>
		<xsl:if test="$thisone!=''">"<xsl:value-of select="$prefix"/><xsl:value-of select="$thisone"/>"<xsl:if test="$therestofthem!=''">, </xsl:if></xsl:if>
		<xsl:if test="$therestofthem!=''">
			<xsl:apply-templates select="." mode="js-list-children">
				<xsl:with-param name="children" select="$therestofthem"/>
				<xsl:with-param name="prefix" select="$prefix"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Attribute" mode="js-list-vvp">
		<xsl:for-each select="Dependency[ @type='2' or @type='4']">"<xsl:value-of select="@parentValueId"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
	</xsl:template>

	<xsl:template match="Attribute" mode="js-list-vvp-selected">
		<xsl:param name="pf"/>
		<xsl:variable name="this-id" select="@id"/>
		<xsl:variable name="vvp-deps" select="Dependency[ @type='2' or @type='4' ]" />
		<xsl:variable name="vcs-id" select="../../../@id" />
		<xsl:choose>
			<xsl:when test="$pf='true'">
				<xsl:for-each select="ValueList/Value[ @id=../../InputFields/Input/Value/@id and @id=$vvp-deps/@parentValueId ]">"<xsl:value-of select="@id" />"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$returnAttr[ @id=$this-id and ../@id=$vcs-id ]/Value[ @id=$vvp-deps/@parentValueId ]">"<xsl:value-of select="@id" />"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="Attribute" mode="js-vvc-children">
		<xsl:param name="children"/>
		<xsl:param name="prefix"/>
		<xsl:variable name="parent-node" select="."/>
		<xsl:variable name="thisone" select="substring-before($children,';')"/>
		<xsl:variable name="therestofthem" select="substring-after($children,';')"/>
		"<xsl:value-of select="$prefix"/><xsl:value-of select="$thisone"/>":{
			<xsl:call-template name="js-vvc-children">
				<xsl:with-param name="parent-node" select="$parent-node"/>
				<xsl:with-param name="child-id" select="$thisone"/>
			</xsl:call-template>
			<xsl:call-template name="js-va-children">
				<xsl:with-param name="parent-node" select="$parent-node"/>
				<xsl:with-param name="child-id" select="$thisone"/>
			</xsl:call-template>
		}<xsl:if test="$therestofthem!=''">, </xsl:if>
		<xsl:if test="$therestofthem!=''">
			<xsl:apply-templates select="." mode="js-vvc-children">
				<xsl:with-param name="children" select="$therestofthem"/>
				<xsl:with-param name="prefix" select="$prefix"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template name="js-vvc-children">
		<xsl:param name="parent-node"/>
		<xsl:param name="child-id"/>
		<xsl:for-each select="$parent-node/Dependency[ @type='1' and @childAttrId=$child-id]">
			"v<xsl:value-of select="@parentValueId"/>": [ <xsl:for-each select="Value">["<xsl:value-of select="Name" disable-output-escaping="yes"/>","<xsl:value-of select="@id"/>"]<xsl:if test="position()!=last()">, </xsl:if></xsl:for-each> ]<xsl:if test="position()!=last()">, </xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="js-va-children">
		<xsl:param name="parent-node"/>
		<xsl:param name="child-id"/>
		<xsl:for-each select="$parent-node/Dependency[ @type='4' and @childAttrId=$child-id]">
			"va<xsl:value-of select="@parentValueId"/>":[]<xsl:if test="position()!=last()">, </xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<!-- returns a set of "child" nodes containing the id's of the children.  use this to prevent calling an expensive XPATH multiple times -->
	<xsl:template match="Attribute" mode="js-get-children">
		<xsl:variable name="id" select="@id"/>
		<xsl:for-each select="../Attribute[ @parentAttrId=$id ]"><xsl:value-of select="@id"/>;</xsl:for-each>
	</xsl:template>
	

<!-- DEBUG INFO: End build include: ..\XSL\en-US\NotLocalized\shared/attr_js_arrays.xsl -->

	<!--These are global variables which are called in the attribute shared files. -->

	<xsl:variable name="error" select="/ebay/ErrorSection/Error"/>
	<xsl:variable name="ProductFinderTop" select="/eBay/ProductFinders/ProductFinder"/>
	<xsl:variable name="returnAttr" select="/eBay/ProductFinders/ProductFinder/AttributeList/Attribute"/>
	<xsl:variable name="attrData" select="/eBay/ProductFinders/ProductFinder/AttributeList/Attribute"/>
	<xsl:variable name="attrList" select="/eBay/ProductFinders/ProductFinder/AttributeList"/>
	<xsl:variable name="thisPI" select="/eBay/ProductFinders/ProductFinder/PresentationInstruction/*/*/Attribute"/>
	<xsl:variable name="attrAsterisk">&lt;img src="http://pics.ebaystatic.com/aw/pics/asteriskG_10x10.gif" width="10" height="10"/&gt;</xsl:variable>
	<xsl:variable name="Image.ArrowMaroon"><img src="http://pics.ebaystatic.com/aw/pics/arrowMaroon_9x11.gif" height="11" width="9"/></xsl:variable>
	<xsl:variable name="thisPage" select="'PF'"/>
	<xsl:variable name="subPage" select="'APIPF'"/>
	<xsl:variable name="formName" select="'ProductFinderSearchForm'"/>
	<xsl:variable name="pfKeywords" select="/eBay/ProductFinders/ProductFinder/Keywords"/>
	<xsl:variable name="UsePostedFormFields" select="false()"/>
	<xsl:variable name="FormFields" select="/eBay/PostedFormFields"/>
	
	<!-- These are the hook templates necessary to put a set of similar Product Finders on an API page -->
	
	<xsl:template name="pf-api-interface">
		<xsl:variable name="num-pfs">
			<xsl:choose>
				<xsl:when test="$ProductFinderTop/@count">
					<xsl:value-of select="$ProductFinderTop/@count" />
				</xsl:when>
				<!-- if no count specified, write 1 pf and show submit button.  
				making this 0 to distinguish from the TL case of asking for 1, 
				which should not show the submit button -->
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="pf-api-javascript" >
			<xsl:with-param name="num-pfs" select="$num-pfs" />
		</xsl:call-template>

		<xsl:variable name="dependencies" select="$attrList/*/Dependency" />

		<xsl:if test="$dependencies">
			<xsl:call-template name="JS_Arrays_pf"/>
		</xsl:if>

		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<xsl:call-template name="pf-api-write-product-finders">
					<xsl:with-param name="count" select="'1'"/>
					<xsl:with-param name="maxcount" select="$num-pfs"/>
					<xsl:with-param name="dependencies" select="$dependencies"/>
				</xsl:call-template>
			</tr>
		</table>

		<script LANGUAGE="javascript1.1">
		<xsl:comment>
		// THE FOLLOWING CODE CALLS FUNCTIONS FOR SETTING THE INITIAL VALUES FOR
		// MULTIPLE PFs FOR API

		<xsl:for-each select="/eBay/ProductFinders/ProductFinder/SearchRequests/SearchRequest[QueryAttributes/Attribute/ValueList/Value]">
			<xsl:variable name="PFposition" select="position()"/>
			formNameVals<xsl:value-of select="$PFposition"/> = new Array();
			<xsl:for-each select="QueryAttributes/Attribute/ValueList/Value">
				<xsl:variable name="attrId" select="../../@id"/>
				<xsl:variable name="LiteralValue">
					<xsl:call-template name="pf-escape-quotes">
						<xsl:with-param name="val" select="ValueLiteral"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="formElName" select="../../../../../../AttributeList/Attribute[@id=$attrId]/InputFields/Input[@id=$attrId]/@name"/>
				formNameVals<xsl:value-of select="$PFposition"/>[formNameVals<xsl:value-of select="$PFposition"/>.length] = new Array("<xsl:value-of select="$formElName"/>","<xsl:value-of select="@id"/>","<xsl:value-of select="$LiteralValue"/>");
			</xsl:for-each>
			attr_API_load_init("ProductFinderSearchForm<xsl:value-of select="$PFposition"/>",formNameVals<xsl:value-of select="$PFposition"/>);
		</xsl:for-each>
		//</xsl:comment>
		</script>

		<!-- now write the hidden stuff that grabs all the PF data and creates the right post string -->
		<div id="tmpformdiv" style="visibility:hidden;"></div>
		<!--<form action="PFPage" method="post" name="{$formName}" style="display:inline;margin:0;padding:0;" onsubmit="attr_submit_multi();">
			< ! - - create the hidden inputs - - >
			<xsl:call-template name="pf-api-write-hidden-inputs">
					<xsl:with-param name="count" select="'1'"/>
					<xsl:with-param name="maxcount" select="$num-pfs"/>
			</xsl:call-template>
		</form>-->
			<!-- debug only 
			<form><input type="submit" value="Submit!"/></form>
			end debug only -->
	</xsl:template>

	<xsl:template name="pf-escape-quotes">
		<xsl:param name="val"/>
		<xsl:choose>
			<xsl:when test="contains($val,'&quot;')"><xsl:value-of select="substring-before($val,'&quot;')"/><xsl:value-of select="'&amp;quot;'"/><xsl:call-template name="pf-escape-quotes"><xsl:with-param name="val" select="substring-after($val,'&quot;')"/></xsl:call-template></xsl:when>
			<xsl:otherwise><xsl:value-of select="$val"/>tst</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="pf-api-write-hidden-inputs">
		<xsl:param name="count"/>
		<xsl:param name="maxcount"/>
		<xsl:variable name="nextcount" select="$count + 1"/>

		<xsl:for-each select="$attrList/Attribute/InputFields/Input">
			<input type="hidden" disabled="disabled" name="{@name}_{$count}"/>
		</xsl:for-each>
		<input type="hidden" disabled="disabled" name="pfid_{$count}" />
				
		<xsl:if test="not($nextcount &gt; $maxcount)">
			<xsl:call-template name="pf-api-write-hidden-inputs">
				<xsl:with-param name="count" select="$nextcount"/>
				<xsl:with-param name="maxcount" select="$maxcount"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Field" mode="pf-api-interface">
		<input type="hidden" name="{Name}" value="{Value}" />
	</xsl:template>
	
	<xsl:template name="pf-api-write-product-finders">
		<xsl:param name="count"/>
		<xsl:param name="maxcount"/>
		<xsl:param name="dependencies"/>
		<xsl:variable name="nextcount" select="$count + 1" />
		<xsl:variable name="currentform" select="concat($formName,$count)"/>

		<td valign="top">
			<form method="post" name="{$currentform}" style="display:inline;margin:0;padding:0;">
			<xsl:attribute name="action">
				<xsl:choose>
					<xsl:when test="$maxcount='0'">
						<xsl:value-of select="'PFPage'" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="''" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates select="PresentationInstruction/Row"/>
			<script LANGUAGE="JavaScript1.1">
				<xsl:if test="$dependencies[@type='1' or @type='2']">
//createButtonLoad();
attr_reset_pf( '<xsl:value-of select="$currentform"/>' );
					<xsl:for-each select="AttributeList/Attribute">
						<xsl:variable name="attributeId" select="InputFields/Input/Value/@id"/>
						<xsl:variable name="hasValueList" select="Dependency[@parentValueId=$attributeId]"/>
						<xsl:choose>
							<xsl:when test="Dependency[@type='1' or @type='2'] and not($hasValueList)">
attr_init("<xsl:value-of select="InputFields/Input/@name"/>","<xsl:value-of select="$currentform"/>")
</xsl:when>
							<xsl:otherwise>
								<xsl:if test="Dependency[@type='1' or @type='2'] and not(InputFields/Input/Value/@id)">
attr_init("<xsl:value-of select="InputFields/Input/@name"/>","<xsl:value-of select="$currentform"/>")
</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
				<xsl:for-each select="$thisPI/Input[@type='radio' or @type='checkbox']">
					<xsl:variable name="InputId" select="../@id"/>
					<xsl:if test="$attrData[@id=$InputId]/Dependency[@type='1' or @type='2']">
// attr_init('a<xsl:value-of select="../@id"/>',1);
</xsl:if>
				</xsl:for-each>
			</script>
			<xsl:apply-templates select="HiddenFields/Field" mode="pf-api-interface"/>
			<xsl:if test="not(HiddenFields/Field[ Name='pfid' ])">
				<input type="hidden" name="pfid" value="{@id}" />
			</xsl:if>
			<!--<xsl:if test="not(HiddenFields/Field[ Name='siteid' ])">
				<input type="hidden" name="SiteId" value="{$Environment/@siteId}" />
			</xsl:if>-->
			<xsl:if test="$maxcount='0'">
				<input type="submit">
					<xsl:attribute name="value">Submit</xsl:attribute>
				</input>
			</xsl:if>
			</form>
		</td>

		<xsl:if test="not($nextcount &gt; $maxcount)">
			<xsl:call-template name="pf-api-write-product-finders">
				<xsl:with-param name="count" select="$nextcount"/>
				<xsl:with-param name="maxcount" select="$maxcount"/>
				<xsl:with-param name="dependencies" select="$dependencies"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

<!--
	JAVASCRIPT
-->

	<xsl:template name="pf-api-javascript">
		<xsl:param name="num-pfs" select="'1'" />
		<script LANGUAGE="javascript1.1">
<![CDATA[
// Attributes.js
// - Dependency code for Product Finders and SYI T&D

// Notes
// - document.forms[ formname ] not working in NN4

// ----------------------------------------------------
// *** INITIALIZE ***

attr_useragent = navigator.userAgent.toLowerCase();
attr_webtv = (attr_useragent.indexOf("webtv") != -1);
attr_opera = (attr_useragent.indexOf("opera") != -1);
attr_net60 = (attr_useragent.indexOf("netscape6/6.0") != -1);
attr_net40 = (attr_useragent.indexOf("4.7") != -1);
attr_currentform = null;

attr_mainformname = "]]><xsl:value-of select="$formName" /><![CDATA[";
attr_numpfs = ]]><xsl:value-of select="$num-pfs" /><![CDATA[;

// init dependencies
function attr_init( widgetname, formcontext ) {
	if( formcontext != null ) {
		attr_currentform = formcontext;
	}
	var values = attr_get_values( widgetname );
	if( !values ) {
		attr_disable_children( widgetname );
		return;
	}
	for( var i=0; i < values.length; i++ ) {
		if( values[i]==null || values[i]=="" || values[i].indexOf("-")>-1 ) {
			attr_disable_children( widgetname );
		} else {
			var children = attr_dependencies[widgetname].children;
			for( var j=0; j < children.length; j++ ) {
				attr_set_values( children[j] );
				attr_init( children[j] );
			}
		}
	}
	if( formcontext != null ) {
		attr_currentform = null;
	}
}


// reset dropdowns to initial state for PF
function attr_reset_pf( formcontext ) {
	var theformname = ( formcontext==null ) ? attr_formname : formcontext;
	var theform = document.forms[ theformname ];
	for( var i=0; i < theform.elements.length; i++ ) {
		if( theform.elements[i].type.indexOf("select") >= 0 ) {
			attr_reset_select( theform.elements[i] );
			// CHANGED FOR API: GET DEPENDENCIES RIGHT
			attr_onchange( theform.elements[i].name, formcontext );
			// END CHANGED FOR API
		}
	}
}

// reset a single dropdown
// doesn't work for multiselects
function attr_reset_select( theselect ) {
	for( var i=0; i < theselect.options.length; i++ ) {
		var opt = theselect.options[i];
		if( opt.defaultSelected ) {
			theselect.selectedIndex = i;
		}
	}
}

// needed by SYI stuff
function createButtonLoad() {
	document.write("<input type='hidden' name='ActionAttributeLoad'>");
}

// ----------------------------------------------------
// *** ARRAY UTILS ***

// compares values or arrays
function array_equals( a, b ) {
	if( a.length && b.length ) {
		if( a.length != b.length ) return false;
		for( var i=0; i<a.length; i++ ) {
			if( a[i] != b[i] ) return false;
		}
		return true;
	} else {
		return (a==b);
	}
}

// return array of values in both array1 and array2
function array_intersect( array1, array2 ) {
	if( array1==null || array2==null ) return null;
	// get how many
	var numvalues = 0;
	for( var i=0; i < array1.length; i++ ) {
		for( var j=0; j < array2.length; j++ ) {
			if( array_equals(array1[i],array2[j]) ) {
				numvalues++;
				break;
			}
		}
	}
	// now create the array
	if( numvalues == 0 ) return null;
	var newarray = new Array( numvalues );
	var tmpindex = 0;
	for( var i=0; i < array1.length; i++ ) {
		for( var j=0; j < array2.length; j++ ) {
			if( array_equals(array1[i], array2[j]) ) {
				newarray[ tmpindex++ ] = array1[i];
				break;
			}
		}
	}
	return newarray;
}

// merge values of two arrays without duplicates
function array_merge( array1, array2 ) {
	if( array1==null ) return array2;
	if( array2==null ) return array1;
	// get how many
	var numvalues = array2.length;
	var flag = 0;
	for( var i=0; i < array1.length; i++ ) {
		flag = 0;
		for( var j=0; j < array2.length; j++ ) {
			if( array_equals(array1[i],array2[j]) ) flag++;
		}
		if( flag == 0 ) numvalues++;
	}
	// now create the array
	if( numvalues == 0 ) return null;
	var newarray = new Array( numvalues );
	var flag = 0;
	for( var i=0; i < array1.length; i++ ) {
		newarray[i] = array1[i];
	}
	var tmpindex = array1.length;
	for( var i=0; i < array2.length; i++ ) {
		flag = 0;
		for( var j=0; j < array1.length; j++ ) {
			if( array_equals(array2[i],array1[j]) ) flag++;
		}
		if( flag==0 ) {
			newarray[tmpindex++] = array2[i];
		}
	}
	return newarray;
}

// return array of values that are in array1 but not in array2
function array_minus( array1, array2 ) {
	if( array1==null || array1.length==0 ) return null;
	if( array2==null ) return array1;
	// get how many
	var numvalues = 0;
	var flag = 0;
	for( var i=0; i < array1.length; i++ ) {
		flag = 0;
		for( var j=0; j < array2.length; j++ ) {
			if( array_equals(array1[i], array2[j]) ) flag++;
		}
		if( flag == 0 ) numvalues++;
	}
	// now create the array
	if( numvalues == 0 ) return null;
	var newarray = new Array( numvalues );
	var tmpindex = 0;
	for( var i=0; i < array1.length; i++ ) {
		flag = 0;
		for( var j=0; j < array2.length; j++ ) {
			if( array_equals(array1[i], array2[j]) ) flag++;
		}
		if( flag == 0 ) newarray[ tmpindex++ ] = array1[i];
	}
	return newarray;
}


// ----------------------------------------------------
// *** GETTERS AND SETTERS ***

// returns reference to form object via name
function attr_get_widget( widgetname ) {
	var theformname = (attr_currentform == null) ? attr_formname : attr_currentform;
	return document.forms[ theformname ][ widgetname ];
}

// return array of values for current widget
function attr_get_values( widgetname ) {
	var widget = attr_get_widget( widgetname );
	if(!widget) return null;

	// check for hidden fields, unknown conditions, and SINGLE CHECKBOX
	if( !widget.options && !widget.length ) {
		if( widget.value != null ) {
			if( widget.type == "checkbox" ){
				if( widget.checked ) {
					return new Array( widget.value );
				} else {
					return null;
				}
			} else {
				// may be a hidden field
				return new Array( widget.value );
			}
		} else {
			return null;
		}
	}
	// get number of selected values
	var numvalues = 0;
	var len = (widget.options)? widget.options.length : widget.length;
	for( var i=0; i < len; i++ ) {
		if( widget.options ) {
			if( widget.options[i].selected ) numvalues++;
		} else {
			if( widget[i].checked ) numvalues++;
		}
	}
	// load the array of selected values or return null
	if( numvalues == 0 ){
		return null;
	} else {
		selectedvalues = new Array( numvalues );
		var tmpindex = 0;
		for( var i=0; i < len; i++ ) {
			if( widget.options ) {
				if( widget.options[i].selected ) selectedvalues[tmpindex++] = widget.options[i].value;
			} else {
				if( widget[i].checked ) selectedvalues[tmpindex++] = widget[i].value;
			}
		}
	}
	return selectedvalues;
}

// load widget based on parent values
function attr_set_values( widgetname ) {
	var current = attr_dependencies[ widgetname ];

	// collect all child values from all parent values and merge them (no dups)
	// make it work with multiselect parents.  heh.
	var parents = attr_dependencies[ widgetname ].parents;
	var childvalues = null;
	var tmpparentvalues = null;
	for( var i=0; i<parents.length; i++ ) {
		tmpparentvalues = attr_get_values( parents[i] );
		if( tmpparentvalues != null ) {
			var attr_widget_obj = attr_dependencies[ parents[i] ][ widgetname ];
			if(attr_widget_obj != null){
				for( var j=0; j<tmpparentvalues.length; j++ ) {
				   childvalues = array_merge( childvalues, attr_dependencies[ parents[i] ][ widgetname ][ "v"+tmpparentvalues[j] ]);
				}
			}
		}
	}
	
	// now, populate the child
	if( childvalues!=null ) {
		var widget = attr_get_widget( widgetname );
		widget.disabled = false;
		widget.className = "fieldenabled";
		widget.options.length = 0; // clear previous options

		for( var i=0; i<childvalues.length; i++ ) {
			widget.options[i] = new Option( childvalues[i][0], childvalues[i][1] );
		}
		widget.options[0].selected = true;
	} else {
		attr_disable( widgetname );
		attr_disable_children( widgetname );
	}
}

// recursively disable children
function attr_disable_children( widgetname ) {
	var children = attr_dependencies[widgetname].children;
	// disable all children first, then recurse
	for( var i=0; i < children.length; i++ ) {
		attr_disable( children[i] );
	}
	for( var i=0; i < children.length; i++ ) {
		attr_disable_children( children[i] );
	}
}

// disable one dropdown or select widget
function attr_disable( widgetname ) {

	var widget = attr_get_widget( widgetname );

	if( !widget || !widget.options ) return;

	// Moz has visual problems if we set length to 1.  Don't do it there
	if( widget.size > 1 || (!document.getElementById || document.all)) widget.options.length = 1;
	widget.options[0] = new Option( attr_dependencies[widgetname].disabledlabel, "-10");
	widget.options[0].selected = true;

	if( !attr_net60 ) {
		widget.disabled = true;
		widget.className = "fielddisabled";
	}
	return;
}

// recursively clear children before VVP post
function attr_clear_children( widgetname ) {
	var children = attr_dependencies[widgetname].children;
	// clear all children first, then recurse
	for( var i=0; i < children.length; i++ ) {
		attr_clear( children[i] );
	}
	for( var i=0; i < children.length; i++ ) {
		attr_clear_children( children[i] );
	}
}

// clear one child dropdown or select widget
function attr_clear( widgetname ) {
	widget = attr_get_widget( widgetname );
	if( attr_net40 ) {
		widget.options[ widget.selectedIndex ].value = "-10";
	} else {
		widget.value = "";
	}
}

// ----------------------------------------------------
// *** EVENTS ***

// handles change events for widgets with children
function attr_onchange( widgetname, formcontext ){

	if( attr_webtv ) attr_submit();

	if( formcontext != null ) { 
		attr_currentform = formcontext; 
	}

// CHANGED FOR API
	if( attr_dependencies[ widgetname ] == null ) return;
	attr_api_va( widgetname );

	// check for VVP and post if required
	var current = attr_dependencies[widgetname];
//	if( current.vvp.length > 0  ) {
//		var widgetvvpvalues = array_intersect(attr_get_values( widgetname ), current.vvp );
//		var newvvpvalues = array_minus( widgetvvpvalues, current.vvpselected );
//		var lostvvpvalues = array_minus( current.vvpselected, widgetvvpvalues );
		
//		if( newvvpvalues!=null || lostvvpvalues!=null ) {
//			attr_clear_children( widgetname );
//			attr_submit();
//			return;
//		}
//	}
// END CHANGED FOR API

	// load children via VVC first, then recurse
	var children = attr_dependencies[widgetname].children;
	for( var i=0; i < children.length; i++ ) {
		attr_set_values( children[i] );
	}
	for( var i=0; i < children.length; i++ ) {
		attr_onchange( children[i] );
	}
	// release the form context
	if( formcontext != null ) { 
		attr_currentform = null; 
	}
}

// NEW FOR API
function attr_api_va( widgetname ){

	// first, determine whether VA is visible or invisible
	var vals = attr_get_values( widgetname );
	var children = attr_dependencies[ widgetname ].children;
	var vvp = attr_dependencies[ widgetname ].vvp;
	var vaattr = null;
	// find the va attribute by looking in the vvp list.  (theres no vvp for api)
	if( vvp.length == 0 ) return;
	for( var i=0; i<children.length; i++ ) {
		if( typeof attr_dependencies[ widgetname ][ children[i] ][ "va"+vvp[0] ] != "undefined" ) {
			vaattr = children[i];
		}
	}
	// now get the div
	var thediv = attr_find_div( document.all[ attr_currentform ].all, vaattr);
	// now get the display state
	var displaystate = "hidden";
	for( var i=0; i<vals.length; i++ ) {
		if( typeof attr_dependencies[ widgetname ][ vaattr ][ "va"+vals[i] ] != "undefined" ) {
			displaystate = "show";
			break;
		}
	}
	// now set the div correctly
	if( displaystate == "show" ) {
		thediv.style.display = "";
	} else {
		thediv.style.display = "none";
	}
}

function attr_find_div( nodeset, classstring ){

	for( var i=0; i<nodeset.length; i++ ) {
		if( nodeset[i].className == classstring ) {
			return nodeset[i];
		} 
	}
	return null;
}
// END NEW FOR API

// submits the form
function attr_submit() {
  //alert("attr_submit! ");
	var theform = document.forms[ attr_formname ];
	for( var i=0; i < theform.length; i++ ) {
		if( theform.elements[i].name == "aus_form_changed") theform.elements[i].value = 1;
	}
	theform.ButtonLoad.value = 1;
	theform.submit();
}

function attr_submit_multi() {

	var mainform = document.forms[ attr_mainformname ];
	var subform = null;
	var mainelement = null;
	var subelement = null;
	var index = null;

	var formstring = "";
	var formstring = '<form id="tmppfform" action="PFPage" method="post">';
	
	for( var i=1; i <= attr_numpfs; i++ ) {
		subform = document.forms[ attr_mainformname+i ];
		for( var j=0; j < subform.elements.length; j++ ) {
			subelement = subform.elements[j];
			if( subelement!=null && !subelement.disabled && subelement.value!='' ) {
				if( subelement.type == "checkbox" ) {
					if( subelement.checked ) {
						formstring += '<input type="checkbox" name="'+subelement.name+'_'+i+'" value="'+subelement.value+'" checked="checked"/>';
					}
				} else 	if( subelement.type == "radio" ) {
					if( subelement.checked ) {
						formstring += '<input type="radio" name="'+subelement.name+'_'+i+'" value="'+subelement.value+'"  checked="checked"/>';
					}
				} else {
				formstring += '<input type="hidden" name="'+subelement.name+'_'+i+'" value="'+subelement.value+'" />';
				}
			}
		}
	}
	
	formstring += '</form>';
	
	var thediv = document.all['tmpformdiv'];
	thediv.innerHTML = "";
	thediv.insertAdjacentHTML("AfterBegin", formstring );
	var thenewform = thediv.all.tmppfform;
	thenewform.submit();

}

// THE NEXT TWO FUNCTIONS HAVE BEEN ADDED MY MIKE S.
// THESE FUNCTIONS ARE FOR SETTING THE INITIAL VALUE OF  
// MULTIPLE PFs FOR API

var attr_dependencies;
function attr_API_load_init(formName,arrVals) {
	var thisForm = document.forms[formName];
	for(i=0;i<arrVals.length;i++) {
		if(document.forms[formName].elements[arrVals[i][0]]) {
			attr_API_load_this(thisForm,arrVals[i][0],arrVals[i][1],arrVals[i][2]);
		}
		if(attr_dependencies) {
			if(attr_dependencies[arrVals[i][0]]) {
				attr_onchange(arrVals[i][0],formName);
			}
		}
	}
}

function attr_API_load_this(thisForm,thisEl,thisVal,thisValLit) {
	var curEl = thisForm.elements[thisEl];
	if(thisValLit.substring("&quot;") != -1) {
		thisValLit = thisValLit.replace(/\&quot\;/,'"');
	}
	switch(curEl.type) {
		case "checkbox":
			if(curEl.length) {
				for(var i=0;i<curEl.length;i++) {
					if(curEl[i].value == thisVal) {
						curEl[i].checked = true;
					}
				}
			} else {
				if(curEl.value == thisVal) {
					curEl.checked = true;
				}
			}
		break;
		case "hidden":
			curEl.value = thisValLit;
		break;
		case "radio":
			for(var i=0;i<curEl.length;i++) {
				if(curEl[i].value == thisVal) {
					curEl[i].checked = true;
				}
			}
		break;
		case "select-one":
			for(var i=0;i<curEl.options.length;i++) {
				if(curEl.options[i].value == thisVal) {
					curEl.options[i].selected = true;
				}
			}
		break;
		case "select-multiple":
			for(var i=0;i<curEl.options.length;i++) {
				if(curEl.options[i].value == thisVal) {
					curEl.options[i].selected = true;
				}
			}
		break;
		case "text":
			curEl.value = thisValLit;
		break;
		case "textarea":
			curEl.value = thisValLit;
		break;
	}
}

]]>		
		</script>
	</xsl:template>

<!--
	MAIN API ENTRY TEMPLATES
-->

	<xsl:template match="/eBay">
		<xsl:apply-templates select="ProductFinders/ProductFinder" />
	</xsl:template>

	<xsl:template match="/eBay/ProductFinders/ProductFinder">
		<xsl:call-template name="pf-api-interface">
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
