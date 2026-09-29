SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--04-06-2008
--Week 23
--inclusão Join com Pessoa_LLP - Claudio

--18-06-2008
--Week 25
--inclusão Pgto_ICMS - Claudio

CREATE      Procedure	[dbo].[spAccountReconciliation_IA_Rel] 

As

Select 
	convert(datetime,HOU.Dt_Emis_HIA,105)							Register_Date,
	OC.Nome_Raz_Soc													Ordering_Customer,
	CS.Nome_Raz_Soc													Consignee,
	LC.Pais_Local													Country_Destination,
	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIA,'Num_Pedido')			Order_Number,
	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIA,'PO')					PO,
	HOU.Num_Proc_HIA												Ref_BDP,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIA,'%Imposto de Imp%')	vlr_II,
	(dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Hia,'%Impos% Prod% Ind%') +  dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_hia,'IPI%')) vlr_IPI,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIA,'%SISC%')			vlr_SISC,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIA,'%PIS%')				vlr_PIS,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIA,'%Cofins%')			vlr_Cofins,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIA,'%ICMS%')			vlr_ICMS,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIA,'%ANTIDUMPING%')		vlr_ANTIDUMPING,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIA,'%AFRMM%')			vlr_AFRMM,
	DI.data_PO_hia													Dt_Pgto,
	null															Pgto_AFRMM,
	dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,24)							Pgto_ICMS,
	dbo.fBusca_Tarefa(HOU.Num_Proc_HIA,4)							Dt_Desembaraco,
	DST.Nome_Local													Destino
from 
	House_Imp_Aer HOU
	Join LLP_Imp_Aer	LLP on HOU.Num_Proc_HIA = LLP.Num_Proc_Lia
	Left Join Pedido_Ship 	PS  on HOU.Num_Proc_HIA = PS.Num_Proc
	Left Join Pedido			P   on PS.Cd_Pedido = P.Cd_Pedido
	Join Pessoa			CS  on HOU.Cd_Consig_HIA = CS.Cd_Pes and CS.desat_pes = 'N'
	Join Pessoa			OC  on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
	Join Localidade		LC  on HOU.Cd_Dst_HIA =  LC.Cd_Local
	Left Join PO_hia 	DI  on DI.Num_Proc_hia 	=HOU.Num_Proc_Hia and DI.ID_DC = 5
	Join Pessoa_LLP		PLL on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
	Join Localidade		DST on DST.cd_local=cd_dst_hia
where
	DI.data_PO_hia is not null and DI.Numero_PO_HIA not like 'Courier%'
Group by
	HOU.Dt_Emis_HIA,
	OC.Nome_Raz_Soc,
	CS.Nome_Raz_Soc,
	LC.Pais_Local,
	HOU.Num_Proc_HIA,
	DI.data_PO_hia,
	DST.Nome_Local












GO
