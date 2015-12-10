<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" />
<xsl:template match="/">
<table id="search">
<col width="200px" />
<col width="200px" />
<col width="100px" />
<col width="100px" />
<col width="300px" />
<thead>
<tr onclick="sort(event);">
 <th id="organization"> Name</th>
 <th id="contacts">Contacts</th>
 <th id="phone">Phone</th>
 <th id="sdate">Callback</th>
 <th id="comment">Info</th>
</tr>
</thead>
<tbody>
<xsl:if test="not(top/row)"><tr><td colspan="5">No Results</td></tr></xsl:if>
<xsl:for-each select="top/row">
<xsl:sort select="organization" order="ascending"/>
<tr id="{id}" class="list" onmouseover="this.className='hilite';" onmouseout="this.className='list';" onclick="chgMode(this);">
<xsl:attribute name="style">color:
<xsl:choose>
 <xsl:when test="cid != '*'">green;</xsl:when>
 <xsl:when test="reminder='1'">red;</xsl:when> 
 <xsl:otherwise>#444;</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
    <td id="org"><xsl:value-of select="organization" /></td>
    <td><xsl:value-of select="contacts" /></td>
    <td><xsl:value-of select="phone" /></td>
    <td style="text-align:right;"><xsl:value-of select="callback" /></td>
    <td style="text-align:right;white-space:normal;"><xsl:value-of select="comment" /></td>
</tr>
</xsl:for-each>
</tbody>
</table>
</xsl:template>
</xsl:stylesheet>
