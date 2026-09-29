SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from dbo.Danfe_base D
--	join dbo.Danfe_Item_Produto IP on IP.Id_Danfe = D.Id_Danfe	
--	where num_proc like 'IAOWE201205002BR' and nNF = '4789'
--
--select * from ATLANTIS.dbo.nota_cliente where  num_proc like 'IMOCV201208004BR'
--select * from ATLANTIS.dbo.nota_fiscal_cliente_det where id_nf = '7' and Cd_CLiente = 'P000007590'
--
--
--
--		join Danfe_Cia C on C.Id_Danfe = D.Id_Danfe and C.Tipo = 'E'
--		join Danfe_Totais T on T.Id_Danfe = D.Id_Danfe
--		join dbo.Danfe_Item_Produto IP on IP.Id_Danfe = D.Id_Danfe
--		join Danfe_Item_Prod_DI DI on DI.Id_Danfe = D.Id_Danfe and DI.id_item=IP.id_Item
--		left Join Danfe_Item_Impostos II on II.id_danfe = D.id_danfe and II.id_item=IP.id_Item and II.cImpostos='II'
--		left Join Danfe_Item_Impostos IPI on IPI.id_danfe = D.id_danfe and IPI.id_item=IP.id_Item and IPI.cImpostos='IPI'
--		left Join Danfe_Item_Impostos PIS on PIS.id_danfe = D.id_danfe and PIS.id_item=IP.id_Item and PIS.cImpostos='PIS'
--		left Join Danfe_Item_Impostos COFINS on COFINS.id_danfe = D.id_danfe and COFINS.id_item=IP.id_Item and COFINS.cImpostos='COFINS'
--		left Join Danfe_Item_Impostos ICMS on ICMS.id_danfe = D.id_danfe and ICMS.id_item=IP.id_Item and ICMS.cImpostos='ICMS'
--		left join Danfe_Transp TR on TR.id_danfe = D.id_danfe
--		left join Danfe_Transp_Vol TRV on TRV.id_danfe = D.id_danfe
--		left join Danfe_Item_Prod_DI_Adicao

--00000000 + numero da nf + 000000000

--select NF.vlr_seguro, NF.vlr_frete from dbo.Danfe_base D
--	join dbo.Danfe_Item_Produto IP on IP.Id_Danfe = D.Id_Danfe
--	join ATLANTIS.dbo.nota_cliente NC on NC.num_proc = D.num_proc and Nota_fiscal = '0'+ nNF
--	join ATLANTIS.dbo.nota_fiscal_cliente_det NF on NF.ID_NF = NC.ID_NF and NF.Cd_CLiente = NC.Cd_Cliente and NF.id_item = IP.Id_item
--	where D.num_proc like 'IAOWE201205002BR' and nNF = '30713'
--
--select * from ATLANTIS.dbo.nota_cliente where num_proc = 'IAOWE201205002BR'
--select * from ATLANTIS.dbo.nota_fiscal_cliente_det
--
--select vlr_frete,vlr_seguro from ATLANTIS.dbo.nota_cliente NC
--    join ATLANTIS.dbo.nota_fiscal_cliente_det NF on NF.ID_NF = NC.ID_NF and NF.Cd_CLiente = NC.Cd_Cliente
--	where num_proc = 'IAOWE201205002BR' and Nota_fiscal = '030710'
--
--select * from ATLANTIS.dbo.nota_cliente NC
--    join ATLANTIS.dbo.nota_fiscal_cliente_det NF on NF.ID_NF = NC.ID_NF and NF.Cd_CLiente = NC.Cd_Cliente
--	where num_proc = 'IAOWE201205002BR' and Nota_fiscal = '030715'
--
--030710
--030711
--030712
--030713
--030715
--
--select * from dbo.Danfe_base D
--	join dbo.Danfe_Item_Produto IP on IP.Id_Danfe = D.Id_Danfe	
--	where num_proc like 'IAOWE201205002BR' and nNF = '30715'
--
--select distinct nNF from dbo.Danfe_base D
--	join dbo.Danfe_Item_Produto IP on IP.Id_Danfe = D.Id_Danfe	
--	where num_proc like 'IAOWE201205002BR'
--30710
--30711
--30712
--30713


