
////server setup
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(0.5);
s.options.memSize = 8192*8;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 16;
s.options.sampleRate= 48000;
s.waitForBoot
)

/////wavetables
Buffer.freeAll

(
~w= Buffer.alloc(s,2048);
~t= Buffer.alloc(s,2048);
~a = VBAPSpeakerArray.new(3, [[0, 45], [180, 45], [90, 45.neg], [90.neg, 45.neg]]);
~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
~time=1;
);

(
var env,sig,wt,angle=0,level,levels;

~levels=360.collect{

	level=exp(Complex(0,1)*angle).imag;
		angle=angle+1.degrad;
	levels=level.rrand(exp(Complex(0,1)*angle+((360-(360/1.6180339887499))/1).degrad).imag);
};
env = Env(~levels,[1]);
sig=env.asSignal(1024);
wt = sig.asWavetable;
~w.loadCollection(wt);
//sig.plot;
);

(
var signal,wt,m=0,amp;

~level=138.round(1).collect{m=m+1;amp=m.reciprocal};
~phase=138.collect{pi};
signal=Signal.sineFill(1024,~level,~phase);

wt = signal.asWavetable;
~t.loadCollection(wt);
//signal.plot;
)

////speaker setup
(
// 3D///cube
~a = VBAPSpeakerArray.new(3, [[45, 45], [135, 45], [135.neg, 45], [45.neg, 45],[45, 45.neg], [135, 45.neg], [135.neg, 45.neg], [45.neg, 45.neg]]);
//0 up fl, 1 up bl, 2 up br, 3 up fr, 4 down fl, 5 down bl, 6 down br, 7 down fr
~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
///furhter on speaker setup can be geodesic octahedron 2nd order torus with 16 channels, and Rhombic triacontahedron with 32 vertices as 32 speaker channels
)

/////////tetrahedron
(
// 3D
~a = VBAPSpeakerArray.new(3, [[0, 45], [180, 45], [90, 45.neg], [90.neg, 45.neg]]);
~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
)

(
// 3D random
~a = VBAPSpeakerArray.new(3, [[180.rand2, 90.rand2], [180.rand2, 90.rand2], [180.rand2, 90.rand2], [180.rand2, 90.rand2]]);
~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
)

//////////arrays
///fractal
(
var c,angle=0,c_real,c_imag,z;



~c = 5.collect{
 	c_real=exp(Complex(0,1)*angle.degrad).real;
	c_imag=exp(Complex(0,1)*angle.degrad).imag;
 	angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
 	c=Complex(c_real,c_imag);
 };
z=Complex(0,0);

~j = (180*~time).collect{
	c=~c.[4];
	z=z.pow(2)+c;
	z.theta.round(0.000001);

}

)

(
var c,angle=0,c_real,c_imag,z;



~k = 5.collect{
 	c_real=exp(Complex(0,1)*angle.degrad).real;
	c_imag=exp(Complex(0,1)*angle.degrad).imag;
 	angle=(angle+45).wrap(0,360);
 	c=Complex(c_real,c_imag);
 };
z=Complex(0,0);

~h = (180*~time).collect{
	c=~k.[4].round(0.00001);
	z=z.pow(2)+c;
	z.theta.round(0.000001);

}

)
//////////////////////basis

(
var  sph1,sph2,m_x=3,m_y=2,m_z=1,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;
var pl1=0,pl2=0,pl3=0,pl4=0,pl5=0;

~az = (90*~time).collect{
pl1=pl1+1;
		az1=(az1+(1)).wrap(180.neg,180);

	el1=(el1+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph1=Spherical(1,az1.degrad*~h.[pl1],el1.degrad*~j.[pl1]).theta.round(0.00001);

	};

~el = (90*~time).collect{
pl2=pl2+1;
		az2=(az2+(1)).wrap(90.neg,90);

	el2=(el2+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sph2=Spherical(1,az2.degrad*~h.[pl2],el2.degrad*~j.[pl2]).phi.round(0.00001);

	};

~magx = (90*~time).collect{
pl3=pl3+1;

	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad*~h.[pl3],elx.degrad*~j.[pl3]);


/*mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
	Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
	mag_x.round(0.00001);*/

	mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
Complex(sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2)))).rho*
Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;


	};

