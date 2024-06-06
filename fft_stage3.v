
module fft(
  output [23:0] A7r,A6r,A5r,A4r,A3r,A2r,A1r,A0r,
  output [23:0] A7i,A6i,A5i,A4i,A3i,A2i,A1i,A0i,
  input [23:0] m7r,m6r,m5r,m4r,m3r,m2r,m1r,m0r,
  input [23:0] m7i,m6i,m5i,m4i,m3i,m2i,m1i,m0i
	);
  parameter ct=24'h00b4fd;//ct=0.707
  
  wire [23:0]a1rs,a1rp;
  wire [23:0]a1id,a1ip;
  wire [23:0]a3rd,a3rp;
  wire [23:0]a3id,a3ip;
  wire [23:0]a5rs,a5rp;
  wire [23:0]a5id,a5ip;
  wire [23:0]a7rd,a7rp;
  wire [23:0]a7is,a7ip;
  //assign A0r=m0r+m4r;
  add a1(A0r,m0r,m4r);
  //assign A0i=m0i+m4i;
  add a2(A0i,m0i,m4i);
  
  //assign A1r=m1r+(0.707*(m5r+m5i));
  add a3(a1rs,m5r,m5i);
  mul m0(a1rp,ct,a1rs);
  add a4(A1r,m1r,a1rp);
  
  //assign A1i=m1i+((m5i-m5r)*0.707);
  sub s1(a1id,m5i,m5r);
  mul m1(a1ip,ct,a1id);
  add a5(A1i,m1i,a1ip);
  
  //assign A2r=m2r+m6i;
  add a6(A2r,m2r,m6i);
  
  //assign A2i=m2i-m6r;
  sub s2(A2i,m2i,m6r);
  
  //assign A3r=m3r+(0.707*(m7i-m7r));
  sub s3(a3rd,m7i,m7r);
  mul m2(a3rp,ct,a3rd);
  add a7(A3r,m3r,a3rp);
  
  //assign A3i=m3i-(0.707*(m7r+m7i));
  add as4(a3id,m7r,m7i);
  mul m3(a3ip,ct,a3id);
  sub s5(A3i,m3i,a3ip);
  
  //assign A4r=m0r-m4r;
  sub s6(A4r,m0r,m4r);
  //assign A4i=m0i-m4i;
  sub s7(A4i,m0i,m4i);
  
  //assign A5r=m1r-((m5r+m5i)*0.707);
  add as8(a5rs,m5r,m5i);
  mul m4(a5rp,ct,a5rs);
  sub s9(A5r,m1r,a5rp);
  
  //assign A5i=m1i+((m5r-m5i)*0.707);
  sub sa8(a5id,m5r,m5i);
  mul m5(a5ip,ct,a5id);
  add as10(A5i,m1i,a5ip);
  
  //assign A6r=m2r-m6i;
  sub s11(A6r,m2r,m6i);
  
  //assign A6i=m2i+m6r;
  add a9(A6i,m2i,m6r);
  
  //assign A7r=m3r+((m7r-m7i)*0.707);
  sub sa10(a7rd,m7r,m7i);
  mul m6(a7rp,ct,a7rd);
  sub s12(A7r,m3r,a7rp);
  
  //assign A7i=m3i+((m7r+m7i)*0.707);
  add a11(a7is,m7r,m7i);
  mul m7(a7ip,ct,a7is);
  add a12(A7i,m3i,a7ip);
  
endmodule

//MULTIPLY
module mul(c,a,b);
  output [23:0]c;
  input [23:0]a,b;
  wire [45:0]cr;
  assign cr=a[22:0]*b[22:0];
  assign c={a[23]^b[23],cr[38:16]};
endmodule

//ADD
module add(c,a,b);
  output [23:0]c;
  input [23:0]a,b;
  wire [23:0]a2,b2,c2;
  assign a2=(a[23])?({a[23],((~a[22:0])+1)}):(a);
  assign b2=(b[23])?({b[23],((~b[22:0])+1)}):(b);
  assign c2=a2+b2;
  assign c=(c2[23])?({c2[23],((~c2[22:0])+1)}):(c2);
endmodule


//sub
module sub(c,a,b);
  output [23:0]c;
  input [23:0]a,b;
  wire [23:0]a2,b2,c2;
  assign a2=(a[23])?({a[23],((~a[22:0])+1)}):(a);
  assign b2={!b[23],((b[23])?(b[22:0]):((~b[22:0])+1))};
  assign c2=a2+b2;
  assign c=(c2[23])?({c2[23],((~c2[22:0])+1)}):(c2);
endmodule

