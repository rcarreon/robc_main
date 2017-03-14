define gnlib::replace_entire_line_full ($file, $pattern, $replacement) {

	exec { "/usr/bin/perl -pi -e 's/${pattern}/$replacement/' '$file'":
		onlyif => "/usr/bin/perl -ne 'BEGIN { \$ret = 1; } \$ret = 0 if /$pattern/ && ! /^$replacement\$/ ; END { exit \$ret; }' '$file'",
	}

}