CREATE procedure [dbo].[spNF2SAP_Item_Rel]--.[spNF2SAP_Item_Rel] 'IMOCV201303001BR','30804'
	@Num_Proc varchar(16),
	@nNF varchar(20)
as
	Declare @Table Table
		(
			[Nome do Fornecedor]		Varchar(100),
			[Descrição do Material]	Varchar(500),
			[Quantidade]				Decimal(10,2),
			[Unidade]					Varchar(4),
			[Preço Unit]				Float,
			[Instrução Normativa Sicomex]	Decimal(10,2),
			[CFOP]							Varchar(4),
			[NCM]							Varchar(8),
			[Base ICMS]						Decimal(10,2),
			[Aliquota ICMS]					Decimal(10,2),
			[Vr. ICMS]						Decimal(10,2),
			[Base IPI]						Decimal(10,2),
			[Aliquota IPI]					Decimal(10,2),
			[Valor IPI]						Decimal(10,2),
			[Transportadora]				Varchar(50),
			Quantidade1						Decimal(10,2),
			[Espécie volume]				Varchar(50),
			[Peso Bruto]					float,
			[Peso Liquido]					float,
			[Número do Pedido]				Varchar(100),
			[Número do Itam do Pedido]		Int,
			[Número da Adição]				int,
			[Número do Item]				int,
			[Frete]							Decimal(10,2),
			[Seguro]						Decimal(10,2),
			[PIS - CST]						char(2),
			[PIS - Valor Base de Cálculo]	Decimal(10,2),
			[PIS - Taxa de Imposto]			Decimal(10,2),
			[PIS - Valor do Imposto]		Decimal(10,2),
			[COFINS - CST]					char(2),
			[COFINS - Valor da Base de Cálculo]	decimal(10,2),
			[COFINS - Taxa de Imposto]			Decimal(10,2),
			[COFINS - Valor do Imposto]			Decimal(10,2),
			[Data da DI]						Datetime,
			[Local do Desembaraço]				Varchar(40),
			[UF do Desembaraço]					Char(2),
			[Data do Desembaraço]				Datetime,
			[Valor Base do Cálculo do Imp Importação]	Decimal(10,2),
			[Valor do Imposto de Importação]			Decimal(10,2),
			[Despesas Aduaneiras (POR ITEM)]			Decimal(10,2),
			[CdProduct]							Varchar(30),
			[vTotal]			Decimal(10,2)
		
		
		
		)
	insert @Table	
	select --D.id_danfe,
		
		C.xNome [Nome do Fornecedor],
		IP.xProd [Descrição do material],
		IP.qCom [Quantidade],
		IP.uCOM [Unidade],			
		IP.vUNCom [Preço Unit],
	--	(T.vOutros / (select max(id_item) from danfe_item_produto where id_danfe=D.id_Danfe)) [Instrução Normativa Siscomex],
		0 [Instrução Normativa Siscomex],

		IP.CFOP [CFOP],
		IP.NCM [NCM],
		ICMS.vBC [Base ICMS],
		ICMS.pImposto [Aliquota ICMS],
		ICMS.vImposto [Vr. ICMS],
		IPI.vBC [Base IPI],
		IPI.pImposto [Aliquota IPI],
		IPI.vImposto [Valor IPI],
		TR.xNome [Transportadora],
--		isnull(TRV.qVol,0) [Quantidade volumes],
		IP.qCom [Quantidade],
		TRV.esp [Espécie volume],
--		isnull(TRV.PesoB,0) [Peso Bruto],
		0 [Peso Bruto],
