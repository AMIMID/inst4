(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=32;
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
    var in1,in2, chainx,chainy,b=1,az1=0,az2=0,el1=0,el2=0,rpr=1;
	var chainxx,chainyy,pl1=0,pl2=0,pl=0,amp1,amp2,phase;
	var angle1=0,angle2=90;
	var phase1,phase2,bank1,bank2,frames=128;
	var samplerate=44100,mags,phases,complex;
	var sig1,sig2,m=0,p=16;


    in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(frames), in1);

	bank2=16;

   bank2.do{


chainxx = chainx.pvcollect(frames, {|magnitude, phase, index|

			//mags=K2A.ar(magnitude);
		//phases=K2A.ar(phase);

		//	mags=K2A.ar(magnitude.sqrt);
		//	phases=K2A.ar(magnitude.atan2(phase));
//
			Out.kr(m,magnitude);
			Out.kr(p,phase);

		//	 BufWr.kr(magnitude, ~magBuffer.bufnum);  // Write magnitude to buffer
      //  BufWr.kr(phase, ~phaseBuffer.bufnum);  // Write phase to buffer

			[magnitude,phase];

		}, frombin: b, tobin: b, zeroothers: 1);

		//complex=exp(Complex(0,1)*phases);

	//	mags = BufRd.kr(1, ~magBuffer.bufnum); // Use MouseX for bin selection
   // phases = BufRd.kr(1, ~phaseBuffer.bufnum);

	//	sig1=Pan2.ar(SinOsc.ar((samplerate/frames)*b,BufRd.kr(1,~phaseBuffer.bufnum),BufRd.kr(1, ~magBuffer.bufnum)*0.001),0);
		sig1=Pan2.ar(SinOsc.ar((samplerate/frames)*b,In.kr(p),In.kr(m)*0.1),0);
	//	sig1=Pan2.ar(SinOsc.ar((samplerate/frames)*b,phases,mags*0.001),0);
	//	sig2=Pan2.ar(SinOsc.ar((samplerate/frames)*b,0,mags*0.001),complex.imag);
	b=b+1;
		m=m+1;
		p=p+1;
		//Out.ar(0,Pan2.ar(IFFT(chainxx),complex.real));
		//Out.ar(0,Pan2.ar(IFFT(chainxx),complex.imag));
		Out.ar(0,sig1);
	//	Out.ar(0,sig2);
		};
}).add;
)
Synth(\o1)
(44100/(128))*16


////////////////////////////

