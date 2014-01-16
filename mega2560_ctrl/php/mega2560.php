<?php

# Costants
$CHECKED = "checked";

# System setup
$d_min = 20;
$d_max = 53;
$a_min = 0;
$a_max = 15; 

# User configuration
# d_out array holds digital output pins
# d_iin array holds digital input pins
$d_out = array(50, 52, 53);
$d_in = array(51);

#
# Mega 2560 control terminal IO Functions
#

include 'mega2560_io_func.inc.php';

#
# Main
#

# Read current IOs status
$fp = mega2560_open("/dev/ttyS3");

# Write digital outputs
$d_out_status = array();
foreach ($d_out as $i) {
	if ($_REQUEST['digital_action'] == "set") {
		if (isset($_REQUEST['digital']))
			$key = array_search($i, $_REQUEST['digital']);
		else
			$key = false;
		if ($key !== false)
			$v = 1;
		else
			$v = 0;

		mega2560_cmd($fp, "w d $i $v");

		$d_out_status[$i] = $v;
	} else {
		$out = mega2560_cmd($fp, "r d $i");
		$arr = explode("\n", $out);
		foreach ($arr as $s) {
			$ret = sscanf($s, "%d=%d", $i, $v);
			if ($ret == 2)
				$d_out_status[$i] = $v;
		}
	}
}

# Read Digital inputs
$d_in_status = array();
foreach ($d_in as $v) {
	$out = mega2560_cmd($fp, "r d $v");
	$arr = explode("\n", $out);
	foreach ($arr as $v) {
		$ret = sscanf($v, "%d=%d", $i, $v);
		if ($ret == 2)
			$d_in_status[$i] = $v;
	}
}

mega2560_close($fp);

# Rewrite controls
?>
<h3>Controls</h3>

Digital inputs
<form method=post>
<?php
for ($i = $d_min; $i <= $d_max; $i++) {
	if (!array_key_exists($i, $d_in_status))
		continue;

	$checked ="";
	if ($d_in_status[$i])
		$checked = $CHECKED;

	echo("   <input $checked disabled type=checkbox name=\"digital[]\" value=\"$i\">$i");

}
?>
	<br>
	<input type="submit" name="digital_action" value="load">
</form>

Digital outputs
<form method=post>
<?php
for ($i = $d_min; $i <= $d_max; $i++) {
	if (!array_key_exists($i, $d_out_status))
		continue;

	$checked ="";
	if ($d_out_status[$i])
		$checked = $CHECKED;

	echo("   <input $checked type=checkbox name=\"digital[]\" value=\"$i\">$i");

}
?>
	<br>
	<input type="submit" name="digital_action" value="set">
</form>
