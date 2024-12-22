(
s.options.numBuffers=1024*2;
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=2;
s.options.memSize = 8192*128*2;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 16;
s.options.sampleRate= 44100;
s.options.maxSynthDefs=1024*8;
s.waitForBoot;
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

~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/uni/ksyme:cmrc/askhsh3/samples mix mono.wav",channels:0 );

~c1.numFrames/512
/////duration(seconds)=number of frames/samplerate

~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/uni/ksyme:cmrc/askhsh2/source/FLOROS A.wav",channels:0 );

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
    var in1,in2, chainx,chainy,b=128,az1=0,az2=0,el1=0,el2=0,rpr=1;
	var chainxx,chainyy,pl1=0,pl2=0,pl=0,amp1,amp2,phase;
	var angle1=0,angle2=90;
	var phase1,phase2,bank1,bank2,frames=1024*8;
	var samplerate=44100,mags,phases,complex;
	var sig1,sig2,m=0,p=16;


    in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(frames), in1);

	bank2=1;

   bank2.do{


chainxx = chainx.pvcollect(frames, {|magnitude, phase, index|

		//	mags=K2A.ar(magnitude);
		//phases=K2A.ar(phase);

//
		//	Out.kr(m,magnitude);
		//	Out.kr(p,phase);

		//	 BufWr.kr(magnitude, ~magBuffer.bufnum);  // Write magnitude to buffer
      //  BufWr.kr(phase, ~phaseBuffer.bufnum);  // Write phase to buffer

			[magnitude,phase];

		}, frombin: b, tobin: b, zeroothers: 1);

		//complex=exp(Complex(0,1)*phases);

	//	mags = BufRd.kr(1, ~magBuffer.bufnum); // Use MouseX for bin selection
   // phases = BufRd.kr(1, ~phaseBuffer.bufnum);

	//	sig1=Pan2.ar(SinOsc.ar((samplerate/frames)*b,BufRd.kr(1,~phaseBuffer.bufnum),BufRd.kr(1, ~magBuffer.bufnum)*0.001),0);
	//	sig1=Pan2.ar(SinOsc.ar((samplerate/frames)*b,In.kr(p),In.kr(m)*0.1),0);
	//	sig1=Pan2.ar(SinOsc.ar((samplerate/frames)*b,phases,mags*0.01),0);
	//	sig2=Pan2.ar(SinOsc.ar((samplerate/frames)*b,0,mags*0.001),complex.imag);
	b=b+1;
	//	m=m+1;
	//	p=p+1;
		Out.ar(0,Pan2.ar(IFFT(chainxx)*8,0));
		//Out.ar(0,Pan2.ar(IFFT(chainxx),complex.imag));
		//Out.ar(0,sig1);
	//	Out.ar(0,sig2);
		};
}).add;
)
Synth(\o1)
(44100/(1024*2))*1024/2


////////////////////////////individual bins with patttern

(
SynthDef.new(\obin, {

	var b=16;
    var in1,chainx,chainy;
	var chainxx,chainyy;
	var bank,frames=1024*2;
	var samplerate=44100;
	var env,k;

    in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(frames), in1);
	chainy = FFT(LocalBuf(frames), in1);
	//b=500.rand.postln;

	k=b;
	k.dump;

chainxx = chainx.pvcollect(frames, {|magnitude, phase, bin|

	//	if(bin == k,[magnitude,phase],[magnitude*0,phase*0]);
		[magnitude,phase]

}, frombin: k, tobin: k, zeroothers: 1);

chainyy = chainx.pvcollect(frames, {|magnitude, phase, bin|

	//	if(bin == k,[magnitude,phase+90.degrad],[magnitude*0,phase*0]);
		[magnitude,phase]

}, frombin: k, tobin: k, zeroothers: 1);

		Out.ar(0,IFFT(chainxx)*8);
		Out.ar(1,IFFT(chainyy)*8);
}).add;
)
Synth(\obin,[\b,16])
/////bin calc
(44100/(1024/4))*10

~time=4
/////////////////bin list
	({
		var n=1.neg;
	~list=(1024).collect{
		n=n+1;
		}
		}.value
	);
//////////////////pattern
(
~aa=Pdef(\1, Pbind(\instrument, \obin,
	\dur,Pseq([4],inf),
	\b,Pxrand(~list,inf)
));
	);

	TempoClock.default.tempo_(1/1);


~aa.play;
s.record(numChannels:4);
\\////////////////////////////////////multiple synths
(~c1.numFrames/512)*i
(
512.do{
	|i|
(
		SynthDef.new(\obin_++i, {

    var b=1.neg;
    var in1,chainx,chainy;
	var chainxx,chainyy;
	var bank,frames=1024;
	var samplerate=44100;
	var env,k;

	in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum),startPos:(~c1.numFrames/512)*i, loop: 0, doneAction:2);


	chainx = FFT(LocalBuf(frames), in1);
	chainy = FFT(LocalBuf(frames), in1);

			b=511.xrand(b).postln;

chainxx = chainx.pvcollect(frames, {|magnitude, phase, bin|
		[magnitude,phase]

}, frombin: b, tobin: b, zeroothers: 1);

chainyy = chainx.pvcollect(frames, {|magnitude, phase, bin|

		[magnitude,phase+90.degrad]

}, frombin: b, tobin: b, zeroothers: 1);

		Out.ar(0,IFFT(chainxx)*1);
		Out.ar(1,IFFT(chainyy)*1);
			chainx.clear;
			chainy.clear;

}).add;
);
}
)


Synth(\obin_++(511.rand))

Synth(\obin_10)

(var b=1.neg; 512.do{ b=511.xrand(b); Synth(\obin_++b)})

512.do{|i| Synth(\obin_++i);}

~dur=((~c1.numFrames/512)/44100)

(~c1.numFrames/512)*8



r=Routine{var b=1.neg; 512.do{ b=511.xrand(b);  Synth(\obin_++b).postln; (~dur).wait;}}
r.play
////////////////////////////////

~dur=((~c1.numFrames/512)/44100)

({
		var n=1.neg;
		~list=(512).collect{
		n=n+1;
		}
		}.value
	)
Synth(\bin);

(
SynthDef.new(\bin,{

	 var b=1.neg;
    var in1,chainx,chainy;
	var chainxx,chainyy;
	var bank,frames=1024;
	var samplerate=44100;
	var env,dur=((~c1.numFrames/512)/44100);

	512.do{

	in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum),startPos:0, loop: 0, doneAction:2);
			env=EnvGen.ar(Env.new([0,0,1],[dur,0.01],\sine));
			dur=dur+dur;

	chainx = FFT(LocalBuf(frames), in1);
	chainy = FFT(LocalBuf(frames), in1);

			b=511.xrand(b).postln;

chainxx = chainx.pvcollect(frames, {|magnitude, phase, bin|
		[magnitude,phase]

}, frombin: b, tobin: b, zeroothers: 1);

chainyy = chainx.pvcollect(frames, {|magnitude, phase, bin|

		[magnitude,phase+90.degrad]

}, frombin: b, tobin: b, zeroothers: 1);

		Out.ar(0,IFFT(chainxx)*env);
		Out.ar(1,IFFT(chainyy)*env);

};

}).add;

)