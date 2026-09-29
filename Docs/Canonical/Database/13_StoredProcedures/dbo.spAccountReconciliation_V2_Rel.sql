SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--mudado pra left join o po_him pra trazer todos os casos, mesmo os sem DI

CREATE Procedure	[dbo].[spAccountReconciliation_V2_Rel] --'IMCSR20100660701'
	@Processo varchar(16)
As

IF left(@Processo,2)='IA'
	Begin
		Select 
			datename(MM,DI.data_PO_hia) + ' - ' + convert(char(4),year(DI.data_PO_hia)) Mes_DI,
			convert(datetime,HOU.Dt_Emis_HIA,105)					Register_Date,
			OC.Nome_Raz_Soc											Ordering_Customer,
			CS.Nome_Raz_Soc											Consignee,
			LC.Pais_Local											Country_Destination,
			dbo.fBusca_PO_NumPedido(@Processo,'Num_Pedido')			Order_Number,
			dbo.fBusca_PO_NumPedido(@Processo,'PO')					PO,
			@Processo												Ref_BDP,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%Imposto de Imp%')	vlr_II,
			(dbo.fBusca_CustoProcessoTAB(@Processo,'%Impos% Prod% Ind%') +  dbo.fBusca_CustoProcessoTAB(@Processo,'IPI%')) vlr_IPI,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%SISC%')			vlr_SISC,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%PIS%')			vlr_PIS,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%Cofins%')		vlr_Cofins,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%ICMS%')			vlr_ICMS,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%ANTIDUMPING%')	vlr_ANTIDUMPING,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%AFRMM%')		vlr_AFRMM,
			--dbo.fBusca_CustoCliente(@Processo,'%AFRMM%')			vlr_AFRMM,
			DI.data_PO_hia											Dt_Pgto,
			null													Pgto_AFRMM,
			dbo.fBusca_Tarefa(@Processo,24)							Pgto_ICMS,
			dbo.fBusca_Tarefa(@Processo,4)							Dt_Desembaraco,
			DST.Nome_Local											Destino
		from 
			House_Imp_Aer HOU
			Join LLP_Imp_Aer	LLP on LLP.Num_Proc_Lia = @Processo
			Left Join Pedido_Ship PS on PS.Num_Proc = @Processo
			Left Join Pedido	P   on PS.Cd_Pedido = P.Cd_Pedido
			Join Pessoa			CS  on HOU.Cd_Consig_HIA = CS.Cd_Pes and CS.desat_pes = 'N'
			Join Pessoa			OC  on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
			Join Localidade		LC  on HOU.Cd_Dst_HIA =  LC.Cd_Local
			Left Join PO_hia 	DI  on DI.Num_Proc_hia = @Processo and DI.ID_DC = 5
			Join Pessoa_LLP		PLL on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
			Join Localidade		DST on DST.cd_local=cd_dst_hia
		where
--			DI.data_PO_hia is not null
--			and DI.Numero_PO_HIA not like 'Courier%'and 
			HOU.Num_Proc_HIA = @Processo
		Group by
			HOU.Dt_Emis_HIA,
			OC.Nome_Raz_Soc,
			CS.Nome_Raz_Soc,
			LC.Pais_Local,
			DI.data_PO_hia,
			DST.Nome_Local
	End

ELSE IF left(@Processo,2)='IM'
	Begin
		Select 
			datename(MM,DI.data_PO_him) + ' - ' + convert(char(4),year(DI.data_PO_him)) Mes_DI,
			convert(datetime,HOU.Dt_Emis_HIM,105)						Register_Date,
			OC.Nome_Raz_Soc												Ordering_Customer,
			CS.Nome_Raz_Soc												Consignee,
			LC.Pais_Local												Country_Destination,
			dbo.fBusca_PO_NumPedido(@Processo,'Num_Pedido')				Order_Number,
			dbo.fBusca_PO_NumPedido(@Processo,'PO')						PO,
			@Processo													Ref_BDP,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%Imposto de Imp%')	vlr_II,
			(dbo.fBusca_CustoProcessoTAB(@Processo,'%Impos% Prod% Ind%') +  dbo.fBusca_CustoProcessoTAB(@Processo,'IPI%')) vlr_IPI,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%SISComeX%')			vlr_SISC,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%PIS%')				vlr_PIS,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%Cofins%')			vlr_Cofins,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%ICMS%')				vlr_ICMS,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%DUMPING%')			vlr_ANTIDUMPING,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%AFRMM%')			vlr_AFRMM,
			--dbo.fBusca_CustoCliente(@Processo,'%AFRMM%')				vlr_AFRMM,
			DI.data_PO_him												Dt_Pgto,
			dbo.fBusca_Tarefa(@Processo,25)								Pgto_AFRMM,
			dbo.fBusca_Tarefa(@Processo,24)								Pgto_ICMS,
			dbo.fBusca_Tarefa(@Processo,4)								Dt_Desembaraco,
			DST.Nome_Local												Destino
		from 
			House_Imp_MAR HOU
			Join LLP_Imp_MAR	LLP on LLP.Num_Proc_LIM = @Processo
			Left Join Pedido_Ship PS on PS.Num_Proc = @Processo
			Left Join Pedido	P   on PS.Cd_Pedido = P.Cd_Pedido
			Join Pessoa			CS  on HOU.Cd_Consig_HIM = CS.Cd_Pes	
			Join Pessoa			OC  on P.Cd_Buyer = OC.Cd_Pes 
			Join Localidade		LC  on HOU.Cd_Dst_HIM =  LC.Cd_Local
			left Join PO_him 		DI  on DI.Num_Proc_him 	=@Processo and DI.ID_DC = 5
			Join Pessoa_LLP		PLL on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
			Join Localidade		DST on DST.cd_local=cd_dst_him
		Where
