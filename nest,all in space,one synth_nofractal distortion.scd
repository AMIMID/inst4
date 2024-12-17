(
Server.default = s = Server.local;
////server setup
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=6;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(0.5);
s.options.memSize = 8192*128;
s.options.blockSize = 64*8;
s.options.maxNodes = 1024 * 16;
s.options.sampleRate= 48000;
);

s.waitForBoot{
/////wavetables
Buffer.freeAll;

(
~w1= Buffer.alloc(s,2048);
~w2= Buffer.alloc(s,2048);
~w3= Buffer.alloc(s,2048);
~t= Buffer.alloc(s,2048);
);

////////////////////////////////////speaker setup///other
/*(
// 3D///cube
~a = VBAPSpeakerArray.new(3, [[0, 45], [90, 45], [180, 45], [90.neg, 45],[0, 45.neg], [90, 45.neg], [180, 45.neg], [90.neg, 45.neg]]);
//0 up fl, 1 up bl, 2 up br, 3 up fr, 4 down fl, 5 down bl, 6 down br, 7 down fr
~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
///furhter on speaker setup can be geodesic octahedron 2nd order torus with 16 channels, and Rhombic triacontahedron with 32 vertices as 32 speaker channels
	// )*/
	// ~a = VBAPSpeakerArray.new(3, [[0, 45], [180, 45], [90, 45.neg], [90.neg, 45.neg]]);
	// ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);

	/////octahedron
	~a = VBAPSpeakerArray.new(3, [[0, 0], [90, 0], [180, 0], [90.neg, 0],[0,90],[0,90.neg]]);
	~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);

// 16
	// ~a = VBAPSpeakerArray.new(3, [[0, 45], [90, 45], [180, 45], [90.neg, 45],
	// 	[0, 0], [45, 0], [90, 0], [135, 0],[180.neg,0], [135.neg, 0], [90.neg, 0],[45.neg, 0],
	// [0, 45.neg], [90, 45.neg], [180, 45.neg], [90.neg, 45.neg]]);
	// //0 up fl, 1 up bl, 2 up br, 3 up fr, 4 down fl, 5 down bl, 6 down br, 7 down fr
	// ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
///furhter on speaker setup can be geodesic octahedron 2nd order torus with 16 channels, and Rhombic triacontahedron with 32 vertices as 32 speaker channels
//)

///////////////////////////////////////////////////////arrays
///////fractal
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


////////////////////////////////////////////////////////notes and durs
{
var dur=2,ph1,ph2,ph3,ph4,ph5,ph6,pl1=0,pl2=0,pl3=0,pl4=0,pl5=0,pl6=0;
var sph1,sph2,sph3,sph4,sph5,sph6,sph7,sph8,sph9;
var n1,n2,n3,n4,n5,n6,n7,n8,n9,mult=122;
var mag1,mag2,mag3,mag4,mag5,mag6,mag7,mag8,mag9,rythm;
var index1,index2,index3,index4,index5,index6,pl7=0,pl8=0,pl9=0,t1,t2,t3,t4,t5,t6;
var pl10=0,pl11=0,pl12=0,pl13=0,pl14=0,pl15=0;

///////////////////////L-system algae variable a,b rules:a=ab b=a , n3 for n0=a
rythm=[1,1/1,1,1,1/1];

~dur = (180*~time).collect{
			ph1=Cartesian(~magx.[pl1],~magy.[pl1],~magz.[pl1]).rho/(2.sqrt);
	index1=rythm.wrapAt(pl7);
	pl7=pl7+1;
	pl1=pl1+1;
	ph1=(ph1*dur).round(1/256);
	t1=ph1*index1;

	};

}.value;
		//////////////////////wavetable
		{
var signal,wt,m=0,amp;

~level=90.collect{m=m+1;amp=m.reciprocal};
~phase=90.collect{pi};
signal=Signal.sineFill(1024,~level,~phase);

wt = signal.asWavetable;
~t.loadCollection(wt);
signal.plot;
		}.value;
