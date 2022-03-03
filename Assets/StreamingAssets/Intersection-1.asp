%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(x(V))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(z(V))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(lightsNbr1(P,trafficSimulationSegment(id(V))))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(lightsNbr1(P,trafficSimulationSegment(x(V))))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(lightsNbr1(P,trafficSimulationSegment(z(V))))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(lightsNbr2(P,trafficSimulationSegment(id(V))))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(lightsNbr2(P,trafficSimulationSegment(x(V))))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(lightsNbr2(P,trafficSimulationSegment(z(V))))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(toSetRed(V))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(lastFrameSwitch(V))).
%inter1(intersection1,objectIndex(X),trafficSimulationIntersection(frame(V))).
%van(carVan,objectIndex(X),trafficSimulationVehicleAI(x(V))).
%van(carVan,objectIndex(X),trafficSimulationVehicleAI(z(V))).
%van(carVan,objectIndex(X),trafficSimulationVehicleAI(vehicleStatus(value(V)))).
%van(carVan,objectIndex(X),trafficSimulationVehicleAI(currentSegment(V))).
%long(carLong8,objectIndex(X),trafficSimulationVehicleAI(x(V))).
%long(carLong8,objectIndex(X),trafficSimulationVehicleAI(z(V))).
%long(carLong8,objectIndex(X),trafficSimulationVehicleAI(vehicleStatus(value(V)))).
%long(carLong8,objectIndex(X),trafficSimulationVehicleAI(currentSegment(V))).
%coupe(carCoupe8,objectIndex(X),trafficSimulationVehicleAI(x(V))).
%coupe(carCoupe8,objectIndex(X),trafficSimulationVehicleAI(z(V))).
%coupe(carCoupe8,objectIndex(X),trafficSimulationVehicleAI(vehicleStatus(value(V)))).
%coupe(carCoupe8,objectIndex(X),trafficSimulationVehicleAI(currentSegment(V))).

minDistanceFromLight(10).
maxDistanceFromLight(20).
intersectionX(V):-inter1(_,_,trafficSimulationIntersection(x(V))).
intersectionZ(V):-inter1(_,_,trafficSimulationIntersection(z(V))).

segments(1,ID,X,Z):-inter1(_,objectIndex(Index),trafficSimulationIntersection(lightsNbr1(Pos,trafficSimulationSegment(id(ID))))),
					inter1(_,objectIndex(Index),trafficSimulationIntersection(lightsNbr1(Pos,trafficSimulationSegment(x(X))))),
					inter1(_,objectIndex(Index),trafficSimulationIntersection(lightsNbr1(Pos,trafficSimulationSegment(z(Z))))).

segments(2,ID,X,Z):-inter1(_,objectIndex(Index),trafficSimulationIntersection(lightsNbr2(Pos,trafficSimulationSegment(id(ID))))),
					inter1(_,objectIndex(Index),trafficSimulationIntersection(lightsNbr2(Pos,trafficSimulationSegment(x(X))))),
					inter1(_,objectIndex(Index),trafficSimulationIntersection(lightsNbr2(Pos,trafficSimulationSegment(z(Z))))).

vehicle(Ve,Seg,St,X,Z):-coupe(_,objectIndex(Ve),trafficSimulationVehicleAI(currentSegment(Seg))),
						coupe(_,objectIndex(Ve),trafficSimulationVehicleAI(vehicleStatus(value(St)))),
						coupe(_,objectIndex(Ve),trafficSimulationVehicleAI(x(X))),
						coupe(_,objectIndex(Ve),trafficSimulationVehicleAI(z(Z))).

vehicle(Ve,Seg,St,X,Z):-long(_,objectIndex(Ve),trafficSimulationVehicleAI(currentSegment(Seg))),
						long(_,objectIndex(Ve),trafficSimulationVehicleAI(vehicleStatus(value(St)))),
						long(_,objectIndex(Ve),trafficSimulationVehicleAI(x(X))),
						long(_,objectIndex(Ve),trafficSimulationVehicleAI(z(Z))).

