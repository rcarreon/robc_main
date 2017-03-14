<div class="navbar navbar-inverse navbar-fixed-top">
	<div class="navbar-inner">
		<div class="container">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="#">NOC Tools</a>
			<div class="navbar-collapse collapse">
				<ul class="nav navbar-nav">
					<li><a href="/ticket_search.php">Noc Reports Search</a></li>
					<li><a href="#">Visual Grafito&reg;</a></li>
					<li><a href="#">Toolshed</a></li>
					<li><a href="#">VipVisual</a></li>
					<li class="active"><a href="/puppet-errors">Track Puppet Errors</a></li>
					<li class="dropdown">
						<a href="/login.php" class="dropdown-toggle" data-toggle="dropdown">User <?php if (isset($user)) { echo $user->fullname; } ?><b class="caret"></b></a>
						<ul class="dropdown-menu">
							<?php
							if ($user->name =="jdoe") {
								//echo "<li><a href='login.php'><span> Login  </span></a></li>";
								echo "<li class='has-sub '><a href='/login.php'><span> Login </span></a>";
							}
							if ( (isset($site)&&($site!="")&&$user->name!="jdoe")  || (isset($time)&&($time!="") ))
							{
								echo "<li><a href=\"javascript: document.graphicsform.submit();\"><span>Mail Preview</span></a></li>";
							}
							if ($user->name!="jdoe")
							{
								echo "<li><a href='/user_settings.php'><span>User Settings</span></a></li>";
							}
							?>
							<li><a href='http://docs.gnmedia.net/wiki/NOC_Guide' target='_blank'><span>User's Manual</span></a></li>
							<?php
							if ($user->name!="jdoe")
							{
								echo  "<li><a href= '/logout.php'><span>Log out</span></a></li>";
							}
							?>
						</ul>

					</li>
				</ul>
			</div><!--/.nav-collapse -->
		</div>
	</div>
</div>