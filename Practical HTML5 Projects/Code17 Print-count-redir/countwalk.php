
<?php
$COUNT_FILE = "countwalk.dat";
if (file_exists($COUNT_FILE)) {
	$fp = fopen("$COUNT_FILE", "r+");
	flock($fp, 1);
	$count = fgets($fp, 4096);
	$count += 1; 
	fseek($fp,0);
	fputs($fp, $count);
	flock($fp, 3);
	fclose($fp);
} else {
	echo "Can't find file, check '\$file'<br>";
}

?>
<small>
<?php echo $count; 
?>
<a href=”http://www.cj-design.com>&copy;CJ Counter</a>
</small>
