<?php
header("Content-Type:application/json");
require "data.php";

$DATABASE_HOST = 'minnow.dk.mysql';
$DATABASE_USER = 'minnow_dkcphbusiness';
$DATABASE_PASS = 'HIDDEN';
$DATABASE_NAME = 'minnow_dkcphbusiness';

$con = mysqli_connect($DATABASE_HOST, $DATABASE_USER, $DATABASE_PASS, $DATABASE_NAME);
if (mysqli_connect_errno()) {
	exit('Serveren er i øjeblikket nede.');
}

$name = $_GET['name'];

switch($name){
    //http://minnow.dk/cphbusiness/alldepartments
    case "alldepartments":
        $response[] = get_all_departments($con);
    break;
    
    //http://minnow.dk/cphbusiness/allemployees
    case "allemployees":
        $response[] = get_all_employees($con);
    break;
    
    //http://minnow.dk/cphbusiness/employee/1
    case "employee":
        $id = $_GET['id'];
        $response[] = get_employee($con, $id);
    break;
    
    default:
        echo json_encode("Invalid Request");
    break;
}

?>