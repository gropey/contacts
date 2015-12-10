var doc = {
 xslDoc:null,
 xmlDoc:null,
 tag:new String(),
 setDefaultTag:function(t){
     if (t) {
         this.tag = t;
     }
     return this.tag;
 },
 getXsldoc:function(){
    return this.xslDoc;
 },
 getXmldoc:function(){
    return this.xmlDoc;
 },
 setXsl:function(xsld){
    if (xsld) {
        this.xslDoc = xsld;
    }
 },
 setXml:function(xmld){
    if (xmld) {
        this.xmlDoc = xmld;
    }
 },
 doXSLT:function(t){
     if (t == undefined) {
         t = this.tag;
     }
     if (window.ActiveXObject) {
         $(t).html(this.xmlDoc.transformNode(this.xslDoc));
     } 
     else {
         var xp = new XSLTProcessor();
         xp.importStylesheet(this.xslDoc);
         var frag = xp.transformToFragment(this.xmlDoc,document);
         $(t).html(frag);
     }
 }
};
function getData(xm,xs,t){
    if (xm == null || xs == null) {
        return false;
    }
    if (t == undefined) {
        t = this.tag;
    }
    $.get(xm,function(data){
        $.get(xs,function(x){
            doc.setXml(data);
            doc.setXsl(x);
            doc.doXSLT(t);
        });
    });
}
