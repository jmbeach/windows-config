function Rotate-Monitor3([bool] $vertical) {
    $rotation = 0;
    if ($vertical) {
        $rotation = 90;
    }

    display.exe /device:3 /rotate $rotation
}