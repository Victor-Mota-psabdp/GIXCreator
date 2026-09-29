SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_CashflowProyectado_Rel]--'Grupo Dow','2015-04-01','2015-04-13',''

	@Grupo		varchar(20),
	@DtInicial	datetime,
	@DtFinal	datetime
	--@cia		varchar(10)
	
AS

	Declare @Cd_Grupo as varchar(10)
	Set @Cd_Grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	select			
		HOU.Num_Proc_HIM											[Ref. BDP],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,1)			[PO],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,3)			[Order],
		SEL.Apelido													[Proveedor],--Seller
		Nome_Pais													[Pais],
		Upper(Isnull(EndSEL.Rua,'')+ ' ' + Isnull(EndSEL.Numero,'')+ 
		' ' +' ' +Isnull(EndSEL.Cidade,'')
		)															[Domicilio],
		Isnull(P.Incoterm,'CFR')									[Condición de Venta],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,2)			[N° de Factura],
		LLP.Vlr_Invoice												[Importe Factura Value],
		cd_regiao													[cd_regiao],
		'US DOLLAR'													[Divisa Factura],
		--LLP.Cd_Moeda_Invoice										Divisa_Factura,
		HOU.Vlr_Frete_Efet_HIM										[Importe_Flete Value],
		MOEDA.Nome_Tp_Moeda											[Divisa_Flete],
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then ((LLP.Vlr_Invoice * 0.14) * 3.05)
		end)														[Import Duties ARP Value],

		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((LLP.Vlr_Invoice * 0.5) /100) * 3.05
		end)														[Statistics Tax ARP Value],

		(case
			when cd_Regiao = '007' then '0'	
			--Import Duties USD + Statistics Tax USD + Importe Factura
		when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 21) /100) * 3.05
		end)														[IVA ARP Value],      
	
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 0.5) /100) * 3.05
		end)														[Ganancias ARP Value],
           
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 1.5) /100) * 3.05
		end)														[Ingresos Brutos ARP Value],     
         
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  LLP.Vlr_Invoice * 0.14
		end)														[Import Duties USD Value],
		
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  (LLP.Vlr_Invoice * 0.5) / 100
		end)														[Statistics Tax USD Value],

		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 21) /100)           
		end)														[IVA USD Value],

		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 0.5) /100)           
		end)														[Ganancias USD Value],
        
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 1.5) /100)           
		end)														[Ingresos Brutos USD Value],
      
		3.05														[Currency Rate ARP USD Value],
		LLP.ETA_LIM													[ETA Date],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIM,5)			[Despacho_Impo]		
		--right(left(planta,5),2)										[Cia]

	from
		House_Imp_Mar			HOU
		Join LLP_Imp_Mar		LLP		on HOU.Num_Proc_HIM=LLP.Num_Proc_LIM
		Left Join Pedido_Ship	PS		on HOU.Num_Proc_HIM=PS.Num_Proc --and convert(int,PS.Item) = 1
		Left Join Pedido		P		on PS.Cd_Pedido=P.Cd_Pedido
		Left Join Pessoa		SEL		on P.Cd_Seller=SEL.Cd_Pes
		Left Join Endereco		EndSEL	on EndSEL.cd_pes=SEL.Cd_Pes and Cd_tp_End = 'COM'
		Left Join Tipo_Moeda	MOEDA	on HOU.Cd_Tp_Moeda=MOEDA.Cd_Tp_Moeda
		Join Pessoa_LLP			PLLP	on cd_consig_him=PLLP.cd_pes and PLLP.Cd_Pes_Grupo=@Cd_Grupo		
		Join Localidade			Org		on org.cd_local=cd_planta_lim
		Left Join Pais			CN		on CN.cd_pais=org.cd_pais
	Where
--		ETA_LIM between getdate()-1 and getdate()+90		
		convert(datetime,ETA_LIM,103) between convert(datetime,@dtInicial,103) and convert(datetime,@dtFinal,103)	
		--and (right(left(planta,5),2) = @cia OR isnumeric(@cia) = 0)
		
	Group by
		HOU.Num_Proc_HIM									,
		SEL.Apelido											,
		Nome_Pais,
		P.Incoterm											,
		LLP.Vlr_Invoice										,
		LLP.Cd_Moeda_Invoice								,
		HOU.Vlr_Frete_Efet_HIM								,
		MOEDA.Nome_Tp_Moeda									,
		LLP.ETA_LIM		,
		Rua,Numero,Compl_End,CEP,Bairro,Cidade,UF,
		cd_Regiao

