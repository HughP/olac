<?php
class Api extends Controller {

	function Api()
	{
		parent::Controller();
		$this->load->model("MetricsDB");
	}
	
	function index()
	{
	}

	function jsontest()
	{
		$json = new Services_JSON();
		$data = array("test"=>1,"c"=>array("x"=>1,"y"=>2));
		print $json->encode($data);
	}

	function barChart()
	{
		$arr = $this->uri->uri_to_assoc(3);
		$this->load->view('barchart', $arr);
	}

	function archiveList()
	{
		$tab = $this->MetricsDB->archiveList();
		$json = new Services_JSON();
		print $json->encode($tab);
	}
	
	function OLACMetrics()
	{
		$tab = $this->MetricsDB->OLACMetrics();
		$json = new Services_JSON();
		print $json->encode($tab);
	}
	
	function elementUsage()
	{
		$archiveId = $this->uri->segment(3);
		$tab = $this->MetricsDB->elementUsage($archiveId);
		$json = new Services_JSON();
		print $json->encode($tab);
	}

	function refinementUsage()
	{
		$archiveId = $this->uri->segment(3);
		$tab = $this->MetricsDB->refinementUsage($archiveId);
		$json = new Services_JSON();
		print $json->encode($tab);
	}
	
	function encodingSchemeUsage()
	{
		$archiveId = $this->uri->segment(3);
		$tab = $this->MetricsDB->encodingSchemeUsage($archiveId);
		$json = new Services_JSON();
		print $json->encode($tab);
	}

	function coreElementPct()
	{
		$archiveId = $this->uri->segment(3);
		$tab = $this->MetricsDB->coreElementPct($archiveId);
		$json = new Services_JSON();
		print $json->encode($tab);
	}
}
?>
