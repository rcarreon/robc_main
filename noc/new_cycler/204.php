<?php
/**
 * This script only purpose is to send a 204 HTTP status which the
 * "frameBusterBuster" function in auto_cycler.js requires to properly work.
 */
header("HTTP/1.1 204 No Response");
?>
