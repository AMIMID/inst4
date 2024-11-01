


////server setup
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
s.options.memSize = 8192*8;
//s.options.blockSize = 64/4;
s.options.maxNodes = 1024 * 4;
s.waitForBoot
)

Buffer.freeAll
s.record(numChannels:4)

(
~c1 = Buffer.read(s,"/Users/petrostatsiopoulos/Music/SuperCollider Recordings/inst-4/final/inst4_imag_version a_sequence.wav");
)
(
(
(
SynthDef.new(\inst4,
{
		arg cutt1=0,cutt2=0,gain1=1,gain2=1,mix1=1,mix2=1;
		var sig1,sig2,sig3,sig4,sig5,sig6;
		var lpass1,lpass2,lpass3,hpass1,hpass2,hpass3;
		var i,j,k,q1,q2,v1,v2,xyz=[1,1,1].normalizeSum.sqrt;
		var angle_cuttfreq1, angle_cuttfreq22;
		var cuttfreq1,cuttfreq2,axis;

		angle_cuttfreq1 = cutt1; angle_cuttfreq2 =  cutt2;

		v1=Quaternion(0,1,0,0);
		v2=Quaternion(0,1,0,0);

	i=Quaternion(0, xyz.[0], 0, 0); j=Quaternion(0, 0, xyz.[1], 0); k=Quaternion(0, 0, 0, xyz.[2]);

		axis=i+j+k;

q1=((axis*exp(Complex(0,1)*angle_cuttfreq1).imag)+exp(Complex(0,1)*angle_cuttfreq1).real); v1=q1*v1*q1.conjugate;

q2=((axis*exp(Complex(0,1)*angle_bandwidth1).imag)+exp(Complex(0,1)*angle_bandwidth1).real); v2=q2*v2*q2.conjugate;


		cuttfreq1=Cartesian(v1.b,v1.c,v1.d);
		cuttfreq2=Cartesian(v2.b,v2.c,v2.d);

		lpass1=cuttfreq1.x.round(0.000001).abs.linlin(0,1,55,55*128);
		lpass2=cuttfreq1.y.round(0.000001).abs.linlin(0,1,55,55*128);
		lpass3=cuttfreq1.z.round(0.000001).abs.linlin(0,1,55,55*128);

		hpass1=cuttfreq2.x.round(0.000001).abs.linlin(0,1,0.001,1);
		hpass2=cuttfreq2.y.round(0.000001).abs.linlin(0,1,0.001,1);
		hpass3=cuttfreq2.z.round(0.000001).abs.linlin(0,1,0.001,1);


sig1=FreeVerb.ar(LPF.ar
			(HPF.ar
			(PlayBuf.ar(4, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 1, doneAction:2),
				freq:lpass1.lag(0.333)),freq:hpass1.lag(0.333)),
			mix:mix1.lag(0.333),room:1);

sig2=FreeVerb.ar(LPF.ar
			(HPF.ar
			(PlayBuf.ar(4, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 1, doneAction:2),
				freq:lpass2.lag(0.333)),freq:hpass2.lag(0.333)),
			mix:mix1.lag(0.333),room:1,mul:gain1.lag(0.333));
sig3=FreeVerb.ar(LPF.ar
			(HPF.ar
				(PlayBuf.ar(4, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 1, doneAction:2),
				freq:lpass3.lag(0.333)),freq:hpass3.lag(0.333)),
			mix:mix1.lag(0.333),room:1,mul:gain1.lag(0.333));


	Out.ar(0,sig1);Out.ar(0,sig2);Out.ar(0,sig3);

}).add;);
(
Window.closeAll;
w=Window.new("gui",Rect.new(750,100,500,420)).front.alwaysOnTop_(true);

~gain1 = Slider.new(w.view,Rect.new(20,20,160,30));

~filter1 = Slider2D.new(w.view,Rect.new(20,100,250,250));

~reverb1 = Slider.new(w.view,Rect.new(250,20,160,30));

~on = Button(w,Rect(320,156,60,60)).states_([
	["off",Color.black],Color.gray,["on",Color.white,Color.gray]]).action_({
	arg obj;
	if(
		obj.value==1,{~synth=Synth.new(\inst4,[
\gain1,~gain1.value,\gain2,~gain2.value,\mix1,~reverb1.value,\mix2,~reverb2.value,
\cutt1,~filter1.x.linlin(0,1,360.neg,360),\cutt2,~filter1.y.linlin(0,1,360.neg,360)]).register;},
		{~synth.free}
)});
(
a = StaticText(w, Rect(190,20,100, 20));
a.string = "gain1";
c = StaticText(w, Rect(20,300,200, 20));
c.string = "3d bandpass s_real";
e = StaticText(w, Rect(420,20,200, 20));
e.string = "reverb1";
)
);

(
~gain1.value_(0.5).action_({
	arg obj;
	var gain;
	obj.value.postln;
	gain=obj.value;
	if(~synth.isPlaying,{~synth.set(\gain1,gain)});
});
);
(
~reverb1.action_({
	arg obj;
	var mix;
	obj.value.postln;
	mix=obj.value;
	if(~synth.isPlaying,{~synth.set(\mix1,mix)});
});
);
(
~filter1.x_(0).y_(0).action_({
	arg obj;
	var pass1,pass2;
	pass=obj.x.linlin(0,1,360.neg,360);
	width=obj.y.linlin(0,1,360.neg,360);
	["pass1","widht1"].postln;
	[pass.value,width.value].postln;
	if(~synth.isPlaying,{~synth.set(\cutt1,pass1,\cutt2,pass2)});
});
);
);

	(
MIDIClient.init;
MIDIIn.connectAll;

	(
MIDIdef.cc(\midi1,{ |val, num, chan, src|
		var pass;
	//[val, num, chan, src].postln;
	pass=val.linlin(0,127,360.neg,360);
		pass.postln;
		if(~synth.isPlaying,{~synth.set(\cutt1,pass)});
},25);
	);
		(
MIDIdef.cc(\midi2,{ |val, num, chan, src|
		var width;
	//[val, num, chan, src].postln;
	width=val.linlin(0,127,360.neg,360);
		width.postln;
		if(~synth.isPlaying,{~synth.set(\band1,width)});
},24);
	);
	(
MIDIdef.cc(\midi3,{ |val, num, chan, src|
		var pass;
	//[val, num, chan, src].postln;
	pass=val.linlin(0,127,0,1);
		pass.postln;
		if(~synth.isPlaying,{~synth.set(\gain1,pass)});
},23);
	);
		(
MIDIdef.cc(\midi4,{ |val, num, chan, src|
		var width;
	//[val, num, chan, src].postln;
	width=val.linlin(0,127,0,1);
		width.postln;
		if(~synth.isPlaying,{~synth.set(\gain2,width)});
},22);
	);
	(
MIDIdef.cc(\midi5,{ |val, num, chan, src|
		var mix;
	//[val, num, chan, src].postln;
	mix=val.linlin(0,127,0,1);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\mix1,mix)});
},21);
	);
		(
MIDIdef.cc(\midi6,{ |val, num, chan, src|
		var mix;
	//[val, num, chan, src].postln;
	mix=val.linlin(0,127,0,1);
		mix.postln;
		if(~synth.isPlaying,{~synth.set(\mix2,mix)});
},20);
	);

)
)