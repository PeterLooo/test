

import UIKit

extension UIView{
    func setBorder(width:CGFloat,radius:CGFloat,color:UIColor?){
        self.layer.cornerRadius = radius
        self.layer.borderWidth  = width
        
        if let borderColor = color{
            self.layer.borderColor  = borderColor.cgColor
        }
    }
    
    func removeBorder(){
        self.layer.cornerRadius = 0
        self.layer.borderWidth  = 0
        self.layer.borderColor  = self.backgroundColor?.cgColor
    }
    
    func setButtonDefaultBorder(){
        self.layer.cornerRadius = 4
        self.layer.borderWidth  = 0
        self.layer.borderColor  = UIColor.white.cgColor
    }
    
    func setCircleView(borderWidth:CGFloat,color:UIColor?){
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        if let borderColor = color{
            self.layer.borderColor  = borderColor.cgColor
        }
    }
    
    func setShadow(offset:CGSize,opacity:Float,shadowRadius:CGFloat) {
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setShadow(offset:CGSize,opacity:Float,shadowRadius:CGFloat, color: UIColor) {
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setDefaultShadow(){
        setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 4, color: UIColor.black.withAlphaComponent(0.8))
    }
    
    func setButtonDefaultShadow() {
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func removeShadow(){
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.0
    }
    
    func setRadius(corners: UIRectCorner,radius:CGFloat) {
        let bezier = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = bezier.cgPath
        shape.shouldRasterize = true
        shape.rasterizationScale = UIScreen.main.scale
        
        self.layer.mask = shape
    }
    
    func setGradient(colors: [UIColor], opacity: Float) {
        
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.opacity = opacity
        
        //為了避免重複無限累加，每次加漸層之前，先把以前"所有"CAGradientLayer清除
        //使用前，請注意是"所有"
        self.layer.sublayers?.forEach( { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } } )
        self.layer.addSublayer(gradientLayer)
    }
    
    func setGradient(colors: [UIColor], opacity: Float, startPoint: CGPoint, endPoint: CGPoint) {
        //Note: Point Example : CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 0)
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.opacity = opacity
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        //為了避免重複無限累加，每次加漸層之前，先把以前"所有"CAGradientLayer清除
        //使用前，請注意是"所有"
        self.layer.sublayers?.forEach( { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } } )
        self.layer.addSublayer(gradientLayer)
    }
    
    func removeAllGradientLayer(){
        //為了避免重複無限累加，每次加漸層之前，先把以前"所有"CAGradientLayer清除
        //使用前，請注意是"所有"
        self.layer.sublayers?.forEach( { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } } )
    }
    
    func constraintToSuperView(){
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview!.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor)
            ])
    }
    
    func constraintToSafeArea(){
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.trailingAnchor)
            ])
    }
    
    func constraint(_ top: CGFloat?, _ bottom: CGFloat?, _ leading: CGFloat?, _ trailing: CGFloat?){
        self.translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: top).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: bottom).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: leading).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: trailing).isActive = true
        }
    }
    
    class func instantiateFromNib<T: UIView>(viewType: T.Type) -> T {
        return Bundle.main.loadNibNamed(String(describing: viewType), owner: nil, options: nil)!.first as! T
    }
    
    class func instantiateFromNib() -> Self {
        return instantiateFromNib(viewType: self)
    }
}

// BaseLine
private var topLayerKey = "TopShapeLineKey"
private var baseLineKey = "BottomShapeLineKey"

public struct BaseLineInset {
    var left:CGFloat = 0.0
    var right:CGFloat = 0.0
    init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
}

public extension UIView {
    
