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

import UIKit

extension PerimeterMenu {

    private func createBluringView() -> PerimeterMenuBluringContainerView {
        let dismissAction: VoidBlock = { [weak self] in
            self?.invertState(animated: true)
        }
        let view = PerimeterMenuBluringContainerView(dismissAction: dismissAction)
        view.alpha = 0
        return view
    }

    func addBluringViewIfNeeded() {
        guard hasBlurEffect else { return }

        bluringView = createBluringView()
        if let bluringViewSuperview = containerSuperview, let bluringView = bluringView {
            let frame = bluringViewSuperview.convert(bluringViewSuperview.frame,
                                                     from: bluringViewSuperview)
            bluringView.frame = frame
            bluringViewSuperview.insertSubview(bluringView, belowSubview: containerView)
        }
    }

    func removeBluringViewIfNeeded() {
        bluringView?.removeFromSuperview()
        bluringView = nil
    }
}
