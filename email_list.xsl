<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<table id="inqem">
<col width="200px" />
<col width="175px" />
<col width="80px" />
<col width="70px" />
<col width="70px" />
<col width="70px" />
<col width="70px" />
<col width="70px" />
<col width="70px" />
<tr onclick="sort(event);">
 <th id="contacts"> First/Contacts</th>
 <th id="organization">Last/Co.</th>
 <th id="email">Email</th>
 <th id="taxstatus">TaxStatus</th>
 <th id="rating">Rating</th>
 <th id="comment">Mat</th>
 <th id="px">Px</th>
 <th id="state">State</th>
 <th id="definition">Status</th>
</tr>
<xsl:if test="not(top/row)"><tr><td colspan="5">No Results</td></tr></xsl:if>
<xsl:for-each select="top/row">
<xsl:sort select="organization" order="ascending" data-type="text" />
<tr id="{id}" cid="{cid}" class="emails" onmouseover="this.className='hilite';" onmouseout="this.className='list';" onclick="editEmail(this);">
<xsl:attribute name="style">color:
<xsl:choose>
 <xsl:when test="definition='Everything'">green;</xsl:when>
 <xsl:otherwise>#444;</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
    <td style="text-align:left;"><xsl:value-of select="contacts" /></td>
    <td style="text-align:left;"><xsl:value-of select="organization" /></td>
    <td><xsl:value-of select="email" /></td>
    <td><xsl:value-of select="taxstatus" /></td>
    <td><xsl:value-of select="rating" /></td>
    <td><xsl:value-of select="mat" /></td>
    <td><xsl:value-of select="px" /></td>
    <td><xsl:value-of select="state" /></td>
    <td><xsl:value-of select="definition" /></td>
</tr>
</xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>
