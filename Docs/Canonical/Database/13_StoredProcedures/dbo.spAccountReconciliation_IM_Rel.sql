SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--05-06-2008
--Week 23
--inclusão Join com Pessoa_LLP - Claudio

--18-06-2008
--Week 25
--inclusão Pgto_ICMS e Pgto_AFRMM - Claudio

CREATE      Procedure	[dbo].[spAccountReconciliation_IM_Rel] 

As

Select 
	convert(datetime,HOU.Dt_Emis_HIM,105)							Register_Date,
	OC.Nome_Raz_Soc													Ordering_Customer,
	CS.Nome_Raz_Soc													Consignee,
	LC.Pais_Local													Country_Destination,
	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIM,'Num_Pedido')			Order_Number,
	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIM,'PO')					PO,
	HOU.Num_Proc_HIM												Ref_BDP,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%Imposto de Imp%')	vlr_II,
	(dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Him,'%Impos% Prod% Ind%') +  dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Him,'IPI%')) vlr_IPI,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%SISComeX%')			vlr_SISC,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%PIS%')				vlr_PIS,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%Cofins%')			vlr_Cofins,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%ICMS%')			vlr_ICMS,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%DUMPING%')			vlr_ANTIDUMPING,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%AFRMM%')			vlr_AFRMM,
	DI.data_PO_him													Dt_Pgto,
	dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,25)							Pgto_AFRMM,
	dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,24)							Pgto_ICMS,
	dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,4)							Dt_Desembaraco,
	DST.Nome_Local													Destino
from 
	House_Imp_MAR HOU
	Join LLP_Imp_MAR	LLP on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Join Pedido_Ship 	PS  on HOU.Num_Proc_HIM = PS.Num_Proc
	Left Join Pedido			P   on PS.Cd_Pedido = P.Cd_Pedido
	Join Pessoa			CS  on HOU.Cd_Consig_HIM = CS.Cd_Pes	
	Join Pessoa			OC  on P.Cd_Buyer = OC.Cd_Pes 
	Join Localidade		LC  on HOU.Cd_Dst_HIM =  LC.Cd_Local
	Join PO_him 		DI  on DI.Num_Proc_him 	=HOU.Num_Proc_Him and DI.ID_DC = 5
	Join Pessoa_LLP		PLL on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
	Join Localidade		DST on DST.cd_local=cd_dst_him
Where
DI.data_PO_him is not null  and DI.numero_po_him not like 'Courier%'
Group By
	HOU.Dt_Emis_HIM,
	OC.Nome_Raz_Soc,
	CS.Nome_Raz_Soc,
	LC.Pais_Local,
	HOU.Num_Proc_HIM,
	DI.data_PO_him,
	DST.Nome_Local



GO
