// The MIT License
//
// Copyright (c) 2018 7bit (Alex Kremer, Valera Chevtaev)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

@IBDesignable
public class PerimeterMenu: UIButton {

    /// XYU
    public typealias VoidBlock = () -> Void
    public typealias ActionCallback = (_ sender: UIButton) -> Bool
    
    private enum State {
        case expanded
        case collapsed
        
        var inversed: State {
            return self == .expanded ? .collapsed : .expanded
        }
    }
    
    // MARK: - Publics
    
    /// Datasource is used to configure the menu buttons
    @IBOutlet weak public var datasource: PerimeterMenuDatasource?
    
    /// Delegate is used to respond to actions
    @IBOutlet weak public var delegate: PerimeterMenuDelegate?
    
    /// Callback for button tap. Implement and return false if you want to customize the action for it and not have the default action happen.
    public var onButtonTap: ActionCallback?
    
    /// Callback for long button press. Implement and return false if you want to customize the action for it and not have the default action happen.
    public var onButtonLongPress: ActionCallback?

    /// Call this method if you want to reconfigure your menu buttons from datasource
    public func reconfigure() {
        configured = false
        lastHoveringButton = nil
        menu.removeAll()
        regenerateMenu()
    }
    
    // MARK: - Inspectables

    private var internalAnimationStyle: AnimationStyle = .linear
    
    @IBInspectable
    public var animationStyle: Int {
        get {
            return internalAnimationStyle.rawValue
        }
        set {
            if let anim = AnimationStyle(rawValue: newValue) {
                internalAnimationStyle = anim
            }
        }
    }
    
    @IBInspectable
    public var animationDuration: Double = 0.33
    
