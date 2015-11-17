//
//  Created by Ben Cochran on 11/12/15.
//  Copyright © 2015 Ben Cochran. All rights reserved.
//

public class Use {
    internal var ref: LLVMUseRef
    internal init(ref: LLVMUseRef) {
        guard ref != nil else { fatalError("unexpected nil value") }
        self.ref = ref
    }
    
    public var user: Value {
        return Value(ref: LLVMGetUser(ref))
    }
}
