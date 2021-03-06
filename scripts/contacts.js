var cards = {
 cArray:[],
 __id__: 0,
 __fld__ :new String(),
 MYUId:0,
 MYUser: new String(),
 __form__: new String(),
 __counter__ : 0,
 __mode__ : 'card.xsl',
 __cell__ : $(),
 __ltr__ : $(),
 __callId__ : 0,
 url:new String('cgi/getcnts.pl?id='),
 acctNum:0,
 setCallId: function(i){
 if(i){
  this.__callId__ = i;
 }
 return i;
},
getCallId:function(){
 return this.__callId__;
},
setLtr:function(l){
 if(l){
  this.__ltr__ = l;
 }
 return l;
},
getLtr:function(){return this.__ltr__;},
setCell:function(c){
 if(c){
   this.__cell__ = c;
 }else{
   return c;
 }
},
getCell:function(){
 return this.__cell__;
},
setUrl:function(){
   var qstr = new String();
   $('select, input[type=text]').each(function(index) {
      var val = new String($(this).val());
      val = val.replace(/\W/g,'');
      qstr += '&'+$(this).attr('name') + '=' + val;
   });
   return this.url+qstr;
},
getMode:function(){
 return this.__mode__;
},
setMode :function(b){
 if(/edit/.test(b)){
   this.__mode__ = 'editcard.xsl';
 }else{
   this.__mode__ = 'card.xsl';
 }
 return this.__mode__;
},
setIds:function(rows){
 if(rows){
    this.cArray = $.map($(rows),function(a){return a.id;});   
    this.__counter__ = 0;
    return this.cArray.length;
 }else{
    return false;
 }
},
getQueue:function(){
 return cArray.length > 0;
},
getCardId:function(dir){
 if(this.cArray.length == 0){return false;}
 if(dir == 37){
   this.__counter__ -= 1;
 }else{
   this.__counter__ += 1;
 }
 if(this.__counter__ == this.cArray.length){
   this.__counter__ = 0;
 }else if(this.__counter__ == -1){
  this.__counter__ = this.cArray.length - 1;
 }
 this.__id__ = this.cArray[this.__counter__];
 return true;
},
getForm:function(){return this.__form__;},
setForm:function(f){
 if(f){
   this.__form__ = f;
 }else{
   return false;
 }
},
getid:function(){return this.__id__;},
getUsrid:function(){return this.MYUId;},
getUName:function(){return this.MYUser;},
setid:function(id){
 if(id){
    this.__id__ = id;
 }else{
    return false;
 }
},
setAcctnum:function(a){
   a = a.replace(/\W/g,'');
   return (/^\d{8}$/.test(a)) ? this.acctNum = a : this.acctNum = 0;
},
getUser:function(){
 this.MYUId = localStorage.getItem('MYUId');
 this.MYUser = localStorage.getItem('MYUser');
 if(this.MYUId){
   return true;
 }else{  
   return false;
 }
},
setUser:function(userAry){
   localStorage.setItem('MYUId',userAry[10]);
   localStorage.setItem('MYUser',userAry[2]);
   this.MYUId = localStorage.getItem('MYUId');
   this.MYUser = localStorage.getItem('MYUser');
   return this.MYUId;
},
mailWin:null,
};

function addpeople(){
 $('<div id="ap"></div>').load('addpeople.html').appendTo('body').css({'background-color':'#fff','position':'absolute','top':'150px','left':'200px'});
 $('html,body').animate({scrollTop:0},'fast');
}
function people(){
    if ($('#people').text().length) {
        $('#people').empty().hide();
    }
    else {
        $('#people').load('cgi/showPhnos.pl?id='+cards.getid()).fadeIn();  
    }
}
function okInput(i,typ){
 var rdate=/(?:0?[1-9]|1[0-2])\/(?:0?[1-9]|[12][0-9]|3[01])\/(?:(19|20)?\d{2})/;
 var rph = /^[(]{0,1}[0-9]{3}[)]{0,1}[-\s\.]{0,1}[0-9]{3}[-\s\.]{0,1}[0-9]{4}$/;
 var rem = /^.+@.+\..+$/;
 var rtime = /\d{1,2}:\d{1,2}/;
 var rtxt=/\w+/;
  switch(typ){
   case "d": return rdate.test(i);
   break;
   case "p": return rph.test(i) || i.length == 0;
   break;
   case "e": 
    if(i.length > 0){
     return rem.test(i);
    }else{
     return true;
    }
   break;
   case "t": return rtxt.test(i);
   break;
   case "ts":return rtime.test(i);
   break;
   case "a":return cards.setAcctnum(i);
   break;
   default: return true
  }
}
function toggleClient(event) {
  var client = $(event.target);
  if (client.prop('checked') && !cards.setAcctnum($('input[name=acctnum]').val())){
     $('input[name=acctnum]').focus();
     client.prop('checked',false)
     alert( 'Acct. number required.');
   }else{
     $.post('cgi/toggleClient.pl',{'cid':cards.getid(),'acctnum':cards.acctNum},function(data){
        if( !data ){
           alert ( 'Call 3059.' + data);
        }     
     });
  }
}

