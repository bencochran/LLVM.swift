//
//  Created by Ben Cochran on 11/12/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import LLVM_C

public class Context {
    internal let ref: LLVMContextRef
    private let managed: Bool
    
    internal init(ref: LLVMContextRef, managed: Bool) {
        self.ref = ref
        self.managed = managed
    }
    
    public static let globalContext = Context(ref: LLVMGetGlobalContext(), managed: false)
    
    deinit {
        if managed {
            LLVMContextDispose(ref)
        }
    }
}
