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

minDistanceFromLight(10).
maxDistanceFromLight(20).
intersectionX(V):-inter1(_,_,intersection(x(V))).
intersectionZ(V):-inter1(_,_,intersection(z(V))).

segments(1,ID,X,Z):-inter1(intersection1,objectIndex(Index),intersection(lightsNbr1(Index1,segment(id(ID))))),
					inter1(intersection1,objectIndex(Index),intersection(lightsNbr1(Index1,segment(x(X))))),
					inter1(intersection1,objectIndex(Index),intersection(lightsNbr1(Index1,segment(z(Z))))).

segments(2,ID,X,Z):-inter1(intersection1,objectIndex(Index),intersection(lightsNbr2(Index1,segment(id(ID))))),
					inter1(intersection1,objectIndex(Index),intersection(lightsNbr2(Index1,segment(x(X))))),
					inter1(intersection1,objectIndex(Index),intersection(lightsNbr2(Index1,segment(z(Z))))).

vehicle(Ve,Seg,St,X,Z):-coupe(_,objectIndex(Ve),vehicleAI(currentSegment(Seg))),
						coupe(_,objectIndex(Ve),vehicleAI(vehicleStatus(value(St)))),
						coupe(_,objectIndex(Ve),vehicleAI(x(X))),
						coupe(_,objectIndex(Ve),vehicleAI(z(Z))).

vehicle(Ve,Seg,St,X,Z):-long(_,objectIndex(Ve),vehicleAI(currentSegment(Seg))),
						long(_,objectIndex(Ve),vehicleAI(vehicleStatus(value(St)))),
						long(_,objectIndex(Ve),vehicleAI(x(X))),
						long(_,objectIndex(Ve),vehicleAI(z(Z))).

vehicle(Ve,Seg,St,X,Z):-van(_,objectIndex(Ve),vehicleAI(currentSegment(Seg))),
						van(_,objectIndex(Ve),vehicleAI(vehicleStatus(value(St)))),
						van(_,objectIndex(Ve),vehicleAI(x(X))),
						van(_,objectIndex(Ve),vehicleAI(z(Z))).

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
switch :- inter1(_,objectIndex(Index),intersection(toSetRed(LightGroup))), stop(LightGroup1), LightGroup<>LightGroup1.

%:~ stop(LightGroup),numberOfVehiclesAtLight(LightGroup,N). [N*2@3,LightGroup,N]
%:~ stop(LightGroup), numberOfComingVehiclesAtLight(LightGroup,N). [N@3,LightGroup,N]
:~ stop(LightGroup), numberOfVehiclesAtLight(LightGroup,N), switch. [N*2@3,LightGroup,N]
:~ stop(LightGroup), numberOfComingVehiclesAtLight(LightGroup,N), switch. [N*2@2,LightGroup,N]
:~ stop(LightGroup), numberOfVehiclesAtLight(LightGroup,N). [N@3,LightGroup,N]
:~ stop(LightGroup), numberOfComingVehiclesAtLight(LightGroup,N). [N@2,LightGroup,N]




setOnActuator(inter1Act(intersection1,objectIndex(Index),intersection(toSetRed(LightGroup)))) :-objectIndex(inter1Act, Index),stop(LightGroup).

#show setOnActuator/1.
#show numberOfVehiclesAtLight/2.
#show numberOfComingVehiclesAtLight/2.
#show segments/4.