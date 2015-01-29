window.addEventListener("keydown", moveSomething, false);
 
function moveSomething(e) {
    switch(e.keyCode) {
        case 37:
            // left key pressed
			window.location.href = "/game/?dir=3";
            break;
        case 38:
            // up key pressed
			window.location.href = "/game/?dir=1";
            break;
        case 39:
            // right key pressed
			window.location.href = "/game/?dir=2";
            break;
        case 40:
            // down key pressed
			window.location.href = "/game/?dir=4";
            break; 
		case 13:
			//new game
			window.location.href = "/game/?dir=0";
            break; 
    }   
}