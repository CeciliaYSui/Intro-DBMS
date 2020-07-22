<?php
$servername = "127.0.0.1";
$username = "root";
$password = "root";
$companydb = "company";

// Create connection
$conn = new mysqli($servername, $username, $password, $companydb);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "Connected successfully\n";

$result = $conn->query("SELECT * FROM EMPLOYEE");
while ($row = $result->fetch_assoc()) {
	echo "employee " . $row["Fname"]. " works for " . $row["Dno"]. "\n";
}

$conn->close();
?>