    fileprivate var topLayer:CAShapeLayer {
        set {
            objc_setAssociatedObject(self, &topLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        } get {
            if let wave = objc_getAssociatedObject(self, &topLayerKey) as? CAShapeLayer {
                return wave
            } else {
                let shape = CAShapeLayer()
                shape.lineWidth = 0.0
                self.topLayer = shape
                shape.isHidden = true
                self.layer.addSublayer(shape)
                return shape
            }
        }
    }
    
    fileprivate var bottomLayer:CAShapeLayer {
        set {
            objc_setAssociatedObject(self, &baseLineKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        } get {
            if let wave = objc_getAssociatedObject(self, &baseLineKey) as? CAShapeLayer {
                return wave
            } else {
                let shape = CAShapeLayer()
                shape.lineWidth = 0.0
                shape.isHidden = true
                self.bottomLayer = shape
                self.layer.addSublayer(shape)
                return shape
            }
        }
    }
    
    func topLineWith(width:CGFloat,color:UIColor,edge:BaseLineInset) {
        self.drawLayer(isTop: true, width: width, color: color, edge: edge)
    }
    
    func bottomLineWith(width:CGFloat,color:UIColor,edge:BaseLineInset
        ) {
        self.drawLayer(isTop: false, width: width, color: color, edge: edge)
    }
    
    func hideTopLine(isHide:Bool) {
        self.topLayer.isHidden = isHide
    }
    
    func hideBottomLine(isHide:Bool) {
        self.bottomLayer.isHidden = isHide
    }
    
    private func drawLayer(isTop:Bool,width:CGFloat,color:UIColor,edge:BaseLineInset) {
        let layer = (isTop) ? topLayer : bottomLayer
        if layer.frame == self.bounds &&
            layer.lineWidth == width &&
            layer.strokeColor == color.cgColor {
            return
        }
        
        layer.isHidden = (width == 0)
        layer.frame = self.bounds
        let pathW = self.bounds.width - edge.right
        let y = (isTop) ? 0 : self.bounds.height - width
        let bezier = UIBezierPath()
        
        bezier.move(to: CGPoint(x: edge.left, y: y))
        bezier.addLine(to: CGPoint(x: pathW, y: y))
        layer.lineWidth = width
        layer.path = bezier.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

public struct CommonAnimate {
    internal let view: UIView
    var duration:TimeInterval = 0.3
    public func scaleBigBounce () {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration = duration
        animation.values = [1.0,1.2,1.1,0.9,1.0]
        self.view.layer.add(animation, forKey: "Scale")
    }
    
    public func rotationY() {
        UIView.transition(with: self.view, duration: duration, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation.init(keyPath: "position.x")
        let x = self.view.center.x
        animation.values = [(x-3),(x+3),(x-2),(x+2),(x-1),(x+1),(x)]
        animation.duration = duration
        self.view.layer.add(animation, forKey: "Shake")
    }
    
    func jumpY() {
        let animation = CAKeyframeAnimation.init(keyPath: "position.y")
        let y = self.view.center.y
        animation.values = [(y-5),(y-4),(y-2),(y+2),(y)]
        animation.duration = duration
        self.view.layer.add(animation, forKey: "JumpY")
    }
    
    internal init(view: UIView) {
        self.view = view
    }
}

extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

class CommonDraw:NSObject {
    var view: UIView!
    var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    func maskWith(alpha:CGFloat , animate:Bool) {
        self.view.bringSubviewToFront(maskView)
        self.maskView.backgroundColor = colorPrimary.withAlphaComponent(alpha)
        let duration = animate ? 0.25 : 0.0
        UIView.animate(withDuration: duration) {
            self.maskView.alpha = alpha
        }
    }
    
    func maskDismiss() {
        self.maskView.alpha = 0.0
    }
    
    override init() {
        super.init()
    }
    
    convenience init(view: UIView) {
        self.init()
        self.view = view
        self.maskView.frame = view.bounds
        self.view.addObserver(self, forKeyPath: "bounds", options: [.new], context: nil)
        self.view.addSubview(maskView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            if let new = change?[.newKey] as? CGRect {
                self.maskView.frame = new
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