--		isnull(TRV.PesoL,0) [Peso liquido],
		0		[Peso liquido],
		atlantis.dbo.fBusca_TipoDocCliente('N',@Num_Proc,1) [Número do Pedido],
		IP.id_Item [Número do Item do Pedido],
		IPDA.nAdicao [Número da Adição],
		IP.id_Item [Numero do ITEM],
		isnull(IP.vFrete, 0) [Frete],
    	isnull(IP.vSeguro,0) [Seguro],


		convert(varchar,PIS.CST) [PIS - CST],
		PIS.vBC [PIS - Valor Base de Cálculo],
		PIS.pImposto [PIS - Taxa de Imposto],
		PIS.vImposto [PIS - Valor do Imposto],
		convert(varchar,COFINS.CST) [COFINS - CST],
		COFINS.vBC [COFINS - Valor Base de Cálculo],
		COFINS.pImposto [COFINS - Taxa de Imposto],
		COFINS.vImposto [COFINS - Valor do Imposto],
		DI.dDI [Data da DI],
		DI.xLocDesemb [Local do desembaraço],
		DI.UFDesemb [UF do desembaraço],
		DI.dDesemb [Data do desembaraço],
		II.vBC [Valor Base do Cálculo do Imp Importação],
		II.vImposto [Valor do Imposto Importação],
--		(T.vOutros /(select count(id_item) from danfe_item_produto where id_danfe=D.id_Danfe)) [Despesas Aduaneiras (POR ITEM)]		
		(0) [Despesas Aduaneiras (POR ITEM)],
		IP.cProd ,
		T.vOutros	

	from 
		ATL_BR.dbo.Danfe_Base D with(nolock)
		join ATL_BR.dbo.Danfe_Cia C with(nolock) on C.Id_Danfe = D.Id_Danfe and C.Tipo = 'D'
		join ATL_BR.dbo.Danfe_Totais T with(nolock) on T.Id_Danfe = D.Id_Danfe
		join ATL_BR.dbo.Danfe_Item_Produto IP with(nolock) on IP.Id_Danfe = D.Id_Danfe
		join ATL_BR.dbo.Danfe_Item_Prod_DI DI with(nolock) on DI.Id_Danfe = D.Id_Danfe and DI.id_item=IP.id_Item and Ip.cProd = Di.cProd
		left Join ATL_BR.dbo.Danfe_Item_Impostos II with(nolock) on II.id_danfe = D.id_danfe and II.id_item=IP.id_Item and II.cImpostos='II'
		left Join ATL_BR.dbo.Danfe_Item_Impostos IPI with(nolock) on IPI.id_danfe = D.id_danfe and IPI.id_item=IP.id_Item and IPI.cImpostos='IPI'
		left Join ATL_BR.dbo.Danfe_Item_Impostos PIS with(nolock) on PIS.id_danfe = D.id_danfe and PIS.id_item=IP.id_Item and PIS.cImpostos='PIS'
		left Join ATL_BR.dbo.Danfe_Item_Impostos COFINS with(nolock) on COFINS.id_danfe = D.id_danfe and COFINS.id_item=IP.id_Item and COFINS.cImpostos='COFINS'
		left Join ATL_BR.dbo.Danfe_Item_Impostos ICMS with(nolock) on ICMS.id_danfe = D.id_danfe and ICMS.id_item=IP.id_Item and ICMS.cImpostos='ICMS'
		left join ATL_BR.dbo.Danfe_Transp TR with(nolock) on TR.id_danfe = D.id_danfe
		left join ATL_BR.dbo.Danfe_Transp_Vol TRV with(nolock) on TRV.id_danfe = D.id_danfe
		left join ATL_BR.dbo.Danfe_Item_Prod_DI_Adicao IPDA with(nolock) on IPDA.nDI = DI.nDI and IPDA.Id_Danfe = DI.Id_Danfe and IPDA.id_item=DI.id_Item

		--join ATLANTIS.dbo.nota_cliente NC with(nolock) on NC.num_proc = D.num_proc and right('0000000000' + Nota_fiscal,10) = right('0000000000' + nNF,10)
		--join ATLANTIS.dbo.nota_fiscal_cliente_det NF with(nolock) on NF.ID_NF = NC.ID_NF and NF.Cd_CLiente = NC.Cd_Cliente   and IP.cProd Collate SQL_Latin1_General_CP1_CI_AS =(select top 1 cd_proc_cliente from produto_Cliente where cd_prod=cd_produto)
		
	where
		D.num_proc = @Num_Proc and nNF = @nNF

