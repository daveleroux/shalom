module ApplicationHelper

  def limit_textarea
    javascript_tag("$(document).ready(function(){

    	var onEditCallback = function(remaining){
    		$(this).siblings('.charsRemaining').text(\"Characters remaining: \" + remaining);

    		if(remaining > 0){
    			$(this).css('background-color', 'white');
    		}
    	}

    	var onLimitCallback = function(){
    		$(this).css('background-color', 'red');
    	}

    	$('textarea[maxlength]').limitMaxlength({
    		onEdit: onEditCallback,
    		onLimit: onLimitCallback
    	});
    });")


  end

end
