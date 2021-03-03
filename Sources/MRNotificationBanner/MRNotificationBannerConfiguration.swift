/*
 MRNotificationBannerConfiguration.swift
 Created by Mohammadreza Khatibi (mohammadreza.me) on 3/1/21.
 
 Copyright 2021 Mohammadreza Khatibi ~ http://mohammadreza.me
 Github: https://github.com/mohammadrezakhatibi
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


import UIKit

public struct MRNotificationBannerConfiguration {
    
    public var notificationEdgeInset    : UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    public var labelEdgeInset           : UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    public var subtitleLabelEdgeInset   : UIEdgeInsets = UIEdgeInsets(top: 04, left: 16, bottom: 12, right: 16)
    
    public var titleFont                : UIFont = UIFont.systemFont(ofSize: 15,weight: .medium)
    public var subtitleFont             : UIFont = UIFont.systemFont(ofSize: 15,weight: .regular)
    
    public var backgroundColor          : UIColor = UIColor.gray
    public var titleColor               : UIColor = UIColor.blue
    
    public var animateDuration          : TimeInterval = 0.35
    public var bannerAppearanceDuration : TimeInterval = 3
    
    public var cornerRadius             : CGFloat = 12.0
    
    public var dropShadow               : Bool = false
    
    public init() {}
    
}