/*
select * from dbo.Danfe_Item_Impostos where id_danfe = 12869
select * from dbo.Danfe_Totais where vFRETE > 0
select * from dbo.Danfe_base where num_proc='IAOWE201205002BR'
select * from dbo.Danfe_cia where id_danfe = 12869
select * from dbo.Danfe_Item_Produto where id_danfe = 12869

select * from dbo.Danfe_Transp_Vol where id_danfe = 12869

select * from dbo.Danfe_Item_Prod_DI where id_danfe in (12869)
select * from dbo.Danfe_Item_Prod_DI_Adicao where  id_danfe in (12869)

select * from Danfe_Transp_Vol


spNF2SAP_Item_Rel 'IMFMC201202008BR','4409'

select * from 
update
dbo.Danfe_base 
set Num_Pedido = '4590151852/ DI-6764'
where num_proc='IAOWE201205002BR'

*/

Declare @TabelaTotais Table
	(
		[Cd_Produto]	varchar(30),
		[QuantidadeTotal]	Decimal(10,2),
		[PesoBruto]	float,
		[PesoLiquido]	float,
		[FreteTotal]			Decimal(10,2),
		[SeguroTotal]		Decimal(10,2),
		[SiscomexTotal]		Decimal(10,2)
		
	
	)


insert @TabelaTotais
SElect cd_proc_cliente,sum(quantidade),sum(peso_bruto),sum(peso_liquido),sum(vlr_frete),sum(vlr_seguro),sum(vlr_siscomex) from Nota_Cliente NC with(nolock)
Join Nota_Fiscal_Cliente_Det NDD with(nolock) on NDD.cd_cliente=NC.cd_cliente and NDD.id_nf=NC.id_nf
Join Produto_cliente PC on cd_prod=cd_produto
Where num_proc=@num_proc and 
right('0000000000' + Nota_fiscal,10) = right('0000000000' + @nnf,10)
group by cd_proc_cliente 


update @Table set 
[Peso Bruto]=[PesoBruto]*(Quantidade/[QuantidadeTotal]),
[Peso Liquido]=[PesoLiquido]*(Quantidade/[QuantidadeTotal]),
[Instrução Normativa Sicomex]	=[SiscomexTotal]*(Quantidade/[QuantidadeTotal]),
--[Despesas Aduaneiras (POR ITEM)]	=[SiscomexTotal]*(Quantidade/[QuantidadeTotal])alterado dia 23/10 - Solicitado por Edson/Jonata
[Despesas Aduaneiras (POR ITEM)]	=[vTotal]*(Quantidade/[QuantidadeTotal])

 from @table
Join @TabelaTotais T on [CdProduct]	= 	[Cd_Produto]


update @Table set 
[Frete]=[FreteTotal]*([Peso Liquido]/[PesoLiquido]),
[Seguro]=[SeguroTotal]*([Peso Liquido]/[PesoLiquido])

 from @table
Join @TabelaTotais T on [CdProduct]	= 	[Cd_Produto]


select 
			[Nome do Fornecedor],[Descrição do Material],[Quantidade],[Unidade],[Preço Unit],[Instrução Normativa Sicomex],
			[CFOP],[NCM],[Base ICMS],[Aliquota ICMS],[Vr. ICMS],[Base IPI],	[Aliquota IPI],[Valor IPI],
			[Transportadora],Quantidade1 Quantidade,[Espécie volume],[Peso Bruto],
			[Peso Liquido],	[Número do Pedido],	[Número do Itam do Pedido],	[Número da Adição],
			[Número do Item],[Frete],[Seguro],[PIS - CST],[PIS - Valor Base de Cálculo],
			[PIS - Taxa de Imposto],[PIS - Valor do Imposto],[COFINS - CST]	,[COFINS - Valor da Base de Cálculo],
			[COFINS - Taxa de Imposto],	[COFINS - Valor do Imposto],[Data da DI],
			[Local do Desembaraço],	[UF do Desembaraço],[Data do Desembaraço],
			[Valor Base do Cálculo do Imp Importação],[Valor do Imposto de Importação],
			[Despesas Aduaneiras (POR ITEM)]

 from @Table
GO
