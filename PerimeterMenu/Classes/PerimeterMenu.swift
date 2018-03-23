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
    public typealias ActionCallback = (_ sender: UIButton) -> Bool
    
    private enum State {
        case expanded
        case collapsed
        
        var inversed: State {
            return self == .expanded ? .collapsed : .expanded
        }
    }
    
    // MARK: - Publics
    
    @objc weak public var datasource: PerimeterMenuDatasource?
    
    public var onButtonTap: ActionCallback?
    public var onButtonLongPress: ActionCallback?

    // MARK: - Inspectables

    @IBInspectable
    public var isExpanded: Bool = true {
        didSet {
            menuState = isExpanded ? .expanded : .collapsed
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
    
    private var tapGesture: UITapGestureRecognizer!
    private var longPressGesture: UILongPressGestureRecognizer!
    
    private func commonInit() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tapGesture)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        addGestureRecognizer(longPressGesture)
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        guard onButtonTap?(self) ?? false else { return }
        menuState = menuState.inversed
    }
    
    @objc private func onLongPress(sender: UILongPressGestureRecognizer) {
        guard onButtonLongPress?(self) ?? false else { return }
        menuState = menuState.inversed
    }
    
    // MARK: -
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        regenerateMenu()
        
        self.layer.masksToBounds = true
    }
    
    
    // MARK: - Privates
    
    private var menuState: State = .collapsed {
        didSet {
            guard menuState != oldValue else { return }
            showMenu(for: menuState, animated: true)
        }
    }
    
    private var itemSize: CGSize {
        return CGSize(width: itemDimensionSize, height: itemDimensionSize)
    }
    
    fileprivate var menu = [UIButton]()
    fileprivate var containerView: UIView!
    
    fileprivate var angleDistance: CGFloat = 0.0
    
    // MARK: - Implementation
    
    private func regenerateContainer() {
        if let cv = containerView {
            cv.removeFromSuperview()
            self.containerView = nil
        }
        
        let containerOrigin = CGPoint(x: frame.origin.x - distanceFromButton - itemSize.width,
                                      y: frame.origin.y - distanceFromButton - itemSize.height)
        let containerSize = CGSize(width: bounds.width + distanceFromButton*2 + itemSize.width*2,
                                   height: bounds.height + distanceFromButton*2 + itemSize.height*2)
        
        let containerFrame = CGRect(origin: containerOrigin, size: containerSize)
        
        let cv = PerimeterMenuContainerView(frame: containerFrame)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isUserInteractionEnabled = true
        cv.backgroundColor = .clear
        superview?.addSubview(cv)
        
        containerView = cv
    }
    
    private func regenerateMenu() {
        
        regenerateContainer()
        menu.removeAll()
        
        if let angle = angleBetweenItems {
            angleDistance = CGFloat(angle.floatValue)
        } else {
            angleDistance = availableAngle / CGFloat(itemsCount == 1 ? 1 : itemsCount-1)
        }
        
        for (index, buttonPosition) in buttonsPositions.enumerated() {
            
            let button = UIButton()
            
            button.backgroundColor = .magenta
            datasource?.perimeterMenu(self, configurationFor: index, withButton: button)

            button.frame = CGRect(origin: .zero, size: itemSize)
            button.center = buttonPosition
            
            button.layer.cornerRadius = menuItemCornerRadius
            button.layer.masksToBounds = true
            
            containerView.addSubview(button)
            menu.append(button)
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
        print("sin=\(sinValue), cos=\(cosValue), degress=\(degrees)")
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
        UIView.animate(withDuration: 0.5) {
            for (index, button) in self.menu.enumerated() {
                print("expand: \(button.center) -> \(self.buttonsPositions[index])")
                button.center = self.buttonsPositions[index]
            }
        }
    }
    
    private func collapseMenu(animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.menu.forEach {
                print("collapse: \($0.center) -> \(self.containerView.center)")
                $0.center = self.centerPoint
            }
        }
    }
    
    private var centerPoint: CGPoint {
        return CGPoint(x: containerView.bounds.width/2,
                       y: containerView.bounds.height/2)
    }
}
