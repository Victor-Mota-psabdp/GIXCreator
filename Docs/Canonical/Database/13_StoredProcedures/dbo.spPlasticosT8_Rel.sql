SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Incluido campo Planta 03/08/09 - Rafael 

CREATE  Procedure	[dbo].[spPlasticosT8_Rel] --'01/01/2009'
(
	
@Data datetime
)
As		
	Select
		'BDP'									Despachante,
		Null		 							Dem_Despesa,
		convert(Datetime,HOU.Dt_Emis_HIO,105)	Dt_Emissao,
		CNPJ.Num_CPF_CNPJ						CNPJ,
		Null									Ref_Dow,
		HOU.Num_Proc_HIO 						Ref_Despachante,
		0										Vlr_Adto,		
		0										Vlr_Dem,
		null									DebCred,
		null									DtDeposito,
		Num_Pedido								SAP,
		PS.Item									Item,
		Null									Especialista,
		P.Planta		
from
		House_IMP_OUT HOU with(nolock)

	Left Outer Join	Nota_Cliente	NC  with(nolock)	on HOU.Num_Proc_HIO = NC.Num_Proc
	Left Outer Join Pessoa			CNPJ with(nolock)	on HOU.Cd_Export_HIO = CNPJ.Cd_Pes
	Join Pedido_Ship 				PS with(nolock)	on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido_Det					PD with(nolock)	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido						P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente			PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 			DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Pessoa_LLP		PT with(nolock)	on HOU.Cd_Export_HIO = PT.Cd_Pes

	where 
		convert(datetime,Dt_Emis_HIO,105) > @Data
		-- and PD.PO_GRP IN ('041')
		and (P.Planta IN ('05031WQ','05031WJ'))







GO
