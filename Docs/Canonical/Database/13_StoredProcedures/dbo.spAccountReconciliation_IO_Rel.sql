SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--05-06-2008
--Week 23
--inclusão Join com Pessoa_LLP - Claudio

--18-06-2008
--Week 25
--inclusão Pgto_ICMS - Claudio


CREATE     Procedure	[dbo].[spAccountReconciliation_IO_Rel] 	

As

Select 
	convert(datetime,Dt_Emis_HIO,105)								Register_Date,
	OC.Nome_Raz_Soc													Ordering_Customer,
	CS.Nome_Raz_Soc													Consignee,
	LC.Pais_Local													Country_Destination,
	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIO,'Num_Pedido')			Order_Number,
	dbo.fBusca_PO_NumPedido(HOU.Num_Proc_HIO,'PO')					PO,
	HOU.Num_Proc_HIO												Ref_BDP,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIO,'%Imposto de Imp%')	vlr_II,
	(dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Hio,'%Impos% Prod% Ind%') +  dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Hio,'IPI%')) vlr_IPI,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIO,'%SISC%')			vlr_SISC,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIO,'%PIS%')				vlr_PIS,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIO,'%Cofins%')			vlr_Cofins,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIO,'%ICMS%')			vlr_ICMS,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIO,'%ANTIDUMPING%')		vlr_ANTIDUMPING,
	dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIO,'%AFRMM%')			vlr_AFRMM,
	DI.Data_PO_hio													Dt_Pgto,
	null															Pgto_AFRMM,
	dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,24)							Pgto_ICMS,
	dbo.fBusca_Tarefa(HOU.Num_Proc_HIO,4)							Dt_Desembaraco,
	DST.Nome_Local													Destino
from
	House_IMP_OUT HOU
	Join LLP_IMP_OUT	LLP on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
	Join Pedido_Ship 	PS  on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido		P   on PS.Cd_Pedido = P.Cd_Pedido
	Join Pessoa		CS  on HOU.Cd_Consig_HIO = CS.Cd_Pes	and CS.desat_pes = 'N'
	Join Pessoa		OC  on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
	Join Localidade		LC  on HOU.Cd_Dst_HIO =  LC.Cd_Local
	--Join Custo_Cliente	CU  on HOU.Num_Proc_HIO=CU.Num_Proc
	Left Join PO_hio 	DI  on DI.Num_Proc_hio 	=HOU.Num_Proc_Hio and DI.ID_DC = 5
	Join Pessoa_LLP		PLL on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
	Join Localidade		DST on DST.cd_local=cd_dst_hio
Where
	DI.Data_PO_hio is not null and DI.Numero_PO_HIO not like 'Courier%'
Group by
	convert(datetime,Dt_Emis_HIO,105),
	OC.Nome_Raz_Soc,
	CS.Nome_Raz_Soc,
	LC.Pais_Local,
	HOU.Num_Proc_HIO,
	DI.Data_PO_hio,
	DST.Nome_Local








GO
