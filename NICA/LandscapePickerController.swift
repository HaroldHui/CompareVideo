//
//  LandscapePickerController.swift
//  NICA
//
//  Created by HUIShu on 5/10/16.
//  Copyright © 2016 Johan Albert. All rights reserved.
//

import Foundation
import UIKit
class LandscapePickerController: UIImagePickerController
{
    internal override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }
}
