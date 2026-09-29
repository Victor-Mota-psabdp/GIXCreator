SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--alterad pra 31 dias - 1-6-2012 cadu



CREATE      Procedure	[dbo].[spBDP_AccountReconciliation_Rel] --'CSR'
(
@Grupo as varchar(3)
)
As
	declare @Cd_Grupo as varchar(10)
	set @Cd_Grupo = (select Cd_Pes_Grupo from grupo where Grupo = @Grupo)
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
	DST.Nome_Local													Destino,
	dbo.fBusca_TipoDocCliente ('N',hou.num_proc_him,68)				N_Transmissao,
	substring(PLANTA,4,2)											Planta

from 
	House_Imp_MAR HOU
	Join LLP_Imp_MAR	LLP on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Join Pedido_Ship 	PS  With(nolock) on HOU.Num_Proc_HIM = PS.Num_Proc
	Left Join Pedido		P  with(nolock)  on PS.Cd_Pedido = P.Cd_Pedido
	Join Pessoa			CS  with(nolock)  on HOU.Cd_Consig_HIM = CS.Cd_Pes	
	Join Pessoa			OC  with(nolock)  on P.Cd_Buyer = OC.Cd_Pes 
	Join Localidade		LC  with(nolock)  on HOU.Cd_Dst_HIM =  LC.Cd_Local
	Join PO_him 		DI  with(nolock)  on DI.Num_Proc_him 	=HOU.Num_Proc_Him and DI.ID_DC = 5
--	Join Pessoa_LLP		PLL with(nolock)  on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
	Join Pessoa_LLP		PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@Cd_Grupo
	Join Localidade		DST with(nolock)  on DST.cd_local=cd_dst_him
Where
DI.data_PO_him is not null  and DI.numero_po_him not like 'Courier%'
and DI.data_PO_him > getdate()-31
Group By
	HOU.Dt_Emis_HIM,
	OC.Nome_Raz_Soc,
	CS.Nome_Raz_Soc,
	LC.Pais_Local,
	HOU.Num_Proc_HIM,
	DI.data_PO_him,
	DST.Nome_Local,
	substring(PLANTA,4,2)


UNION

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
	DST.Nome_Local													Destino,
	dbo.fBusca_TipoDocCliente ('N',hou.num_proc_hia,68)				N_Transmissao,
	substring(PLANTA,4,2)
from 
	House_Imp_Aer HOU with(nolock) 
	Join LLP_Imp_Aer	LLP with(nolock)  on HOU.Num_Proc_HIA = LLP.Num_Proc_Lia
	Left Join Pedido_Ship 	PS  with(nolock)  on HOU.Num_Proc_HIA = PS.Num_Proc
	Left Join Pedido		P   with(nolock)  on PS.Cd_Pedido = P.Cd_Pedido
	Join Pessoa			CS with(nolock)   on HOU.Cd_Consig_HIA = CS.Cd_Pes and CS.desat_pes = 'N'
	Join Pessoa			OC  with(nolock)  on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
	Join Localidade		LC  with(nolock)  on HOU.Cd_Dst_HIA =  LC.Cd_Local
	Left Join PO_hia 	DI  with(nolock)  on DI.Num_Proc_hia 	=HOU.Num_Proc_Hia and DI.ID_DC = 5
--	Join Pessoa_LLP		PLL on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
	Join Pessoa_LLP		PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIA and PLL.Cd_Pes_Grupo=@Cd_Grupo
	Join Localidade		DST with(nolock)  on DST.cd_local=cd_dst_hia
where
	DI.data_PO_hia is not null and DI.Numero_PO_HIA not like 'Courier%'
and DI.data_PO_hia > getdate()-31
Group by
	HOU.Dt_Emis_HIA,
	OC.Nome_Raz_Soc,
	CS.Nome_Raz_Soc,
	LC.Pais_Local,
	HOU.Num_Proc_HIA,
	DI.data_PO_hia,
	DST.Nome_Local,
	substring(PLANTA,4,2)


UNION


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
	DST.Nome_Local													Destino,
	dbo.fBusca_TipoDocCliente ('N',hou.num_proc_hio,68)				N_Transmissao,
	substring(PLANTA,4,2)

from
	House_IMP_OUT HOU	with(nolock) 
	Join LLP_IMP_OUT	LLP with(nolock)  on HOU.Num_Proc_HIO = LLP.Num_Proc_LIO
	Join Pedido_Ship 	PS  with(nolock)  on HOU.Num_Proc_HIO = PS.Num_Proc
	Join Pedido			P   with(nolock)  on PS.Cd_Pedido = P.Cd_Pedido
	Join Pessoa			CS  with(nolock)  on HOU.Cd_Consig_HIO = CS.Cd_Pes	and CS.desat_pes = 'N'
	Join Pessoa			OC  with(nolock)  on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
	Join Localidade		LC  with(nolock)  on HOU.Cd_Dst_HIO =  LC.Cd_Local
	--Join Custo_Cliente	CU  on HOU.Num_Proc_HIO=CU.Num_Proc
	Left Join PO_hio 	DI  with(nolock)  on DI.Num_Proc_hio 	=HOU.Num_Proc_Hio and DI.ID_DC = 5
--	Join Pessoa_LLP		PLL on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
	Join Pessoa_LLP		PLL with(nolock)  on PLL.Cd_Pes=HOU.Cd_Consig_HIO and PLL.Cd_Pes_Grupo=@Cd_Grupo
	Join Localidade		DST with(nolock)  on DST.cd_local=cd_dst_hio
Where
	DI.Data_PO_hio is not null and DI.Numero_PO_HIO not like 'Courier%'
	and DI.data_PO_hio > getdate()-31
Group by
	convert(datetime,Dt_Emis_HIO,105),
	OC.Nome_Raz_Soc,
	CS.Nome_Raz_Soc,
	LC.Pais_Local,
	HOU.Num_Proc_HIO,
	DI.Data_PO_hio,
	DST.Nome_Local,
	substring(PLANTA,4,2)







GO
