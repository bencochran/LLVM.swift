//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import LLVM_C

public protocol GlobalValueType : ConstantType { }

public protocol GlobalObjectType : GlobalValueType { }

public protocol GlobalVariableType : GlobalObjectType { }

public struct AnyGlobalVariable : GlobalVariableType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
}
