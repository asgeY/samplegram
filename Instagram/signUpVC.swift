//
//  signUpVC.swift
//  Instagram
//
//  Created by Shao Kahn on 9/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,CropViewControllerDelegate,selectCellDelegate,goBackDelegate{
    
    @IBOutlet var tipSelectedView: [UIView]!
    
    @IBOutlet weak var gradientImgView: UIImageViewX!
    
    @IBOutlet weak var avaImgView: UIImageView!
    
    @IBOutlet var allTextFieldsInScreen: [UITextField_Attributes]!
        {didSet{_ = self.allTextFieldsInScreen.map{$0.delegate = self
            $0.rightView?.frame = CGRect(x: 0, y: 0, width: 30 , height: 30)
            $0.rightViewMode = .unlessEditing
            }
        }
    }
    
    @IBOutlet var allCountTip: [UILabel]!
        {didSet{
            _ = allCountTip.map{
                $0.layer.borderColor = UIColor.white.cgColor
                $0.layer.borderWidth = 3}}}
    
    @IBOutlet var allTipLabelsInScreen: [UILabel]!
        {didSet{_ = self.allTipLabelsInScreen.map{$0.textColor = .red}
        }}
    
    @IBOutlet weak var signUpBtn: TransitionButton!
    @IBOutlet weak var cancelBtn: UIButton_Attributes!{
        didSet{self.cancelBtn.backDelegate = self}
    }
    
    //profile crop image
    var image: UIImage? = #imageLiteral(resourceName: "profile")
    
    //profile crop rect & angle
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    
    //input curosr shown textfield
    fileprivate var currentTextField:UITextField!
    
    //background gradient colors tuple type array
    fileprivate var colorArray:[(color1:UIColor,color2:UIColor)] = []
    fileprivate var currentColorArrayIndex = -1
    
    //if mark image show , get true, if not,false
    fileprivate var tempMarkArr = [Bool].init(repeating: false, count: 7)
    
    //loading view on textfield right view
    fileprivate let views = UIView()
    
    //text on same textfield which input again
    fileprivate var isChanged = false
    
    //shown text when input same textfield again
    fileprivate var tempText = ""
    
    // check if it is be taken animation
   fileprivate let rootLayer:CALayer = {
        let rootLayer = CALayer()
        rootLayer.backgroundColor = UIColor.black.cgColor
        return rootLayer
    }()
   fileprivate let circle:CALayer = {
        let circle = CALayer()
        circle.frame = CGRect(origin: CGPoint.zero,size: CGSize(width: 7, height: 7))
        circle.backgroundColor = UIColor.blue.cgColor
        circle.cornerRadius = 5
        return circle
    }()
   fileprivate let replicatorLayer:CAReplicatorLayer = {
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: -22, y: -5, width: 20, height: 20)
        replicatorLayer.borderColor = UIColor.clear.cgColor
        replicatorLayer.cornerRadius = 5.0
        replicatorLayer.borderWidth = 1.0
        replicatorLayer.instanceCount = 9
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(-CGFloat.pi * 2 / CGFloat(9), 0, 0, 1)
        return replicatorLayer
    }()
  fileprivate  let shrinkAnimation:CABasicAnimation = {
        let shrinkAnimation = CABasicAnimation(keyPath: "transform.scale")
        shrinkAnimation.fromValue = 1
        shrinkAnimation.toValue = 0.1
        shrinkAnimation.duration = 0.5
        shrinkAnimation.repeatCount = Float.infinity
        return shrinkAnimation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        //create tap gesture
        createScreenDismissKeyboard()
        
        //ava image layer
        setAvaImgLayer()
        
        //declare select image
        declareSelectedImage()
        
        //add gradient colors on buttons
        initInputFirst()
        
        //create check targets
        createCheckTargets()
        
        //set image color set
        setColorArr()
        
        //recursively run animatedBackground()
        animatedBackground()
        
        //put profile setting buttton on screen
        configueProfileSettingBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create observers
        createObservers()
        
        //change text field to enable
        changeTextfieldToEnable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove observers
        removeObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //click sign up
    @IBAction func signUpBtn_click(_ sender: TransitionButton) {
        
        _ = allTextFieldsInScreen.map{$0.isEnabled = false}
        cancelBtn.isEnabled = false
        
        sender.startAnimation()
        
        //send data to server to relative columns
        let user = PFUser()
        user.username = allTextFieldsInScreen[0].text?.lowercased()
        user.email = allTextFieldsInScreen[4].text?.lowercased()
        user.password = allTextFieldsInScreen[2].text
        user["fullname"] = allTextFieldsInScreen[1].text?.lowercased()
        user["bio"] = allTextFieldsInScreen[6].text
        user["web"] = allTextFieldsInScreen[5].text?.lowercased()
        
        //in Edited Profile it's gonna be assigned
        user["tel"] = ""
        user["gender"] = ""
        
        //convert our image for sending to server
        guard let avaData = UIImageJPEGRepresentation(avaImgView.image!, 0.5),let avaFile = PFFile(name: "ava.jpg", data: avaData) else
        {return}
        user["ava"] = avaFile
        
        //save data in server
        user.signUpInBackground { (success:Bool, error:Error?) in
            if success{
                
                //remember logged user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                sender.stopAnimation(animationStyle: .expand, revertAfterDelay: 1.0, completion: {
                    
                    //call login func from AppleDelegate.swift class
                    (UIApplication.shared.delegate as! AppDelegate).login()
                })
            }else{
                sender.stopAnimation(animationStyle: .shake, revertAfterDelay: 1.0, completion: nil)
                print(error ?? "")
                _ = self.allTextFieldsInScreen.map{$0.isEnabled = true}
                self.cancelBtn.isEnabled = true
            }
        }
    }
    
}//signUpVC class over line

