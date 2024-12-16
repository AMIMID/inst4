(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=6;
s.options.numInputBusChannels=2;
TempoClock.default.tempo_(1);
s.options.memSize = 8192*64;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 16;
s.options.sampleRate= 44100;
s.waitForBoot
)

////////////////buffers
Buffer.freeAll
(
(
~c1 = Buffer.readChannel(s,,channels:0 );
~c2 = Buffer.readChannel(s,,channels:1 );
~c3 = Buffer.readChannel(s,,channels:2 );
~c4 = Buffer.readChannel(s,,channels:3 );
~c5 = Buffer.readChannel(s,,channels:4 );
~c6 = Buffer.readChannel(s,,channels:5 );
);
)
~c1 = Buffer.read(s,"/Users/petrostatsiopoulos/Dokuments/EXTERNAL/music/piece of my heart Intermission.wav");

~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/uni/ksyme:cmrc/askhsh2/source/SPINOS A.wav",channels:0 );


~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Dokuments/EXTERNAL/music/piece of my heart Intermission.wav",channels:0 );
~c2 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Dokuments/EXTERNAL/music/piece of my heart Intermission.wav",channels:1 );

	({
		var angle=0;
		~angle=(720*8).collect{
		angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
		}
		}.value;
	);

s.boot;

// Allocate buffers for magnitude and phase
~magBuffer = Buffer.alloc(s, 1024);  // For magnitude
~phaseBuffer = Buffer.alloc(s, 1024); // For phase


(
SynthDef.new(\o1, {
    var in1,in2, chainx,chainy,b=0,az1=0,az2=0,el1=0,el2=0,rpr=1;
	var chainxx,chainyy,pl1=0,pl2=0,pl=0,amp1,amp2,phase;
	var angle1=0,angle2=90;
	var phase1,phase2,bank1,bank2,frames=1024;
	var samplerate=44100,mags,phases,complex;
	var sig1,sig2;


    in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(frames), in1);

	bank2=180;

   bank2.do{


chainxx = chainx.pvcollect(frames, {|magnitude, phase, index|

			//mags=K2A.ar(magnitude);
		//phases=K2A.ar(phase);

		//	mags=K2A.ar(magnitude.sqrt);
		//	phases=K2A.ar(magnitude.atan2(phase));
//
		//	Out.kr(0,magnitude);
			//Out.kr(1,phase);

			 BufWr.kr(magnitude, ~magBuffer.bufnum);  // Write magnitude to buffer
        BufWr.kr(phase, ~phaseBuffer.bufnum);  // Write phase to buffer

			[magnitude,phase];

		}, frombin: b, tobin: b, zeroothers: 1);

		//complex=exp(Complex(0,1)*phases);

	//	mags = BufRd.kr(1, ~magBuffer.bufnum); // Use MouseX for bin selection
   // phases = BufRd.kr(1, ~phaseBuffer.bufnum);

	//	sig1=Pan2.ar(SinOsc.ar((samplerate/frames)*b,In.kr(1),In.kr(0)*0.001),0);
	//	sig1=Pan2.ar(SinOsc.ar((samplerate/frames)*b,phases,mags*0.001),0);
	//	sig2=Pan2.ar(SinOsc.ar((samplerate/frames)*b,0,mags*0.001),complex.imag);
	b=b+1;
		//Out.ar(0,Pan2.ar(IFFT(chainxx),complex.real));
		//Out.ar(0,Pan2.ar(IFFT(chainxx),complex.imag));
	//	Out.ar(0,sig1);
	//	Out.ar(0,sig2);
		};
}).add;
)
Synth(\o1)
(44100/(1024*16))*180

{SinOsc.ar(440,BufRd.kr(1, ~phaseBuffer.bufnum),BufRd.kr(1, ~magBuffer.bufnum).poll)}.play