~magy = (90*~time).collect{
pl4=pl4+1;
	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad*~h.[pl4],ely.degrad*~j.[pl4]);

	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;
mag_y.round(0.00001);
//	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

	};

~magz = (90*~time).collect{
pl5=pl5+1;
	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad*~h.[pl5],elz.degrad*~j.[pl5]);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	mag_z.round(0.00001);
	};

)

(
var  sph1,sph2,m_x=0,m_y=0,m_z=0,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;
var pl1=0,pl2=0,pl3=0,pl4=0,pl5=0;


~magx1 = (90*~time).collect{
pl3=pl3+1;
	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad*~h.[pl3],elx.degrad*~j.[pl3]);

	mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
	Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
	mag_x.round(0.00001);

	/*mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
Complex(sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2)))).rho*
Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
*/
	};

~magy1 = (90*~time).collect{
pl4=pl4+1;
	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad*~h.[pl4],ely.degrad*~j.[pl4]);

	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;
mag_y.round(0.00001);
//	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

	};

~magz1 = (90*~time).collect{
pl5=pl5+1;
	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad*~h.[pl5],elz.degrad*~j.[pl5]);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	mag_z.round(0.00001);
	};

)

(
var  sph1,sph2,m_x=1,m_y=1,m_z=1,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;
var pl1=0,pl2=0,pl3=0,pl4=0,pl5=0;


~magx2 = (90*~time).collect{
pl3=pl3+1;
	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad*~h.[pl3],elx.degrad*~j.[pl3]);

mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
	Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
	mag_x.round(0.00001);

	/*mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
Complex(sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2)))).rho*
Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
*/

	};

~magy2 = (90*~time).collect{
pl4=pl4+1;
	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad*~h.[pl4],ely.degrad*~j.[pl4]);

	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;
mag_y.round(0.00001);
//	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

	};

~magz2 = (90*~time).collect{
pl5=pl5+1;
	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad*~h.[pl5],elz.degrad*~j.[pl5]);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	mag_z.round(0.00001);
	};

)

(
var  sph1,sph2,m_x=2,m_y=2,m_z=2,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;
var pl1=0,pl2=0,pl3=0,pl4=0,pl5=0;


~magx3 = (90*~time).collect{
pl3=pl3+1;
	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad*~h.[pl3],elx.degrad*~j.[pl3]);

mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
	Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
	mag_x.round(0.00001);

	/*mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
Complex(sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2)))).rho*
Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
*/

	};

~magy3 = (90*~time).collect{
pl4=pl4+1;
	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad*~h.[pl4],ely.degrad*~j.[pl4]);

	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;
mag_y.round(0.00001);
//	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

	};

~magz3 = (90*~time).collect{
pl5=pl5+1;
	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad*~h.[pl5],elz.degrad*~j.[pl5]);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	mag_z.round(0.00001);
	};

)

(
var  sph1,sph2,m_x=3,m_y=3,m_z=3,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;
var pl1=0,pl2=0,pl3=0,pl4=0,pl5=0;


~magx4 = (90*~time).collect{
pl3=pl3+1;
	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad*~h.[pl3],elx.degrad*~j.[pl3]);

mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
	Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
	mag_x.round(0.00001);

	/*mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
Complex(sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2)))).rho*
Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
*/

	};

~magy4 = (90*~time).collect{
pl4=pl4+1;
	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad*~h.[pl4],ely.degrad*~j.[pl4]);

	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;
mag_y.round(0.00001);
//	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

	};

~magz4 = (90*~time).collect{
pl5=pl5+1;
	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad*~h.[pl5],elz.degrad*~j.[pl5]);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	mag_z.round(0.00001);
	};

)

