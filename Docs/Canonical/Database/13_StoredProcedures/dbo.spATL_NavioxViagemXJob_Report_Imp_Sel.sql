SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from LLP_Imp_Mar where ID_Viagem is not null
--select * from LLP_exp_Mar where ID_Viagem is not null

CREATE PROCEDURE [dbo].[spATL_NavioxViagemXJob_Report_Imp_Sel]--'PARAMETRO'
(
	@ID		int
)
AS
	select 
		distinct LLP.Num_Proc_Lim		JOB,		
		convert(varchar(10),TP42.Dt_Conclusao,103) [Redestinação],
		TER.Nome_Terminal		[Terminal],
		ATD_lim [ATD],
		Nome_Tp_Carga [Tipo Carga]
	From  
		LLP_Imp_Mar  LLP	with(nolock)	
		Left Outer Join Terminal		TER			with(nolock)	on LLP.Cd_Terminal	= TER.Cd_Terminal	
		Left Outer Join Tarefas_Processos TP42		with(nolock)	on LLP.Num_Proc_LIM = TP42.Num_Proc and TP42.ID_Task = 42 
		Left Join Tipo_carga TP with(nolock) on LLp.Cd_Tp_Carga=tp.Cd_Tp_Carga
	 where 
		LLP.ID_Viagem = @ID
		
	UNION All
	
	select 
		distinct LLP.Num_Proc_Master		JOB,		
		convert(varchar(10),TP42.Dt_Conclusao,103) [Redestinação],	
		TER.Nome_Terminal		[Terminal],
		ATD_Master [ATD],
		Nome_Tp_Carga [Tipo Carga]		
	From  
		Master_Imp_Mar  HOU 	with(nolock)
		Left Outer Join LLP_Master			LLP		with(nolock)	on HOU.Num_Proc_MIM	= LLP.Num_Proc_Master		
		Left Outer Join House_Imp_Mar	JOB		with(nolock)	on HOU.Num_Proc_MIM 	= JOB.Num_Proc_MIM
		Left Outer Join LLP_Imp_Mar		LIM		with(nolock)	on JOB.Num_Proc_HIM	= LIM.Num_Proc_Lim		
		Left Outer Join Terminal		TER	with(nolock)		on LIM.Cd_Terminal	= TER.Cd_Terminal	
		Left Outer Join Tarefas_Processos TP42	with(nolock)	on JOB.Num_Proc_HIM = TP42.Num_Proc and TP42.ID_Task = 42 
		Left Join Tipo_carga TP with(nolock) on LLp.Cd_Tp_Carga=tp.Cd_Tp_Carga
	 where 
		LLP.ID_Viagem = @ID


