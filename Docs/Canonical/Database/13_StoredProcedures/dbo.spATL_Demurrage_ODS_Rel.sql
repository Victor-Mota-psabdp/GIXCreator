SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Taxa_Demurrage_BDP
--select * from Taxa_Demurrage

CREATE PROCEDURE [dbo].[spATL_Demurrage_ODS_Rel]--[spATL_Demurrage_ODS_Rel]'2016-06-01','2016-08-10'
	@DtInicial datetime,
	@DtFinal datetime
AS

Select	
	HOU.Num_Proc_HIM		[BDP REFERENCE],
	HOU.NUM_PROC_MIM		[CONSOLIDATION],
	Consig.Nome_raz_Soc		[CONSIGNEE NAME],
	Consig.Num_CPF_CNPJ		[CNPJ],
	HAWB_HIM				[HBL NUMBER],
	HOU.MAWB_HIM			[MBL NUMBER],
	Upper(ARM.Nome_Armador)	[CARRIER NAME],
	Upper(MARM.Nome_Armador)[MASTER CARRIER NAME],
	Upper(Orig.Nome_Local)	[PORT OF DEPARTURE NAME],
	Upper(Destin.Nome_Local)[PORT OF ARRIVAL NAME],
	Navio_HIM				[VESSEL NAME],
	Viagem_HIM				[VOYAGE FLIGHT NUMBER],
	TC.Nome_Tp_Carga		[CARGO TYPE],
	replace(Num_cont_IM,'-','')	[CONTAINER NUMBER],
	replace(Upper(TCC.Nome_Tp_cont),'-','')	[CONTAINER TYPE DESCRIPTION],
	ATA_LIM					[ATA],
	--Dt_Devol_IM				[CONTAINER EMPTY DELIVERY DATE],
	convert(datetime,Dt_Devol_IM,103)				[CONTAINER EMPTY DELIVERY DATE],
	CONVERT(varchar, datediff(day,(ATA_LIM + (convert(int,CP.campo_dados,10)) - 1),convert(datetime,Dt_Devol_IM,103))) + ' dias' [DAYS],
	--convert(varchar(10),datediff(day,ATA_LIM,convert(datetime,Dt_Vcto_Devol_IM,103))) + ' dias' [DAYS],
	CP.Campo_Dados  + ' dias' [FREE TIME],
	--dateadd(day,[FREE TIME],ATA_LIM) [FREE TIME EXPIRATION ESTIMATED DATE],
	ATA_LIM + (convert(int,CP.campo_dados,10)) - 1			[FREE TIME EXPIRATION ESTIMATED DATE]
	--ATA_LIM + 10			[FREE TIME EXPIRATION ESTIMATED DATE]
From  
	House_Imp_Mar  HOU with(nolock)
	Left Outer Join Job_Imp_Mar				JOB		with(nolock) on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
	Left Outer Join LLP_Imp_Mar				LLP		with(nolock) on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
	Left Outer Join master_imp_mar			MIM		with(nolock) on MIM.Num_Proc_MIM = HOU.Num_Proc_MIM
	Left Outer Join LLP_master				LLM		with(nolock) on LLM.Num_Proc_master = HOU.Num_Proc_MIM
	Left Outer Join Armador					MARM	with(nolock) on MARM.Cd_Armador	= MIM.Cd_Armador	
	Left Outer Join Pessoa					Consig	with(nolock) on Cd_Consig_HIM 	= Consig.Cd_Pes 
	Left Outer Join Localidade				Orig	with(nolock) on Cd_Org_HIM 		= Orig.Cd_Local
	Left Outer Join Pais					POrig	with(nolock) on POrig.Cd_pais 	= Orig.Cd_pais
	Left Outer Join Localidade				Destin	with(nolock) on Cd_Dst_HIM 		= Destin.Cd_Local 
	Left Outer Join Armador					ARM		with(nolock) on JOB.Cd_Armador	= Arm.Cd_Armador
	Left Outer Join Tipo_Carga				TC		with(nolock) on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
	Left Outer Join Container_Hou_Imp_Mar	CC		with(nolock) on CC.Num_Proc_HIM	= HOU.Num_Proc_HIM
	Left Outer Join	container_mas_imp_mar	MAS		with(nolock) on MAS.Num_Proc_MIM = CC.Num_Proc_MIM and MAS.Item_Cont_IM = CC.Item_Cont_IM  
	Left Outer Join Tipo_Container			TCC		with(nolock) on TCC.cd_tp_cont	= MAS.cd_tp_cont
	Left Outer Join campo_processo			CP		with(nolock) on	HOU.Num_Proc_HIM = CP.Num_Proc and Id_Campo = '138'
Where
	LLP.ATA_LIM between @DtInicial and @DtFinal and	
	Tipo = 'B'
	and LLP.Cd_Tp_Carga = 1
	--and HOU.num_proc_him = 'IMATL201606024BR'
	
	--order by 1


















