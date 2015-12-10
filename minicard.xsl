<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/top">
<table id="minicard">
<col width="200px" /><col width="200px" /><col width="200px" /><col width="200px" />
<tr>
<td><xsl:value-of select="row/organization" /></td>
<td><xsl:value-of select="row/contacts" />
<td><xsl:value-of select="row/phone" />
<td><xsl:value-of select="row/address" />
</tr>
</table>
</xsl:template>
</xsl:stylesheet>
