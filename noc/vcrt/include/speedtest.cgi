#!/usr/bin/perl -w
my $speed=`/usr/local/bin/speedtest-cli --simple --server 3194 | sed -e :a -e '\$!N;s/\\n/ /;ta'`;
sub speed_test{
my $html_speed="
		<html>
		<body>
			$speed
		</body>
		</html>
		";
print $html_speed;
}

&speed_test;
