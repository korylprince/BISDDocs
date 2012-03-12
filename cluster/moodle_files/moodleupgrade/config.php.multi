<?php  // Moodle configuration file

//Get site name
if (empty($_SERVER['PHP_SELF'])) die;
$dirpath = explode('/', $_SERVER['PHP_SELF']);
$site = $dirpath[1];

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = 'mysqli';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'ubuntu-db1';
$CFG->dbname    = 'moodle_'.$site;
$CFG->dbuser    = 'root';
$CFG->dbpass    = 'password';
$CFG->prefix    = '';
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbsocket' => 0,
);

//Allow Proxying
$CFG->sslproxy=true;
$CFG->wwwroot   = 'https://moodle.example.com/'.$site;
$CFG->dataroot  = '/var/moodledata/'.$site;
$CFG->admin     = 'admin';

$CFG->directorypermissions = 0777;

#ADD YOUR OWN SALT!
$CFG->passwordsaltmain = 'salt';

require_once(dirname(__FILE__) . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
