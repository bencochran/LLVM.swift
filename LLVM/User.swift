//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

// TODO CollectionType this up
public class User : Value {
    public func operandAtIndex(index: UInt32) -> Value {
        return Value(ref: LLVMGetOperand(ref, index))
    }
    
    public func operandUseAtIndex(index: UInt32) -> Use {
        return Use(ref: LLVMGetOperandUse(ref, index))
    }

    public func setOperand(value: Value, atIndex: UInt32) {
        LLVMSetOperand(ref, atIndex, value.ref)
    }
    
    public var operandCount: UInt32 {
        return UInt32(LLVMGetNumOperands(ref))
    }
}
