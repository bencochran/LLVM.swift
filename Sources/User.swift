//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

import LLVM_C

// TODO CollectionType this up
public protocol UserType : ValueType {
    func operandAtIndex(index: UInt32) -> ValueType
    func operandUseAtIndex(index: UInt32) -> Use
    func setOperand(value: ValueType, atIndex: UInt32)
    var operandCount: UInt32 { get }
}

public extension UserType {
    public func operandAtIndex(index: UInt32) -> ValueType {
        return AnyValue(ref: LLVMGetOperand(ref, index))
    }
    
    public func operandUseAtIndex(index: UInt32) -> Use {
        return Use(ref: LLVMGetOperandUse(ref, index))
    }

    public func setOperand(value: ValueType, atIndex: UInt32) {
        LLVMSetOperand(ref, atIndex, value.ref)
    }
    
    public var operandCount: UInt32 {
        return UInt32(LLVMGetNumOperands(ref))
    }
}

// TODO CollectionType this up
public struct User : UserType {
    public let ref: LLVMValueRef
    public init(ref: LLVMValueRef) {
        self.ref = ref
    }
}
