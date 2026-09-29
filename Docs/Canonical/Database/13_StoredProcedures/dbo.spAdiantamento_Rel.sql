SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--			spAdiantamento_Rel '10-25-2007'

CREATE	  Procedure	 spAdiantamento_Rel

(
	@Data datetime
)

As
	select 
		Cia.Nome_Raz_Soc	Cia_Dow,
		P.Num_Pedido		Order_Number,
	--	Taxa_Adiantamento
	--	Etiqueta
	--	Controle
		HOU.Num_Proc_HEM	BDP_Reference,
		DPP.GMID_Descr_Curta	Produto,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_Exp_Mar HOU

	Join Pedido_Ship 	PS	on HOU.Num_Proc_HEM = PS.Num_Proc
	Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Join Pessoa		Cia	on Cia.Cd_Pes = HOU.Cd_Export_HEM
	
	where 
		convert(datetime,Dt_Emis_HEM,105) > @Data

	Group by Cia.Nome_Raz_Soc, P.Num_Pedido, HOU.Num_Proc_HEM, DPP.GMID_Descr_Curta, PS.Cd_Produto, PS.Cd_Pedido

Union All

	select 
		Cia.Nome_Raz_Soc	Cia_Dow,
		P.Num_Pedido		Order_Number,
	--	Taxa_Adiantamento
	--	Etiqueta
	--	Controle
		HOU.Num_Proc_HIM 	BDP_Reference,
		DPP.GMID_Descr_Curta	Produto,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_Imp_Mar HOU

	Join Pedido_Ship 	PS	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Join Pessoa		Cia	on Cia.Cd_Pes = HOU.Cd_Consig_HIM
	
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data

	Group by Cia.Nome_Raz_Soc, P.Num_Pedido, HOU.Num_Proc_HIM, DPP.GMID_Descr_Curta, PS.Cd_Produto, PS.Cd_Pedido


Union All

	select 
		Cia.Nome_Raz_Soc	Cia_Dow,
		P.Num_Pedido		Order_Number,
	--	Taxa_Adiantamento
	--	Etiqueta
	--	Controle
		HOU.Num_Proc_HEA	BDP_Reference,
		DPP.GMID_Descr_Curta	Produto,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_Exp_Aer HOU

	Join Pedido_Ship 	PS	on HOU.Num_Proc_HEA = PS.Num_Proc
	Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Join Pessoa		Cia	on Cia.Cd_Pes = HOU.Cd_Export_HEA
	
	where 
		convert(datetime,Dt_Emis_HEA,105) > @Data

	Group by Cia.Nome_Raz_Soc, P.Num_Pedido, HOU.Num_Proc_HEA, DPP.GMID_Descr_Curta, PS.Cd_Produto, PS.Cd_Pedido

Union All
	select 
		Cia.Nome_Raz_Soc	Cia_Dow,
		P.Num_Pedido		Order_Number,
	--	Taxa_Adiantamento
	--	Etiqueta
	--	Controle
		HOU.Num_Proc_HIA	BDP_Reference,
		DPP.GMID_Descr_Curta	Produto,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_Imp_Aer HOU

	Join Pedido_Ship 	PS	on HOU.Num_Proc_HIA = PS.Num_Proc
	Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Join Pessoa		Cia	on Cia.Cd_Pes = HOU.Cd_Consig_HIA
	
	where 
		convert(datetime,Dt_Emis_HIA,105) > @Data

	Group by Cia.Nome_Raz_Soc, P.Num_Pedido, HOU.Num_Proc_HIA, DPP.GMID_Descr_Curta, PS.Cd_Produto, PS.Cd_Pedido

Union All

	select 
		Cia.Nome_Raz_Soc	Cia_Dow,
		P.Num_Pedido		Order_Number,
	--	Taxa_Adiantamento
	--	Etiqueta
	--	Controle
		HOU.Num_Proc_HEO	BDP_Reference,
		DPP.GMID_Descr_Curta	Produto,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_Exp_OUT HOU

	Join Pedido_Ship 	PS	on HOU.Num_Proc_HEO = PS.Num_Proc
	Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Join Pessoa		Cia	on Cia.Cd_Pes = HOU.Cd_Export_HEO
	
	where 
		convert(datetime,Dt_Emis_HEO,105) > @Data

	Group by Cia.Nome_Raz_Soc, P.Num_Pedido, HOU.Num_Proc_HEO, DPP.GMID_Descr_Curta, PS.Cd_Produto, PS.Cd_Pedido

Union All

	select 
		Cia.Nome_Raz_Soc	Cia_Dow,
		P.Num_Pedido		Order_Number,
	--	Taxa_Adiantamento
	--	Etiqueta
	--	Controle
		HOU.Num_Proc_HIO	BDP_Reference,
		DPP.GMID_Descr_Curta	Produto,
		PS.Cd_Produto  		CD_Produto,
		PS.Cd_Pedido		CD_Pedido
	from
		House_Imp_OUT HOU

	Join Pedido_Ship 	PS	on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido_Det		PD	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido		P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente	PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 	DPP	on PC.Cd_Proc_Cliente = DPP.GMID 
	Join Pessoa		Cia	on Cia.Cd_Pes = HOU.Cd_Consig_HIO
	
	where 
		convert(datetime,Dt_Emis_HIO,105) > @Data

	Group by Cia.Nome_Raz_Soc, P.Num_Pedido, HOU.Num_Proc_HIO, DPP.GMID_Descr_Curta, PS.Cd_Produto, PS.Cd_Pedido


GO
