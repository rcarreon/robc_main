<?php
require_once 'puppetUtils.php';

$userOptions = getUsersOptions();

?>
<html lang="en">
<head>
    <meta charset="utf-8">
	<title> Track Puppet Errors </title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">
	<!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <!-- Optional theme -->
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="js/jquery-ui-1.10.3.custom/css/jquery-ui-1.10.3.custom.min.css">

    <style type="text/css">
		body {
			padding-top: 50px;
		}
		.half {
			width: 50%;
		}
		.ui-dialog{
			z-index: 1050;
		}
		table.tablesorter thead tr .header {
			background-image: url(img/bg.gif);
			background-repeat: no-repeat;
			background-position: center right;
			cursor: pointer;
		}
		table.tablesorter thead tr .headerSortUp {
			background-image: url(img/asc.gif);
		}
		table.tablesorter thead tr .headerSortDown {
			background-image: url(img/desc.gif);
		}
	</style>
</head>

<body>

<div id="container">
<?php require_once 'navbar.php'; ?>
</div>
	<div class="container">
		<h2>Track Puppet Errors</h2>
		<div class="container">
			<form action="index.php" class="form-inline" method="post">
				<h4>Search</h4>
				<div class="form-group">
					<input type="text" class="form-control" id="start_date" placeholder="Start Date">
				</div>
				<div class="form-group">
					<input type="text" class="form-control" id="end_date" placeholder="End Date">
				</div>
				<div class="form-group">
					<input type="text" class="form-control" id="search_host_name" placeholder="Host Name">
				</div>
				<div class="form-group">
					<input type="text" class="form-control" id="search_centos_os" placeholder="Centos OS">
				</div>
				<div class="form-group">
					<select class="form-control" id="search_resolved_by" name="search_resolved_by">
						<option value="">-- Select User --</option>
						<?php echo $userOptions;  ?>
						</select>
				</div>
				<button type="button" class="btn btn-primary" id="searchButton">Search</button>
				<br>
				<button type="button" class="btn btn-warning" id="resetButton" style="margin-top: 5px">Reset Search</button>
				<button type="button" class="btn btn-success newPuppetError" id="addButton" style="margin-top: 5px">Add new Puppet Error</button>
			</form>
		</div>
		<div class="container">
			<h4>Puppet Errors</h4>
			<table id="tbl_puppet_errors" class="table table-bordered table-striped tablesorter" width="90%">
				<thead>
					<tr>
						<th>Error Date</th>
						<th>Host Name</th>
						<th>Centos OS</th>
						<th>Action</th>
						<th>Resolved By</th>
					</tr>
				</thead>
				<tbody>
					<?php
						//function in puppetUtils.php, shows all of the rows
						getAll();
					?>
				</tbody>
			</table>
		</div>
	</div>
    <hr>
	<div id="footer">
		<div class="container span12">
			<p class="text-muted credit">NOC Tools <?php echo date('Y'); ?></p>
		</div>
	</div>

<!-- new puppet error form -->
<div id="newPuppetError" style="display: none" title="Add A New Puppet Error">
	<div class="alert alert-danger validate" style="display: none"><span class="glyphicon glyphicon-warning-sign"></span>&nbsp;Please fill out the required fields!</div>
	<div class="alert alert-danger duplicate" style="display: none"><span class="glyphicon glyphicon-warning-sign"></span>&nbsp;Duplicate row! Please check that this puppet error hasn't already been added!</div>
	<h3>Add A New Puppet Error</h3>
	<form action="index.php" method="post">
		<div class="form-group">
			<label for="error_date">Error Date</label>
			<input type="text" class="form-control" id="error_date" name="error_date" placeholder="Error Date">
		</div>
		<div class="form-group half">
			<label for="error_time">Error Time</label>
			<input type="text" class="form-control col-sm-4" id="error_time" name="error_time" placeholder="hh:mm"><br>
			<small class="text-muted">Set time in 24 hour format</small>
		</div>
		<div class="clearfix"></div>
		<div class="form-group">
			<label for="host_name">Host Name</label>
			<input type="text" class="form-control" id="host_name" name="host_name" placeholder="Host Name">
		</div>
		<div class="form-group">
			<label for="centos_os">Centos OS</label>
			<input type="text" class="form-control" id="centos_os" name="centos_os" placeholder="Centos OS">
		</div>
		<div class="form-group">
			<label for="action">Action Taken</label>
			<textarea rows="3" class="form-control" id="action" name="action"></textarea>
		</div>
		<div class="form-group">
			<label for="resolved_by">Resolved By</label>
			<select class="form-control" id="resolved_by" name="resolved_by">
				<option value="">--Select User--</option>
				<?php
					$userOptions = getUsersOptions(true);
					echo $userOptions;
				?>
			</select>
		</div>
		<button id="sendPuppetError" type="button" class="btn btn-primary">Send</button>
	</form>
</div>
<!-- new puppet error form -->

