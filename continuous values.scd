({
		var angle=0;
		~angle=(720).collect{
		angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
		}
		}.value;
	)

///////////////////////////////////////////routine sending to control bus
~controlBus.free
(
~controlBus1 = Bus.control(s, 1);
~controlBus2 = Bus.control(s, 1);
)

(
 // Initialize angle
var angle = 0, value1, value2;
~angleRoutine = Routine({
    loop {
        // Calculate the next angle
        angle = (angle + (360 - (360 / 1.6180339887499))).wrap(0, 360);
       // angle.yield; // Yield the value to the routine
		value1=exp(Complex(0,1)*angle.degrad).imag.abs;
		value2=exp(Complex(0,1)*angle.degrad).real.abs;
		"value1".postln;
		value1.postln;
		"value2".postln;
		value2.postln;
		~controlBus1.set(value1);
		~controlBus2.set(value2);
		0.1.wait;
    }
});
)

//) Start the routine and get values
~angleRoutine.play; // Get the first 10 values

(
{
		Out.ar(0,SinOsc.ar(440*In.kr(~controlBus1).reciprocal,mul:In.kr(~controlBus1)));
	    Out.ar(1,SinOsc.ar(440*In.kr(~controlBus2).reciprocal,phase:90.degrad,mul:In.kr(~controlBus2)));
}.play
)




/////////////////////////////////////////////

