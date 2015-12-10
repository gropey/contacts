/*
 * jquery.xslt.js
 *
 * Copyright (c) 2005-2008 Johann Burkard (<mailto:jb@eaio.com>)
 * <http://eaio.com>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
 * NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
 * USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 */
 
/**
 * jQuery client-side XSLT plugins.
 * 
 * @author <a href="mailto:jb@eaio.com">Johann Burkard</a>
 * @version $Id: jquery.xslt.js,v 1.5 2008/06/05 19:32:08 Johann Exp $
 */
(function() {
	$.fn.xslt = function() {
		return this;
	}
    if (document.recalc) { // IE 5+
		$.fn.xslt = function(xml, xslt) {
			return this.each(function() {
				var id = function() {
					do {
				   		var f = 'xsltjs' + (Math.round(Math.random() * 999));
				   	}
				   	while ($('#' + f).length);
				   	return f;
				};
				
	            var xmlID = id();
	            var xsltID = id();
	            
	            var target = $(this);
	            
	            var change = function() {
	                var c = 'complete';
	                var xm = $('#' + xmlID);
	                var xs = $('#' + xsltID);
	                if (xm.length && xm.get(0).readyState == c &&
	                	xs.length && xs.get(0).readyState == c) {
	                    window.setTimeout(function() {
	                        target.html(xm.get(0).transformNode(xs.get(0).XMLDocument));
	                    }, 50);
	                }
	            };
	            
	            var xm = document.createElement('xml');
	            xm.onreadystatechange = change;
	            xm.id = xmlID;
	            xm.src = xml;
	            
	            var xs = document.createElement('xml');
	            xs.onreadystatechange = change;
	            xs.id = xsltID;
	            xs.src = xslt;
	            
	            $('body').append(xm).append(xs);
        	});
		};
    }
    else if (window.XMLHttpRequest != undefined && window.XSLTProcessor != undefined) { // Mozilla 0.9.4+, Opera 9+
       var processor = new XSLTProcessor();
       var support = false;
       if ($.isFunction(processor.transformDocument)) {
           support = window.XMLSerializer != undefined;
       }
       else {
           support = true;
       }
       if (support) {
			$.fn.xslt = function(xml, xslt) {
				return this.each(function() {
				
					var xmlRequest = $.ajax({ cache: true, dataType: "xml", url: xml});
					var xsltRequest = $.ajax({ cache: true, dataType: "xml", url: xslt});
					
					var target = $(this);
					var transformed = false;
					
					var change = function() {
						if (xmlRequest.readyState == 4 && xsltRequest.readyState == 4  && !transformed) {

		                    xmlDoc = xmlRequest.responseXML;
    		                xsltDoc = xsltRequest.responseXML;
    	                
	    	                var processor = new XSLTProcessor();
	    	                if ($.isFunction(processor.transformDocument)) {
		                        // obsolete Mozilla interface
		                        resultDoc = document.implementation.createDocument("", "", null);
		                        processor.transformDocument(xmlDoc, xsltDoc, resultDoc, null);
		                        target.html(new XMLSerializer().serializeToString(resultDoc));
	    	                }
		                    else {
		                        processor.importStylesheet(xsltDoc);
		                        resultDoc = processor.transformToFragment(xmlDoc, document);
		                        target.empty().append(resultDoc);
		                    }
                    
		                    transformed = true;
		               	}
	                };
		            xmlRequest.onreadystatechange = change;
		            xsltRequest.onreadystatechange = change;		
				});
			};
       }
    }
})();