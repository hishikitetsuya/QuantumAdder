namespace Quantum.adder
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
	operation SetQubit(qs: Qubit[], target: Bool[]): Unit {
		for (i in 0..Length(qs) - 1) {
			if(target[i]) {
				X(qs[i]);
			}
		}
	}

	operation fulladder (a: Qubit, b: Qubit, cin: Qubit, s: Qubit, cout: Qubit): Unit {
		Reset(s);
		Reset(cout);

		// Parity messuerment provides "a + b + cin"
		let m0 = MeasureAllZ([a, b, cin]);
		if (m0 == One) {
			X(s);
		} 

		// Following provides majority of "[a, b, cin]" to Cout
		CCNOT(a, b, cout);
		CCNOT(a, cin, cout);
		CCNOT(b, cin, cout);
	}

    operation QuantumAdder (intA: Int, intB: Int, N: Int) : Int {

		let boolA = BoolArrFromPositiveInt(intA, N);
		let boolB = BoolArrFromPositiveInt(intB, N);
		mutable result =  0;

		// Need N*4 + 1 Qubits since
		//   a) N qubits for input register A
		//   b) N qubits for input register B
		//   c) N+1 qubits for carry 
		//   d) N qubits for result
		using (qs = Qubit[N * 4 + 1]) {
			let a = qs[0..N-1];
			let b = qs[N..2*N-1];
			let carry = qs[2*N..3*N];
			let sum = qs[3*N+1..4*N];

			let res = sum[0..N-1] + [carry[N]];

			SetQubit(a, boolA);
			SetQubit(b, boolB);

			for(i in 0..N -1) {
				fulladder(a[i], b[i], carry[i], sum[i], carry[i+1]);
			}

			set result = MeasureInteger(LittleEndian(res));
			ResetAll(qs);


		}
		return result;
    }
}
