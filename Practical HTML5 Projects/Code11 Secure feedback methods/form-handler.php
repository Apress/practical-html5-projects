<?php
/* FORM-HANDLER.PHP Feedback Form PHP Script Ver 5.0 */ 
// set the email address for the recipient, this setting sends it to your client for example 
//$mailto = "webmasters-mailaddress@your-isp.com" ;
$mailto = "yourclient@clients-isp.com" ;
//choose the subject so that you can recognize emails sent from this form 
$subject = "Help query" ; 
/*The next block of code tells the handler where to find the various documents É
associated with it. In this case the documents and the form are all in the same root É
folder.*/
// list the pages to be displayed, 
$formurl = "http://www.clients-website.com/feedback-form.html" ;
$errorurl = "http://www.clients-website.com/error.html" ; 
$thankyouurl = "http://www. clients-website.com /thankyou.html" ; 
$emailerrurl = "http://www. clients-website.com /emailerr.html" ; 
$errorphoneurl = "http://www. clients-website.com /phonerror.html" ;
$errorsuggesturl = "http://www. clients-website.com /suggesterror.html" ;
$errorboxurl = "http://www. clients-website.com /boxerror.html" ;
$uself = 0;
// ------- Set the information received from the form as $ values --------------- 
$headersep = (!isset( $uself ) || ($uself == 0)) ? "\r\n" : "\n" ; 
/*The following code receives the items from the HTML form and converts them to formats É
 that can be used by the handler, for example, username is converted to $username.*/
$username = $_POST['username'] ; 
$useremail = $_POST['useremail'] ; 
$phone = $_POST['phone']; 
$w98me2000 = $_POST['w98me2000']; 
$xp = $_POST['xp']; 
$vista = $_POST['vista'];
$w7=$_POST['windows7']; 
$computer=$_POST['computer'];
$suggestion = $_POST['suggestion'] ; 
$http_referrer = getenv( "HTTP_REFERER" ); 
if (!isset($_POST['useremail'])) { 
header( "Location: $formurl" );
exit ;}
//Check that all three essential fields are filled in
if (empty($username) || empty($useremail) || empty($suggestion)) { 
header( "Location: $errorurl" ); 
	exit ; }
//Check that at least one box has been ticked
if ((!$w98me2000 and !$xp and !$vista and !$w7)) { 
header( "Location: $errorboxurl" ); 
	exit ; }
//check that no urls have been inserted in the username text area
if (strpos ($username, '://')||strpos($username, 'www') !==false){
header( "Location: $errorsuggesturl" );
exit ; }
//Check that no urls  haves been entered in the phone field
if (strpos ($phone, '://')||strpos($phone, 'www') !==false){
header( "Location: $errorphoneurl" );
exit ; }
//check that no urls have been inserted in the suggestion text area
if (strpos ($suggestion, '://')||strpos($suggestion, 'www') !==false){
header( "Location: $errorsuggesturl" );
exit ; }
if ( ereg( "[\r\n]", $username ) || ereg( "[\r\n]", $useremail )) { 
header( "Location: $errorurl" ); 
exit ; } 
#remove any spaces from beginning and end of email address
$useremail = trim($useremail); 
#Check for permitted email address patterns 
$_name = "/^[-!#$%&\'*+\\.\/0-9=?A-Z^_`{|}~]+"; 
$_host = "([-0-9A-Z]+\.)+"; 
$_tlds = "([0-9A-Z]){2,4}$/i"; 
if(!preg_match($_name."@".$_host.$_tlds,$useremail)) { 
header( "Location: $emailerrurl" ); 
exit ; } 
if (get_magic_quotes_gpc()) { 
$message = stripslashes( $message ); }
if(!$w98me2000) {$w98me2000 = "No";} 
if(!$xp) {$xp = "No";} 
if(!$vista) {$vista = "No";}
if(!$w7) {$w7 = "No";}
if($computer !=null) {$computer = $computer;}
//-- SET UP THE EMAIL’S CONTENT, FORMAT IT, SEND IT. THEN SHOW A THANK YOU PAGE --
$messageproper = 
"This message was sent from:\n" . 
"$http_referrer\n" . 
"------------------------------------------------------------\n" .
"Name of sender: $username\n" . 
"Email of sender: $useremail\n" . 
"Telephone No: $phone\n" . 
"W98,ME,2000?: $w98me2000\n" . 
"XP?: $xp\n" . 
"Vista?: $vista\n" .
"Windows7?: $w7\n" .
"Computer?:$laptop\n" .
"Computer?;$desktop\n" .
"------------------------- MESSAGE -------------------------\n\n" . 
$suggestion . 
"\n\n------------------------------------------------------------\n" ; 
mail($mailto, $subject, $messageproper, "From: \"$username\" <$useremail>" . $headersep . "Reply-To: \"$username\" <$useremail>" . 
$headersep . "X-Mailer: feedback4.php 5.0" ); header( "Location: $thankyouurl" ); exit ; 
?>
