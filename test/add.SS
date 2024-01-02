000000000001076e <add_vec>:
   1076e:	c295                	beqz	a3,10792 <add_vec+0x24>
   10770:	0106f757          	vsetvli	a4,a3,e32,m1,tu,mu
   10774:	00271793          	slli	a5,a4,0x2
   10778:	02056087          	vle32.v	v1,(a0)
   1077c:	0205e107          	vle32.v	v2,(a1)
   10780:	8e99                	sub	a3,a3,a4
   10782:	021110d7          	vfadd.vv	v1,v1,v2
   10786:	020660a7          	vse32.v	v1,(a2)
   1078a:	953e                	add	a0,a0,a5
   1078c:	95be                	add	a1,a1,a5
   1078e:	963e                	add	a2,a2,a5
   10790:	f2e5                	bnez	a3,10770 <add_vec+0x2>
   10792:	8082                	ret