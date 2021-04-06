/*
 MRNotificationBanner.swift
 Created by Mohammadreza Khatibi (mohammadreza.me) on 3/1/21.
 
 Copyright 2021 Mohammadreza Khatibi ~ http://mohammadreza.me
 Github: https://github.com/mohammadrezakhatibi
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

open class MRNotificationBanner: UIView {
    
    private var titleLabel      : UILabel
    private var subtitleLabel   : UILabel
    private var bannerView      : UIView
    private var OriginalFrame   : CGRect? = .zero
    private var bannerType      : MRNotificationType = .full
    private var parent          : UIView!
    private var timer           : Timer?
    private var queue           : [MRNotificationBanner]
    private var configuration   : MRNotificationBannerConfiguration
        
    /// Notification Types
    public enum MRNotificationType {
        
        /// It's like Android snack bar.
        /// Open from bottom
        case snack
        
        /// Full width notification.
        /// Open from top and behind navigationBar.
        case full
        
        /// It's like snack bar but open from top.
        /// margin can set in configuration with bannerEdgeInset.
        case float
    }
    
    public init(type: MRNotificationType) {
        
        titleLabel                  = UILabel()
        subtitleLabel               = UILabel()
        bannerView                  = UIView()
        queue                       = [MRNotificationBanner]()
        configuration               = MRNotificationBannerConfiguration()
        
        super.init(frame: .zero)
        
        bannerType                  = type
        
        titleLabel.numberOfLines    = 0
        titleLabel.lineBreakMode    = .byWordWrapping
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(title: String,
                     subtitle: String? = nil,
                     style: MRNotificationStyle,
                     parentView: UIView,
                     icon: UIImage? = nil,
                     dismissAutomatically: Bool? = true) {
        
        
        /// Set parent view
        parent = parentView
        
        /// Set configuration
        configuration = style.configuration()
        
        /// Add icon to banner
        addBannerStyleAndColor(with: bannerType, and: style)
        
        /// Parent Width
        let width = parent.frame.size.width
        
        /// Banner vertical and horizontal margin
        /// Margin calculated based on bannerEdgeInset set in configuration
        /// For .full type horizontal and vertical margin set to 0
        let bannerHorizontalMargin  = bannerType == .full ? 0 : (configuration.notificationEdgeInset.left + configuration.notificationEdgeInset.right)
        let bannerVerticalMargin    = bannerType == .full ? 0 : (configuration.notificationEdgeInset.top + configuration.notificationEdgeInset.bottom)
        
        /// Calculate banner width
        /// calculated based on parents width and horizontal margin
        let bannerWidth = width - bannerHorizontalMargin
        
        
        /// All labels (title and subtitle) vertical and horizontal margin
        /// Margin calculated based on labelEdgeInset and subtitleLabelEdgeInset set in configuration
        let labelsVerticalMargin = (configuration.labelEdgeInset.top + configuration.subtitleLabelEdgeInset.top) + (subtitle == nil ? (self.configuration.labelEdgeInset.bottom) : (self.configuration.subtitleLabelEdgeInset.bottom))
        let labelsHorizontalMargin = (self.configuration.labelEdgeInset.right + self.configuration.labelEdgeInset.left)
        
        
        /// Calculate label width
        /// calculated based on parents width and labels and banner horizontal margins
        let labelWidth = width - (labelsHorizontalMargin + bannerHorizontalMargin)
        
        
        /// Add elements to parent view
        bannerView.addSubview(titleLabel)
        bannerView.addSubview(subtitleLabel)
        addSubview(bannerView)
        parent.addSubview(self)
        
        
        /// Initial titleLabel
        /// Add font, value and frame to titleLabel and calculate titleLabel height
        titleLabel.text = title
        titleLabel.font = style.configuration().titleFont
        titleLabel.frame = CGRect(x: configuration.labelEdgeInset.left,
                                  y: configuration.labelEdgeInset.top,
                                  width: labelWidth,
                                  height: 0)
        
        titleLabel.textAlignment = configuration.textAlignment!
        titleLabel.sizeToFit()
        let labelHeight = titleLabel.textRect(forBounds: titleLabel.bounds, limitedToNumberOfLines: 0).height
        
        
        /// Initial subtitleLabel
        /// Add font, value and frame to subtitleLabel and calculate subtitleLabel height
        subtitleLabel.font = style.configuration().subtitleFont
        subtitleLabel.text = subtitle
        subtitleLabel.frame = CGRect(x: configuration.subtitleLabelEdgeInset.left,
                                     y: (configuration.labelEdgeInset.top + configuration.subtitleLabelEdgeInset.top) + labelHeight,
                                     width: labelWidth,
                                     height: 0)
        
        subtitleLabel.textAlignment = configuration.textAlignment!
        subtitleLabel.sizeToFit()
        let subtitleLabelHeight = subtitleLabel.textRect(forBounds: subtitleLabel.bounds, limitedToNumberOfLines: 0).height
        
        
        /// Banner Height
        /// Calculate height of banner based on labels and margins
        let bannerHeight = subtitleLabelHeight + labelHeight + labelsVerticalMargin
        
        
        /// Set titleLabel frame
        titleLabel.frame = CGRect(x: configuration.labelEdgeInset.left,
                                  y: configuration.labelEdgeInset.top,
                                  width: labelWidth,
                                  height: labelHeight)
        
        /// Set subtitleLabel frame
        subtitleLabel.frame = CGRect(x: configuration.subtitleLabelEdgeInset.left,
                                     y: subtitleLabel.frame.origin.y,
                                     width: labelWidth,
                                     height: subtitleLabelHeight)
        
        /// Set originalFrame and bannerView's frame
        switch bannerType {
        
        case .full:
            
            OriginalFrame = CGRect(x: 0, y: -bannerHeight, width:bannerWidth, height: bannerHeight)
            bannerView.frame = CGRect(x: 0, y: -bannerHeight , width: width, height: bannerHeight)
            
        case .snack:
            
            OriginalFrame = CGRect(x: configuration.notificationEdgeInset.left, y: parent.frame.height + (bannerHeight + bannerVerticalMargin), width:bannerWidth, height: bannerHeight)
            bannerView.frame = CGRect(x: configuration.notificationEdgeInset.left, y: parent.frame.height + bannerVerticalMargin, width: width - (configuration.notificationEdgeInset.left + configuration.notificationEdgeInset.right), height: bannerHeight)
        default:
            OriginalFrame = CGRect(x: configuration.notificationEdgeInset.left, y: 0 + (-bannerHeight - bannerVerticalMargin), width:bannerWidth, height: bannerHeight)
            bannerView.frame = CGRect(x: configuration.notificationEdgeInset.left, y: -bannerHeight - bannerVerticalMargin, width: width - (configuration.notificationEdgeInset.left + configuration.notificationEdgeInset.right), height: bannerHeight)
        }
    
        /// Add icon to bannerView
        if let icon = icon {
            addIcon(icon: icon, bannerHeight: bannerHeight, labelWidth: labelWidth, labelHeight: labelHeight, subtitleLabelHeight: subtitleLabelHeight)
        }
        
    
        /// Finally, show bannerView
        switch bannerType {
        case .full:
            showFullBanner(width: width, bannerHeight: bannerHeight, dismissAutomatically: dismissAutomatically)
        case .snack:
            showSnakBanner(width: width, bannerHeight: bannerHeight, dismissAutomatically: dismissAutomatically)
        default:
            showFloatBanner(width: width, bannerHeight: bannerHeight, dismissAutomatically: dismissAutomatically)
        }
        
    }
    
    
    /// Add icon to banner
    private func addIcon(icon: UIImage, bannerHeight: CGFloat, labelWidth: CGFloat, labelHeight: CGFloat, subtitleLabelHeight: CGFloat ) {
        
        /// Intial icon
        let icon = UIImageView(image: icon)
        bannerView.addSubview(icon)
        
        /// Change icon frame
        icon.frame = CGRect(x: 12, y: (bannerHeight / 2) - 11, width: 22, height: 22)
        
        /// Change titleLabelFrame
        titleLabel.frame = CGRect(x: 44, y: configuration.labelEdgeInset.top, width: labelWidth - 30, height: labelHeight)
        subtitleLabel.frame = CGRect(x: 44,
                                     y: subtitleLabel.frame.origin.y,
                                     width: labelWidth - 30,
                                     height: subtitleLabelHeight)
        
    }
    
    /// Set banner styles and colors
    private func addBannerStyleAndColor(with type: MRNotificationType, and style: MRNotificationStyle) {
        
        bannerView.layer.cornerRadius = type == .full ? 0 : configuration.cornerRadius
        
        if configuration.dropShadow == true {
            dropShadow()
        }
        
        switch type {
        case .snack:
            bannerView.backgroundColor = UIColor.hex("000000", alpha: 0.75)
            titleLabel.textColor = UIColor.white
            subtitleLabel.textColor = UIColor.white
        default:
            bannerView.backgroundColor = configuration.backgroundColor
            titleLabel.textColor = configuration.titleColor
            subtitleLabel.textColor = configuration.titleColor
            bannerView.layer.shadowColor = configuration.titleColor.cgColor
        }
    }

    /// DropShadow function
    private func dropShadow() {
        bannerView.layer.shadowOpacity = 0.15
        bannerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bannerView.layer.shadowRadius = 5
        bannerView.layer.shadowPath = UIBezierPath(rect: bannerView.bounds).cgPath
        bannerView.layer.shouldRasterize = true
        bannerView.layer.rasterizationScale = UIScreen.main.scale
    }
}

// Banner Animations
extension MRNotificationBanner {
    
    private func showFullBanner(width: CGFloat, bannerHeight: CGFloat,dismissAutomatically: Bool?) {
        
        queue.append(self)
        UIView.animate(withDuration: configuration.animateDuration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.85, options: .curveEaseInOut, animations: { [weak self] in
            
            guard let self = self else { return }
            self.bannerView.frame =  CGRect(x: 0, y: 0, width: width, height: bannerHeight)
            self.parent.layoutIfNeeded()
            
        }, completion: { [weak self] (finished) in
            
            guard let self = self else { return }
            if dismissAutomatically == true {
                self.beginToDismissAutomatically()
            }
            
        })
    }
    
    private func showSnakBanner(width: CGFloat, bannerHeight: CGFloat,dismissAutomatically: Bool?) {
        
        queue.append(self)
        UIView.animate(withDuration: configuration.animateDuration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.85, options: .curveEaseInOut, animations: { [weak self] in
            
            guard let self = self else { return }
            self.bannerView.frame =  CGRect(x: self.configuration.notificationEdgeInset.left, y: self.parent.frame.height - (bannerHeight + self.configuration.notificationEdgeInset.top + self.parent.safeAreaInsets.bottom), width: width - (self.configuration.notificationEdgeInset.left + self.configuration.notificationEdgeInset.right), height: bannerHeight)
            self.parent.layoutIfNeeded()
            
        }, completion: { [weak self] (finished) in
            
            guard let self = self else { return }
            if dismissAutomatically == true {
                self.beginToDismissAutomatically()
            }
            
        })
        
    }
    
    private func showFloatBanner(width: CGFloat, bannerHeight: CGFloat,dismissAutomatically: Bool?) {
        
        queue.append(self)
        UIView.animate(withDuration: configuration.animateDuration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.85, options: .curveEaseInOut, animations: { [weak self] in
            
            guard let self = self else { return }
            self.bannerView.frame =  CGRect(x: self.configuration.notificationEdgeInset.left, y: self.configuration.notificationEdgeInset.top, width: width - (self.configuration.notificationEdgeInset.left + self.configuration.notificationEdgeInset.right), height: bannerHeight)
            
            self.parent.layoutIfNeeded()
            
        }, completion: { [weak self] (finished) in
            
            guard let self = self else { return }
            if dismissAutomatically == true {
                self.beginToDismissAutomatically()
            }
            
        })
        
    }
    
    public func dismiss() {
        dismissBanner()
    }
    
    private func beginToDismissAutomatically() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: self.configuration.bannerAppearanceDuration, target: self, selector: #selector(dismissBanner), userInfo: nil, repeats: false)
    }
    
    private func dismissElementInQueue() {
        DispatchQueue.main.async {
            self.dismissBanner()
        }
    }
    /// BannerView dismiss function
    @objc private func dismissBanner() {
        
        UIView.animate(withDuration: configuration.animateDuration, delay: 0.05, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.85, options: .curveEaseIn, animations: { [weak self] in
            
            guard let self = self else { return }
            
            var element : MRNotificationBanner?
            if let index = self.queue.firstIndex(of: self) {
                element = self.queue[index]
            }
            element?.bannerView.frame =  (element?.OriginalFrame)!
            guard let parent = element?.parent else { return }
            parent.layoutIfNeeded()
            
            /// remove all elements in queue
            self.queue.remove(at: self.queue.firstIndex(of: self) ?? 0)
            for element in self.queue {
                element.dismissElementInQueue()
            }
            
            
        }, completion: { [weak self] finished in
            
            /// Remove subview after time bannerAppearanceDuration second
            guard let self = self else { return }
            var element : MRNotificationBanner?
            /// Remove all elements in queue from superview
            if let index = self.queue.lastIndex(of: self) {
                element = self.queue[index]
            }
            element?.bannerView.removeFromSuperview()
            
        })
    }
}
