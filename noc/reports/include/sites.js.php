<?php
error_reporting(E_ALL);
header("Content-type: text/javascript");

$SITES = `/usr/local/bin/rt ls -s -t asset "Type = 'Site' AND Status != 'retired' AND Status = 'production'  AND 'CF.{MonitorPriority}' != 'Off'" | sed -e 's/.*: //g;s/.*/\"&\",/g' | sort | sed "$ s/\",/\"/g" | grep -v -E "/|^\"analytics|^external|^trigger|origin.evolvemediacorp.com|assets|microsites.gorillanation|geo.g|^widget|^\"campaigns"`;


?>
 $(function() {
    var availableSites = [
<?php echo $SITES; ?>
   ];
$( "#inputbox" ).autocomplete({
      source: availableSites,
      minLength: 3
    });
  });
