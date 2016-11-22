//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import LLVM_C

public protocol ConstantType : ValueType {
    var isNull: Bool { get }
}

public extension ConstantType {
    var isNull: Bool {
        return LLVMIsNull(ref) != 0
    }
}

public struct RealConstant : ConstantType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }

    public static func type(_ type: TypeType, value: Double) -> RealConstant {
        return RealConstant(ref: LLVMConstReal(type.ref, value))
    }
    
    public static func type(_ type: TypeType, value: String) -> RealConstant {
        return RealConstant(ref: LLVMConstRealOfString(type.ref, value))
    }
    
    public var value: (Double, infoLost: Bool) {
        var infoLost: LLVMBool = 0
        let val = LLVMConstRealGetDouble(ref, &infoLost)
        return (val, infoLost != 0)
    }
}
