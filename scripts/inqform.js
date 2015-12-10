var eId = {
 id:0,
 row:$(),
 setRow:function(r){if(r){this.row = r;}return this.row;},
 getRow:function(){return this.row;},
 hiltRow:function(){$(this.row).css('backgroundColor','yellow');},
 unhltRow:function(){$(this.row).css('backgroundColor','#fff');},
 setId:function(i){this.id=i;},
 getId:function(){return this.id;},
 repno:0,
 setRepno:function(rn){
   if(rn){
     this.repno = rn;
   }
   return this.rn;
 },
 getRepno:function(){
   return this.repno;
 }
}
$(function(){
 eId.setRepno($.cookie('MYUser')); 
 $('input[type=button]').click(vld); 
 listemails();
 $(document).keydown(function(event){
   if(event.keyCode == 13){
     vld(event);
   }
 });
 $('input[name=send]').click(function(event){
  if( $(this).val() > 0){
    $('#none').attr('checked',0);
  }else{
    $('#offg,#invite,#blog').attr('checked',0);
  }
 });
});
function listemails(){
 $('#data').load('cgi/inqemaillist.pl?rep='+eId.getRepno(),function(data){
    $('#inqem tr').mouseover(function(){
       $(this).addClass('hilite');
     }).mouseout(function(){
       $(this).removeClass('hilite');
     });
 });
}
function addActions(str){
 var ary = str.split(',');
 $('#email').val(ary[4]);
 $('#action').val('Update');
 $('#stcodes').val(ary[7])
 $('input[name=send]').removeAttr('checked');
 $('input[value='+ary[9]+']').attr('checked','checked');
}
function findEmail(){
 var chrs = $('#email').val();
  $.get('cgi/findinqemail.pl?rep='+eId.getRepno()+'&chrs='+chrs,function(data){
    if(/Not found/.test(data)){
      $('#email').val(data);
    }else{      
      addActions(data);
    }
 });
}
function vld(e){
var bIndx = 0;
var sendOpts = 0;
e.preventDefault();
if(e){
 bIndx = $('input[type=button]').index($(e.target));
}
params = {};
var url = new String();
if(bIndx == 3){
  clr();
  return;
}else if(bIndx == 2){
  reset();
  return;
}else if(bIndx == 1){
  findEmail();
  return;
}
if($('#del').is(':checked')){
  params['del'] = $('#del').val();
}
$('input[name=send]').each(function(index){
  if($(this).val() == 0 & $(this).attr('checked')){
    return false;
  }
  if($(this).attr('checked')){
    sendOpts += parseInt($(this).val());
  }
}); 
params['send'] = sendOpts;
if(isValidEmail($('#email').val())){
   params['email'] = $('#email').val();
}else{
   alert( 'Review/reenter email box.' );
   $('#email').focus();
   return false;
}
params['ae'] = eId.getRepno();
params['state'] = isValidState($('#stcodes').val());
if($('#action').val() == 'Update'){
  params['id'] = eId.getId();
  url = 'cgi/updateinqemail.pl';
}else{
  url = 'cgi/addinqemail.pl';
}

$.post(url,params,function(data){
    listemails();
    reset();
});
}
function isValidState(st){
 return (/[A-Z][A-Z]/.test(st)) ? st : 0;
}
function isValidEmail(sText){
 var reEmail=/^[A-Z0-9._%+-]+@[A-Z0-9-.]+\.[A-Z]{2,4}$/i;
 return reEmail.test(sText);
}
function isValidAcct(sText){
 var reAcctNo=/^(?:\d{8})$/;
 return reAcctNo.test(sText);
}
function editEmail(x){
 $('html,body').animate({scrollTop:0},'fast');
 eId.unhltRow();
 eId.setRow(x);
 eId.setId(x.id);
 $.get('cgi/getinqemail.pl?id='+x.id,function(data){
   addActions(data);
   eId.hiltRow();
 });
}
function reset(){
 $('#action').val('OK');
 $('#email').val('');
 $('#stcodes').attr('selectedIndex',0); 
 $('input[type=checkbox]').each(function(index){
 	$(this).attr('checked',0);
 }); 
 eId.unhltRow();
}