(
		~time=16;
//////////////////////////////////////////////////basis
{
var  sph1,sph2,sph3,sph4,sph5,m_x=3,m_y=2,m_z=3;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z;
var az4=0,el4=0,az5=0,el5=0,pl1=0,pl2=0,pl3=0,pl4=0,pl5=0;

~az = (720*~time).collect{
	pl1=pl1+1;

		az1=(az1+(1)).wrap(180.neg,180);

	el1=(el1+(360-(360/1.6180339887499))).wrap(90.neg,90);

		sph1=Spherical(1,(az1.degrad).wrap(pi.neg,pi),(el1.degrad).wrap((pi/2).neg,(pi/2))).theta.round(0.00001);

	};

~el = (720*~time).collect{
	pl2=pl2+1;

		az2=(az2+(1)).wrap(180.neg,180);

	el2=(el2+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph2=Spherical(1,(az2.degrad).wrap(pi.neg,pi),(el2.degrad).wrap((pi/2).neg,(pi/2))).phi.round(0.00001);

	};

~magx = (720*~time).collect{
pl3=pl3+1;
	az3=(az3+(1)).wrap(180.neg,180);

	el3=(el3+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph3=Spherical(1,(az3.degrad).wrap(pi.neg,pi),(el3.degrad).wrap((pi/2).neg,(pi/2)));

			//mag_x=(Complex(cos((sph3.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sph3.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*Complex(cos((sph3.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sph3.rho;

////for in-between harmonics multiply sin(phi) after cos, when m is 2 then harm 3/2 is formed in oder 3, when m is 3 harm 4/3 is formed in oder 4 and when m is 3 for theta and 2 for phi harm 4/2 is formed for order4//////same for y axis

		 mag_x=(Complex(cos((sph3.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),
		 	cos((sph3.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
		 	Complex(sin((sph3.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sph3.phi.round(0.00001)*(m_x-1)).wrap((pi/
			2).neg,(pi/2)))).rho*
		 Complex(cos((sph3.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph3.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sph3.rho;

};

~magy = (720*~time).collect{
pl4=pl4+1;
	az4=(az4+(1)).wrap(180.neg,180);

	el4=(el4+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph4=Spherical(1,(az3.degrad).wrap(pi.neg,pi),(el4.degrad).wrap((pi/2).neg,(pi/2)));

	mag_y=(Complex(sin((sph4.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),
		sin((sph4.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sph4.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.00001)).wrap((pi/2).neg,(pi/
		2)))).rho)*sph4.rho;
//		mag_y=(Complex(sin((sph4.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sph4.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sph4.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sph4.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sph4.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph4.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sph4.rho;
};

~magz = (720*~time).collect{
pl5=pl5+1;
	az5=(az5+(1)).wrap(180.neg,180);

	el5=(el5+(360-(360/1.6180339887499))).wrap(90.neg,90);

		sph5=Spherical(1,((az5.degrad).wrap(pi.neg,pi)).wrap(pi.neg,pi),((el5.degrad).wrap((pi/2).neg,(pi/2))).wrap((pi/2).neg,(pi/2)));

if(
m_z.even,
mag_z=Complex(cos((sph5.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sph5.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sph5.rho,
mag_z=Complex(sin((sph5.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sph5.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sph5.rho
	);
////z axis   ambi..  sin for odd numbers, cos for even
	};
}.value;

	)

(
SynthDef.new(\o1, {
    var in1,in2, chainx,chainy,b=0,az1=0,az2=0,el1=0,el2=0,rpr=1;
	var chainxx,chainyy,pl1=0,pl2=0,pl=0,amp1,amp2,phase;
	var angle1=0,angle2=90;
	var phase1,phase2,bank1,bank2,frames=1024;
	var samplerate=44100,mags,phases,complex;
	var sig1,sig2,sig3,mag_o,sphere,ton1,ton2,ton3,mult;


    in1 = PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1), loop: 0, doneAction:2);

	chainx = FFT(LocalBuf(frames), in1);

	bank2=360;
	mult=24;

   bank2.do{

		mag_o=Cartesian(~magx.[b],~magy.[b],~magz.[b]);
		sphere=Spherical(mag_o.rho/(2.sqrt)*mult,~az.[b],~el.[b]);

		ton1=2.pow(sphere.x.round(0.00001)/12);
		ton2=2.pow(sphere.y.round(0.00001)/12);
		ton3=2.pow(sphere.z.round(0.00001)/12);

chainxx = chainx.pvcollect(frames, {|magnitude, phase, index|

							mags=K2A.ar(magnitude);
		phases=K2A.ar(phase);
			[magnitude,phase];



		}, frombin: b, tobin: b, zeroothers: 1);

	sig1=Pan2.ar(SinOsc.ar((samplerate/frames)*b*ton1,phases,ton1.reciprocal*mag_o.rho/(2.sqrt)*mags*0.001),0);
		sig2=Pan2.ar(SinOsc.ar((samplerate/frames)*b*ton2,phases,ton2.reciprocal*mag_o.rho/(2.sqrt)*mags*0.001),0);
		sig3=Pan2.ar(SinOsc.ar((samplerate/frames)*b*ton3,phases,ton3.reciprocal*mag_o.rho/(2.sqrt)*mags*0.001),0);

	b=b+1;
	//	Out.ar(0,Pan2.ar(IFFT(chainxx),complex.real));
	//	Out.ar(0,Pan2.ar(IFFT(chainxx),complex.imag));
	Out.ar(0,sig1);
	Out.ar(0,sig2);
	Out.ar(0,sig3);
		};
}).add;
)
Synth(\o1)