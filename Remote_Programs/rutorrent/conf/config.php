<?php

    $_uname = posix_uname();
    $_pw = posix_getpwuid(posix_geteuid());

	// configuration parameters

	// for snoopy client
	@define('HTTP_USER_AGENT', 'Mozilla/5.0 (Linux x86_64; '.$_uname['nodename'].'; compatible) rutorrent/tag-3.8', true);
	@define('HTTP_TIME_OUT', 30, true);	// in seconds
	@define('HTTP_USE_GZIP', true, true);
	$httpIP = null;				// IP string. Or null for any.

	@define('RPC_TIME_OUT', 10, true);	// in seconds

	@define('LOG_RPC_CALLS', false, true);
	@define('LOG_RPC_FAULTS', true, true);

	// for php
	@define('PHP_USE_GZIP', false, true);
	@define('PHP_GZIP_LEVEL', 2, true);

	$schedule_rand = 10;			// rand for schedulers start, +0..X seconds

	$do_diagnostic = true;
    $log_file = 'error.log';		// path to log file (comment or leave blank to disable logging)

	$saveUploadedTorrents = true;		// Save uploaded torrents to profile/torrents directory or not
	$overwriteUploadedTorrents = false;     // Overwrite existing uploaded torrents in profile/torrents directory or make unique name

    $topDirectory = $_pw['dir'];			// Upper available directory. Absolute path with trail slash.
	$forbidUserSettings = false;

    $scgi_port = 0;
    $scgi_host = 'unix://'.$_pw['dir'].'/private/rtorrent/.socket';

	// For web->rtorrent link through unix domain socket 
	// (scgi_local in rtorrent conf file), change variables 
	// above to something like this:
	//
	// $scgi_port = 0;
	// $scgi_host = "unix:///tmp/rpc.socket";

    $XMLRPCMountPoint = '//rutorrent:@'.gethostname().'/'.$_pw['name'].'/RPC';

	$pathToExternals = array(
		"php" 	=> '',			// Something like /usr/bin/php. If empty, will be found in PATH.
		"curl"	=> '',			// Something like /usr/bin/curl. If empty, will be found in PATH.
		"gzip"	=> '',			// Something like /usr/bin/gzip. If empty, will be found in PATH.
		"id"	=> '',			// Something like /usr/bin/id. If empty, will be found in PATH.
		"stat"	=> '',			// Something like /usr/bin/stat. If empty, will be found in PATH.
	);

	$localhosts = array( 			// list of local interfaces
		"127.0.0.1",
		"localhost",
	);

	$profilePath = '../share';		// Path to user profiles
	$profileMask = 0700;			// Mask for files and directory creation in user profiles.
						// Both Webserver and rtorrent users must have read-write access to it.
						// For example, if Webserver and rtorrent users are in the same group then the value may be 0770.

	$tempDirectory = null;			// Temp directory. Absolute path with trail slash. If null, then autodetect will be used.

	$canUseXSendFile = false;		// If true then use X-Sendfile feature if it exist

	$locale = "UTF8";