//custom functions
extension signUpVC {
    
    fileprivate func changeTextfieldToEnable(){
        _ = self.allTextFieldsInScreen.map{$0.isEnabled = true}
        cancelBtn.isEnabled = true
    }
    
    fileprivate func configueProfileSettingBtn(){
        
        var profileSettingBtn = dropDownBtn()
        profileSettingBtn = dropDownBtn.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        profileSettingBtn.translatesAutoresizingMaskIntoConstraints = false
        profileSettingBtn.dropView.tapDelegate = self
        self.view.addSubview(profileSettingBtn)
        
        profileSettingBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileSettingBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileSettingBtn.bottomAnchor.constraint(equalTo: avaImgView.bottomAnchor).isActive = true
        profileSettingBtn.leftAnchor.constraint(equalTo: avaImgView.rightAnchor, constant: 10).isActive = true
        
        profileSettingBtn.dropView.dropDownOptions = ["Choose from photo library","Reset to default"]
    }
    
    fileprivate func createScreenDismissKeyboard(){
        let gestrue = UITapGestureRecognizer.init(target: self, action: #selector(tapGestrue))
        self.view.addGestureRecognizer(gestrue)
    }
    
    fileprivate  func setAvaImgLayer(){
        avaImgView.layer.cornerRadius = avaImgView.frame.size.width / 2
        avaImgView.clipsToBounds = true
        avaImgView.layer.borderWidth = 3
        avaImgView.layer.borderColor = UIColor.white.cgColor
    }
    
    //add gradient colors on buttons
    fileprivate func initInputFirst(){
        
        signUpBtn.applyGradient(gradient: CAGradientLayer(), colours: [UIColor(hex:"000000"),UIColor(hex:"FF0000")], locations: [0.0,1.0], stP: CGPoint(x:0.0,y:0.0), edP: CGPoint(x:1.0,y:0.0), gradientAnimation: CABasicAnimation())
        
        cancelBtn.applyGradient(gradient: CAGradientLayer(), colours: [UIColor(hex: "FC5C7D"), UIColor(hex: "6A82FB")], locations:[0.0,1.0], stP: CGPoint(x:0.0, y:0.0), edP: CGPoint(x:1.0, y:0.0), gradientAnimation: CABasicAnimation())
    }
    
    //declare select image
    fileprivate func declareSelectedImage(){
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        avaTap.numberOfTapsRequired = 1
        avaImgView.isUserInteractionEnabled = true
        avaImgView.addGestureRecognizer(avaTap)
    }
    
    //set image color set
    fileprivate func setColorArr(){
        colorArray.append(contentsOf: [(color1: #colorLiteral(red: 0.2039215686, green: 0.9098039216, blue: 0.6196078431, alpha: 1), color2: #colorLiteral(red: 0.05882352941, green: 0.2039215686, blue: 0.262745098, alpha: 1)),(color1: #colorLiteral(red: 0.03529411765, green: 0.2117647059, blue: 0.2156862745, alpha: 1), color2: #colorLiteral(red: 0.2666666667, green: 0.6274509804, blue: 0.5529411765, alpha: 1)),(color1: #colorLiteral(red: 0.4039215686, green: 0.6980392157, blue: 0.4352941176, alpha: 1), color2: #colorLiteral(red: 0.2980392157, green: 0.6352941176, blue: 0.8039215686, alpha: 1)),(color1: #colorLiteral(red: 0, green: 0.7647058824, blue: 1, alpha: 1), color2: #colorLiteral(red: 1, green: 1, blue: 0.1098039216, alpha: 1)),(color1: #colorLiteral(red: 0.968627451, green: 0.6156862745, blue: 0, alpha: 1), color2: #colorLiteral(red: 0.3921568627, green: 0.9529411765, blue: 0.5490196078, alpha: 1))])
    }
    
    //recursively run animatedBackground()
    fileprivate func animatedBackground(){
        currentColorArrayIndex = currentColorArrayIndex == (colorArray.count - 1) ? 0 : currentColorArrayIndex + 1
        UIView.transition(with: gradientImgView, duration: 2, options: [.transitionCrossDissolve], animations: {
            self.gradientImgView.firstColor = self.colorArray[self.currentColorArrayIndex].color1
            self.gradientImgView.secondColor = self.colorArray[self.currentColorArrayIndex].color2}) { (success) in self.animatedBackground()}
    }
    
    fileprivate func setCountTip(with someoneCount:UILabel,someoneLimitCount:UILabel){
       let tempCount = (currentTextField.text?.count)!
       var tempString = ""
        if tempCount == 0{
            someoneCount.textColor = UIColor.red
        }else{
            someoneCount.textColor = someoneLimitCount.textColor}
        if tempCount == Int(someoneLimitCount.text!)!{
            someoneCount.text = someoneLimitCount.text
            tempString = currentTextField.text!
        }else if tempCount > Int(someoneLimitCount.text!)!{
            someoneCount.text = someoneLimitCount.text
            currentTextField.text = tempString
        }else {someoneCount.text = "\(tempCount)"}
    }
    
    fileprivate func progressIndicator(){
    replicatorLayer.addSublayer(circle)
        circle.removeAllAnimations()
        circle.add(shrinkAnimation, forKey: nil)
        replicatorLayer.instanceDelay = shrinkAnimation.duration / CFTimeInterval(9)
        rootLayer.addSublayer(replicatorLayer)
        self.views.layer.addSublayer(rootLayer)
    }
    
    fileprivate func createCheckTargets(){
        _ = allTextFieldsInScreen.map{
            $0.addTarget(self, action: #selector(checkText(sender:)), for: .editingChanged)
        }
    }
    
    fileprivate func checkIfNil(with index: Int, and text: String) -> Bool{
        guard allTextFieldsInScreen[index].text != "" else{
            allTextFieldsInScreen[index].rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
            tempMarkArr[index] = false
            allTipLabelsInScreen[index].text = text
            _ = allTextFieldsInScreen.map{$0.isEnabled = true}
            return false
        }
        return true
    }
    
    fileprivate func checkIfMatchRegex(with index: Int, and text: String) {
        allTextFieldsInScreen[index].rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
        tempMarkArr[index] = false
        allTipLabelsInScreen[index].text = text
        _ = allTextFieldsInScreen.map{$0.isEnabled = true}
    }
    
    fileprivate func checkIfSameInput(){
        if allTextFieldsInScreen[3].text != allTextFieldsInScreen[2].text{
            allTextFieldsInScreen[3].rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
            tempMarkArr[3] = false
            allTipLabelsInScreen[3].text = "Twice inputs is not same"
            _ = allTextFieldsInScreen.map{$0.isEnabled = true}
        }else {allTextFieldsInScreen[3].rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
            tempMarkArr[3] = true
            _ = allTextFieldsInScreen.map{$0.isEnabled = true}
        }
    }
    
    fileprivate func ifThereNoWrong(index: Int){
        allTextFieldsInScreen[index].rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
        tempMarkArr[index] = true
        _ = allTextFieldsInScreen.map{$0.isEnabled = true}
    }
    
    fileprivate func checkIfBeTaken(with index: Int, and text: String){
        progressIndicator()
        allTextFieldsInScreen[index].rightView = self.views
        let query = PFQuery.init(className: "_User")
        query.whereKey("username", equalTo: allTextFieldsInScreen[index].text!)
        query.findObjectsInBackground(block: { (objects, error) in
            if error == nil{if objects!.count > 0{
                self.allTextFieldsInScreen[index].rightView = UIImageView.init(image: #imageLiteral(resourceName: "wrong"))
                self.tempMarkArr[index] = false
                self.allTipLabelsInScreen[index].text = text
                _ = self.allTextFieldsInScreen.map{$0.isEnabled = true}
            } else {
                self.allTextFieldsInScreen[index].rightView = UIImageView.init(image: #imageLiteral(resourceName: "right"))
                self.tempMarkArr[index] = true
                _ = self.allTextFieldsInScreen.map{$0.isEnabled = true}}
            }else {print(error!.localizedDescription)}})
    }
    
    func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        avaImgView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

//custom functions selectors
extension signUpVC{
    
    @objc fileprivate func tapGestrue(){
        self.view.endEditing(true)
    }
    
    @objc func didTapImageView() {
        
        // When tapping the image view, restore the image to the previous cropping state
        let viewFrame = view.convert(avaImgView.frame, to: self.view)
        
        if self.image == #imageLiteral(resourceName: "profile") {
            let cropViewController = CropViewController(croppingStyle:.circular, image: self.image!)
            cropViewController.delegate = self
            cropViewController.presentAnimatedFrom(self, fromImage: self.avaImgView.image,fromView: avaImgView, fromFrame: viewFrame, angle: self.croppedAngle, toImageFrame: self.croppedRect, setup:
                { self.avaImgView.isHidden = false }, completion: nil)
        }else {
            let cropViewController = CropViewController(croppingStyle:.circular, image: self.image!)
            cropViewController.delegate = self
            cropViewController.presentAnimatedFrom(self, fromImage: self.avaImgView.image,fromView: avaImgView, fromFrame: viewFrame, angle: self.croppedAngle, toImageFrame: self.croppedRect, setup:
                { self.avaImgView.isHidden = false }, completion: nil)
        }
    }
    
    @objc fileprivate func checkText(sender: UITextField){
        isChanged = true
    }
}

//observers
extension signUpVC{
    
    fileprivate func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setCountTip(_:)), name: .UITextFieldTextDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(isCountWith7(_:)), name: NSNotification.Name.init("isEnableClicked"), object: nil)
    }
    
    fileprivate func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
}

//observers selectors
extension signUpVC{
    
    @objc fileprivate func isCountWith7(_: Notification){
        
        if (tempMarkArr.filter{$0 == true}).count == 7{
            signUpBtn.isEnabled = true}
        else {signUpBtn.isEnabled = false}
    }
    
    @objc fileprivate func setCountTip(_: Notification){
        
        _ = [10,20,30,40,70].enumerated().map{ (offset,element) in
            
            if element == currentTextField.tag{
                setCountTip(with: allCountTip[offset * 2], someoneLimitCount: allCountTip[offset * 2 + 1])
            }
        }
    }
}

//UITextFieldDelegate
extension signUpVC{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        signUpBtn.isEnabled = false
        tempText = allTipLabelsInScreen[textField.tag / 10 - 1].text!
        allTipLabelsInScreen[textField.tag / 10 - 1].text = ""
        tipSelectedView[textField.tag / 10 - 1].backgroundColor = .purple
        _ = allTextFieldsInScreen.map{if $0 != textField {
            $0.isEnabled = false
            }}
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        tipSelectedView[textField.tag / 10 - 1].backgroundColor = .white
        
        //if text has changed than before
        if isChanged == true {
            
            //user can't edit in the checking time
            _ = allTextFieldsInScreen.map{$0.isEnabled = false}
            
            //username textfield
            if textField.tag == 10 {
                
                guard checkIfNil(with: 0, and: "username can't be nil") else {return}
                guard Validate.username((allTextFieldsInScreen[0].text)!).isRight else {
                    checkIfMatchRegex(with: 0, and: "only a-zA-Z,0-9,.,_")
                    return}
                checkIfBeTaken(with: 0, and: "username has been taken")
            }
            
            //fullname textfield
            if textField.tag == 20 {
                guard checkIfNil(with: 1, and: "fullname can't be nil") else {return}
                guard
                    Validate.fullname((allTextFieldsInScreen[1].text)!).isRight else {
                        checkIfMatchRegex(with: 1, and: "only a-zA-Z,0-9,., ,_")
                        return
                }
                checkIfBeTaken(with: 1, and: "fullname has been taken")
            }
            
            //password textfield
            if textField.tag == 30{
                guard checkIfNil(with: 2, and: "password can't be nil") else {return}
                guard Validate.password((allTextFieldsInScreen[2].text)!).isRight else {
                    checkIfMatchRegex(with: 2, and: "only 6-20 count, a-zA-Z,0-9")
                    return}
                ifThereNoWrong(index: 2)
            }
            
            //repeat password textfield
            if textField.tag == 40{
                guard checkIfNil(with: 3, and: "repeat must be done") else {return}
                checkIfSameInput()
            }
            
            //email textfield
            if textField.tag == 50{
                guard checkIfNil(with: 4, and: "email can't be nil") else {return}
                guard Validate.email((allTextFieldsInScreen[4].text)!).isRight else{
                    checkIfMatchRegex(with: 4, and: "(4-20words)@gmail.(2-3 letters)")
                    return}
                checkIfBeTaken(with: 4, and: "email has been taken")
            }
            
            // web textfield
            if textField.tag == 60{
                guard checkIfNil(with: 5, and: "web can't be nil") else {return}
                guard Validate.URL((allTextFieldsInScreen[5].text)!).isRight else{
                    checkIfMatchRegex(with: 5, and: "www.xxxx.(2-3 letters)")
                    return}
                ifThereNoWrong(index: 5)
            }
            
            //bio textfield
            if textField.tag == 70{
                guard checkIfNil(with: 6, and: "bio can't be nil") else {return}
                ifThereNoWrong(index: 6)
            }
            
            isChanged = false
            
            //after checking completes, tell observer the status of ✓ & ✘
            NotificationCenter.default.post(name: NSNotification.Name.init("isEnableClicked"), object: nil)
        }
        else {allTipLabelsInScreen[textField.tag / 10 - 1].text = tempText
            
            //if there has no change than before, also tell observern the status of ✓ & ✘
            NotificationCenter.default.post(name: NSNotification.Name.init("isEnableClicked"), object: nil)
            _ = allTextFieldsInScreen.map{$0.isEnabled = true}
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = allTextFieldsInScreen.map{ $0.resignFirstResponder()}
        return true
    }
}

//UIImagePickerControllerDelegate
extension signUpVC{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: .circular, image: image)
        cropController.delegate = self
        self.image = image
        picker.pushViewController(cropController, animated: true)
    }
}

//CropViewControllerDelegate
extension signUpVC{
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
}

//selectCellDelegate
extension signUpVC{
    
    func tapToPhotoLibrary() {
        avaImgView.isUserInteractionEnabled = true
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .popover
        imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func tapToReset() {
        croppedRect = CGRect.zero
        croppedAngle = 0
        self.image = #imageLiteral(resourceName: "profile")
        avaImgView.image = self.image
      }
}

//goBackDelegate
extension signUpVC{
    
    func goBackFromPage() {
        self.dismiss(animated: true, completion: nil)
    }
}