UNION ALL

	select		
		HOU.Num_Proc_HIO											[Ref. BDP],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,1)			[PO],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,3)			[Order],
		SEL.Apelido													[Proveedor],--Seller
		Nome_Pais													[Pais],
		Upper(Isnull(EndSEL.Rua,'')+ ' ' + Isnull(EndSEL.Numero,'')+ 
		' ' +' ' +Isnull(EndSEL.Cidade,'')
		)															[Domicilio],
		Isnull(P.Incoterm,'CFR')									[Condición de Venta],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,2)			[N° de Factura],
		LLP.Vlr_Invoice												[Importe Factura Value],
		cd_regiao													[cd_regiao],
		'US DOLLAR'													[Divisa Factura],
		--LLP.Cd_Moeda_Invoice										Divisa_Factura,
		HOU.Vlr_Frete_Efet_HIO										[Importe_Flete Value],
		MOEDA.Nome_Tp_Moeda											[Divisa_Flete],
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then ((LLP.Vlr_Invoice * 0.14) * 3.05)
		end)														[Import Duties ARP Value],

		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((LLP.Vlr_Invoice * 0.5) /100) * 3.05
		end)														[Statistics Tax ARP Value],

		(case
			when cd_Regiao = '007' then '0'	
			--Import Duties USD + Statistics Tax USD + Importe Factura
		when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 21) /100) * 3.05
		end)														[IVA ARP Value],      
	
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 0.5) /100) * 3.05
		end)														[Ganancias ARP Value],
           
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 1.5) /100) * 3.05
		end)														[Ingresos Brutos ARP Value],     
         
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  LLP.Vlr_Invoice * 0.14
		end)														[Import Duties USD Value],
		
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  (LLP.Vlr_Invoice * 0.5) / 100
		end)														[Statistics Tax USD Value],

		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 21) /100)           
		end)														[IVA USD Value],

		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 0.5) /100)           
		end)														[Ganancias USD Value],
        
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 1.5) /100)
           
		end)														[Ingresos Brutos USD Value],
      
		3.05														[Currency Rate ARP USD Value],
		LLP.ETA_LIO													[ETA Date],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIO,5)			[Despacho_Impo]		
		--right(left(planta,5),2)										[Cia]

	from
		House_Imp_OUT			HOU
		Join LLP_Imp_OUT		LLP		on HOU.Num_Proc_HIO=LLP.Num_Proc_LIO
		Left Join Pedido_Ship	PS		on HOU.Num_Proc_HIO=PS.Num_Proc-- and convert(int,PS.Item) = 1
		Left Join Pedido		P		on PS.Cd_Pedido=P.Cd_Pedido
		Left Join Pessoa		SEL		on P.Cd_Seller=SEL.Cd_Pes
		Left Join Endereco		EndSEL	on EndSEL.cd_pes=SEL.Cd_Pes and Cd_tp_End = 'COM'
		Left Join Tipo_Moeda	MOEDA	on HOU.Cd_Tp_Moeda=MOEDA.Cd_Tp_Moeda
		Join Pessoa_LLP			PLLP	on cd_consig_HIO=PLLP.cd_pes and PLLP.Cd_Pes_Grupo=@Cd_Grupo
		Join Localidade			Org		on org.cd_local=cd_planta_lio
		Join Pais				CN		on CN.cd_pais=Org.cd_pais
	Where
--		ETA_LIM between getdate()-1 and getdate()+90		
		convert(datetime,ETA_LIO,103) between convert(datetime,@dtInicial,103) and convert(datetime,@dtFinal,103)
		--and (right(left(planta,5),2) = @cia OR isnumeric(@cia) = 0)

	Group by
		HOU.Num_Proc_HIO									,
		SEL.Apelido											,
		Nome_Pais											,
		P.Incoterm											,
		LLP.Vlr_Invoice										,
		LLP.Cd_Moeda_Invoice								,
		HOU.Vlr_Frete_Efet_HIO								,
		MOEDA.Nome_Tp_Moeda									,
		LLP.ETA_LIO		,
		Rua,Numero,Compl_End,CEP,Bairro,Cidade,UF,
		cd_Regiao
		--planta


