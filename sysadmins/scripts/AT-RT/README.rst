Command Line Interface for Pingdom REST API
==================================

Description
-----------

Simple command line interface for the Pingdom REST API.

Dependencies
------------
- Python
- drcraig's Python Module for Pingdom REST API: https://github.com/drcraig/python-restful-pingdom

Usage
-----

pingdom-cli COMMAND CHECK_NAME [PARAMS]

Commands:

add
    add a site check
delete
    delete a check by name
info
    get JSON dump of check info
modify
    modify a check
listnames
    list all check names
listids
    list all check ids

Examples:

# List checks
    pingdom-cli listnames

# Add check
    pingdom-cli add www.example.com

# Get check info
    pingdom-cli info www.example.com

# Modifiy a check, in this case, pause it
    pingdom-cli modify www.example.com '{"paused": true}'

# Delete check
    pingdom-cli delete www.example.com 
