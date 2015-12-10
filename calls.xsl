<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
<table id="calls_table" style="border-collapse:collapse;">
<col width="90px" />
<col width="400px" />
<xsl:if test="top/row">
 <caption>Calls/Events</caption>
 <tr style="color:#469;text-align:center;"><td>Date</td><td>Comments</td></tr>
</xsl:if>
<xsl:for-each select="top/row">
 <xsl:sort select="sortby" order="descending" />
<tr id="{guid}" onmousedown="editcall(this);" onmouseover="this.className='hilite';" onmouseout="this.className='';">
  <td><xsl:value-of select="lastcontact" /></td>
  <td style="border-bottom:1px solid #333;"><xsl:value-of select="notes" /></td>
<!-- <td>|&#160;&#160;<i><xsl:value-of select="usrname" /></i></td> -->
</tr>
</xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>
