SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from LLP_Imp_Mar where ID_Viagem is not null
--select * from LLP_exp_Mar where ID_Viagem is not null

CREATE PROCEDURE [dbo].[spATL_NavioxViagemXJob_Sel]--778,'I'
(
	@ID_Viagem		int,
	@Modal			varchar(1)
)
AS

if @Modal = 'I'
	select 
		LLP.Num_Proc_Lim		JOB,
		TC.Nome_Tp_Carga		[Type Of Cargo],
		TP42.Dt_Conclusao		[Redestinação],	
		TER.Nome_Terminal		[Terminal],
		HOU.MAWB_HIM			[MBL],
		HAWB_HIM				[HBL],
		--Ship.Apelido 			Shipper,
		--Consig.Apelido 			Consignee,
		--Import.Apelido 			Notify,	
		Orig.Nome_Local 		[Port Of Loading],
		Destin.Nome_Local 		[Port Of Delivery],	
		ARM.Nome_Armador		Carrier,
		HOU.Navio_HIM 			Vessel,
		HOU.Viagem_HIM 			Voyage,
		
		--LLP.ETD_Lim				ETD,
		LLP.ATD_Lim				ATD,
		LLP.ETA_Lim				ETA,
		LLP.ATA_Lim				ATA
		
	From  
		House_Imp_Mar  HOU
		Left Outer Join Job_Imp_Mar		JOB			on HOU.Num_Proc_HIM 	= JOB.Num_Proc_HIM
		Left Outer Join LLP_Imp_Mar		LLP			on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
		Left Outer Join Pessoa			Ship		on Cd_Export_HIM 	= Ship.Cd_Pes
		Left Outer Join Pessoa			Consig		on Cd_Consig_HIM 	= Consig.Cd_Pes 
		Left Outer Join Pessoa			Import		on Cd_Import_HIM 	= Import.Cd_Pes
		Left Outer Join Pessoa			CHB			on Cd_Despachante	= CHB.Cd_Pes
		Left Outer Join Localidade		Orig		on Cd_Org_HIM 		= Orig.Cd_Local 
		Left Outer Join Localidade		Destin		on Cd_Dst_HIM 		= Destin.Cd_Local 
		Left Outer Join Localidade		Origin		on Cd_Planta_Lim 	= Origin.Cd_Local
		Left Outer Join Localidade		DstFinal	on Cd_DstFinal_LIM 	= DstFinal.Cd_Local
		Left Outer Join Armador			ARM			on JOB.Cd_Armador	= Arm.Cd_Armador
		Left Outer Join Tipo_Carga		TC			on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
		Left Outer Join Terminal		TER			on LLP.Cd_Terminal	= TER.Cd_Terminal	
		Left Outer Join Tarefas_Processos TP42		on HOU.Num_Proc_HIM = TP42.Num_Proc and TP42.ID_Task = 42 
	 where 
		LLP.ID_Viagem = @ID_Viagem
		
	UNION
	
	select 
		LLP.Num_Proc_Master		JOB,
		TC.Nome_Tp_Carga		[Type Of Cargo],
		NULL					[Redestinação],	
		NULL					[Terminal],
		HOU.MAWB_MIM			[MBL],
		NULL					[HBL],
		--Ship.Apelido 			Shipper,
		--Consig.Apelido 			Consignee,
		--Import.Apelido 			Notify,	
		Orig.Nome_Local 		[Port Of Loading],
		Destin.Nome_Local 		[Port Of Delivery],	
		ARM.Nome_Armador		Carrier,
		Navio_MIM 				Vessel,
		Viagem_MIM 				Voyage,
		
		--LLP.ETD_Lim				ETD,
		LLP.ATD_Master				ATD,
		LLP.ETA_Master				ETA,
		LLP.ATA_Master				ATA
		
	From  
		Master_Imp_Mar  HOU
		--Left Outer Join Job_Imp_Mar		JOB			on HOU.Num_Proc_HIM 	= JOB.Num_Proc_HIM
		Left Outer Join LLP_Master		LLP			on HOU.Num_Proc_MIM	= LLP.Num_Proc_Master
		--Left Outer Join Pessoa			Ship		on Cd_Export_HIM 	= Ship.Cd_Pes
		--Left Outer Join Pessoa			Consig		on Cd_Consig_HIM 	= Consig.Cd_Pes 
		--Left Outer Join Pessoa			Import		on Cd_Import_HIM 	= Import.Cd_Pes
		--Left Outer Join Pessoa			CHB			on Cd_Despachante	= CHB.Cd_Pes
		Left Outer Join Localidade		Orig		on Cd_Org_MIM 		= Orig.Cd_Local 
		Left Outer Join Localidade		Destin		on Cd_Dst_MIM 		= Destin.Cd_Local 
		--Left Outer Join Localidade		Origin		on Cd_Planta_Lim 	= Origin.Cd_Local
		--Left Outer Join Localidade		DstFinal	on Cd_DstFinal_LIM 	= DstFinal.Cd_Local
		Left Join Armador			ARM		on HOU.Cd_Armador	collate Latin1_General_CI_AI = ARM.Cd_Armador collate Latin1_General_CI_AI
		Left Outer Join Tipo_Carga		TC			on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
		--Left Outer Join Terminal		TER			on LLP.Cd_Terminal	= TER.Cd_Terminal	
		--Left Outer Join Tarefas_Processos TP42		on HOU.Num_Proc_HIM = TP42.Num_Proc and TP42.ID_Task = 42 
	 where 
		LLP.ID_Viagem = @ID_Viagem
