//Cookies.js
//Dec 4 209
//
function setCookie(sName,sVal,oExpires,sPath,sDom,bSec){
 var sCookie=sName+'='+encodeURIComponent(sVal);
 if(oExpires){
  sCookie+='; expires='+oExpires.toGMTString();
 }
 if(sPath){
  sCookie+='; path='+sPath;
 }
 if(sDom){
  sCookie+='; domain='+ sDom;
 }
 if(bSec){
  sCookie+='; secure';
 }
 document.cookie=sCookie;
}
