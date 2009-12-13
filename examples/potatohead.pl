use VRML;

$vrml = new VRML (2.0);
$vrml->browser('Live3d')
->background('lightblue','starbak.gif','brown')
->title('Potato Head')
->headlight("on")
->cameras_begin
->camera_set
->light("0 0 -1",.3)
->def("HEAD")
->transform_begin
    ->touchsensor("HEAD-TOUCH")
    ->at("s=4 3 2")->sphere(1,"d=orange; e=orange%30")->back
    ->at("0 4 0")->cone([2, 3],"blue")->back
    ->at("-1 1 1")
        ->def("eye")->begin
	    ->sphere(.9,"white")
	    ->at("0 .1 .8")->sphere(.2,"black")->back
	->end
    ->back
    ->at("1 1 1")->use("eye")->back
    ->at("r=1 0 0 90; 0 -0.3 2.5")->cone([.5, 2],"red")->back
    ->at("0 -.4 0.7; r=1 0 0 80")->cylinder("2 1","red")->back
->transform_end
->at("0 -3 0")->cylinder("0.8 2","yellow")->back
->at("0 -6.5 0")->touchsensor("BODY-TOUCH")->cylinder("2.5 6",'darkgreen')->back
->def("ARM")->at("0 -5.5 0")
    ->at("-4 2 0; r=0 0 1 1")
    ->def("arm")->cylinder(".5 6",'green')->back
->back
->at("4 -3.5 0; r=0 0 1 -1")->use("arm")->back
->at("1.2 -12 0")->def("leg")->cylinder(".5 5",'green')->back
->at("-1.2 -12 0")->use("leg")->back
->at("1.2 -14.5 0.3")->def("shoe")->cube("1.4 .5 2",'black')->back
->at("-1.2 -14.5 0.3")->use("shoe")->back
->sound("hallo.wav","HALLO",undef,"0 0 -1",undef,undef,2)
->DEF("MOVE")->VRML_put("PositionInterpolator {
    key [ 0, .5, 1]
    keyValue [0 0 0, 0 1 0, 0 0 0]
}\n")
->DEF("TURN")->VRML_put("OrientationInterpolator {
    key [ 0, .2, .5, .7, 1]
    keyValue [0 0 1 0, 0 0 1 .5, 0 0 1 0, 0 0 1 .5, 0 0 1 0]
}\n")
->timesensor("TS1",0.5)
->timesensor("TS2",2)
->ROUTE("HEAD-TOUCH.touchTime","TS1.startTime")
->ROUTE("HEAD-TOUCH.touchTime","HALLO.startTime")
->ROUTE("TS1.fraction_changed","MOVE.set_fraction")
->ROUTE("MOVE.value_changed","HEAD.set_translation")
->ROUTE("BODY-TOUCH.touchTime","TS2.startTime")
->ROUTE("BODY-TOUCH.touchTime","HALLO.startTime")
->ROUTE("TS2.fraction_changed","TURN.set_fraction")
->ROUTE("TURN.value_changed","ARM.set_rotation")
->camera_auto_set(1.5)
->cameras_end
->save
->print;