/*Select	
	HOU.Num_Proc_HIM		[BDP REFERENCE NUMBER],
	HAWB_HIM				[BOL AWB NUMBER],
	Navio_HIM				[VESSEL NAME],
	Viagem_HIM				[VOYAGE FLIGHT NUMBER],	
	HOU.MAWB_HIM			[MASTER BOL AWB NUMBER],
	Consig.Num_CPF_CNPJ		[CONSIGNEE GOVERNMENT IDENTIFIER],
	Consig.Nome_raz_Soc		[CONSIGNEE NAME],
	Upper(ARM.Nome_Armador)		[CARRIER NAME],	
	--Dt_Vcto_Devol_IM		[CONTAINER EMPTY DELIVERY DATE],
	Dt_Devol_IM				[CONTAINER EMPTY DELIVERY DATE],
	ATA_LIM + 10			[FREE TIME EXPIRATION ESTIMATED DATE],
	--ATA_LIM + TDE.Dias		[FREE TIME EXPIRATION ESTIMATED DATE],
	ATA_LIM					[PORT OF ARRIVAL ACTUAL DATE],
	convert(varchar(10),datediff(day,ATA_LIM,convert(datetime,Dt_Vcto_Devol_IM,103))) + ' dias' [DAYS],
	HOU.NUM_PROC_MIM		[TRANSPORT CONSOLIDATION NUMBER],	
	--convert(varchar(10),datediff(day,ATA_LIM,convert(datetime,Dt_Devol_IM,103))) + ' dias' [FREE TIME],	
	convert(varchar(10),[dbo].[fBusca_CampoCliente](HOU.num_proc_him,138))  + ' dias' [FREE TIME],	
	--Convert(varchar(10),TDE.Dias)  + ' dias' [FREE TIME],	 
	POrig.Nome_Pais			[ORIGIN COUNTRY NAME],
	replace(Num_cont_IM,'-','')	[CONTAINER NUMBER],
	--TCC.cd_CC_ofc			[CONTAINER SIZE CODE],
	TCC.cd_tp_cont			[CONTAINER SIZE CODE],
	replace(Upper(TCC.Nome_Tp_cont),'-','')	[CONTAINER TYPE DESCRIPTION],
	Upper(MARM.Nome_Armador)		[MASTER CARRIER NAME],
	Upper(Orig.Nome_Local)			[PORT OF DEPARTURE NAME],
	Upper(Destin.Nome_Local)		[PORT OF ARRIVAL NAME],
	ATD_LIM					[PORT OF DEPARTURE ACTUAL DATE],
	TC.Nome_Tp_Carga		[CARGO TYPE],	
	[dbo].[fBusca_CaixaTaxaVlr](HOU.num_proc_him,'Garantia de Demurrage%','C') [Recebimento Da Garantia HOUSE],
	[dbo].[fBusca_CaixaMASTaxaVlr](HOU.num_proc_mim,'Garantia de Demurrage%','C') [Recebimento Da Garantia Master]	
From  
	House_Imp_Mar  HOU
	Left Outer Join Job_Imp_Mar				JOB			on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
	Left Outer Join LLP_Imp_Mar				LLP			on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
	Left Outer Join master_imp_mar			MIM			on MIM.Num_Proc_MIM = HOU.Num_Proc_MIM
	Left Outer Join LLP_master				LLM			on LLM.Num_Proc_master = HOU.Num_Proc_MIM
	Left Outer Join Armador					MARM		on MARM.Cd_Armador	= MIM.Cd_Armador	
	Left Outer Join Pessoa					Consig		on Cd_Consig_HIM 	= Consig.Cd_Pes 
	Left Outer Join Localidade				Orig		on Cd_Org_HIM 		= Orig.Cd_Local
	Left Outer Join Pais					POrig		on POrig.Cd_pais 	= Orig.Cd_pais
	Left Outer Join Localidade				Destin		on Cd_Dst_HIM 		= Destin.Cd_Local 
	Left Outer Join Armador					ARM			on JOB.Cd_Armador	= Arm.Cd_Armador
	Left Outer Join Tipo_Carga				TC			on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
	Left Outer Join Container_Hou_Imp_Mar	CC			on CC.Num_Proc_HIM	= HOU.Num_Proc_HIM
	Left Outer Join	container_mas_imp_mar	MAS			on MAS.Num_Proc_MIM = CC.Num_Proc_MIM and MAS.Item_Cont_IM = CC.Item_Cont_IM  
	Left Outer Join Tipo_Container			TCC			on TCC.cd_tp_cont	= MAS.cd_tp_cont
	--Left Outer Join Taxa_Demurrage_BDP		TDE			on TDE.cd_tp_cont	= MAS.cd_tp_cont and TDE.Periodo = 0		
Where
	LLP.ATA_LIM between @DtInicial and @DtFinal and	
	Tipo = 'B'
	and LLP.Cd_Tp_Carga = 1
	--and HOU.num_proc_him = 'IMAET201303002BR'
	
	order by 1*/




GO