(
		{
var env,sig,wt,angle=0,level,levels,pl=1.neg;

~levelsss=360.collect{

	level=exp(Complex(0,1)*angle).imag;
		angle=angle+1.degrad;
				pl=pl+1;
				//level=level;
				levels=level.rrand(exp(Complex(0,1)*angle+((360-(360/1.6180339887499))/100).degrad.round(0.000001)).imag);
			//levels=level+(~magx.[pl]/100);
};
			env = Env(~levelsss,[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~w1.loadCollection(wt);
sig.plot;
}.value;
	{
var env,sig,wt,angle=0,level,levels,pl=1.neg;

~levelssss=360.collect{

	level=exp(Complex(0,1)*angle).imag;
		angle=angle+1.degrad;
				pl=pl+1;
		//level=level;
	levels=level.rrand(exp(Complex(0,1)*angle+((360-(360/1.6180339887499))/1000).degrad.round(0.000001)).imag);
		//	levels=level+(~magy.[pl]/100);
};
			env = Env(~levelssss,[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~w2.loadCollection(wt);
sig.plot;
}.value;
	{
var env,sig,wt,angle=0,level,levels,pl=1.neg;

~levelsssss=360.collect{

	level=exp(Complex(0,1)*angle).imag;
		angle=angle+1.degrad;
				pl=pl+1;
			//	level=level;
	levels=level.rrand(exp(Complex(0,1)*angle+((360-(360/1.6180339887499))/1000).degrad.round(0.000001)).imag);
		//	levels=level+(~magz.[pl]/100);
			};
			env = Env(~levelsssss,[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~w3.loadCollection(wt);
sig.plot;
}.value;
);

/////////////////////////////////////////////wt envelope sine levels
	 {
	 	var ang=0,level,levels,env,pl;
	 	~levels=180.collect{ level=exp(Complex(0,1)*ang).imag; ang=ang+1.degrad;
	levels=level.rrand(exp(Complex(0,1)*ang+((360-(360/1.6180339887499))/1000).degrad).imag);};
	 }.value;

	// Env(~levels,[0.04444]).plot;

		//////notes
	({
		var angle=0;
		~angle=(720*~time).collect{
		angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
		}
		}.value;
	~angle1=~angle/2;
	);

/////synths////
(
SynthDef.new(\ospace1, {
	arg angle_rot1=0,angle_rot2=0,angle_rot3=0,angle_rot4=0,angle_rot5=0,mult=12,xr=1,yr=1,zr=1,gate=1,pl1=0;
	var phase,osc1,osc2,osc3,sphere,mag_o,amp1,amp2,amp3,decay=0.04444,pl2=0,octave=1,envp;
	var ton1,ton2,ton3,rq1=1,rq2=1,rq3=1,cutt_freq1=1,cutt_freq2=1,cutt_freq3=1;
	var fundamental=3000,fundamental1,fundamental2,fundamental3;
	var freq1,freq2,freq3,m=1,pitch1,pitch2,pitch3,env,cutt=440;
	var v0,v,v6,q1,q2,q3,q4,q5,axis;
	var pitch;
	var xyz,xyz_array;
	var n1,n2,n3;
	var mag_x,mag_y,mag_z;
	var sphere1,sphere2,sphere3;
	var ph_x,ph_y,ph_z;

	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
var out1 = NamedControl.kr(\out1, [0, 1, 2, 3, 4, 5]);  // multiple buses!
//	var out2 = NamedControl.kr(\out2, [0, 1, 2, 3, 4, 5]);  // multiple buses!
//	var out3 = NamedControl.kr(\out3, [0, 1, 2, 3, 4, 5]);  // multiple buses!

				env=EnvGen.ar(Env.adsr(0.1,0.5,0.5,8),gate:gate,doneAction:2,levelScale:0.001);

//env=EnvGen.ar(Env(~levels,[decay],4.neg),doneAction:2,levelScale:0.1);
			//	env=EnvGen.ar(Env.perc(0.05,6),doneAction:2,levelScale:0.1);
fundamental1=fundamental;
fundamental2=fundamental;
fundamental3=fundamental;
freq1=(fundamental1*octave);
freq2=(fundamental2*octave);
freq3=(fundamental3*octave);

		//mag_o=Cartesian(~magx.[pl1], ~magy.[pl1],~magz.[pl1]);

	//sphere1=Spherical(mag_o.x,~az.[pl1],~el.[pl1]);
	//sphere2=Spherical(mag_o.y,~az.[pl1],~el.[pl1]);
	//sphere3=Spherical(mag_o.z,~az.[pl1],~el.[pl1]);
	//sphere=Spherical(mag_o.rho.round(0.00000001)/(2.sqrt),~az.[pl1],~el.[pl1]);

				mag_o=Cartesian(Select.kr(pl1,~magx), Select.kr(pl1,~magy),Select.kr(pl1,~magz));

	sphere1=Spherical(mag_o.x,Select.kr(pl1,~az),Select.kr(pl1,~el));
	sphere2=Spherical(mag_o.y,Select.kr(pl1,~az),Select.kr(pl1,~el));
	sphere3=Spherical(mag_o.z,Select.kr(pl1,~az),Select.kr(pl1,~el));
	sphere=Spherical(mag_o.rho.round(0.00000001)/(2.sqrt),Select.kr(pl1,~az),Select.kr(pl1,~el));

	xyz=Spherical(mult*mag_o.rho.round(0.00000001)/(2.sqrt),sphere.theta,sphere.phi);
	xyz_array=[xyz.x.round(0.000001),xyz.y.round(0.000001),xyz.z.round(0.000001)];

v6=Quaternion(0, xyz_array.[0], xyz_array.[1], xyz_array.[2]);
/*v0=Quaternion(0,0.57735026918963,0.57735026918963,0.57735026918963);

axis=[xr,yr,zr].normalizeSum.sqrt;
i=Quaternion(0, axis.[0], 0, 0);
j=Quaternion(0, 0,  axis.[1], 0);
k=Quaternion(0, 0, 0,  axis.[2]);
v=(i+j+k);

q1=((v0*exp(Complex(0,1)*angle_rot1.degrad).imag)+exp(Complex(0,1)*angle_rot1.degrad).real);
v=q1*v*q1.conjugate;
q2=((v*exp(Complex(0,1)*angle_rot2.degrad).imag)+exp(Complex(0,1)*angle_rot2.degrad).real);
v=q2*v*q2.conjugate;
q3=((v*exp(Complex(0,1)*angle_rot3.degrad).imag)+exp(Complex(0,1)*angle_rot3.degrad).real);
v=q3*v*q3.conjugate;
q4=((v*exp(Complex(0,1)*angle_rot4.degrad).imag)+exp(Complex(0,1)*angle_rot4.degrad).real);
v=q4*v*q4.conjugate;
q5=((v*exp(Complex(0,1)*angle_rot5.degrad).imag)+exp(Complex(0,1)*angle_rot5.degrad).real);
v6=q5*v6*q5.conjugate;*/


	pitch=Cartesian(v6.b,v6.c,v6.d);

	n1=(pitch.x).round(0.00001); n2=(pitch.y).round(0.00001); n3=(pitch.z).round(0.00001);

ton1=2.pow(n1/(2*6));
ton2=2.pow(n2/(2*6));
ton3=2.pow(n3/(2*6));

/*	ph_x=Polar(sphere1.phi.bilin(0,90.degrad.neg,90.degrad,1,0,0),sphere1.theta.linlin(pi.neg,pi,2pi.neg,2pi));
	ph_y=Polar(sphere2.phi.bilin(0,90.degrad.neg,90.degrad,1,0,0),sphere2.theta.linlin(pi.neg,pi,2pi.neg,2pi));
	ph_z=Polar(sphere3.phi.bilin(0,90.degrad.neg,90.degrad,1,0,0),sphere3.theta.linlin(pi.neg,pi,2pi.neg,2pi));
	mag_x=sphere1.rho;
	mag_y=sphere2.rho;
	mag_z=sphere3.rho;*/

	    amp1=(ton1.reciprocal*octave.reciprocal*sphere1.rho).round(0.0000000000001);
		amp2=(ton2.reciprocal*octave.reciprocal*sphere2.rho).round(0.0000000000001);
		amp3=(ton3.reciprocal*octave.reciprocal*sphere3.rho).round(0.0000000000001);

	pitch1=(freq1*ton1*sphere1.rho.reciprocal).round(0.0000000000001);
	pitch2=(freq2*ton2*sphere2.rho.reciprocal).round(0.0000000000001);
	pitch3=(freq3*ton3*sphere3.rho.reciprocal).round(0.0000000000001);

				phase=Complex(exp(Complex(0,1)*(sphere.theta)).real.round(0.000001),exp(Complex(0,1)*(sphere.phi)).imag.round(0.000001)).theta;



					///%2==0 simulates .even
			//phase=if(pl2%2==0,0.degrad,90.degrad);

		/*cutt_freq1=(freq*ton1*m).round(0.0000000000001);
		cutt_freq2=(freq*ton2*m).round(0.0000000000001);
		cutt_freq3=(freq*ton3*m).round(0.0000000000001);*/
				/////fm///+SinOsc.ar(mag_x.rho,mag_x.theta,mul:mag_x.rho.reciprocal)
					envp=EnvGen.ar(Env.adsr(0.1,0.5,1/2,8,1),gate:gate);


osc1=VBAP.ar(6,
				//Osc.ar(~w1.bufnum,pitch1,mul:amp1,phase:phase+ph_x.theta),
				SinOsc.ar(pitch1,mul:amp1,phase:phase),
~b.bufnum,
sphere1.theta.raddeg,sphere1.phi.raddeg
//Osc.ar(~t.bufnum,envp,phase:sphere1.theta.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
//Osc.ar(~t.bufnum,envp,phase:sphere1.phi.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);

osc2=VBAP.ar(6,
				//Osc.ar(~w3.bufnum,pitch3,mul:amp3,phase:phase+ph_z.theta),
						SinOsc.ar(pitch2,mul:amp2,phase:phase),
~b.bufnum,
sphere2.theta.raddeg,sphere2.phi.raddeg
//Osc.ar(~t.bufnum,envp,phase:sphere2.theta.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
//Osc.ar(~t.bufnum,envp,phase:sphere2.phi.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);

osc3=VBAP.ar(6,
					//Osc.ar(~w3.bufnum,pitch3,mul:amp3,phase:phase+ph_z.theta),
						SinOsc.ar(pitch3,mul:amp3,phase:phase),
~b.bufnum,
sphere3.theta.raddeg,sphere3.phi.raddeg
//Osc.ar(~t.bufnum,envp,phase:sphere3.theta.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
//Osc.ar(~t.bufnum,envp,phase:sphere3.phi.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);

	//wrappedOut3.value(out1,LeakDC.ar(osc3,mul:env));
					Out.ar(0,LeakDC.ar(LeakDC.ar(osc3,mul:env)));

	//	wrappedOut2.value(out1,LeakDC.ar(osc2,mul:env));
					Out.ar(0,LeakDC.ar(LeakDC.ar(osc2,mul:env)));

		//wrappedOut1.value(out1,LeakDC.ar(osc1,mul:env));
					Out.ar(0,LeakDC.ar(LeakDC.ar(osc1,mul:env)));
							//	m=m+1;
					//pl1=pl1+1;

}).add;
);

////////////list
	({
		var n=1.neg;
		~list1=(720*~time).collect{
		n=n+1;
		}
		}.value
	);

//////////pattern for mobius strib of sequential or parallel play of directions
(
~aa=Pdef(\1, Pbind(\instrument, \ospace1,
	\dur,Pseq(~dur,1),
			\pl1,Pseq(~list1,inf),
		\out1,Pn(Pshuf([0, 1, 2, 3, 4, 5], 1), inf).clump(6).collect([_]),
		//	\out2,Pn(Pshuf([0, 1, 2, 3, 4, 5], 1), inf).clump(6).collect([_]),
		//	\out3,Pn(Pshuf([0, 1, 2, 3, 4, 5], 1), inf).clump(6).collect([_]),
			\mult,Prand([48],inf),
			\gate,Pseq([1,0,1,1,0,1,0,1,1,0,1,1,1,0],inf),///l system
		\xr,Pbrown(0,1,0.1,inf),
		\yr,Pbrown(0,1,0.1,inf),
		\zr,Pbrown(0,1,0.1,inf),
	\angle_rot1,Prand(~angle1,inf),
	\angle_rot2,Prand(~angle1,inf),
	\angle_rot3,Prand(~angle1,inf),
	\angle_rot4,Prand(~angle1,inf),
	\angle_rot5,Prand(~angle1,inf),
));
	);
	TempoClock.default.tempo_(32/1);

//s.record(numChannels:4);
	/////////////////////scales
//Scale.directory;

		//	s.record(numChannels:4);

	(
Tdef.new(\h,{
//loop({
			(1).wait;
//s.record(numChannels:4);
			(1).wait;
		//	s.record(numChannels:4);
~aa.play;
s.record(numChannels:6);
			(1).wait;
//s.stopRecording
//	})
})
);



//Tdef(\h).stop;
//Tdef(\h).play;
//Tdef(\h).clear;

}
)