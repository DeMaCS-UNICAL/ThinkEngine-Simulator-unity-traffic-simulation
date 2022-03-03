using System.Collections;
using System.Collections.Generic;
using TrafficSimulation;
using UnityEditor;
using UnityEngine;

public class ReplaceCars : MonoBehaviour
{
    public GameObject coupe;
    public GameObject longs;
    public GameObject van;
    public bool done;
    // Start is called before the first frame update
    void Update()
    {
        if (!done)
        {
            GameObject cars = GameObject.Find("Cars");
            foreach (GameObject currentCoupe in GameObject.FindGameObjectsWithTag("Coupe"))
            {
                GameObject newCoupe = (GameObject)PrefabUtility.InstantiatePrefab(coupe, cars.transform);
                cloneCar(currentCoupe, newCoupe);
            }
            foreach (GameObject currentVan in GameObject.FindGameObjectsWithTag("Van"))
            {
                GameObject newVan = (GameObject)PrefabUtility.InstantiatePrefab(van, cars.transform);
                cloneCar(currentVan, newVan);
            }
            foreach (GameObject currentLong in GameObject.FindGameObjectsWithTag("Long"))
            {
                GameObject newLong = (GameObject)PrefabUtility.InstantiatePrefab(longs, cars.transform);
                cloneCar(currentLong, newLong);
            }
            done = true;
        }
    }

    private static void cloneCar(GameObject currentCoupe, GameObject newCoupe)
    {
        newCoupe.tag = "AutonomousVehicle";
        newCoupe.name = currentCoupe.name;
        newCoupe.transform.position = currentCoupe.transform.position;
        newCoupe.transform.rotation = currentCoupe.transform.rotation;
        newCoupe.transform.localScale = currentCoupe.transform.localScale;
        WheelDrive wd = newCoupe.GetComponent<WheelDrive>();
        WheelDrive currentWd = currentCoupe.GetComponent<WheelDrive>();
        wd.downForce = currentWd.downForce;
        wd.maxAngle = currentWd.maxAngle;
        wd.steeringLerp = currentWd.steeringLerp;
        wd.steeringSpeedMax = currentWd.steeringSpeedMax;
        wd.maxTorque = currentWd.maxTorque;
        wd.brakeTorque = currentWd.brakeTorque;
        wd.unitType = currentWd.unitType;
        wd.minSpeed = currentWd.minSpeed;
        wd.leftWheelShape = currentWd.leftWheelShape;
        wd.rightWheelShape = currentWd.rightWheelShape;
        wd.animateWheels = currentWd.animateWheels;
        wd.driveType = currentWd.driveType;
        VehicleAI vAI = newCoupe.GetComponent<VehicleAI>();
        VehicleAI currentvAI = currentCoupe.GetComponent<VehicleAI>();
        vAI.trafficSystem = currentvAI.trafficSystem;
        vAI.waypointThresh = currentvAI.waypointThresh;
        vAI.raycastLength = currentvAI.raycastLength;
        vAI.raySpacing = currentvAI.raySpacing;
        vAI.raysNumber = currentvAI.raysNumber;
        vAI.emergencyBrakeThresh = currentvAI.emergencyBrakeThresh;
        vAI.slowDownThresh = currentvAI.slowDownThresh;
    }

    // Update is called once per frame

}