function delRec(){
 var doit = confirm('Delete permanently?');
 if(!doit){return;}
 $.post('cgi/delRec.pl',{'id':cards.getid()},function(data){
    if(data > 0){
        listDriver();
    }else{
        alert("Error.");
    }
 });
}
function ckform(){
 var data = {};
 var ok = true;
 $('.err').removeClass('err');
 $('form input[type=text]').each(function(index){
   if(!$(this).val() && $(this).attr('req')){
    $(this).addClass('err').focus();
    ok = false;
    return false; 
  }else if($(this).val() && !okInput($(this).val(),$(this).attr('val'))){
    $(this).addClass('err').focus();
    ok = false;
    return false; 
   }else{
      if($(this).attr('name') == 'acctno'){
         data[$(this).attr('name')] = cards.acctNum;
      }else{
         data[$(this).attr('name')] = $(this).val();
      }
  }  
 });
 $('textarea').each(function(index){
   if($.trim($(this).val()) && !okInput($(this).val(),$(this).attr('val'))){
     $(this).addClass('err').focus();
     ok = false;
     return false;
   }else{
     data[$(this).attr('name')] = $.trim( $(this).val() );
   }
 });
 $('form select').each(function(index){
     if( $(this).attr('req') && parseInt($(this).val()) == 0) {
         $(this).addClass('err').focus();
         ok = false;
         return false;
     }
     else {
         data[$(this).attr('name')] = $(this).val();
     }
 });
 if(ok){procData(data);}
}
function procData(d){
 if(!cards.getUsrid()){
   alert("Session expired, login again.");
   $('#controls').load('signin.html',function(){
    $('#usrn').focus();
    $('#signin input').keydown(function(event){if(event.keyCode==13){chkin();}});
  });
  return;
 }
 if(cards.getForm() == 'addone'){
  d["usrid"] = cards.getUsrid();
  if(d.source == "0"){d.source = "xx";}
  $.post('cgi/addrec.pl',d,function(data){
	cards.setid(data);
	chgMode();    
  });
 }else if(cards.getForm() == 'addcall'){
  d['id'] = cards.getid();
  d['repn'] = cards.getUName();
  $.post('cgi/addcall.pl',d,function(data){
      chgMode();
      return;
   });
 }else if(cards.getForm() == 'editcall'){
   d.id = cards.getCallId();
   $.post('cgi/editcall.pl',d,function(data){
      chgMode(1);
   }); 
 }
}

