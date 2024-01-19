<?php
if (isset($_POST)) {
    $input = file_get_contents("php://input");
    $data = json_decode($input);
    file_put_contents("data.txt", $data->data);
}
?>