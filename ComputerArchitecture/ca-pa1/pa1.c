
int dst_idx;
int bit_count;
int tot_len;

int convert(char *const dst, const int dstlen, int flag_count)
{
   if (bit_count + 3 >= 8)
   {
      if (bit_count == 5)
      {
         *(dst+dst_idx) |= (flag_count << (5 - bit_count));
	 dst_idx++;      
      }
      if (dst_idx + 1 >= dstlen)
      {
         return -1;
      }
      else if (bit_count == 6)
      {
         *(dst+dst_idx) |= (flag_count & 6) >> 1;
         dst_idx++;
         *(dst+dst_idx) |= (flag_count % 2) << 7;
      }
      else if (bit_count == 7)
      {
         *(dst+dst_idx) |= (flag_count & 4) >> 2;
         dst_idx++;
         *(dst+dst_idx) |= (flag_count & 3) << 6;
      }
   }
   else
   {
      *(dst+dst_idx) |= (flag_count << (5 - bit_count));
   }
   bit_count += 3;
   tot_len += 3;
   bit_count %= 8;
   return 0;
}

int convert_decode(int src_count, int code, int code_later){
	int code4=0;
	int code2=0;
	int code1=0;
	int i=0;
	if(src_count+3>8)
	{
		if(src_count==6)
		{
			code4=(code&(1<<1))>>1;
			code2=(code&1);
			code1=(code_later&(1<<7))>>7;
			i=4*code4+2*code2+1*code1;
			return i ;
		}
		if(src_count==7)
		{
			code4=(code&1);
			code2=(code_later&(1<<7))>>7;
			code1=(code_later&(1<<6))>>6;
			i=4*code4+2*code2+1*code1;
			return i;
		}
	}else{
		code4=(code&(1<<(7-src_count)))>>(7-src_count);
		code2=(code&(1<<(6-src_count)))>>(6-src_count);
		code1=(code&(1<<(5-src_count)))>>(5-src_count);
		i=4*code4+2*code2+1*code1;
		return i;
	}
}
			
			
		

/* TODO: Implement this function */
int encode(const char *const src, const int srclen, char *const dst, const int dstlen) 
{
   int src_idx = 0;
   dst_idx = 0;
   bit_count = 0;
   int flag = 0;
   int flag_count = 0;
   tot_len = 0;

   for (int i = 0; i < dstlen; i++)
   {
      *(dst+i) = 0;
   }
   while (src_idx < srclen)
   {
      int code = (unsigned int)*(src+src_idx);
      src_idx++;
      int i = 7;
      while (i >= 0)
      {
         while (i >= 0 && flag == ((code & (1 << i)) ? 1 : 0) && flag_count + 1 < 8)
         {
            flag_count++;
            i--;
         }
         if (i != -1 || src_idx == srclen)
         {
            if (convert(dst, dstlen, flag_count) == -1)
               return -1;
            flag = 1 - flag;
            flag_count = 0;
         }
      }
   }
   return (tot_len + 7) / 8;
}

/* TODO: Implement this function */
int decode(const char* const src, const int srclen, char* const dst, const int dstlen)
{
    int cnt=0;
    int src_idx=0;
    int dst_idx=0;
    bit_count=0;
    int dst_count=0;
    tot_len=0;
    int code_later=0;
    int flag=0;
    int src_count=0;
    
    for (int i = 0; i < dstlen; i++)
   {
      *(dst+i) = 0;
   }
    while(src_idx<srclen){
    	while(src_count<8){
        	int code = (unsigned int)*(src+src_idx);
        	if((src_idx+1)==srclen)
        		code_later=0;
        	else
        		code_later=(unsigned int)*(src+src_idx+1);
         
        	cnt=convert_decode(src_count, code, code_later);
        	if(dst_count+cnt<8){
        		for(int i=0; i<cnt; i++){
        			*(dst+dst_idx) |= (flag<<(7-dst_count-i));
        		}
        		dst_count+=cnt;
        		tot_len +=cnt;
        		dst_count %=8;
        	} else if(dst_idx+1>=dstlen){
        		return -1;
        	} else if(dst_count+cnt==8){
        		for(int i=0; i<cnt; i++){
        			*(dst+dst_idx) |= (flag<<(7-dst_count-i));
        		}
        		dst_count+=cnt;
        		tot_len +=cnt;
        		dst_count %=8;
        		dst_idx++;
        	} else {
        		for(int i=0;i< (cnt-(dst_count+cnt)%8);i++){
        			*(dst+dst_idx) |= (flag<<(7-dst_count-i));
        		}
        		dst_idx++;
        		for(int i=0; i<((dst_count+cnt)%8);i++){
        			*(dst+dst_idx) |= (flag<<(7-i));
        		}
        		dst_count+=cnt;
        		tot_len+=cnt;
        		dst_count %=8;
        	}
        	flag= 1-flag;
        	src_count+=3;
        }
        src_count %=8;
        src_idx++;
    }
    return (tot_len+7)/8;
}