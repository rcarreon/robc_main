<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">

        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">Status Changer</a>
            </div>
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-">


                    <li>
                        <a href="index.php">Home</a>
                    </li>
                    <li>
                        <a href="about.php">About</a>
                    </li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
		   <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown"><?php echo $_COOKIE["username"];  ?> <span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu">
            <li><a href="about.php">About</a></li>
            <li class="divider"></li>
            <li><a href="index.php?logout=true">Logout</a></li>
          </ul>
        </li>
                </ul>
            </div>
        </div>
    </div>
