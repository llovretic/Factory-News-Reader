//
//  UIPageControl+Rx.swift
//  RxCocoa
//
//  Created by Francesco Puntillo on 14/04/2016.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)

import RxSwift
import UIKit
    
extension Reactive where Base: UIPageControl {
    
    /// Bindable sink for `currentPage` property.
    public var currentPage: Binder<Int> {
        return Binder(self.base) { singleNewsController, page in
            singleNewsController.currentPage = page
        }
    }
    
    /// Bindable sink for `numberOfPages` property.
    public var numberOfPages: Binder<Int> {
        return Binder(self.base) { singleNewsController, page in
            singleNewsController.numberOfPages = page
        }
    }
    
}
    
#endif
