<!-- menu.bdy -->
<div class='img_header'><a href="/" border="0"><img src="/images/banner.jpg"></a></div>
<div id='cssmenu'>
        <ul>
          <li class='has-sub '><a href='/index.php'><span>Home</span></a>
            <ul>
              <li><a href='/indexGanglia.php'><span>Home using Ganglia Graphs</span></a></li>
            </ul>
          </li>
	  <li><a href="/ticket_search.php"><span>NOC reports search </span></a></li>
          <li class='has-sub '><a href='/site.php?'><span>VisualGrafito®</span></a>
            <ul>
              <li><a href='/siteGanglia.php'><span>Ganglia Graphs</span></a></li>
            </ul>
          </li>
          <li><a href='http://toolshed.gnmedia.net/toolshed/sqlps/' target='_blank'><span>Toolshed</span></a></li>
          <li><a href='http://vipvisual.gnmedia.net/' target='_blank'><span>VipVisual</span></a></li>
          <li><a href='/puppet-errors/'><span>Puppet Errors</span></a></li>
          <?php

          if ($user->name!="jdoe")
            //echo "<li><a href='login.php'><span> User: $username </span></a></li>";
            echo "<li class='has-sub '><a href='/login.php'><span> User: $user->fullname </span></a>";
          else
            //echo "<li><a href='login.php'><span> Login  </span></a></li>";
            echo "<li class='has-sub '><a href='/login.php'><span> Login </span></a>";
          ?>
            <ul>
            <?php
            if ( (isset($site)&&($site!="")&&$user->name!="jdoe")  || (isset($time)&&($time!="")) || (isset($from)&&($from!=""))&&(isset($until)&&($until!="")) )
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
</div>
<!-- menu.bdy  end -->
