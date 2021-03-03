/*
 MRNotificationStyle.swift
 Created by Mohammadreza Khatibi (mohammadreza.me) on 3/1/21.
 
 Copyright 2021 Mohammadreza Khatibi ~ http://mohammadreza.me
 Github: https://github.com/mohammadrezakhatibi
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit

private protocol MRNotificationBannerConfigurationProtocol {
    func configuration() -> MRNotificationBannerConfiguration
}
extension MRNotificationBanner {
    
    public enum MRNotificationStyle: MRNotificationBannerConfigurationProtocol {
        
        case success
        case danger
        case info
        case warning
        case custom(config: MRNotificationBannerConfiguration)
        
        public func configuration() -> MRNotificationBannerConfiguration {
            var configuration = MRNotificationBannerConfiguration()
            
            switch self {
            case .success:
                configuration.backgroundColor = UIColor.hex("65CF60")
                configuration.titleColor = UIColor.white
                return configuration
                
            case .danger:
                configuration.backgroundColor = UIColor.hex("F7DDDB")
                configuration.titleColor = UIColor.hex("3C1611")
                return configuration
                
            case .warning:
                configuration.backgroundColor = UIColor.hex("FAE5B8")
                configuration.titleColor = UIColor.hex("433312")
                return configuration
                
            case .info:
                configuration.backgroundColor = UIColor.hex("DBE5FD")
                configuration.titleColor = UIColor.hex("1A2B17")
                return configuration
                
            case .custom(let config):
                return config
            }
        }
    }
    
}
