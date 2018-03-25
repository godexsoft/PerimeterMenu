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

    // MARK: - Types

    public typealias ActionCallback = (_ sender: UIButton) -> Bool

    enum State {
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
        
        menu.forEach { button in
            button.removeFromSuperview()
        }
        menu = []
        
        regenerateMenu()
    }

    // MARK: - Inspectables

    var internalAnimationStyle: AnimationStyle = .linear

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

    // MARK: - Properties

    private var itemSize: CGSize {
        return CGSize(width: itemDimensionSize, height: itemDimensionSize)
    }

    var menu = [UIButton]()
    lazy var containerView: UIView = {
        let cv = PerimeterMenuContainerView(frame: containerFrame)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isUserInteractionEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()

    private var angleDistance: CGFloat = 0.0

    private var configured = false

    private var menuState: State = .collapsed {
        didSet {
            guard menuState != oldValue else { return }
        }
    }

    private func invertState(animated: Bool) {
        menuState = menuState.inversed
        showMenu(for: menuState, animated: animated)
    }

    // MARK: - Gestures

    private var lastHoveringButton: UIButton?
    private var tapGesture: UITapGestureRecognizer!
    private var longPressGesture: UILongPressGestureRecognizer!

    func enableGestures(_ enable: Bool) {
        tapGesture.isEnabled = enable
        longPressGesture.isEnabled = enable
    }

    @objc private func onTap(sender: UITapGestureRecognizer) {
        guard onButtonTap?(self) ?? true else { return }
        invertState(animated: true)
    }

    @objc private func onLongPress(sender: UILongPressGestureRecognizer) {
        guard onButtonLongPress?(self) ?? true else { return }

        let endLastButtonHoveringIfNeeded: VoidBlock = {
            if let button = self.lastHoveringButton,
                let lastHoveringButtonIndex = self.menu.index(of: button) {
                self.delegate?.perimeterMenu?(self,
                                              didEndHoveringOver: button,
                                              at: lastHoveringButtonIndex)
                self.lastHoveringButton = nil
            }
        }

        switch sender.state {
        case .began:
            lastHoveringButton = nil
            invertState(animated: true)

        case .changed:
            let location = sender.location(ofTouch: 0, in: containerView)
            if let button = containerView.hitTest(location, with: nil) as? UIButton,
                let index = menu.index(of: button) {
                if button != lastHoveringButton {
                    endLastButtonHoveringIfNeeded()
                    lastHoveringButton = button
                    delegate?.perimeterMenu?(self,
                                             didStartHoveringOver: button,
                                             at: index)
                }
            } else {
                endLastButtonHoveringIfNeeded()
            }

        case .ended:
            let location = sender.location(ofTouch: 0, in: containerView)
            if let button = containerView.hitTest(location, with: nil) as? UIButton,
                let index = menu.index(of: button) {

                delegate?.perimeterMenu?(self, didSelectItem: button, at: index)
            }

            endLastButtonHoveringIfNeeded()
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

    // MARK: - Container view

    private var containerFrame: CGRect {
        let containerOrigin = CGPoint(x: frame.origin.x - distanceFromButton - itemSize.width,
                                      y: frame.origin.y - distanceFromButton - itemSize.height)
        let containerSize = CGSize(width: bounds.width + distanceFromButton*2 + itemSize.width*2,
                                   height: bounds.height + distanceFromButton*2 + itemSize.height*2)
        return CGRect(origin: containerOrigin, size: containerSize)
    }

    private func regenerateContainer() {
        if let superview = superview, containerView.superview == nil {
            superview.addSubview(containerView)
        }
        containerView.frame = containerFrame
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

                // this is purely for storyboard visibility
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

    var buttonsPositions: [CGPoint] {
        var positions: [CGPoint] = []

        for i in 0..<itemsCount {
            let p: CGPoint
            if menuState == .expanded {
                let angle = startAngle + angleDistance * CGFloat(i)
                let radius = itemSize.width/2 + distanceFromButton + bounds.width/2
                p = pointInCircle(radius: radius, angle: angle)
            } else {
                p = centerPoint
            }
            positions.append(p)
        }

        return positions
    }

    private func pointInCircle(radius: CGFloat, angle degrees: CGFloat) ->  CGPoint {
        let cosValue = cos(degrees * .pi / 180.0)
        let sinValue = sin(degrees * .pi / 180.0)

        let x = (radius * cosValue) + containerView.bounds.width/2
        let y = (radius * sinValue) + containerView.bounds.height/2

        return CGPoint(x: x, y: y)
    }
}
