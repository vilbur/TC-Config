<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp '&#xA0;'>]>
<!--  XSL style sheet for Ultra TC Configuration Editor data files.-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <head>
        <style type="text/css">
          td {
            border-style: solid;
            border-width: 1px;
            vertical-align: top;
            padding: 8px;
            }
          .td_header {font-weight: bold; background-color: #A3E4A3; color: #000;border-style: solid;border-width: 1px 1px 1px 0; border-color: #000;}
          .td_key {background-color: #FFF7E8; color: #000; border-style: solid;border-width: 0 1px 1px 1px;padding: 8px;}
          .td_file {background-color: #fff; border-width: 0 1px 1px 0;padding: 8px;}
          .td_section {background-color: #fff; border-width: 0 1px 1px 0;padding: 8px;}
          .td_version {background-color: #fff; border-width: 0 1px 1px 0;padding: 8px;}
          .td_default {background-color: #fff; border-width: 0 1px 1px 0;padding: 8px;}
          .td_advanced {background-color: #fff; border-width: 0 1px 1px 0;padding: 8px;}
          .td_description {background-color: #FFF7E8; border-width: 0 1px 1px 0;padding: 8px;}
          .keyscount {font-size: 0.8em;}
          a:link {text-decoration:none;}
          a:visited {text-decoration:none;}
          a:hover {text-decoration:underline;}
          a:active {text-decoration:underline;}
        </style>
      </head>
      <body>

        <h1><xsl:value-of select="ultra_tc_editors_data_file/main_category/@title"/></h1>
        <ul>
            <li><a href="#keyslist">Keys list</a></li>
            <li><a href="#sectionslist">Sections list</a></li>
        </ul>
        <a name="keyslist"></a>
        <h2 style="margin: 16px 0 -8px 0;">
            Keys List<span class="keyscount">&nbsp;&nbsp;(<xsl:value-of select="count(//key)"/> keys)</span>
        </h2>

<!-- Start of keys data -->
        <xsl:for-each select="//category">
          <xsl:if test="count(./key) > 0">
            <h3 style="color: #00c; margin: 32px 0 0 0; padding: 0 0 3px 0; border-style: solid; border-width: 0 0 4px 0; border-color: #000;">
              <xsl:choose>
                <xsl:when test="parent::main_category">
                    <xsl:value-of select="@title"/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="keyscount">(<xsl:value-of select="count(./key)"/> keys)</span>
                </xsl:when>
                <xsl:when test="parent::category/category/category">
                    <xsl:value-of select="../@title"/>\<xsl:value-of select="@title"/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="keyscount">(<xsl:value-of select="count(./key)"/> keys)</span>
                </xsl:when>
                <xsl:when test="parent::category/category">
                    <xsl:value-of select="../../@title"/>\<xsl:value-of select="../@title"/>\<xsl:value-of select="@title"/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="keyscount">(<xsl:value-of select="count(./key)"/> keys)</span>
                </xsl:when>
              </xsl:choose>
            </h3>
            <table style="width: 100%;" cellspacing="0px">
              <tbody>
                <tr>
                  <td class="td_header" style="border-width: 1px;">Key</td>
                  <td class="td_header">File</td>
                  <td class="td_header">Section</td>
                  <td class="td_header">Version</td>
                  <td class="td_header">Default</td>
                  <td class="td_header">Advanced</td>
                  <td class="td_header">Description</td>
                </tr>
                <xsl:for-each select="./key">
                  <tr>
                    <td class="td_key"><xsl:value-of select="@name"/></td>
                    <td class="td_file"><xsl:value-of select="@file"/></td>
                    <td class="td_section"><xsl:value-of select="@section"/></td>
                    <td class="td_version"><xsl:value-of select="@version"/>+</td>
                    <td class="td_default"><xsl:value-of select="@default"/></td>
                    <xsl:choose>
                      <xsl:when test="@advanced">
                        <td class="td_advanced"><xsl:value-of select="@advanced"/></td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="td_advanced">---</td>
                      </xsl:otherwise>
                    </xsl:choose>
                    <td class="td_description">
                      <xsl:call-template name="LineFeedToBr">
                        <xsl:with-param name="DescriptionText" select="description"/>
                      </xsl:call-template>
                    </td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </xsl:if>
        </xsl:for-each>
<!-- End of keys data -->

        <div style="margin: 64px;"></div>
        <a name="sectionslist"></a>
        <h2 style="margin: 0 0 -8px 0;">
            Sections List<span class="keyscount">&nbsp;&nbsp;(<xsl:value-of select="count(//section)"/> sections)</span>
        </h2>

<!-- Start of sections data -->
        <xsl:for-each select="//category">
          <xsl:if test="count(./section) > 0">
            <h3 style="color: #00c; margin: 32px 0 0 0; padding: 0 0 3px 0; border-style: solid; border-width: 0 0 4px 0; border-color: #000;">
              <xsl:choose>
                <xsl:when test="parent::main_category">
                    <xsl:value-of select="@title"/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="keyscount">(<xsl:value-of select="count(./section)"/> sections)</span>
                </xsl:when>
                <xsl:when test="parent::category/category">
                    <xsl:value-of select="../@title"/>\<xsl:value-of select="@title"/>&nbsp;&nbsp;&nbsp;&nbsp;<span class="keyscount">(<xsl:value-of select="count(./section)"/> sections)</span>
                </xsl:when>
              </xsl:choose>
            </h3>
            <table style="width: 100%;" cellspacing="0px">
              <tbody>
                <tr>
                  <td class="td_header" style="border-width: 1px; background-color: #FFD171;">Name</td>
                  <td class="td_header" style="background-color: #FFD171;">File</td>
                  <td class="td_header" style="background-color: #FFD171;">Version</td>
                  <td class="td_header" style="background-color: #FFD171;">Description</td>
                </tr>
                <xsl:for-each select="./section">
                  <tr>
                    <td class="td_key"><xsl:value-of select="@name"/></td>
                    <td class="td_file"><xsl:value-of select="@file"/></td>
                    <td class="td_version"><xsl:value-of select="@version"/>+</td>
                    <td class="td_description">
                      <xsl:call-template name="LineFeedToBr">
                        <xsl:with-param name="DescriptionText" select="description"/>
                      </xsl:call-template>
                    </td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </xsl:if>
        </xsl:for-each>
<!-- End of sections data -->

        <div style="margin: 64px;"></div>
      </body>
    </html>
  </xsl:template>

<!-- template to convert LineFeed to <br />-->
  <xsl:template name="LineFeedToBr">
    <xsl:param name="DescriptionText"/>
    <xsl:choose>
      <xsl:when test="contains($DescriptionText,'&#xA;')">
        <xsl:value-of select="substring-before($DescriptionText,'&#xA;')"/>
        <br />
        <xsl:call-template name="LineFeedToBr">
          <xsl:with-param name="DescriptionText">
            <xsl:value-of select="substring-after($DescriptionText,'&#xA;')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$DescriptionText"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
