//
//  SceneVC.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 16.04.2018.
//

import SceneKit

class SceneVC: UIViewController {

    @IBOutlet weak var sceneView: SCNView!

    var device: HolyDevice!

    var cubeNode: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = SCNScene()
        sceneView.scene = scene

        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 3.0)

        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)

        let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        cubeNode = SCNNode(geometry: cubeGeometry)

        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(cubeNode)

//        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
//        sceneView.addGestureRecognizer(panRecognizer)

        device.delegate = self

        device.turnOn()

        device.setNotifyValue(true, for: .sfl)
    }
    @objc func panGesture(_ gestureRecognize: UIPanGestureRecognizer){

        let translation = gestureRecognize.translation(in: gestureRecognize.view!)

        let x = Float(translation.x)
        let y = Float(-translation.y)

        let anglePan = sqrt(pow(x,2)+pow(y,2))*(Float)(M_PI)/180.0

        var rotationVector = SCNVector4()
        rotationVector.x = -y
        rotationVector.y = x
        rotationVector.z = 0
        rotationVector.w = anglePan

        cubeNode.rotation = rotationVector

        //geometryNode.transform = SCNMatrix4MakeRotation(anglePan, -y, x, 0)

        if(gestureRecognize.state == UIGestureRecognizerState.ended) {

            let currentPivot = cubeNode.pivot
            let changePivot = SCNMatrix4Invert( cubeNode.transform)

            cubeNode.pivot = SCNMatrix4Mult(changePivot, currentPivot)

            cubeNode.transform = SCNMatrix4Identity
        }
    }
}

extension SceneVC: HolyDeviceProtocol {
    func holyDevice(_ holyDevice: HolyDevice, didReceiveAccData data: AccelerometerData) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveGyroData data: GyroscopeData) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveMagnetoData data: MagnetometerData) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveBarometerValue value: Int) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveHumidityValue value: Float) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveTemperatureValue value: Float) {

    }

    func connected(_ holyDevice: HolyDevice) {

    }

    func disconnected(_ holyDevice: HolyDevice) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveSFLData data: SFLData) {

        var rotationVector = SCNVector4()
        rotationVector.x = data.x
        rotationVector.y = data.y
        rotationVector.z = data.z
        rotationVector.w = data.w

        cubeNode.rotation = rotationVector
    }
}
