//
//  Created by Ben Cochran on 11/12/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import LLVM_C

public struct Use {
    internal var ref: LLVMUseRef
    internal init(ref: LLVMUseRef) {
        self.ref = ref
    }
    
    public var user: ValueType {
        return AnyValue(ref: LLVMGetUser(ref))
    }
}