vehicle(Ve,Seg,St,X,Z):-van(_,objectIndex(Ve),trafficSimulationVehicleAI(currentSegment(Seg))),
						van(_,objectIndex(Ve),trafficSimulationVehicleAI(vehicleStatus(value(St)))),
						van(_,objectIndex(Ve),trafficSimulationVehicleAI(x(X))),
						van(_,objectIndex(Ve),trafficSimulationVehicleAI(z(Z))).

interestingVehicle(Ve,LightGroup):-vehicle(Ve,Seg,_,_,_),segments(LightGroup,Seg,_,_).

vehicleToCompareOnZ(Ve,Z) :- interestingVehicle(Ve,_), vehicle(Ve,Seg,_,X,Z),segments(_,Seg,X,Z1), Z<>Z1.
vehicleToCompareOnX(Ve,X) :- interestingVehicle(Ve,_), vehicle(Ve,Seg,_,X,Z),segments(_,Seg,X1,Z), X<>X1.

vehicleAbsZ(Ve, -Z):- vehicleToCompareOnZ(Ve,Z), Z<0.
vehicleAbsZ(Ve, Z) :- vehicleToCompareOnZ(Ve,Z), Z>0.
vehicleAbsX(Ve, -X):- vehicleToCompareOnX(Ve,X), X<0.
vehicleAbsX(Ve, X) :- vehicleToCompareOnX(Ve,X), X>0.

intersectionAbsX(X) :- intersectionX(X), X>0.
intersectionAbsX(-X):- intersectionX(X), X<0.
intersectionAbsZ(Z) :- intersectionZ(Z), Z>0.
intersectionAbsZ(-Z):- intersectionZ(Z), Z<0.

distanceFromIntersection(Ve,D) :- vehicleAbsZ(Ve, Z), intersectionAbsZ(Z1), D=Z-Z1, Z>Z1. 
distanceFromIntersection(Ve,D) :- vehicleAbsZ(Ve, Z), intersectionAbsZ(Z1), D=Z1-Z, Z<=Z1. 
distanceFromIntersection(Ve,D) :- vehicleAbsX(Ve, X), intersectionAbsX(X1), D=X-X1, X>X1. 
distanceFromIntersection(Ve,D) :- vehicleAbsX(Ve, X), intersectionAbsX(X1), D=X1-X, X<=X1.

nearestVehiclesAtLight(LightGroup,Ve) :- interestingVehicle(Ve,LightGroup), distanceFromIntersection(Ve,D), minDistanceFromLight(D1), D<D1.
numberOfVehiclesAtLight(LightGroup,N) :- #count{Ve : nearestVehiclesAtLight(LightGroup,Ve)}=N, nearestVehiclesAtLight(LightGroup,_).
comingVehiclesAtLigh(LightGroup,Ve) :- interestingVehicle(Ve,LightGroup), distanceFromIntersection(Ve,D), distanceFromLight(D1),maxDistanceFromLight(D2), D<D2, D>=D1.
numberOfComingVehiclesAtLight(LightGroup,N) :- #count{Ve : comingVehiclesAtLigh(LightGroup,Ve)}=N, comingVehiclesAtLigh(LightGroup,_).

{stop(LightGroup) : segments(LightGroup,_,_,_)}=1.
switch :- inter1(intersection1,objectIndex(X),trafficSimulationIntersection(toSetRed(LightGroup))), stop(LightGroup1), LightGroup<>LightGroup1.

%:~ stop(LightGroup),numberOfVehiclesAtLight(LightGroup,N). [N*2@3,LightGroup,N]
%:~ stop(LightGroup), numberOfComingVehiclesAtLight(LightGroup,N). [N@3,LightGroup,N]
:~ stop(LightGroup), numberOfVehiclesAtLight(LightGroup,N), switch. [N*2@3,LightGroup,N]
:~ stop(LightGroup), numberOfComingVehiclesAtLight(LightGroup,N), switch. [N*2@2,LightGroup,N]
:~ stop(LightGroup), numberOfVehiclesAtLight(LightGroup,N). [N@3,LightGroup,N]
:~ stop(LightGroup), numberOfComingVehiclesAtLight(LightGroup,N). [N@2,LightGroup,N]




setOnActuator(inter1Act(intersection1,objectIndex(X),trafficSimulationIntersection(toSetRed(LightGroup)))):-objectIndex(inter1Act,X),stop(LightGroup).