    /// Sets menu to expanded or collapsed. Used in Storyboard to design the menu.
    @IBInspectable
    public var isExpanded: Bool = true {
        didSet {
            menuState = isExpanded ? .expanded : .collapsed
            showMenu(for: menuState, animated: false)
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    public var menuItemCornerRadius: CGFloat = 0 {
        didSet {
            regenerateMenu()
        }
    }
    
    @IBInspectable
    public var itemsCount: UInt = 3 {
        didSet {
            regenerateMenu()
        }
    }
    
    @IBInspectable
    public var angleBetweenItems: NSNumber? = nil {
        didSet {
            regenerateMenu()
        }
    }
    
    @IBInspectable
    public var startAngle: CGFloat = 180 {
        didSet {
            regenerateMenu()
        }
    }
    
    @IBInspectable
    public var distanceFromButton: CGFloat = 50 {
        didSet {
            regenerateMenu()
        }
    }
    
    @IBInspectable
    public var itemDimensionSize: CGFloat = 30 {
        didSet {
            regenerateMenu()
        }
    }
    
    @IBInspectable
    public var availableAngle: CGFloat = 180 {
        didSet {
            regenerateMenu()
        }
    }
    
    @IBInspectable
    public var hasBlurEffect: Bool = false {
        didSet {
            regenerateMenu()
        }
    }
    
    // TODO: add animation duration, animation style (fade, spring, etc.)
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        longPressGesture.cancelsTouchesInView = false
        addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Gestures
    
    private var lastHoveringButton: UIButton?
    private var tapGesture: UITapGestureRecognizer!
    private var longPressGesture: UILongPressGestureRecognizer!
    
    private func enableGestures(_ enable: Bool) {
        tapGesture.isEnabled = enable
        longPressGesture.isEnabled = enable
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        guard onButtonTap?(self) ?? false else { return }
        invertState(animated: true)
    }
    
    @objc private func onLongPress(sender: UILongPressGestureRecognizer) {
        guard onButtonLongPress?(self) ?? false else { return }
        
        switch sender.state {
            case .began:
                lastHoveringButton = nil
                invertState(animated: true)
            
            case .changed:
                let location = sender.location(ofTouch: 0, in: containerView)
                if let button = containerView.hitTest(location, with: nil) as? UIButton,
                    let index = menu.index(of: button) {
                    
                    if button != lastHoveringButton {
                        lastHoveringButton = button
                        delegate?.perimeterMenu?(self,
                                                 didStartHoveringOver: button,
                                                 at: index)
                    }
                } else if let button = lastHoveringButton,
                    let lastHoveringButtonIndex = menu.index(of: button) {
                    delegate?.perimeterMenu?(self,
                                             didEndHoveringOver: button,
                                             at: lastHoveringButtonIndex)
                    lastHoveringButton = nil
                }

            case .ended:
                let location = sender.location(ofTouch: 0, in: containerView)
                if let button = containerView.hitTest(location, with: nil) as? UIButton,
                    let index = menu.index(of: button) {
                    
                    delegate?.perimeterMenu?(self, didSelectItem: button, at: index)
                }
                
                lastHoveringButton = nil
                invertState(animated: true)
            
            default:
                return
        }
    }
    
    @objc private func itemTap(sender: UIButton) {
        if let buttonIndex = menu.index(of: sender) {
            invertState(animated: true)
            delegate?.perimeterMenu?(self, didSelectItem: sender, at: buttonIndex)
        }
    }
    
    // MARK: - Layout and draw
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        regenerateMenu()
        
        self.layer.masksToBounds = true
    }
    
    
    // MARK: - Privates
    
    private var itemSize: CGSize {
        return CGSize(width: itemDimensionSize, height: itemDimensionSize)
    }
    
    fileprivate var menu = [UIButton]()
    fileprivate var containerView: UIView!
    
    fileprivate var angleDistance: CGFloat = 0.0
    
    fileprivate var configured = false
    
    private var menuState: State = .collapsed {
        didSet {
            guard menuState != oldValue else { return }
        }
    }
    
    private func invertState(animated: Bool) {
        menuState = menuState.inversed
        showMenu(for: menuState, animated: animated)
    }
    
    // MARK: - Container view
    
    private func regenerateContainer() {
        let containerOrigin = CGPoint(x: frame.origin.x - distanceFromButton - itemSize.width,
                                      y: frame.origin.y - distanceFromButton - itemSize.height)
        let containerSize = CGSize(width: bounds.width + distanceFromButton*2 + itemSize.width*2,
                                   height: bounds.height + distanceFromButton*2 + itemSize.height*2)
        
        let containerFrame = CGRect(origin: containerOrigin, size: containerSize)
        
        if let cv = containerView {
            cv.frame = containerFrame
        } else {
            let cv = PerimeterMenuContainerView(frame: containerFrame)
            
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.isUserInteractionEnabled = true
            cv.backgroundColor = .clear
            superview?.addSubview(cv)
            
            containerView = cv
        }
    }
    
    // MARK: - Menu view
    
    private func regenerateMenu() {
        regenerateContainer()
        
        // if already configured the buttons - just skip this step
        guard !configured else { return }
        
        if let angle = angleBetweenItems {
            angleDistance = CGFloat(angle.floatValue)
        } else {
            angleDistance = availableAngle / CGFloat(itemsCount == 1 ? 1 : itemsCount-1)
        }
        
        for (index, buttonPosition) in buttonsPositions.enumerated() {
            
            if index < menu.count {
                let button = menu[index]
                
                datasource?.perimeterMenu(self, configurationFor: index, withButton: button)

                button.frame = CGRect(origin: .zero, size: itemSize)
                button.center = buttonPosition
                
                button.layer.cornerRadius = menuItemCornerRadius
                button.layer.masksToBounds = true
                
            } else {
                let button = UIButton()
                
                button.backgroundColor = .magenta

                datasource?.perimeterMenu(self, configurationFor: index, withButton: button)

                button.frame = CGRect(origin: .zero, size: itemSize)
                button.center = buttonPosition
                
                button.layer.cornerRadius = menuItemCornerRadius
                button.layer.masksToBounds = true
                
                button.addTarget(self, action: #selector(itemTap), for: .touchUpInside)
                
                containerView.addSubview(button)
                menu.append(button)
            }
        }
        
        if let _ = datasource {
            // datasource was present while configuring buttons so no need to do it again
            configured = true
        }
    }
    
    private var buttonsPositions: [CGPoint] {
        var positions: [CGPoint] = []
        
        for i in 0..<itemsCount {
            
            let p: CGPoint
            
            if menuState == .expanded {
                let angle = startAngle + angleDistance * CGFloat(i)
                let radius = itemSize.width/2 + distanceFromButton + bounds.width/2
                p = pointInCircle(radius: radius, angle: angle)
            } else {
                p = self.centerPoint
            }
            positions.append(p)
        }
        
        return positions
    }
    
    private func pointInCircle(radius: CGFloat, angle degrees: CGFloat) ->  CGPoint {
        let cosValue = cos( degrees * .pi / 180.0)
        let sinValue = sin( degrees * .pi / 180.0)
        
        let x = (radius * cosValue) + containerView.bounds.width/2
        let y = (radius * sinValue) + containerView.bounds.height/2
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - Animations
    
    private var isAnimating = false
    
    private func showMenu(for state: State, animated: Bool) {
        switch state {
        case .expanded:
            expandMenu(animated: animated)
        case .collapsed:
            collapseMenu(animated: animated)
        }
    }
    
    private func expandMenu(animated: Bool) {
        print("expand menu")
        let animations: VoidBlock = {
            for (index, button) in self.menu.enumerated() {
                button.center = self.buttonsPositions[index]
                button.alpha = 1.0
            }
        }

        self.containerView.isHidden = false
        let duration = animated ? animationDuration : 0
        animator.animate(withDuration: duration,
                         animations: animations,
                         completion: nil)
    }
    
    private func collapseMenu(animated: Bool) {
        print("collapse menu")
        let animations: VoidBlock = {
            self.enableGestures(false)
            self.menu.forEach {
                $0.center = self.centerPoint
                $0.alpha = 0.0
            }
        }
        let completion: (Bool) -> Void = { _ in
            self.containerView.isHidden = true
            self.enableGestures(true)
        }
        
        let duration = animated ? animationDuration : 0
        animator.animate(withDuration: duration,
                         animations: animations,
                         completion: completion)
    }
    
    private var animator: MenuAnimator {
        return AnimatorFactory.createAnimator(forStyle: internalAnimationStyle)
    }
    
    private var centerPoint: CGPoint {
        return CGPoint(x: containerView.bounds.width/2,
                       y: containerView.bounds.height/2)
    }
}
