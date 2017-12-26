//
//  CropViewController.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import TOCropViewController

//An enum containing all of the aspect ratio presets that this view controller supports
typealias CropViewControllerAspectRatioPreset = TOCropViewControllerAspectRatioPreset

//An enum denoting whether the control tool bar is drawn at the top, or the bottom of the screen in portrait mode
typealias CropViewControllerToolbarPosition = TOCropViewControllerToolbarPosition

//The type of cropping style for this view controller (ie a square or a circle cropping region)
typealias CropViewCroppingStyle = TOCropViewCroppingStyle

@objc protocol CropViewControllerDelegate:NSObjectProtocol{
   
    @objc optional func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int)
    
     @objc optional func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int)
    
     @objc optional func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int)
    
    @objc optional func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool)
}


class CropViewController: UIViewController,TOCropViewControllerDelegate {
    
      var image: UIImage {
        return self.toCropViewController.image }
    
    var delegate: CropViewControllerDelegate? {
        didSet { self.setUpDelegateHandlers() }
    }
    
    var showActivitySheetOnDone: Bool {
        set { toCropViewController.showActivitySheetOnDone = newValue }
        get { return toCropViewController.showActivitySheetOnDone }
    }
    
    var imageCropFrame: CGRect {
        set { toCropViewController.imageCropFrame = newValue }
        get { return toCropViewController.imageCropFrame }
    }
    
    var angle: Int {
        set { toCropViewController.angle = newValue }
        get { return toCropViewController.angle }
    }
    
    var croppingStyle: CropViewCroppingStyle {
        return toCropViewController.croppingStyle
    }
    
    var aspectRatioPreset: CropViewControllerAspectRatioPreset {
        set { toCropViewController.aspectRatioPreset = newValue }
        get { return toCropViewController.aspectRatioPreset }
    }
    
    var titleLabel: UILabel? {
        return toCropViewController.titleLabel
    }
    
    var aspectRatioLockEnabled: Bool {
        set { toCropViewController.aspectRatioLockEnabled = newValue }
        get { return toCropViewController.aspectRatioLockEnabled }
    }
    
    var resetAspectRatioEnabled: Bool {
        set { toCropViewController.resetAspectRatioEnabled = newValue }
        get { return toCropViewController.resetAspectRatioEnabled }
    }
    
    var toolbarPosition: CropViewControllerToolbarPosition {
        set { toCropViewController.toolbarPosition = newValue }
        get { return toCropViewController.toolbarPosition }
    }
    
    var rotateClockwiseButtonHidden: Bool {
        set { toCropViewController.rotateClockwiseButtonHidden = newValue }
        get { return toCropViewController.rotateClockwiseButtonHidden }
    }
    
    var rotateButtonsHidden: Bool {
        set { toCropViewController.rotateButtonsHidden = newValue }
        get { return toCropViewController.rotateButtonsHidden }
    }
    
    var aspectRatioPickerButtonHidden: Bool {
        set { toCropViewController.aspectRatioPickerButtonHidden = newValue }
        get { return toCropViewController.aspectRatioPickerButtonHidden }
    }
    
    var activityItems: [Any]? {
        set { toCropViewController.activityItems = newValue }
        get { return toCropViewController.activityItems }
    }
    
    var applicationActivities: [UIActivity]? {
        set { toCropViewController.applicationActivities = newValue }
        get { return toCropViewController.applicationActivities }
    }
    
    var excludedActivityTypes: [UIActivityType]? {
        set { toCropViewController.excludedActivityTypes = newValue }
        get { return toCropViewController.excludedActivityTypes }
    }
    
    var onDidFinishCancelled: ((Bool) -> (Void))? {
        set { toCropViewController.onDidFinishCancelled = newValue }
        get { return toCropViewController.onDidFinishCancelled }
    }
    
    var onDidCropImageToRect: ((CGRect, Int) -> (Void))? {
        set { toCropViewController.onDidCropImageToRect = newValue }
        get { return toCropViewController.onDidCropImageToRect }
    }
    
    var onDidCropToRect: ((UIImage, CGRect, NSInteger) -> (Void))? {
        set { toCropViewController.onDidCropToRect = newValue }
        get { return toCropViewController.onDidCropToRect }
    }
    
    var onDidCropToCircleImage: ((UIImage, CGRect, NSInteger) -> (Void))? {
        set { toCropViewController.onDidCropToCircleImage = newValue }
        get { return toCropViewController.onDidCropToCircleImage }
    }
    
    var cropView: TOCropView {
        return toCropViewController.cropView
    }
    
    var toolbar: TOCropToolbar {
        return toCropViewController.toolbar
    }
    
    var doneButtonTitle: String! {
        set { toCropViewController.doneButtonTitle = newValue }
        get { return toCropViewController.doneButtonTitle }
    }
    
