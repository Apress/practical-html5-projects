if(navigator.appName=="Netscape")
window.captureEvents(Event.MOUSEMOVE) ;
//specify the onmousemove event-handler
document.onmousemove=track;

//get the menu layer objects
var m1=document.getElementById("menu_1");
var m2=document.getElementById("menu_2");
var m3=document.getElementById("menu_3");

//function that reacts to MOUSEMOVE event and hide menu layers dynamically
function track(e)
{
//get the current x,y coordinates
var x =(document.all) ? event.x : e.pageX;
var y =(document.all) ? event.y : e.pageY;

// hide menu 1 if out of bounds.
//Change the coordinates to match the menu heading position and tab width
if(x<381 || x>441 || y<253 || y>323)
m1.style.visibility="hidden";
// hide menu 2 if out of bounds
if(x<450 || x>511 || y<253 || y>323)
m2.style.visibility="hidden";
// hide menu 3 if out of bounds
if(x<520 || x>581 || y<253 || y>323)
m3.style.visibility="hidden";
}

//function that reveals a menu layer
function reveal(menu)
{
if (menu==1) m1.style.visibility="visible";
if (menu==2) m2.style.visibility="visible";
if (menu==3) m3.style.visibility="visible";
}