<?php

function get_all_departments($con){
    
        $stmt = $con->query("SELECT * FROM Department WHERE 1");

        while ($row = $stmt->fetch_assoc()) 
        {
            $code = $row['code'];
            $name = $row['name'];
            $description = $row['description'];
            
            $arr = array('code' => $code, 'name' => $name, 'description' => $description);

            echo json_encode($arr);
        }
}

function get_all_employees($con){
    
        $stmt = $con->query("SELECT * FROM Employee WHERE 1");

        while ($row = $stmt->fetch_assoc()) 
        {
            $id = $row['id'];
            $department_code = $row['department_code'];
            $project_id = $row['project_id'];
            $firstName = $row['firstName'];
            $lastName = $row['lastName'];
            $email = $row['email'];
            
            $arr = array('id' => $id, 'department_code' => $department_code, 'project_id' => $project_id, 'firstName' => $firstName, 'lastName' => $lastName, 'email' => $email);

            echo json_encode($arr);
        }
}

function get_employee($con, $id){
        
        $stmt = $con->query("SELECT * FROM Employee WHERE id = $id");

        while ($row = $stmt->fetch_assoc()) 
        {
            $id = $row['id'];
            $department_code = $row['department_code'];
            $project_id = $row['project_id'];
            $firstName = $row['firstName'];
            $lastName = $row['lastName'];
            $email = $row['email'];
            
            $arr = array('id' => $id, 'department_code' => $department_code, 'project_id' => $project_id, 'firstName' => $firstName, 'lastName' => $lastName, 'email' => $email);

            echo json_encode($arr);
        }
}
?>