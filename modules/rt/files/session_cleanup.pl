#!/usr/bin/perl                                                                                                                            
use lib qw(/usr/share/rt3/lib);                                                                                                                  
use RT;                                                                                                                                    
RT::LoadConfig();                                                                                                                          
RT::Init();                                                                                                                                
$RT::Handle->SimpleQuery("delete from sessions where LastUpdated < (now() - interval 1 hour)");
