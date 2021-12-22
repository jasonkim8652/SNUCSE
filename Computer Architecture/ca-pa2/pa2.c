//---------------------------------------------------------------
//
//  4190.308 Computer Architecture (Fall 2021)
//
//  Project #2: FP10 (10-bit floating point) Representation
//
//  October 5, 2021
//
//  Jaehoon Shim (mattjs@snu.ac.kr)
//  Ikjoon Son (ikjoon.son@snu.ac.kr)
//  Seongyeop Jeong (seongyeop.jeong@snu.ac.kr)
//  Systems Software & Architecture Laboratory
//  Dept. of Computer Science and Engineering
//  Seoul National University
//
//---------------------------------------------------------------

#include "pa2.h"

/* Convert 32-bit signed integer to 10-bit floating point */
fp10 int_fp10(int n)
{
	int fracidx=0;
	int sign=0;
	int L=0;
	int R=0;
	int S=0;
	int exp=0;
	int num=0;
	fp10 ans=0;
	
	if(n==0)
		return 0;
	if((n&(1<<31))>>31==0){
		sign=0;
		num=n;
	}
	else{
		sign=1;
		num=~(n-1);
	}
	
	for(int i=0;i<31;i++){
		if(((num&(1<<(30-i)))>>(30-i))==1){
			fracidx=30-i;
			break;
		}
	}
			
	L=(num&(1<<(fracidx-4)))>>(fracidx-4);
	R=(num&(1<<(fracidx-5)))>>(fracidx-5);
	for(int i=0;i<fracidx-5;i++){
		S=(num&(1<<i)>>i);
		if(S==1)
			break;
	}
	if(R==1){
		if(L==1|S==1)
			num+=(1<<(fracidx-4));
	}
	for(int i=0;i<31;i++){
		if(((num&(1<<(30-i)))>>(30-i))==1){
			fracidx=30-i;
			break;
		}
	}
	for(int i=0;i<7;i++){
		ans|=(sign<<(15-i));
	}
	exp=fracidx+15;
	if(exp>=31){
		if(sign==0){
			ans= 0B0000000111110000;
			return ans;
		}else if(sign==1){
			ans= 0B1111111111110000;
			return ans;
		}
	}
	if(exp<15){
		return 0;
	}
	ans|=((fracidx+15)<<4);
	num=num>>(fracidx-4);
	for(int i=4;i<32;i++){
		num&=(~(1<<i));
	}
	ans|=num;
	return ans;	
}

/* Convert 10-bit floating point to 32-bit signed integer */
int fp10_int(fp10 x)
{
	int ans=0;
	int exp=0;
	int sign=0;
	
	if((x&(1<<15))==(1<<15))
		sign=1;
	else
		sign=0;
	exp=(x&(1<<8)? 1:0)*16+(x&(1<<7)? 1:0)*8+(x&(1<<6)? 1:0)*4+(x&(1<<5)? 1:0)*2+(x&(1<<4)? 1:0)-15;
	ans=(x&15)+16;
	if(exp>=16)
		return 0x80000000;
	if(exp<0)
		return 0;
	if(exp-4>=0)
		ans=(ans<<(exp-4));
	else
		ans=(ans>>(4-exp));	
	if(sign==1){
		ans=-ans;
		return ans;
	} else{
		return ans;
	}
	
}

/* Convert 32-bit single-precision floating point to 10-bit floating point */
fp10 float_fp10(float f)
{
	int exp=0;
	int sign=0;
	fp10 ans=0;
	int L=0;
	int R=0;
	int S=0;
	int fracidx=22;
	union data{
		int int_val;
		float float_val;
	};
	
	union data input;
	
	input.float_val=f;
	
	for(int i =0; i<8;i++){
		exp+=(input.int_val&(1<<(30-i)))>>23;
	}// getting exp
	exp-=127;//minus bias
	if((input.int_val&(1<<31))>>31==0){// get sign bit
		sign =0;
	} else{
		sign =1;
	}
	if(exp==128){//if NAN or inf in float, it should be NAN or inf in fp10
		input.int_val&=0B00000000011111111111111111111111;
		if(input.int_val>0){// if NAN
			if(sign==1){
				return 0B1111111111110001;
			}
			else if(sign==0){
				return 0B0000000111110001;
			}
		}else{//restore 
			input.float_val=f;
		}
	}
		
				
	exp+=15;//plus bias

	if((exp>=31)&(sign==1)){//if NAN or inf in fp 10
		ans= 0B1111111111110000;
		return ans;
	}else if((exp>=31)&(sign==0)){
		ans= 0B0000000111110000;
		return ans;
	}
	input.int_val&=0B00000000011111111111111111111111;
	if(exp<0|exp==0){
		input.int_val=((input.int_val+(1<<23))>>(1-exp));
	}
	L=((input.int_val&(1<<19))>>19);
	R=((input.int_val&(1<<18))>>18);
	for(int i=0;i<18;i++){
		S=(input.int_val&(1<<i))>>i;
		if(S==1)
			break;
	}
	if(R==1){
		if(L==1|S==1)
			input.int_val+=(1<<19);
	}
	for(int i=0;i<7;i++){//putting signbit
		ans|=(sign<<(15-i));
	}
	if((input.int_val&(1<<23))>>23==1){
		exp+=1;
		if((exp>=31)&(sign==1)){//plus goes to inf
			ans= 0B1111111111110000;
			return ans;
		}else if((exp>=31)&(sign==0)){//plus goes to inf
			ans= 0B0000000111110000;
			return ans;
		}
		ans|=(exp<<4);//put exp
		input.int_val&=0B00000000011111111111111111111111;
		ans|=(input.int_val>>19);//put others
	} else{
		ans|=(exp<<4);
		ans|=(input.int_val>>19);
	}
	if((exp<0)&(sign==1)){
		ans= 0B1111111000000000;
		ans|=(input.int_val>>19);
		return ans;
	}else if((exp<0)&(sign==0)){
		ans=0;
		ans|=(input.int_val>>19);
		return ans;
	}
	return ans;
}

/* Convert 10-bit floating point to 32-bit single-precision floating point */
float fp10_float(fp10 x)
{
	union data{
		int int_val;
		float float_val;
	};
	
	union data output;
	
	output.int_val=0;
	
	int exp=0;
	int sign=0;
	if(x==0)
		return 0;
	if((x&(1<<15))>>15==0)
		sign=0;
	else
		sign=1;
	output.int_val|=(sign<<31);
	exp=((x&(1<<8))>>8)*16+((x&(1<<7))>>7)*8+((x&(1<<6))>>6)*4+((x&(1<<5))>>5)*2+((x&(1<<4))>>4)-15;
	if((exp>-15)&(exp<16)){
		exp+=127;
		output.int_val|=(exp<<23);
		x&=0B0000000000001111;
		output.int_val|=(x<<19);
	}
	else if(exp==-15){
		if(x&(1<<3)==1){
			exp+=126;
			output.int_val|=(exp<<23);
			x&=0B0000000000000111;
			output.int_val|=(x<<20);
		}else if(x&(1<<2)==1){
			exp+=125;
			output.int_val|=(exp<<23);
			x&=0B0000000000000011;
			output.int_val|=(x<<21);
		}else if(x&(1<<1)==1){
			exp+=124;
			output.int_val|=(exp<<23);
			x&=0B0000000000000001;
			output.int_val|=(x<<22);
		}else{
			exp+=124;
			output.int_val|=(exp<<23);
		}
	}else if(exp==16){
		exp=255;
		output.int_val|=(exp<<23);
		x&=0B0000000000001111;
		output.int_val|=x;
	}	
	return output.float_val;
		
}