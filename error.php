<?php
if (isset($_POST)) {
    $input = file_get_contents("php://input");
    $data = json_decode($input);

    $denied = $data->Denied;
    $una = $data->Una;
    $time = $data->Time;
    $unk = $data->Unk;
    $support = 'Geolocation is not supported!';

    if (isset($denied)) {
        $f = fopen('error.txt', 'w+');
        fwrite($f, $denied);
        fclose($f);
    } elseif (isset($una)) {
        $f = fopen('error.txt', 'w+');
        fwrite($f, $una);
        fclose($f);
    } elseif (isset($time)) {
        $f = fopen('error.txt', 'w+');
        fwrite($f, $time);
        fclose($f);
    } elseif (isset($unk)) {
        $f = fopen('error.txt', 'w+');
        fwrite($f, $unk);
        fclose($f);
    } else {
        $f = fopen('error.txt', 'w+');
        fwrite($f, $support);
        fclose($f);
    }
}
?>