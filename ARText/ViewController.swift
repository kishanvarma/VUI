//
//  ViewController.swift
//  ARTEXT
//
//  Created by Mark Zhong on 8/28/17.
//  Copyright © 2017 Mark Zhong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController,ARSCNViewDelegate, UIPopoverPresentationControllerDelegate,UIWebViewDelegate{
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var growingTextView: NextGrowingTextView!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    let session = ARSession()
    
    var textNode:SCNNode?
    var textSize:CGFloat = 5
    var textDistance:Float = 10
    
    // required for screenshot
    var totalURLs = 0
    var urls = [String]()
    @IBOutlet weak var webView: UIWebView!
    
    var counter = 1
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup sceneView
        
        setupScene()
        SettingsViewController.registerDefaults()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.growingTextView.layer.cornerRadius = 4
        self.growingTextView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.growingTextView.textView.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        self.growingTextView.placeholderAttributedText = NSAttributedString(string: "Placeholder text",
                                                                            attributes: [NSAttributedStringKey.font: self.growingTextView.textView.font!,
                                                                                         NSAttributedStringKey.foregroundColor: UIColor.gray
            ]
        )
        
    }
    
    private var oneGeom: SCNGeometry = {
        let geo = SCNPlane(width: 0.3, height: 0.4)
        //let geo = SCNBox(width: 0.3, height: 0.3, length: 0.4, chamferRadius: 0.01)
        //let geo = SCNCylinder(radius: 0.3, height: 0.4)
        //let geo = SCNSphere(radius: 0.3)
        //let Image = UIImage(named: "Lava")
        let Image = UIImage(named: "art.scnassets/1.png")
        let material = SCNMaterial()
        material.diffuse.contents = Image
        material.locksAmbientWithDiffuse = true
        geo.firstMaterial = material
        return geo
    }()
    
    private var twoGeom: SCNGeometry = {
    let geo = SCNPlane(width: 0.3, height: 0.4)
    //let geo = SCNBox(width: 0.3, height: 0.3, length: 0.4, chamferRadius: 0.01)
    //let geo = SCNCylinder(radius: 0.3, height: 0.4)
    //let geo = SCNSphere(radius: 0.3)
    //let Image = UIImage(named: "Lava")
    let Image = UIImage(named: "art.scnassets/2.png")
    let material = SCNMaterial()
    material.diffuse.contents = Image
    material.locksAmbientWithDiffuse = true
    geo.firstMaterial = material
    return geo
    }()
    
    private var threeGeom: SCNGeometry = {
        let geo = SCNPlane(width: 0.3, height: 0.4)
        //let geo = SCNBox(width: 0.3, height: 0.3, length: 0.4, chamferRadius: 0.01)
        //let geo = SCNCylinder(radius: 0.3, height: 0.4)
        //let geo = SCNSphere(radius: 0.3)
        //let Image = UIImage(named: "Lava")
        let Image = UIImage(named: "art.scnassets/3.png")
        let material = SCNMaterial()
        material.diffuse.contents = Image
        material.locksAmbientWithDiffuse = true
        geo.firstMaterial = material
        return geo
    }()
    
    private var fourGeom: SCNGeometry = {
        let geo = SCNPlane(width: 0.3, height: 0.4)
        //let geo = SCNBox(width: 0.3, height: 0.3, length: 0.4, chamferRadius: 0.01)
        //let geo = SCNCylinder(radius: 0.3, height: 0.4)
        //let geo = SCNSphere(radius: 0.3)
        //let Image = UIImage(named: "Lava")
        let Image = UIImage(named: "art.scnassets/4.png")
        let material = SCNMaterial()
        material.diffuse.contents = Image
        material.locksAmbientWithDiffuse = true
        geo.firstMaterial = material
        return geo
    }()
    
    private var otherGeom: SCNGeometry = {
    let geo = SCNPlane(width: 0.3, height: 0.4)
    //let geo = SCNBox(width: 0.3, height: 0.3, length: 0.4, chamferRadius: 0.01)
    //let geo = SCNCylinder(radius: 0.3, height: 0.4)
    //let geo = SCNSphere(radius: 0.3)
    let Image = UIImage(named: "Lava")
    let material = SCNMaterial()
    material.diffuse.contents = Image
    material.locksAmbientWithDiffuse = true
    geo.firstMaterial = material
    return geo
    }()
    
    func project(i : Int){
        print(i)
        let distance =  textDistance/20
        guard let pointOfView = sceneView.pointOfView else { return }
        let mat = pointOfView.transform
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        let currentPosition = pointOfView.position + (dir * distance)
        let sphereNode = SCNNode();
        switch i {
        case 1:
             sphereNode.geometry = oneGeom
        case 2:
            sphereNode.geometry = twoGeom
        case 3:
            sphereNode.geometry = threeGeom
        case 4:
            sphereNode.geometry = fourGeom
        default:
            sphereNode.geometry = otherGeom
        }
        //sphereNode.camera = SCNCamera()
        sphereNode.position = currentPosition
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    // returns only https links
    func showText(text:String) -> Void{
        let api = GoogleAPI()
        self.urls = api.makeCall(query: text)
        self.totalURLs = self.urls.count
        if !urls.isEmpty {
            
            project(i : counter)
            counter = counter + 1
 
            //self.renderWV() // add check for size of urls
        }
    }
    
    // creating WebUI here
    // currently works for https only
    func renderWV() -> Void{
        let url:String = urls[0]
        urls.removeFirst(1)
        print( url )
        let myWebView:UIWebView = UIWebView( frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height) )
        self.view.addSubview(myWebView)
        let myURL = URL(string: url)
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        myWebView.loadRequest(myURLRequest)
        myWebView.delegate = self
    }
    
    // take screenshot of the WebUI
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (!webView.isLoading) {
            sleep(1)
            let webViewFrame = webView.frame
            let f = createScreenShotFromWebView(frame: webViewFrame)
            f.setWebView(view: webView)
            f.setSearchID(searchID: self.totalURLs - self.urls.count)
            f.draw(webViewFrame)
            webView.frame = webViewFrame
           
            /*
            let imagePath = f.getimagePath()
            project(i,imagePath)
            */
        }
        if !urls.isEmpty {
            self.renderWV() // add check for size of urls
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScene() {
        // set up sceneView
        sceneView.delegate = self
        sceneView.session = session
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = false
        
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1.3
        
        enableEnvironmentMapWithIntensity(25.0)
        
        DispatchQueue.main.async {
            //self.screenCenter = self.sceneView.bounds.mid
        }
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            //camera.wantsExposureAdaptation = true
            //camera.exposureOffset = -1
            //camera.minimumExposure = -1
        }
        
        sceneView.showsStatistics = false
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func handleSendButton(_ sender: AnyObject) {
        if let text = growingTextView.textView.text {
            self.showText(text: text)
        }else{
            print("empty string")
        }
        //print(growingTextView.textView.text)
        self.growingTextView.textView.text = ""
        self.view.endEditing(true)
    }
    
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                self.inputContainerViewBottom.constant =  0
                //textViewBottomConstraint.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.inputContainerViewBottom.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    @IBAction func showSettings(_ button: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingsViewController = storyboard.instantiateViewController(withIdentifier: "settingsViewController") as? SettingsViewController else {
            return
        }
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSettings))
        settingsViewController.navigationItem.rightBarButtonItem = barButtonItem
        settingsViewController.title = "Setting"
        
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        navigationController.modalPresentationStyle = .popover
        navigationController.popoverPresentationController?.delegate = self
        navigationController.preferredContentSize = CGSize(width: sceneView.bounds.size.width - 20, height: sceneView.bounds.size.height - 100)
        self.present(navigationController, animated: true, completion: nil)
        
        navigationController.popoverPresentationController?.sourceView = settingsButton
        navigationController.popoverPresentationController?.sourceRect = settingsButton.bounds
    }
    
    @objc
    func dismissSettings() {
        self.dismiss(animated: true, completion: nil)
        updateSettings()
        
    }
    
    private func updateSettings() {
        //let defaults = UserDefaults.standard
        
        
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) -> Void in
            node.removeFromParentNode()
        }
        
    }
    
    func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if sceneView.scene.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
                sceneView.scene.lightingEnvironment.contents = environmentMap
            }
        }
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
}