UNION ALL

	select		
		HOU.Num_Proc_HIA											[Ref. BDP],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,1)			[PO],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,3)			[Order],
		SEL.Apelido													[Proveedor],--Seller
		Nome_Pais													[Pais],
		Upper(Isnull(EndSEL.Rua,'')+ ' ' + Isnull(EndSEL.Numero,'')+ 
		' ' +' ' +Isnull(EndSEL.Cidade,'')
		)															[Domicilio],
		Isnull(P.Incoterm,'CFR')									[Condición de Venta],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,2)			[N° de Factura],
		LLP.Vlr_Invoice												[Importe Factura Value],
		cd_regiao													[cd_regiao],
		'US DOLLAR'													[Divisa Factura],
		--LLP.Cd_Moeda_Invoice										Divisa_Factura,
		HOU.Vlr_Frete_Efet_HIA										[Importe_Flete Value],
		MOEDA.Nome_Tp_Moeda											[Divisa_Flete],
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then ((LLP.Vlr_Invoice * 0.14) * 3.05)
		end)														[Import Duties ARP Value],

		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((LLP.Vlr_Invoice * 0.5) /100) * 3.05
		end)														[Statistics Tax ARP Value],

		(case
			when cd_Regiao = '007' then '0'	
			--Import Duties USD + Statistics Tax USD + Importe Factura
		when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 21) /100) * 3.05
		end)														[IVA ARP Value],      
	
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 0.5) /100) * 3.05
		end)														[Ganancias ARP Value],
           
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 1.5) /100) * 3.05
		end)														[Ingresos Brutos ARP Value],     
         
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  LLP.Vlr_Invoice * 0.14
		end)														[Import Duties USD Value],
		
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  (LLP.Vlr_Invoice * 0.5) / 100
		end)														[Statistics Tax USD Value],

		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 21) /100)
           
		end)														[IVA USD Value],

		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 0.5) /100)
           
		end)														[Ganancias USD Value],
        
		(case
			when cd_Regiao = '007' then '0'			
			when cd_Regiao <> '007' then  ((((LLP.Vlr_Invoice * 0.14) + ((LLP.Vlr_Invoice * 0.5) /100) + (LLP.Vlr_Invoice)) * 1.5) /100)
           
		end)														[Ingresos Brutos USD Value],
      
		3.05														[Currency Rate ARP USD Value],

		LLP.ETA_LIA													[ETA Date],
		dbo.fBusca_TipoDocCliente('N',HOU.Num_Proc_HIA,5)			[Despacho_Impo]		
		--right(left(planta,5),2)										[Cia]
	from
		House_Imp_aer			HOU
		Join LLP_Imp_aer		LLP		on HOU.Num_Proc_hia=LLP.Num_Proc_lia
		Left Join Pedido_Ship	PS		on HOU.Num_Proc_hia=PS.Num_Proc --and convert(int,PS.Item) = 1
		Left Join Pedido		P		on PS.Cd_Pedido=P.Cd_Pedido
		Left Join Pessoa		SEL		on P.Cd_Seller=SEL.Cd_Pes
		Left Join Endereco		EndSEL	on EndSEL.cd_pes=SEL.Cd_Pes and Cd_tp_End = 'COM'
		Left Join Tipo_Moeda	MOEDA	on HOU.Cd_Tp_Moeda=MOEDA.Cd_Tp_Moeda
		Join Pessoa_LLP			PLLP	on cd_consig_hia=PLLP.cd_pes and PLLP.Cd_Pes_Grupo=@Cd_Grupo
		Join Localidade			Org		on org.cd_local=cd_planta_lia
		Join Pais				CN		on CN.cd_pais=ORg.cd_pais
	Where
--		ETA_LIM between getdate()-1 and getdate()+90		
		convert(datetime,ETA_LIA,103) between convert(datetime,@dtInicial,103) and convert(datetime,@dtFinal,103)
		--and (right(left(planta,5),2) = @cia OR isnumeric(@cia) = 0)
	Group by
		HOU.Num_Proc_hia									,
		SEL.Apelido											,
		Nome_Pais											,
		P.Incoterm											,
		LLP.Vlr_Invoice										,
		LLP.Cd_Moeda_Invoice								,
		HOU.Vlr_Frete_Efet_hia								,
		MOEDA.Nome_Tp_Moeda									,
		LLP.ETA_lia		,
		Rua,Numero,Compl_End,CEP,Bairro,Cidade,UF,
		cd_Regiao
		--planta

Order by 16

GO