Else
	select 
		LLP.Num_Proc_Lem		JOB,
		TC.Nome_Tp_Carga		[Type Of Cargo],
		TP42.Dt_Conclusao		[Redestinação],	
		TER.Nome_Terminal		[Terminal],
		HOU.MAWB_HEM			[MBL],
		HAWB_HEM				[HBL],
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		Import.Apelido 			Notify,	
		Orig.Nome_Local 		[Port Of Loading],
		Destin.Nome_Local 		[Port Of Delivery],	
		ARM.Nome_Armador		Carrier,
		Navio_HEM 				Vessel,
		Viagem_HEM 				Voyage,
		
		LLP.ETD_Lem				ETD,
		LLP.ATD_Lem				ATD,
		LLP.ETA_Lem				ETA,
		LLP.ATA_Lem				ATA
		
	From  
		House_Exp_Mar  HOU
		Left Outer Join Job_Exp_Mar		JOB			on HOU.Num_Proc_HEM 	= JOB.Num_Proc_HEM
		Left Outer Join LLP_Exp_Mar		LLP			on HOU.Num_Proc_HEM	= LLP.Num_Proc_Lem
		Left Outer Join Pessoa			Ship		on Cd_Export_HEM 	= Ship.Cd_Pes
		Left Outer Join Pessoa			Consig		on Cd_Consig_HEM 	= Consig.Cd_Pes 
		Left Outer Join Pessoa			Import		on Cd_Notify_HEM 	= Import.Cd_Pes
		--Left Outer Join Pessoa			CHB			on Cd_Despachante	= CHB.Cd_Pes
		Left Outer Join Localidade		Orig		on Cd_Org_HEM 		= Orig.Cd_Local 
		Left Outer Join Localidade		Destin		on Cd_Dst_HEM 		= Destin.Cd_Local 
		Left Outer Join Localidade		Origin		on Cd_Planta_Lem 	= Origin.Cd_Local
		Left Outer Join Localidade		DstFinal	on Cd_DstFinal_Lem 	= DstFinal.Cd_Local
		Left Outer Join Armador			ARM			on LLP.Cd_Armador_Lem	= Arm.Cd_Armador
		Left Outer Join Tipo_Carga		TC			on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
		Left Outer Join Terminal		TER			on LLP.Cd_Terminal	= TER.Cd_Terminal	
		Left Outer Join Tarefas_Processos TP42		on HOU.Num_Proc_HEM = TP42.Num_Proc and TP42.ID_Task = 42 
	 where 
		LLP.ID_Viagem = @ID_Viagem
	
	UNION
	
	select 
		LLP.Num_Proc_Master		JOB,
		TC.Nome_Tp_Carga		[Type Of Cargo],
		NULL						[Redestinação],	
		NULL						[Terminal],
		HOU.MAWB_MEM			[MBL],
		NULL					[HBL],
		Ship.Apelido 			Shipper,
		Consig.Apelido 			Consignee,
		Import.Apelido 			Notify,	
		Orig.Nome_Local 		[Port Of Loading],
		Destin.Nome_Local 		[Port Of Delivery],	
		ARM.Nome_Armador		Carrier,		
		LLP.Navio				Vessel,
		LLP.Num_Viagem			Voyage,
		
		LLP.ETD_Master				ETD,
		LLP.ATD_Master				ATD,
		LLP.ETA_Master				ETA,
		LLP.ATA_Master				ATA
		
	From  
		Master_Exp_Mar  HOU
		--Left Outer Join Job_Imp_Mar		JOB			on HOU.Num_Proc_HIM 	= JOB.Num_Proc_HIM
		Left Outer Join LLP_Master		LLP			on HOU.Num_Proc_MEM	= LLP.Num_Proc_Master
		Left Outer Join Pessoa			Ship		on Cd_Export_MEM 	= Ship.Cd_Pes
		Left Outer Join Pessoa			Consig		on Cd_Consig_MEM	= Consig.Cd_Pes 
		Left Outer Join Pessoa			Import		on Cd_Notify 	= Import.Cd_Pes
		--Left Outer Join Pessoa			CHB			on Cd_Despachante	= CHB.Cd_Pes
		Left Outer Join Localidade		Orig		on Cd_Org_MEM 		= Orig.Cd_Local 
		Left Outer Join Localidade		Destin		on Cd_Dst_MEM 		= Destin.Cd_Local 
		--Left Outer Join Localidade		Origin		on Cd_Planta_Lim 	= Origin.Cd_Local
		--Left Outer Join Localidade		DstFinal	on Cd_DstFinal_LIM 	= DstFinal.Cd_Local
		Left Outer Join Armador			ARM			on LLP.Cd_Carrier	= Arm.Cd_Armador
		Left Outer Join Tipo_Carga		TC			on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
		--Left Outer Join Terminal		TER			on LLP.Cd_Terminal	= TER.Cd_Terminal	
		--Left Outer Join Tarefas_Processos TP42		on HOU.Num_Proc_HIM = TP42.Num_Proc and TP42.ID_Task = 42 
	 where 
		LLP.ID_Viagem = @ID_Viagem
 
  
 
 
 
 
 
 


GO
