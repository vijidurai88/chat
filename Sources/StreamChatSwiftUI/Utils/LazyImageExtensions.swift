//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Nuke
import NukeUI
import SwiftUI

extension LazyImage {

    public init(imageURL: URL?) where Content == NukeUI.Image {
        let imageCDN = InjectedValues[\.utils].imageCDN
        guard let imageURL = imageURL else {
            #if COCOAPODS
            self.init(source: imageURL)
            #else
            self.init(url: imageURL, resizingMode: .aspectFill)
            #endif
            return
        }
        let urlRequest = imageCDN.urlRequest(forImage: imageURL)
        let imageRequest = ImageRequest(urlRequest: urlRequest)
        #if COCOAPODS
        self.init(source: imageRequest)
        #else
        self.init(request: imageRequest, resizingMode: .aspectFill)
        #endif
    }

    public init(imageURL: URL?, @ViewBuilder content: @escaping (LazyImageState) -> Content) {
        let imageCDN = InjectedValues[\.utils].imageCDN
        guard let imageURL = imageURL else {
            #if COCOAPODS
            self.init(source: imageURL, content: content)
            #else
            self.init(url: imageURL, content: content)
            #endif
            return
        }
        let urlRequest = imageCDN.urlRequest(forImage: imageURL)
        let imageRequest = ImageRequest(urlRequest: urlRequest)
        #if COCOAPODS
        self.init(source: imageRequest, content: content)
        #else
        self.init(request: imageRequest, content: content)
        #endif
    }
}
