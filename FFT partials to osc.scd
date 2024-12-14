(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=6;
s.options.numInputBusChannels=2;
TempoClock.default.tempo_(1);
s.options.memSize = 8192*64;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 16;
s.options.sampleRate= 48000;
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

~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Dokuments/EXTERNAL/music/piece of my heart Intermission.wav",channels:0 );
~c2 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Dokuments/EXTERNAL/music/piece of my heart Intermission.wav",channels:1 );

(
SynthDef.new(\o1, {
    var in1,in2, chainx,chainy,b=0,az1=0,az2=0,el1=0,el2=0,rpr=1;
	var chainxx,chainyy,pl1=0,pl2=0,pl=0,amp1,amp2,phase;
	var angle1=0,angle2=90;
	var phase1,phase2,bank1,bank2,frames=1024*2;
	var samplerate=48000,sig,mags,phases;


    in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(frames), in1);

	bank2=200;

   bank2.do{



chainxx = chainx.pvcollect(frames, {|mag, phase, index|

//var mag, phase;

        // Compute magnitude and phase
   //     mag = hypot(real, imag);  // sqrt(real^2 + imag^2)
    //    phase = atan2(imag, real);  // atan2(imaginary, real)
			//K2A.ar(phase).poll;
		//[mag * cos(phase), mag * sin(phase)];
			mags=K2A.ar(mag);
			phases=K2A.ar(phase).poll;
			[mag,phase];

		}, frombin: b, tobin: b, zeroothers: 1);

		sig=SinOsc.ar((samplerate/frames)*b,phases,mags*0.001);
	b=b+1;
	//Out.ar(0,IFFT(chainxx));
		Out.ar(0,sig);
		};
}).add;
)
Synth(\o1)