(
var  sph1,sph2,m_x=4,m_y=4,m_z=4,az1=0,el1=0,az2=0,el2=0,mag_x,mag_y,mag_z;
var azx=0,elx=0,azy=0,ely=0,azz=0,elz=0,sphx,sphy,sphz,rad=1;
var pl1=0,pl2=0,pl3=0,pl4=0,pl5=0;


~magx5 = (90*~time).collect{
pl3=pl3+1;
	azx=(azx+(1)).wrap(180.neg,180);

	elx=(elx+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphx=Spherical(rad,azx.degrad*~h.[pl3],elx.degrad*~j.[pl3]);

mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
	Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
	mag_x.round(0.00001);

	/*mag_x=(Complex(cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi)),cos((sphx.theta.round(0.00001)*m_x).wrap(pi.neg,pi))).rho*
Complex(sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2))),sin((sphx.phi.round(0.00001)*(m_x-1)).wrap((pi/2).neg,(pi/2)))).rho*
Complex(cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphx.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphx.rho;
*/

	};

~magy5 = (90*~time).collect{
pl4=pl4+1;
	azy=(azy+(1)).wrap(180.neg,180);

	ely=(ely+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphy=Spherical(rad,azy.degrad*~h.[pl4],ely.degrad*~j.[pl4]);

	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
		Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;
mag_y.round(0.00001);
//	mag_y=(Complex(sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi)),sin((sphy.theta.round(0.00001)*m_y).wrap(pi.neg,pi))).rho*
//Complex(sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2))),sin((sphy.phi.round(0.00001)*(m_y-1)).wrap((pi/2).neg,(pi/2)))).rho*
//Complex(cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sphy.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho)*sphy.rho;

	};

~magz5 = (90*~time).collect{
pl5=pl5+1;
	azz=(azz+(1)).wrap(180.neg,180);

	elz=(elz+(360-(360/1.6180339887499))).wrap(90.neg,90);

	sphz=Spherical(rad,azz.degrad*~h.[pl5],elz.degrad*~j.[pl5]);

if(
m_z.even,
mag_z=Complex(cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),cos((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho,
mag_z=Complex(sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2))),sin((sphz.phi.round(0.00001)*m_z).wrap((pi/2).neg,(pi/2)))).rho*sphz.rho
	);
	mag_z.round(0.00001);
	};

)


////////////////////////az///randomizer-difuser

(
var pl1=0,az1,el1,sph1,rot1,i1,j1,k1,q1,raz1,rel1;
var pl2=0,az2,el2,sph2,rot2,i2,j2,k2,q2,raz2,rel2;
var pl3=0,az3,el3,sph3,rot3,i3,j3,k3,q3,raz3,rel3;
var r1=[0,0,1],r2=[1,0,0],r3=[0,1,0];
var v1=Quaternion(0,r1.[0],r1.[1],r1.[2]),v2=Quaternion(0,r2.[0],r2.[1],r2.[2]),v3=Quaternion(0,r3.[0],r3.[1],r3.[2]);
var angle=(360-(360/1.6180339887499));
var harm1,harn2,harm3;

~az_x=(90*~time).collect{

	az1=~az.[pl1];el1=~el.[pl1];
	pl1=pl1+1;
sph1=Spherical(1,az1,el1).asCartesian;

	rot1=[sph1.x,sph1.y,sph1.z];

	i1=Quaternion(0, rot1.[0], 0, 0);
	j1=Quaternion(0, 0, rot1.[1], 0);
	k1=Quaternion(0, 0, 0, rot1.[2]);

q1=(cos(angle.degrad)+(sin(angle.degrad)*(i1+j1+k1)));
v1=q1*v1*q1.conjugate;

raz1=Cartesian(v1.b.round(0.0001),v1.c.round(0.0001),v1.d.round(0.0001)).theta.round(0.00001);
};

~az_y=(90*~time).collect{

	az2=~az.[pl2];el2=~el.[pl2];
	pl2=pl2+1;
sph2=Spherical(1,az2,el2).asCartesian;

	rot2=[sph2.x,sph2.y,sph2.z];

	i2=Quaternion(0, rot2.[0], 0, 0);
	j2=Quaternion(0, 0, rot2.[1], 0);
	k2=Quaternion(0, 0, 0, rot2.[2]);

q2=(cos(angle.degrad)+(sin(angle.degrad)*(i2+j2+k2)));
v2=q2*v2*q2.conjugate;

raz2=Cartesian(v2.b.round(0.0001),v2.c.round(0.0001),v2.d.round(0.0001)).theta.round(0.00001);
};

~az_z=(90*~time).collect{

	az3=~az.[pl3];el3=~el.[pl3];
	pl3=pl3+1;
sph3=Spherical(1,az3,el3).asCartesian;

	rot3=[sph3.x,sph3.y,sph3.z];

	i3=Quaternion(0, rot3.[0], 0, 0);
	j3=Quaternion(0, 0, rot3.[1], 0);
	k3=Quaternion(0, 0, 0, rot3.[2]);

q3=(cos(angle.degrad)+(sin(angle.degrad)*(i3+j3+k3)));
v3=q3*v3*q3.conjugate;

raz3=Cartesian(v3.b.round(0.0001),v3.c.round(0.0001),v3.d.round(0.0001)).theta.round(0.00001);
};

)

///////////////////////el
(
var pl1=0,az1,el1,sph1,rot1,i1,j1,k1,q1,raz1,rel1;
var pl2=0,az2,el2,sph2,rot2,i2,j2,k2,q2,raz2,rel2;
var pl3=0,az3,el3,sph3,rot3,i3,j3,k3,q3,raz3,rel3;
var r1=[0,0,1],r2=[1,0,0],r3=[0,1,0];
var v1=Quaternion(0,r1.[0],r1.[1],r1.[2]),v2=Quaternion(0,r2.[0],r2.[1],r2.[2]),v3=Quaternion(0,r3.[0],r3.[1],r3.[2]);
var angle=(360-(360/1.6180339887499));

~el_x=(90*~time).collect{

	az1=~az.[pl1];el1=~el.[pl1];
	pl1=pl1+1;
sph1=Spherical(1,az1,el1).asCartesian;

	rot1=[sph1.x,sph1.y,sph1.z];

	i1=Quaternion(0, rot1.[0], 0, 0);
	j1=Quaternion(0, 0, rot1.[1], 0);
	k1=Quaternion(0, 0, 0, rot1.[2]);

q1=(cos(angle.degrad)+(sin(angle.degrad)*(i1+j1+k1)));
v1=q1*v1*q1.conjugate;

rel1=Cartesian(v1.b.round(0.0001),v1.c.round(0.0001),v1.d.round(0.0001)).phi.round(0.00001);
};

~el_y=(90*~time).collect{

	az2=~az.[pl2];el2=~el.[pl2];
	pl2=pl2+1;
sph2=Spherical(1,az2,el2).asCartesian;

	rot2=[sph2.x,sph2.y,sph2.z];

	i2=Quaternion(0, rot2.[0], 0, 0);
	j2=Quaternion(0, 0, rot2.[1], 0);
	k2=Quaternion(0, 0, 0, rot2.[2]);

q2=(cos(angle.degrad)+(sin(angle.degrad)*(i2+j2+k2)));
v2=q2*v2*q2.conjugate;

rel2=Cartesian(v2.b.round(0.0001),v2.c.round(0.0001),v2.d.round(0.0001)).phi.round(0.00001);
};

~el_z=(90*~time).collect{

	az3=~az.[pl3];el3=~el.[pl3];
	pl3=pl3+1;
sph3=Spherical(1,az3,el3).asCartesian;

	rot3=[sph3.x,sph3.y,sph3.z];

	i3=Quaternion(0, rot3.[0], 0, 0);
	j3=Quaternion(0, 0, rot3.[1], 0);
	k3=Quaternion(0, 0, 0, rot3.[2]);

q3=(cos(angle.degrad)+(sin(angle.degrad)*(i3+j3+k3)));
v3=q3*v3*q3.conjugate;

rel3=Cartesian(v3.b.round(0.0001),v3.c.round(0.0001),v3.d.round(0.0001)).phi.round(0.00001);
};

)
/////////////////notes and durs
(
var dur=4,ph1,ph2,ph3,pl1=0,pl2=0,pl3=0,pl4=0,pl5=0,pl6=0,sph1,sph2,sph3,n1,n2,n3,mult=10;
var mag1,mag2,mag3,rythm,index1,index2,index3,pl7=0,pl8=0,pl9=0,t1,t2,t3;

////L-system algae variable a,b rules:a=ab b=a , n3 for n0=a
rythm=[1,1/2,1,1,1/2];

~phase2 = (45*~time).collect{
	ph1=~magx.normalize(0,1).[pl1];
	index1=rythm.wrapAt(pl7);
	pl7=pl7+1;
	pl1=pl1+1;
	ph1=(ph1*dur).round(1/32);
	t1=ph1*index1;

	};

~phase3 = (45*~time).collect{
	ph2=~magy.normalize(0,1).[pl2];
	index2=rythm.wrapAt(pl8);
	pl8=pl8+1;
	pl2=pl2+1;
	ph2=(ph2*dur).round(1/32);
	t2=ph2*index2;
	};

~phase4 = (45*~time).collect{
	ph3=~magz.normalize(0,1).[pl3];
	index3=rythm.wrapAt(pl9);
	pl9=pl9+1;
	pl3=pl3+1;
	ph3=(ph3*dur).round((1/32));
	t3=ph3*index3;
	};

~n2 = (45*~time).collect{
	mag1=Cartesian(~magx.normalize(0,1).[pl4],~magy.normalize(0,1).[pl4],~magz.normalize(0,1).[pl4]).rho/(2.sqrt);
	sph1=Spherical(mag1*mult,~az.[pl4],~el.[pl4]).x;
	pl4=pl4+1;
	n1=(sph1).round(1);
	};

~n3 = (45*~time).collect{
	mag2=Cartesian(~magx.normalize(0,1).[pl5],~magy.normalize(0,1).[pl5],~magz.normalize(0,1).[pl5]).rho/(2.sqrt);
	sph2=Spherical(mag2*mult,~az.[pl5],~el.[pl5]).y;
	pl5=pl5+1;
	n2=(sph2).round(1);
	};

~n4 = (45*~time).collect{
	mag3=Cartesian(~magx.normalize(0,1).[pl6],~magy.normalize(0,1).[pl6],~magz.normalize(0,1).[pl6]).rho/(2.sqrt);
	sph3=Spherical(mag3*mult,~az.[pl6],~el.[pl6]).z;
	pl6=pl6+1;
	n3=(sph3).round(1);
	};

)

///////////////////////////wt envelope sine levels
(
var ang=0,level,levels,env,pl;
~levels=180.collect{ level=exp(Complex(0,1)*ang).imag; ang=ang+1.degrad;
	levels=level.rrand(exp(Complex(0,1)*ang+((360-(360/1.6180339887499))/1000).degrad).imag);};
)
Env.step(~levels,~levels/60).plot;
Env(~levels,[0.02222]).plot;
////perc
(
var ang=0,level,levels,env,pl;
~levels=90.collect{ level=exp(Complex(0,1)*ang).real; ang=ang+1.degrad;
	levels=level.rrand(exp(Complex(0,1)*ang+((360-(360/1.6180339887499))/1).degrad).real);};
~levels=[0]++[0.5]++~levels;
)
Env.step(~levels,~levels/60).plot;

/////////////////////extra radomizer

(
~az_x=~az_x.scramble;
~az_y=~az_y.scramble;
~az_z=~az_z.scramble;
~el_x=~el_x.scramble;
~el_y=~el_y.scramble;
~el_z=~el_z.scramble;
)

//////////////////////////////////////////////////space
(
~magx_array=[~magx1.normalize(0,1),~magx2.normalize(0,1),~magx3.normalize(0,1),~magx4.normalize(0,1),~magx5.normalize(0,1)];
~magy_array=[~magy1.normalize(0,1),~magy2.normalize(0,1),~magy3.normalize(0,1),~magy4.normalize(0,1),~magy5.normalize(0,1)];
~magz_array=[~magz1.normalize(0,1),~magz2.normalize(0,1),~magz3.normalize(0,1),~magz4.normalize(0,1),~magz5.normalize(0,1)];
)
/////////////////////////////piknotites
(
var freq=1,ph1,ph2,ph3,pl1=0,pl2=0,pl3=0,pl4=0,pl5=0,pl6=0,sph1,sph2,sph3,n1,n2,n3;
var mag1,mag2,mag3,rythm,index1,index2,index3,pl7=0,pl8=0,pl9=0,t1,t2,t3;


~rot_speed = (45*~time).collect{
	ph1=Cartesian(~magx.normalize(0,1).[pl1],~magy.normalize(0,1).[pl1],~magz.normalize(0,1).[pl1]).rho/(2.sqrt);
	pl1=pl1+1;
	ph1=(ph1).round(0.000001);

	};

)
~rot_speed=~rot_speed.scramble;

/////synths////
(
(
SynthDef.new(\ospace1, {
    arg  n1=1,fund=55,octave=2,cutt=10,rpr=1,speed=10;
	var phase,osc,sphere,mag_o,amp,ton,pl1=0,pl2=1,rq=1,cutt_freq=1,fundamental=64*(speed.reciprocal);
	var freq,m=1,bank1,bank2,pitch=1, angle=360,rad,env,gate=1;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
var out = NamedControl.kr(\out, [0, 1, 2, 3]);  // multiple buses!

bank1=4;
	bank2=8;
ton=2.pow(n1/(2*6));
freq=(fundamental*octave);

bank1.do{

bank2.do{

mag_o=Cartesian(~magx_array.[pl2].[pl1], ~magy_array.[pl2].[pl1], ~magz_array.[pl2].[pl1]);

	sphere=Spherical(mag_o.rho.round(0.00001)/(2.sqrt),~az_x.[pl1],~el_x.[pl1]);
			//sphere=Spherical(mag_o.rho.round(0.00001)/(2.sqrt),~az.[pl1],~el.[pl1]);

			phase=(exp(Complex(0,1)*(mag_o.theta))*exp(Complex(0,1)*(mag_o.phi)));
			amp=m.reciprocal*ton.reciprocal;
		pitch=freq*amp.reciprocal*sphere.rho.reciprocal;

env=EnvGen.ar(Env(~levels*speed*octave.reciprocal,[0.02222],4.neg),doneAction:2,levelScale:0.333);

		cutt_freq=(freq*amp.reciprocal*sphere.rho).round(0.00001);
			rq=((sphere.rho.reciprocal)/cutt_freq).round(0.00001);

osc=VBAP.ar(4,
LeakDC.ar(Osc.ar(~w.bufnum,pitch,mul:amp*sphere.rho,phase:phase.theta)),
~b.bufnum,
Osc.ar(~t.bufnum,speed.reciprocal,phase:sphere.theta.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
Osc.ar(~t.bufnum,speed.reciprocal,phase:sphere.phi.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);

			wrappedOut1.value(out,LeakDC.ar((BPF.ar(osc,cutt_freq,rq,env*(1/rq.sqrt)))));
			//Out.ar(0,LeakDC.ar(LeakDC.ar(BPF.ar(osc,cutt_freq,rq,env*(1/rq.sqrt)))));
pl1=pl1+1;

		};
		pl2=pl2+1;
		m=m+1;
	};
}).add;
);
(
SynthDef.new(\ospace2, {
    arg  n1=1,fund=55,octave=2,cutt=10,rpr=1,speed=10;
	var phase,osc,sphere,mag_o,amp,ton,pl1=0,pl2=1,rq=1,cutt_freq=1,fundamental=64*(speed.reciprocal);
	var freq,m=1,bank1,bank2,pitch=1, angle=360,rad,env,gate=1;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
var out = NamedControl.kr(\out, [0, 1, 2, 3]);  // multiple buses!

bank1=4;
	bank2=8;
ton=2.pow(n1/(2*6));
freq=(fundamental*octave);

bank1.do{

bank2.do{

mag_o=Cartesian(~magx_array.[pl2].[pl1], ~magy_array.[pl2].[pl1], ~magz_array.[pl2].[pl1]);


		sphere=Spherical(mag_o.rho.round(0.00001)/(2.sqrt),~az_y.[pl1],~el_y.[pl1]);
			//sphere=Spherical(mag_o.rho.round(0.00001)/(2.sqrt),~az.[pl1],~el.[pl1]);

			phase=(exp(Complex(0,1)*(mag_o.theta))*exp(Complex(0,1)*(mag_o.phi)));
			amp=m.reciprocal*ton.reciprocal;
		pitch=freq*amp.reciprocal*sphere.rho.reciprocal;

env=EnvGen.ar(Env(~levels*speed*octave.reciprocal,[0.02222],4.neg),doneAction:2,levelScale:0.333);

		cutt_freq=(freq*amp.reciprocal*sphere.rho).round(0.00001);
			rq=((sphere.rho.reciprocal)/cutt_freq).round(0.00001);

osc=VBAP.ar(4,
LeakDC.ar(Osc.ar(~w.bufnum,pitch,mul:amp*sphere.rho,phase:phase.theta)),
~b.bufnum,
Osc.ar(~t.bufnum,speed.reciprocal,phase:sphere.theta.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
Osc.ar(~t.bufnum,speed.reciprocal,phase:sphere.phi.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);

			wrappedOut1.value(out,LeakDC.ar((BPF.ar(osc,cutt_freq,rq,env*(1/rq.sqrt)))));
			//Out.ar(0,LeakDC.ar(LeakDC.ar(BPF.ar(osc,cutt_freq,rq,env*(1/rq.sqrt)))));
pl1=pl1+1;

		};
		pl2=pl2+1;
		m=m+1;
	};
}).add;
);
(
SynthDef.new(\ospace3, {
    arg  n1=1,fund=55,octave=2,cutt=10,rpr=1,speed=10;
	var phase,osc,sphere,mag_o,amp,ton,pl1=0,pl2=1,rq=1,cutt_freq=1,fundamental=64*(speed.reciprocal);
	var freq,m=1,bank1,bank2,pitch=1, angle=360,rad,env,gate=1;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
var out = NamedControl.kr(\out, [0, 1, 2, 3]);  // multiple buses!

bank1=4;
	bank2=8;
ton=2.pow(n1/(2*6));
freq=(fundamental*octave);

bank1.do{

bank2.do{

mag_o=Cartesian(~magx_array.[pl2].[pl1], ~magy_array.[pl2].[pl1], ~magz_array.[pl2].[pl1]);

		sphere=Spherical(mag_o.rho.round(0.00001)/(2.sqrt),~az_z.[pl1],~el_z.[pl1]);
			//sphere=Spherical(mag_o.rho.round(0.00001)/(2.sqrt),~az.[pl1],~el.[pl1]);

			phase=(exp(Complex(0,1)*(mag_o.theta))*exp(Complex(0,1)*(mag_o.phi)));
			amp=m.reciprocal*ton.reciprocal;
		pitch=freq*amp.reciprocal*sphere.rho.reciprocal;

env=EnvGen.ar(Env(~levels*speed*octave.reciprocal,[0.02222],4.neg),doneAction:2,levelScale:0.333);

		cutt_freq=(freq*amp.reciprocal*sphere.rho).round(0.00001);
			rq=((sphere.rho.reciprocal)/cutt_freq).round(0.00001);

osc=VBAP.ar(4,
LeakDC.ar(Osc.ar(~w.bufnum,pitch,mul:amp*sphere.rho,phase:phase.theta)),
~b.bufnum,
Osc.ar(~t.bufnum,speed.reciprocal,phase:sphere.theta.linlin(pi.neg,pi,2pi.neg,2pi),mul:180),
Osc.ar(~t.bufnum,speed.reciprocal,phase:sphere.phi.linlin((pi/2).neg,(pi/2),2pi.neg,2pi),mul:90)
		);

			wrappedOut1.value(out,LeakDC.ar((BPF.ar(osc,cutt_freq,rq,env*(1/rq.sqrt)))));
			//Out.ar(0,LeakDC.ar(LeakDC.ar(BPF.ar(osc,cutt_freq,rq,env*(1/rq.sqrt)))));
pl1=pl1+1;

		};
		pl2=pl2+1;
		m=m+1;
	};
}).add;
)
)
/////////////////////scales
Scale.directory

//////////pattern for mobius strib of sequential or parallel play of directions

(
a=Pdef(\1, Pbind(\instrument, \ospace1,
	\dur,Pseq(~phase2.mirror,1),
\n1,PdegreeToKey(Pseq(~n2.mirror,inf),Scale.minor),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\octave,Prand([1,2,4],inf),
	\rpr,Pseq(~rot_speed.mirror,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
b=Pdef(\2, Pbind(\instrument, \ospace2,
	\dur,Pseq(~phase3.mirror,1),
\n1,PdegreeToKey(Pseq(~n3.mirror,inf),Scale.minor),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
			\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.mirror,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
c=Pdef(\3, Pbind(\instrument, \ospace3,
	\dur,Pseq(~phase4.mirror,1),
\n1,PdegreeToKey(Pseq(~n4.mirror,inf),Scale.minor),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
			\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.mirror,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
d=Pdef(\4, Pbind(\instrument, \ospace1,
	\dur,Pseq(~phase2.reverse.mirror,1),
\n1,PdegreeToKey(Pseq(~n2.reverse.mirror,inf),Scale.minor),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
			\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.reverse.mirror,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
e=Pdef(\5, Pbind(\instrument, \ospace2,
	\dur,Pseq(~phase3.reverse.mirror,1),
\n1,PdegreeToKey(Pseq(~n3.reverse.mirror,inf),Scale.minor),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.reverse.mirror,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
f=Pdef(\6, Pbind(\instrument, \ospace3,
	\dur,Pseq(~phase4.reverse.mirror,1),
\n1,PdegreeToKey(Pseq(~n4.reverse.mirror,inf),Scale.minor),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\octave,Prand([1,2,4],inf),
		\rpr,Pseq(~rot_speed.reverse.mirror,inf),
	\speed,Prand([1,3/4,2/3,1/2],inf);
));
	)
TempoClock.default.tempo_(0.5)

(
		(
a.play;
s.record(numChannels:4)
b.play;
s.record(numChannels:4)
c.play;
s.record(numChannels:4)
);
d.play;
//s.record(numChannels:4,duration:45)
e.play;
//s.record(numChannels:4,duration:45)
f.play;
//s.record(numChannels:4)
);


s.record(numChannels:4);


////////////////pattern for web of directions////////need correction
(
~phase2=~phase2.mirror;
~n2=~n2.mirror.mirror;
~phase3=~phase3.mirror
~n3=~n3.mirror;
~phase4=~phase4.mirror;
~n4=~n4.mirror;

~phase22=~phase2.reverse.mirror;
~n22=~n2.reverse.mirror;
~phase33=~phase3.reverse.mirror;
~n33=~n3.reverse.mirror;
~phase44=~phase4.reverse.mirror;
~n44=~n4++~n4.reverse.mirror;

~azz=~az.mirror;
~ell=~el.mirror;
~azzz=~az.reverse.mirror;
~azzz=~az.reverse.mirror;

~magxx=~magx.mirror;
~magyy=~magy.mirror;
~magzz=~magz.mirror;
~magxxx=~magx.reverse.mirror;
~magyyy=~magy.reverse.mirror;
~magzzz=~magz.reverse.mirror;

)
(
b=Pdef(\2, Pbind(\instrument, \ob,
	\dur,Ppatlace([Pseq(~phase2,1),Pseq(~phase22,1)],inf),
	\n1,PdegreeToKey(Ppatlace([Pseq(~n2,inf),Pseq(~n22,inf)],inf),Scale.phrygian),
\pl,Prand(Array.fill(180,{arg i; i=i+1}),inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\decay,Pbrown(2,8,1,inf);
));
c=Pdef(\3, Pbind(\instrument, \oc,
	\dur,Ppatlace([Pseq(~phase3,1),Pseq(~phase33,1)],inf),
	\n1,PdegreeToKey(Ppatlace([Pseq(~n3,inf),Pseq(~n33,inf)],inf),Scale.phrygian),
\pl,Prand(Array.fill(180,{arg i; i=i+1}),inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\decay,Pbrown(2,8,1,inf);
));
d=Pdef(\4, Pbind(\instrument, \od,
	\dur,Ppatlace([Pseq(~phase4,1),Pseq(~phase44,1)],inf),
	\n1,PdegreeToKey(Ppatlace([Pseq(~n4,inf),Pseq(~n44,inf)],inf),Scale.phrygian),
\pl,Prand(Array.fill(180,{arg i; i=i+1}),inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
	\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
	\decay,Pbrown(2,8,1,inf);
));
)


(
b.play;
//s.record(numChannels:4)
//)
//(
c.play;
//s.record(numChannels:4)
//)
//(
d.play;
s.record(numChannels:4)
)

////////////////////////////////////task

(
Tdef.new(\h,{loop({

	b.play;
c.play;
d.play;
	(1).wait;
		bb.play;
cc.play;
dd.play;


	}
)})
)


Tdef(\h).stop;
Tdef(\h).play;
Tdef(\h).clear;