/*
	select 
		LLP.Num_Proc_Lim		JOB,
		--TC.Nome_Tp_Carga		[Type Of Cargo],
		convert(varchar(10),TP42.Dt_Conclusao,103) [Redestinação],
		TER.Nome_Terminal		[Terminal]
		--HOU.MAWB_HIM			[MBL],
		--HAWB_HIM				[HBL],
		----Ship.Apelido 			Shipper,
		----Consig.Apelido 			Consignee,
		----Import.Apelido 			Notify,	
		--Orig.Nome_Local 		[Port Of Loading],
		--Destin.Nome_Local 		[Port Of Delivery],	
		--ARM.Nome_Armador		Carrier,
		--HOU.Navio_HIM 			Vessel,
		--HOU.Viagem_HIM 			Voyage,
		
		----LLP.ETD_Lim				ETD,
		--LLP.ATD_Lim				ATD,
		--LLP.ETA_Lim				ETA,
		--LLP.ATA_Lim				ATA
		
	From  
		House_Imp_Mar  HOU
		--Left Outer Join Job_Imp_Mar		JOB			on HOU.Num_Proc_HIM 	= JOB.Num_Proc_HIM
		Left Outer Join LLP_Imp_Mar			LLP			on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
		--Left Outer Join Pessoa			Ship		on Cd_Export_HIM 	= Ship.Cd_Pes
		--Left Outer Join Pessoa			Consig		on Cd_Consig_HIM 	= Consig.Cd_Pes 
		--Left Outer Join Pessoa			Import		on Cd_Import_HIM 	= Import.Cd_Pes
		--Left Outer Join Pessoa			CHB			on Cd_Despachante	= CHB.Cd_Pes
		--Left Outer Join Localidade		Orig		on Cd_Org_HIM 		= Orig.Cd_Local 
		--Left Outer Join Localidade		Destin		on Cd_Dst_HIM 		= Destin.Cd_Local 
		--Left Outer Join Localidade		Origin		on Cd_Planta_Lim 	= Origin.Cd_Local
		--Left Outer Join Localidade		DstFinal	on Cd_DstFinal_LIM 	= DstFinal.Cd_Local
		--Left Outer Join Armador			ARM			on JOB.Cd_Armador	= Arm.Cd_Armador
		--Left Outer Join Tipo_Carga		TC			on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
		Left Outer Join Terminal		TER			on LLP.Cd_Terminal	= TER.Cd_Terminal	
		Left Outer Join Tarefas_Processos TP42		on HOU.Num_Proc_HIM = TP42.Num_Proc and TP42.ID_Task = 42 
	 where 
		LLP.ID_Viagem = @ID_Viagem
		
	UNION
	
	select 
		LLP.Num_Proc_Master		JOB,
		--TC.Nome_Tp_Carga		[Type Of Cargo],
		convert(varchar(10),TP42.Dt_Conclusao,103) [Redestinação],	
		TER.Nome_Terminal		[Terminal]
		--HOU.MAWB_MIM			[MBL],
		--NULL					[HBL],
		--Ship.Apelido 			Shipper,
		--Consig.Apelido 			Consignee,
		--Import.Apelido 			Notify,	
		--Orig.Nome_Local 		[Port Of Loading],
		--Destin.Nome_Local 		[Port Of Delivery],	
		--ARM.Nome_Armador		Carrier,
		--Navio_MIM 				Vessel,
		--Viagem_MIM 				Voyage,
		
		----LLP.ETD_Lim				ETD,
		--LLP.ATD_Master				ATD,
		--LLP.ETA_Master				ETA,
		--LLP.ATA_Master				ATA
		
	From  
		Master_Imp_Mar  HOU
		--Left Outer Join Job_Imp_Mar		JOB			on HOU.Num_Proc_HIM 	= JOB.Num_Proc_HIM
		Left Outer Join LLP_Master		LLP			on HOU.Num_Proc_MIM	= LLP.Num_Proc_Master
		
		Left Outer Join House_Imp_Mar		JOB			on HOU.Num_Proc_MIM 	= JOB.Num_Proc_MIM
		Left Outer Join LLP_Imp_Mar			LIM			on JOB.Num_Proc_HIM	= LIM.Num_Proc_Lim
		
		--Left Outer Join Pessoa			Ship		on Cd_Export_MIM 	= Ship.Cd_Pes
		--Left Outer Join Pessoa			Consig		on Cd_Consig_MIM 	= Consig.Cd_Pes 
		--Left Outer Join Pessoa			Import		on Cd_Import_mIM 	= Import.Cd_Pes
		----Left Outer Join Pessoa			CHB			on Cd_Despachante	= CHB.Cd_Pes
		--Left Outer Join Localidade		Orig		on Cd_Org_MIM 		= Orig.Cd_Local 
		--Left Outer Join Localidade		Destin		on Cd_Dst_MIM 		= Destin.Cd_Local 
		--Left Outer Join Localidade		Origin		on Cd_Planta_Lim 	= Origin.Cd_Local
		--Left Outer Join Localidade		DstFinal	on Cd_DstFinal_LIM 	= DstFinal.Cd_Local
		--Left Join Armador			ARM		on HOU.Cd_Armador	collate Latin1_General_CI_AI = ARM.Cd_Armador collate Latin1_General_CI_AI
		--Left Outer Join Tipo_Carga		TC			on LLP.Cd_Tp_Carga	= TC.Cd_Tp_Carga
		Left Outer Join Terminal		TER			on LIM.Cd_Terminal	= TER.Cd_Terminal	
		Left Outer Join Tarefas_Processos TP42		on JOB.Num_Proc_HIM = TP42.Num_Proc and TP42.ID_Task = 42 
	 where 
		LLP.ID_Viagem = @ID_Viagem
*/
GO