function convT(t,am_pm){
 var h = parseInt(t.split(':')[0]);
 if(am_pm == 'pm' && h < 12){return h+12;}
}
function clr(){
$('#source').val('0');
$('#minicard').remove();
$('#ap').remove();
$('#filteron').val('');
$('select#srch_col').val('0');
$('.hiltr').removeClass('hiltr');
//$('#calls').remove();
$('#divOutput').empty();
$(document).unbind('keydown');
cards.getLtr().removeClass('hiltr');
cards.setMode();
$('#calls').empty();
}
// Onload code  
$(function(){
if(cards.getUser()){
   init();
   //$('#search').tablesorter();
}else{
  $('#controls').load('signin.html',function(){
    $('#usrn').focus();
    $('#signin input').keydown(function(event){
   if(event.keyCode==13){
	   chkin();
 	}
    });
  });
  return;
}
});
//End onload code
function init(){
 cards.url += cards.getUsrid(); 
 $('#controls').load('controls.html',function(data){
   $('input').each(function(index){
     switch(index){
      case 0:$(this).click(clr);
        break;
      case 1:$(this).click(addrec);
        break;
      case 2:$(this).keydown(function(event){
    	if(event.keyCode == 13){
          listDriver(event);
          return false;
    	}else{
          return;
    	}
      }).focus();
        break;
      case 3:$(this).click(function(event){
               clr();
               if(!cards.mailWin || cards.mailWin.closed){
                  cards.mailWin = window.open('email_app.html');
               }else{
                  cards.mailWin.focus();
               }
            });
        break;
     }
   });
   $('select[name=src]').load('cgi/srcCodes.pl?uid='+cards.getUsrid()).change(listDriver);
   doc.setDefaultTag('#divOutput');
 });
 var ltrs = new String();
 for(var c = 65;c < 91;c++){
   ltrs += '<td class=\"ltrs\">'+String.fromCharCode(c)+'</td>';
 }
 $('#alpha').html(ltrs).click(setLtr);
}
window.onunload = function(){delete cards;delete Cid;}
function setLtr(event){
    $('.hiltr').removeClass('hiltr');
    $('input[name=filteron]').val( $(event.target).text() );
    $(event.target).addClass('hiltr');
    listDriver();
}
function setDefaultSearch(){
 var s = $('select[name=cat] option:selected');
 var txt = s.text();
 var val = s.val();
 if (s.attr('selectedIndex') == 0) {
     s.attr('selectedIndex',7);
 }
 else {
     $('select[name=cat] option:first').val(val).text(txt);
 }
}
function showclicks(){
   getData('cgi/get_clicks.pl?id='+cards.getid(),'show_clicks.xsl','#calls');
}
function chgMode(row){
   cards.setid($(row).attr('id'));
//   $('body').keydown(cardDriver);
   showCard();
}
function listDriver(event){
$('#divOutput').html('<img width="12px" src="/imgs/hourglass.png" />');
$('#minicard').remove();
$('body').unbind('keydown');
$('#calls').empty();
cards.setMode();
getData(cards.setUrl(),'search.xsl');
setTimeout(function(){
   cards.setIds($('tr.list'));
   //$('#search').tablesorter();
},1000);
}
function cardDriver(event){
 var kc = parseInt(event.keyCode);
 switch(kc){
  case 37: cards.getCardId(kc);
  break;
  case 39: cards.getCardId(kc);
  break;
  default:
   return;
 }
 showCard();
}
function showEditCard(obj){
   getData('cgi/showcard.pl?id='+cards.getid(),'editcard.xsl');
   $('body').unbind('keydown');
   setTimeout( function(){
      $('input[type=text]').click(editField);
   }
   ,1000 );
 //  $('body').keydown(cardDriver);
   return false;
}
function editField(){
 var fld = $(this);
 fld.css({'background-color':'#fff','width':'100%'});
 fld.bind('keydown blur',function(event){
   if(event.keyCode == 27 ){
      fld.css('background-color','#ddd').blur();
      return false;
   }
   if(event.keyCode == 13 || event.type == 'blur'){
	   if(fld.attr('name') == 'email' && !okInput(fld.val(),'e')){
   	   fld.addClass('err').focus();
         return false;
	   }else	if(fld.attr('name') == 'phone' && !okInput(fld.val(),'p')){
   	  fld.addClass('err').focus();
        return false;
	   }
      fld.removeClass('err');
   	var param = {
		  'cid':cards.getid(),	
		  'field':fld.attr('name'),
		  'value':fld.val(),
		  'rep_code':cards.getUName()
	   };
   	$.post('cgi/updatecell.pl',param,function(data){
         fld.css('background-color','#ddd').blur();
	   });
   }
   event.stopPropagation();
   });
}
function showCard(){
 getData('cgi/showcard.pl?id='+cards.getid(),'card.xsl');
 showCalls();
 $('html,body').animate({scrollTop:0},'fast');
}
function showCalls(){
  getData('cgi/calls.pl?id='+cards.getid()+'&repn='+cards.getUName(),'calls.xsl','#calls');
}
function addrec(){
$('body').unbind();
$('#minicard').remove();
$('#calls').empty();
cards.setForm('addone');
$.get('addrec.html',function(data){
   $('#divOutput').html(data);
   $('#src').load('cgi/srcCodes.pl').focus();
   $('form[name=frm] input').focus(function(){
      $(this).closest('td').prev('td').addClass('frmfocus');
   }).blur(function(){
      $('.frmfocus').removeClass('frmfocus');
   });
});
}
function addcall(){
$('body').unbind();
var who = $('#card #org').html();
cards.setForm('addcall');
$('#calls').load('addcall.html',function(data){
  $(function(){$('#callback').datepicker({inline:true});});
  $('#who').text(who);
});
}
function remind(){
 $.post('cgi/remind.pl',{'id':cards.getid()},function(data){
    showCard();
 });
}
function sort(event){
 var c = $(event.target).attr('id');
 var s = $(doc.getXsldoc()).find('sort');
 if(/stime/.test(c)){
  s.attr('data-type','number');
 }else{ 
  s.attr('data-type','text');
 }
 if(s.attr('order') == 'ascending'){
  s.attr('order','descending');
 }else{
  s.attr('order','ascending');
 }
 s.attr('select',c);
 doc.doXSLT();
}
function chkin(){
 if($('#usrn').val().length==0 || $('#pwd').val().length==0){
   alert("Your input requires review.");
   $('#usrn').focus();
   return false;
 }else{
   $.post('cgi/login.pl',{'usrn':$('#usrn').val(),'pwd':$('#pwd').val()},function(data){
      var usrAry = data.split(/,/);
      if(usrAry.length < 11){
        alert( data );
      }else{
        cards.setUser(usrAry);
        init();
      }
   });
 }
}
function editcall(row){
cards.setForm('editcall');
cards.setCallId(row.id);
 var rvals = rowData(row);
 $('#calls').load('edit_call.html',function(){
    $('input[name=cdate]').val(rvals[0]);
    $('textarea[name=note]').val(rvals[1]);
 });
 $('body').unbind('keydown');
}
function rowData(tr){
 var ary = new Array();$(tr).find('td').each(function(index){ary.push($(this).text());});return ary;
}