    var cancelButtonTitle: String! {
        set { toCropViewController.cancelButtonTitle = newValue }
        get { return toCropViewController.cancelButtonTitle }
    }
    
    let toCropViewController: TOCropViewController!
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return toCropViewController
    }
    
    override var childViewControllerForStatusBarHidden: UIViewController? {
        return toCropViewController
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    return toCropViewController.preferredStatusBarStyle
    }
    
    init(image: UIImage) {
        self.toCropViewController = TOCropViewController(image: image)
        super.init(nibName: nil, bundle: nil)
        setUpCropController()
    }
    
    init(croppingStyle: CropViewCroppingStyle, image: UIImage) {
        self.toCropViewController = TOCropViewController(croppingStyle: croppingStyle, image: image)
        super.init(nibName: nil, bundle: nil)
        setUpCropController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
// Defer adding the view until we're about to be presented
        if toCropViewController.view.superview == nil {
            view.addSubview(toCropViewController.view)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        toCropViewController.view.frame = view.bounds
        toCropViewController.viewDidLayoutSubviews()
    }
    
    override func preferredScreenEdgesDeferringSystemGestures() -> UIRectEdge {
        if #available(iOS 11.0, *) {
            return toCropViewController.preferredScreenEdgesDeferringSystemGestures()
        }
        
        return UIRectEdge.all
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//custom funcitons
extension CropViewController{
    
    func resetCropViewLayout() {
        toCropViewController.resetCropViewLayout()
    }
    
    func setAspectRatioPreset(_ aspectRatio: CropViewControllerAspectRatioPreset, animated: Bool) {
        toCropViewController.setAspectRatioPresent(aspectRatio, animated: animated)
    }
    
    func presentAnimatedFrom(_ viewController: UIViewController, fromView view: UIView?, fromFrame frame: CGRect,setup: (() -> (Void))?, completion: (() -> (Void))?)
{toCropViewController.presentAnimatedFrom(viewController, view: view, frame: frame, setup: setup, completion: completion)
    }
    
    func presentAnimatedFrom(_ viewController: UIViewController, fromImage image: UIImage?,fromView: UIView?, fromFrame: CGRect, angle: Int, toImageFrame toFrame: CGRect,setup: (() -> (Void))?, completion:(() -> (Void))?)
{toCropViewController.presentAnimatedFrom(viewController, fromImage: image, fromView: fromView,fromFrame: fromFrame, angle: angle, toFrame: toFrame,setup: setup, completion: completion)
    }
    
    func dismissAnimatedFrom(_ viewController: UIViewController, toView: UIView?, toFrame: CGRect,setup: (() -> (Void))?, completion:(() -> (Void))?)
{toCropViewController.dismissAnimatedFrom(viewController, toView: toView, toFrame: toFrame, setup: setup, completion: completion)
    }
    
    func dismissAnimatedFrom(_ viewController: UIViewController, withCroppedImage croppedImage: UIImage?, toView: UIView?,toFrame: CGRect, setup: (() -> (Void))?, completion:(() -> (Void))?)
{toCropViewController.dismissAnimatedFrom(viewController, croppedImage: croppedImage, toView: toView,toFrame: toFrame, setup: setup, completion: completion)
    }

    fileprivate func setUpCropController() {
        addChildViewController(toCropViewController)
        transitioningDelegate = (toCropViewController as! UIViewControllerTransitioningDelegate)
        toCropViewController.delegate = self
toCropViewController.didMove(toParentViewController: self)
    }
    
    fileprivate func setUpDelegateHandlers() {
        guard let delegate = self.delegate else {
            onDidCropToRect = nil
            onDidCropImageToRect = nil
            onDidCropToCircleImage = nil
            onDidFinishCancelled = nil
            return
        }
        
        if delegate.responds(to: #selector(CropViewControllerDelegate.cropViewController(_:didCropImageToRect:angle:))) {
            self.onDidCropImageToRect = {rect, angle in
    delegate.cropViewController!(self, didCropImageToRect: rect, angle: angle)
            }
        }
        
        if delegate.responds(to: #selector(CropViewControllerDelegate.cropViewController(_:didCropToImage:withRect:angle:))) {
            self.onDidCropToRect = {image, rect, angle in
delegate.cropViewController!(self, didCropToImage: image, withRect: rect, angle: angle)
            }
        }
        
    if delegate.responds(to: #selector(CropViewControllerDelegate.cropViewController(_:didCropToCircularImage:withRect:angle:))) {
            self.onDidCropToCircleImage = {image, rect, angle in
delegate.cropViewController!(self, didCropToCircularImage: image, withRect: rect, angle: angle)
            }
        }
        
if delegate.responds(to: #selector(CropViewControllerDelegate.cropViewController(_:didFinishCancelled:))) {
self.onDidFinishCancelled = { finished in
delegate.cropViewController!(self, didFinishCancelled: finished)
            }
        }
    }
}

