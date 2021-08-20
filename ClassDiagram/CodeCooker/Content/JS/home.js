
var loginOpen = false;
function toggleLogin() {
	var loginButtons = $('#loginButtons');
	if(loginOpen)
	{
		loginButtons.animate({
    	height: "-=50",
  		},300);
  	}
	else
	{
		loginButtons.animate({
    	height: "+=50",
  		},300);
	}

	loginOpen = !loginOpen;


}