<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/top">
<span class="cardbuttons">
<input type="button" value="Edit" onclick="showEditCard();" />
<input type="button" value="Delete" onclick="delRec()" />
<input type="button" value="Remind" onclick="remind()" />
<input type="button" value="Add Call" onclick="addcall()" />
<input type="button" value="Add'nl #s" onclick="people()" />
<input type="button" value="Clicks" onclick="showclicks()" />
<input type="button" value="Close" onclick="listDriver()" />
<xsl:if test="row/source != '-'">
    <span class="source"><xsl:value-of select="row/source" /></span>
</xsl:if>
</span>
<table id="card" onclick="showEditCard();">
<col width="100px" /><col width="200px" /><col width="200px" /><col width="100px" />
<tr class="row1">
<th>Since</th><th>Last Name</th><th>Contacts</th><th>Phone</th>
</tr>
<tr>
 <td>
  <xsl:attribute name="style"> 
    <xsl:if test="row/client != '*'">
      color:green;font-weight:bold;
    </xsl:if>
  </xsl:attribute>
   <xsl:value-of select="row/added" />
 </td>
 <td id="org"  field="organization"><xsl:value-of select="row/organization" /> </td>
 <td><xsl:value-of select="row/contacts" /></td>
 <td><xsl:value-of select="row/phone" /></td>
</tr>
<tr>
<td class="label">Address</td>
<td colspan="3"><xsl:value-of select="row/address"/></td>
</tr>
<tr>
<td class="label">Email</td><td><xsl:value-of select="row/email" /></td>
<td colspan="3"></td>
</tr>
<tr class="row2">
<th>Callback</th><th colspan="3"></th></tr>
<tr>
 <td id="reminder" class="reminder" onclick="remind();">
 <xsl:attribute name="style">
  <xsl:choose>
   <xsl:when test="row/reminder=1">color:red;font-weight:bold;</xsl:when>
   <xsl:otherwise>color:#000;</xsl:otherwise>
  </xsl:choose>
 </xsl:attribute>
 <xsl:value-of select="row/callback"/>&#160;&#160;<xsl:value-of select="row/tt" />
</td>
<td colspan="3"><xsl:value-of select="row/bloomberg" /></td> 
</tr>
<tr class="row3"><th colspan="4">Inquiries/Contacts</th></tr>
<tr>
 <td class="label">Munis</td>
 <td colspan="3"><xsl:value-of select="row/munis" /></td>
</tr>
<tr>
 <td class="label">Corps</td>
 <td colspan="3"><xsl:value-of select="row/corps" /></td>
</tr>
<tr>
 <td class="label">CMOs</td>
 <td colspan="3"><xsl:value-of select="row/cmos" /></td>
</tr>
<tr>
 <td class="label">Agencies</td>
 <td colspan="3"><xsl:value-of select="row/agencies" /></td>
</tr>
<tr>
 <td class="label">Other</td>
 <td colspan="4"><xsl:value-of select="row/other" /></td>
</tr>
<tr class="row3">
 <th colspan="4">Profile</th>
</tr>
<tr>
 <td colspan="4"><xsl:value-of select="row/comment" /></td>
</tr>
<tr><td id="people" colspan="4"></td></tr>
</table>
</xsl:template>
</xsl:stylesheet>
