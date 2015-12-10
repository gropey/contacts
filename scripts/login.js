$(document).ready(function(){
 $('#usrn').focus();
 $('#pwd').keypress(function(event){if(event.keyCode==13){chkin();}});
});
function chkin(){
 if($('#usrn').val().length==0 || $('#pwd').val().length==0){
   alert("Your input requires review.");
   $('#usrn').focus();
   return false;
 }else{
   var data={};
   data["usrn"]=$('#usrn').val();
   data["pwd"]=$('#pwd').val();
   $.post('cgi/login.pl',data,well);
 }
}
function well(data){
 var x=data.getElementsByTagName('ok')[0].firstChild.nodeValue;
 switch(parseInt(x)){
  case 1: 
   if($('#usrn').val() == 'admin'){
     location.replace('/salesmgr/mgrcontacts.html');
   }else{
     location.replace('contacts.html');
   }
   break;
  case -1: alert('Invalid username.');
   $('#usrn').focus();
   break;
  case 0: alert('Invalid password.');
   $('#pwd').focus();
   break;
  default:
   alert('They think it be what it aint but it do');
 }
 return;
}
