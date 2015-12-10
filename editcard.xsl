<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/top">
<span class="cardbuttons">
<input type="button" value="View" onclick="showCard();" />
<input type="button" value="Contacts" onclick="addpeople();" />
<input type="button" value="Close" onclick="listDriver()" />
Client <input type="checkbox" onclick="toggleClient(event)" >
 <xsl:if test="row/client!='*'">
  <xsl:attribute name="checked"></xsl:attribute>
 </xsl:if>
</input>
<input type="text" size="12" name="acctnum" value="{row/acctnum}"/>
</span>
<table id="card">
<col width="100px" /><col width="200px" /><col width="200px" /><col width="200px" />
<tr class="row1">
<th>Since</th>
<th>Last Name</th>
<th>Contacts</th>
<th onmousedown="showhist(this);" id="{row/id}">Phone</th>
</tr>
<tr>
<td><xsl:value-of select="row/added" /></td>
<td id="org" >
  <input type="text" value="{row/organization}" name="organization" />
</td>
<td >
  <input type="text" value="{row/contacts}" name="contacts" />
</td>
<td >
  <input type="text" value="{row/phone}" name="phone" />
</td>
</tr>
<tr>
<td class="label">Address</td>
<td  colspan="3">
  <input type="text" value="{row/address}" name="address" style="width:500px" />
</td>
</tr>
<tr>
<!--<th onmousedown="sendem(this);" id="emaddr" em="{row/email}">Send Msg</th>-->
<td class="label">Email</td>
<td >
 <input type="text" value="{row/email}" name="email" />
</td>
<td  colspan="2">
 <input type="text" value="{row/bloomberg}" name="bloomberg" style="width:300px" />
</td>
</tr>
<tr class="row3"><th colspan="4">Inquiries/Contacts</th></tr>
<tr>
 <td class="label">Munis</td>
 <td colspan="3" >
   <input type="text" value="{row/munis}" name="munis" style="width:400px;" />
 </td>
</tr>
<tr>
 <td class="label">Corps</td>
 <td colspan="3" >
  <input type="text" value="{row/corps}" name="corps" style="width:400px" />
 </td>
</tr>
<tr>
 <td class="label">CMOs</td>
 <td colspan="3" >
  <input type="text" value="{row/cmos}" name="cmos" style="width:400px;" />
 </td>
</tr>
<tr>
 <td class="label">Agencies</td>
 <td colspan="3" >
  <input type="text" value="{row/agencies}" name="agencies" style="width:400px;" />
 </td>
</tr>
<tr>
 <td class="label">Other</td>
 <td colspan="4" >
  <input type="text" value="{row/other}" name="other" style="width:400px;" />
 </td>
</tr>
<tr class="row2">
<th colspan="4">Profile</th></tr>
<tr>
<td colspan="4">
 <input type="text" value="{row/comment}" name="comment" style="width:400px;" />
</td>
</tr>
</table>
</xsl:template>
</xsl:stylesheet>