<script src="js/jquery-1.10.2.min.js"></script>
<script src="js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/jquery.tablesorter.js"></script>
<script type="text/javascript">
	$(function() {
		$('#start_date').datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "yy-mm-dd"
		});

		$('#end_date').datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "yy-mm-dd"
		});

		$(".newPuppetError").click(function(){
			$('#newPuppetError').dialog({
				modal: true,
				width: 600,
				open: function() {
					$('#error_date').datepicker({
						title:'Error Date',
						changeMonth: true,
						changeYear: true,
						dateFormat: "yy-mm-dd"}).blur();
				},
				close: function() {
					$('#error_date').datepicker('destroy');
					$('.alert-danger').hide("");
					$("#error_date").val("");
					$("#error_time").val("");
					$("#host_name").val("");
					$("#centos_os").val("");
					$("#action").val("");
					$("#resolved_by").val("");
				}
			});
		});

		$('#search_host_name').autocomplete({
			source: 'puppetAjax.php?hostAutocomplete=1',
			minLength: 2
		});

		$("#searchButton").click(function() {
			var start_date = $("#start_date").val();
			var end_date = $("#end_date").val();
			var host_name = $("#search_host_name").val();
			var centos = $("#search_centos_os").val();
			var user = $("#search_resolved_by").val() == '-- Select User --' ? "" : $("#search_resolved_by").val();
			var searchErrors = 1;

			$.ajax({
				type: "GET",
				url: 'puppetAjax.php?searchErrors=1&start_date='+start_date+"&end_date="+end_date+"&host="+host_name+"&user="+user+"&centos="+centos,
				success: function (html) {
					var obj = JSON.parse(html);
					var tr  = "";

					for (i=0; i<obj.length; i++) {
						tr += "<tr><td>"+obj[i].error_date+"</td><td>"+obj[i].host_name+"</td><td>"+obj[i].centos_os+"</td><td>"+obj[i].action+"</td><td>"+obj[i].name+"</td></tr>";
					}

					$('#tbl_puppet_errors')
						.unbind('appendCache applyWidgetId applyWidgets sorton update updateCell')
						.removeClass('tablesorter')
						.find('thead th')
						.unbind('click mousedown')
						.removeClass('header headerSortDown headerSortUp');
					$('#tbl_puppet_errors tbody').remove();
					$('#tbl_puppet_errors').append("<tbody>"+tr+"</tbody>")
						.tablesorter()
						.addClass("tablesorter")
						.trigger("update")
						.trigger("sorton", [2,1])
						.trigger("appendCache")
						.trigger("applyWidgets");
				}
			});
		});

		$("#resetButton").click(function(){
			$("#start_date").val("");
			$("#end_date").val("");
			$("#search_host_name").val("");
			$("#search_centos_os").val("");
			$("#search_resolved_by :first-child").attr('selected', 'selected');

			$.ajax({
				type: "GET",
				url: 'puppetAjax.php?getALl=1',
				success: function (html) {
					var obj = JSON.parse(html);
					var tr  = "";

					for (i=0; i<obj.length; i++) {
						tr += "<tr><td>"+obj[i].error_date+"</td><td>"+obj[i].host_name+"</td><td>"+obj[i].centos_os+"</td><td>"+obj[i].action+"</td><td>"+obj[i].name+"</td></tr>";
					}

					$('#tbl_puppet_errors')
						.unbind('appendCache applyWidgetId applyWidgets sorton update updateCell')
						.removeClass('tablesorter')
						.find('thead th')
						.unbind('click mousedown')
						.removeClass('header headerSortDown headerSortUp');
					$('#tbl_puppet_errors tbody').remove();
					$('#tbl_puppet_errors').append("<tbody>"+tr+"</tbody>")
						.tablesorter()
						.addClass("tablesorter")
						.trigger("update")
						.trigger("sorton", [2,1])
						.trigger("appendCache")
						.trigger("applyWidgets");
				}
			});
		});

		$("#tbl_puppet_errors").tablesorter();

		$("#sendPuppetError").click(function(){
			var error_date = $("#error_date").val();
			var error_time = $("#error_time").val();
			var host_name = $("#host_name").val();
			var centos = $("#centos_os").val();
			var action = $("#action").val();
			var user = $("#resolved_by").val();

			if (error_date == "" || error_time == "" || host_name == "" || centos == "" || action == "" || user == "") {
				$(".validate").fadeIn('slow');
			} else {
				action = action.replace(/'/g, "\\'");

				$.ajax({
					type: "GET",
					url: "puppetAjax.php",
					data: "newPuppetError=1&error_date="+error_date+"&error_time="+error_time+"&host_name="+host_name+"&user="+user+"&centos="+centos+"&action="+action,
					success: function(html) {
						if (html != "duplicate") {

							$.ajax({
								type: "GET",
								url: 'puppetAjax.php?getALl=1',
								success: function (html) {
									var obj = JSON.parse(html);
									var tr  = "";

									for (i=0; i<obj.length; i++) {
										tr += "<tr><td>"+obj[i].error_date+"</td><td>"+obj[i].host_name+"</td><td>"+obj[i].centos_os+"</td><td>"+obj[i].action+"</td><td>"+obj[i].name+"</td></tr>";
									}

									$("#newPuppetError").dialog('close');

									$('#tbl_puppet_errors')
										.unbind('appendCache applyWidgetId applyWidgets sorton update updateCell')
										.removeClass('tablesorter')
										.find('thead th')
										.unbind('click mousedown')
										.removeClass('header headerSortDown headerSortUp');
									$('#tbl_puppet_errors tbody').remove();
									$('#tbl_puppet_errors').append("<tbody>"+tr+"</tbody>")
										.tablesorter()
										.addClass("tablesorter")
										.trigger("update")
										.trigger("sorton", [2,1])
										.trigger("appendCache")
										.trigger("applyWidgets");
								}
							});
						} else {
							$(".duplicate").fadeIn('slow');
						}
					}
				});
			}
		});
	});
</script>
</body>
</html>