--			DI.data_PO_him is not null
--			and DI.numero_po_him not like 'Courier%' and 
			HOU.Num_Proc_HIM = @Processo
		Group By
			HOU.Dt_Emis_HIM,
			OC.Nome_Raz_Soc,
			CS.Nome_Raz_Soc,
			LC.Pais_Local,
			DI.data_PO_him,
			DST.Nome_Local
	End

ELSE IF left(@Processo,2)='IO'
	Begin
		Select 
			datename(MM,DI.data_PO_hio) + ' - ' + convert(char(4),year(DI.data_PO_hio)) Mes_DI,
			convert(datetime,Dt_Emis_HIO,105)							Register_Date,
			OC.Nome_Raz_Soc												Ordering_Customer,
			CS.Nome_Raz_Soc												Consignee,
			LC.Pais_Local												Country_Destination,
			dbo.fBusca_PO_NumPedido(@Processo,'Num_Pedido')				Order_Number,
			dbo.fBusca_PO_NumPedido(@Processo,'PO')						PO,
			@Processo													Ref_BDP,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%Imposto de Imp%')	vlr_II,
			(dbo.fBusca_CustoProcessoTAB(@Processo,'%Impos% Prod% Ind%') +  dbo.fBusca_CustoProcessoTAB(@Processo,'IPI%')) vlr_IPI,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%SISC%')				vlr_SISC,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%PIS%')				vlr_PIS,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%Cofins%')			vlr_Cofins,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%ICMS%')				vlr_ICMS,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%ANTIDUMPING%')		vlr_ANTIDUMPING,
			dbo.fBusca_CustoProcessoTAB(@Processo,'%AFRMM%')			vlr_AFRMM,
			--dbo.fBusca_CustoCliente(@Processo,'%AFRMM%')				vlr_AFRMM,
			DI.Data_PO_hio												Dt_Pgto,
			null														Pgto_AFRMM,
			dbo.fBusca_Tarefa(@Processo,24)								Pgto_ICMS,
			dbo.fBusca_Tarefa(@Processo,4)								Dt_Desembaraco,
			DST.Nome_Local												Destino
		from
			House_IMP_OUT HOU
			Join LLP_IMP_OUT	LLP on LLP.Num_Proc_LIO = @Processo
			Join Pedido_Ship 	PS  on PS.Num_Proc = @Processo
			Join Pedido			P   on PS.Cd_Pedido = P.Cd_Pedido
			Join Pessoa			CS  on HOU.Cd_Consig_HIO = CS.Cd_Pes and CS.desat_pes = 'N'
			Join Pessoa			OC  on P.Cd_Buyer = OC.Cd_Pes and OC.desat_pes = 'N'
			Join Localidade		LC  on HOU.Cd_Dst_HIO =  LC.Cd_Local
			Left Join PO_hio 	DI  on DI.Num_Proc_hio = @Processo and DI.ID_DC = 5
			Join Pessoa_LLP		PLL on PLL.Cd_Pes=CS.Cd_Pes and PLL.Cd_Pes_Grupo='1'
			Join Localidade		DST on DST.cd_local=cd_dst_hio
		Where
		--	DI.Data_PO_hio is not null
--			and DI.Numero_PO_HIO not like 'Courier%' and 
		HOU.Num_Proc_HIO = @Processo
		Group by
			convert(datetime,Dt_Emis_HIO,105),
			OC.Nome_Raz_Soc,
			CS.Nome_Raz_Soc,
			LC.Pais_Local,
			DI.Data_PO_hio,
			DST.Nome_Local
	End






GO
