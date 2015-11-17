//
//  Created by Ben Cochran on 11/13/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public class Constant : User {
    public var isNull: Bool {
        return LLVMIsNull(ref) != 0
    }
}

public class RealConstant : Constant {
    public static func type(type: Type, value: Double) -> RealConstant {
        return RealConstant(ref: LLVMConstReal(type.ref, value))
    }
    
    public static func type(type: Type, value: String) -> RealConstant {
        return RealConstant(ref: LLVMConstRealOfString(type.ref, value))
    }
    
    public var value: (Double, infoLost: Bool) {
        var infoLost: LLVMBool = 0
        let val = LLVMConstRealGetDouble(ref, &infoLost)
        return (val, infoLost != 0)
    }
}
