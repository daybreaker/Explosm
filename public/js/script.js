$.tablesorter.addParser({ 
        // set a unique id 
        id: 'comic', 
        is: function(s) { 
            // return false so this parser is not auto detected 
            return false; 
        }, 
        format: function(s) { 
            // format your data for normalization 
            return s.split('#')[1]; 
        }, 
        // set type, either numeric or text 
        type: 'numeric' 
    }); 
    
$(function(){
	$("#sortable")
		.tablesorter({ 
            headers: { 
                0: { 
                    sorter:'comic' 
                } 
            },
            widthFixed: true, 
            widgets: ['zebra']
    });
//		.tablesorterPager({container: $("#pager")}); 
});
