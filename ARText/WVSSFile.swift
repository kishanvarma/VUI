//
//  WVSSFile
//
//  Created by Yogesh Agrawal on 31/03/18.
//  Copyright © 2018 Yogesh Agrawal. All rights reserved.
//
import UIKit
import Foundation

class createScreenShotFromWebView: UIView {
    
    let fileDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    var webView:UIWebView?
    var searchID:Int?
    var imagePath:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setWebView(view: UIWebView) {
        webView = view
    }
    
    func setSearchID(searchID: Int) {
        self.searchID = searchID
    }
    
    func getimagePath() -> String{
        return self.imagePath!
    }
    
    override func draw(_ rect: CGRect) {
        print("inside draw")
        UIGraphicsBeginImageContextWithOptions((self.webView?.scrollView.contentSize)!, false, 0.0)
        self.webView?.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        let currentFileName = String(describing: self.searchID as! Int?) + ".jpeg"
        //let imageData = UIImagePNGRepresentation(image)
        //let currentFileName = String(describing: self.searchID) + ".png"
        
       // print(fileDirectory[0])
        let imageFilePath = (fileDirectory[0] as NSString).appendingPathComponent( currentFileName )
        let imageFileURL = NSURL(fileURLWithPath: imageFilePath)
        
        self.imagePath = imageFilePath
        print(imageFileURL)
        do{
            try imageData?.write(to: imageFileURL as URL)
            print("success")
        }
        catch let error as NSError {
            print(error)
        }
    }
}
