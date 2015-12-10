<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/top">
<table style="font-family:arial;font-size:9pt;">
<tr><th>Date</th><th>Page</th></tr>
<col width="90px" /><col width="250px" />
<xsl:for-each select="row">
<tr>
   <td><xsl:value-of select="clk_date" /></td>
   <td style="text-align:center;"><xsl:value-of select="url" /></td>
</tr>
</xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>
