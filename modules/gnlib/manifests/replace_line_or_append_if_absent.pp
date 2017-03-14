define gnlib::replace_line_or_append_if_absent ($file, $pattern, $replacement) {

	exec { "echo '$replacement' >> $file":
		unless => "egrep '(${pattern}|${replacement})' -- $file",
		path => "/bin:/usr/bin"
	}

	exec { "/usr/bin/perl -pi -e 's/^.*${pattern}.*/$replacement/' '$file'":
		onlyif => "/usr/bin/perl -ne 'BEGIN { \$ret = 1; } \$ret = 0 if /$pattern/ && ! /^$replacement\$/ ; END { exit \$ret; }' '$file'",
	}
}
