%For runtime instantiated GameObject, only the prefab mapping is provided. Use that one substituting the gameobject name accordingly.
 %Sensors.
%inter1(intersection1,objectIndex(Index),intersection(x(Value))).
%inter1(intersection1,objectIndex(Index),intersection(z(Value))).
%inter1(intersection1,objectIndex(Index),intersection(lightsNbr1(Index1,segment(id(Value))))).
%inter1(intersection1,objectIndex(Index),intersection(lightsNbr1(Index1,segment(x(Value))))).
%inter1(intersection1,objectIndex(Index),intersection(lightsNbr1(Index1,segment(z(Value))))).
%inter1(intersection1,objectIndex(Index),intersection(lightsNbr2(Index1,segment(id(Value))))).
%inter1(intersection1,objectIndex(Index),intersection(lightsNbr2(Index1,segment(x(Value))))).
%inter1(intersection1,objectIndex(Index),intersection(lightsNbr2(Index1,segment(z(Value))))).
%inter1(intersection1,objectIndex(Index),intersection(toSetRed(Value))).
%inter1(intersection1,objectIndex(Index),intersection(lastFrameSwitch(Value))).
%inter1(intersection1,objectIndex(Index),intersection(frame(Value))).
%van(carVan,objectIndex(Index),vehicleAI(x(Value))).
%van(carVan,objectIndex(Index),vehicleAI(z(Value))).
%van(carVan,objectIndex(Index),vehicleAI(vehicleStatus(value(Value)))).
%van(carVan,objectIndex(Index),vehicleAI(currentSegment(Value))).
%long(carLong8,objectIndex(Index),vehicleAI(x(Value))).
%long(carLong8,objectIndex(Index),vehicleAI(z(Value))).
%long(carLong8,objectIndex(Index),vehicleAI(currentSegment(Value))).
%long(carLong8,objectIndex(Index),vehicleAI(vehicleStatus(value(Value)))).
%coupe(carCoupe8,objectIndex(Index),vehicleAI(x(Value))).
%coupe(carCoupe8,objectIndex(Index),vehicleAI(z(Value))).
%coupe(carCoupe8,objectIndex(Index),vehicleAI(vehicleStatus(value(Value)))).
%coupe(carCoupe8,objectIndex(Index),vehicleAI(currentSegment(Value))).
%Actuators:
setOnActuator(inter1Act(intersection1,objectIndex(Index),intersection(toSetRed(Value)))) :-objectIndex(inter1Act, Index), .

#show setOnActuator/1.