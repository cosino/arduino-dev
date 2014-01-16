<?php

#
# Mega 2560 control terminal IO Functions
#

function mega2560_open($dev)
{
	$fp = fopen($dev, "w+");
	if (!$fp) {
        	echo "Error";
        	die();
	}

	return $fp;
}

function mega2560_close($f)
{
	fclose($f);
}

function mega2560_cmd($f, $cmd)
{
	fwrite($f, $cmd . chr(13));

	$ans = "";
	while (1) {
		$data = trim(fgets($f, 128), "\n\r");
		if ($data == "ok" || $data == "ko")
			break;
	
		$ans .= $data . "\n";
	}

	return $ans;
}
