SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spSmart_Levis_XML_Rules_REL]--'ALL'
	@ALL as varchar(3)
AS

select distinct
		Hou.num_proc_him	[JOB],
		HOU.HAWB_HIM		[HAWB], 
		HOU.MAWB_HIM		[MAWB], 
		ARM.SCAC			[SCAC],
		DI.NUMERO_PO_HIM	[DI],
		T4.DT_Conclusao	[Custom Clearance],
		T16.DT_Conclusao	[Docs Received],
		DST.SCAC			[SCAC Port Of Entry],
		PO.Numero_PO_HIM	[ISD NUMBER],
		LX.Dt_Envio			[Data do Envio a LEVIS]
	from House_Imp_Mar HOU
		left outer join Smart_Levis_XML	LX	on HOU.Num_Proc_HIM = LX.Num_Proc
		Left Outer Join Job_Imp_Mar	JOB	on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
		Left Outer Join LLP_Imp_Mar	LLP	on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
		Left Outer Join Armador	ARM	on JOB.Cd_Armador	= Arm.Cd_Armador
		Left Outer Join Localidade	DST	on DST.cd_local	= HOU.cd_dst_him
		left Outer Join PO_HIM PO on HOU.Num_Proc_HIM = PO.Num_Proc_HIM and PO.ID_DC = 9
		Left Outer Join PO_HIM	DI	on HOU.Num_Proc_HIM	= DI.Num_Proc_him  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HIM = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T16	on HOU.Num_Proc_HIM = T16.Num_proc and T16.ID_Task = 16		
	where
		--Hou.num_proc_him in ( 'IMLVS201411076BR','IMLVS201412008BR','IMLVS201412004BR','IMLVS201410026BR',
		--'IMLVS201412046BR','IMLVS201412048BR')			  
		substring(Hou.num_proc_him,3,3) = 'LVS'
		and isnull(llp.ID_Status,0) <> 9
		--and HOU.HAWB_HIM is not null	
		--and	HOU.MAWB_HIM is not null
		--and ARM.SCAC is not null			
		--and DI.NUMERO_PO_HIM is not null	
		--and T4.DT_Conclusao	is not null
		--and T16.DT_Conclusao is not null	
		--and DST.SCAC is not null
		
UNION ALL
	select distinct
		Hou.num_proc_hia,
		HOU.HAWB_HIA		[HAWB], 
		HOU.MAWB_HIA		[MAWB], 
		CiaAER.SCAC			[SCAC Carrier],
		DI.NUMERO_PO_HIA	[DI],
		T4.DT_Conclusao	[Custom Clearance],
		T16.DT_Conclusao	[Docs Received],
		DST.IATACODE		[IATACODE Port Of Entry],
		PO.Numero_PO_HIA	[ISD NUMBER],
		LX.Dt_Envio			[Data do Envio a LEVIS]
	from House_Imp_Aer HOU	
		left outer join Smart_Levis_XML	LX	on HOU.Num_Proc_HIA = LX.Num_Proc
		Left Outer Join Job_Imp_AER	JOB	on HOU.Num_Proc_HIa = JOB.Num_Proc_HIa
		Left Outer Join LLP_Imp_aer	LLP	on HOU.Num_Proc_HIa	= LLP.Num_Proc_Lia
		Left Outer Join Cia_Aerea	CiaAER	on JOB.Cd_Cia_Aer	= CiaAER.Cd_Cia_Aer
		Left Outer Join Localidade	DST	on DST.cd_local	= HOU.cd_dst_hia
		left Outer Join PO_HIA PO on HOU.Num_Proc_HIA = PO.Num_Proc_HIA and PO.ID_DC = 9
		Left Outer Join PO_HIA	DI	on HOU.Num_Proc_HIA	= DI.Num_Proc_hia  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HIA = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T16	on HOU.Num_Proc_HIA = T16.Num_proc and T16.ID_Task = 16		
	where
		substring(Hou.num_proc_hia,3,3) = 'LVS'
		and isnull(llp.ID_Status,0) <> 9
		--and HOU.HAWB_HIA is not null
		--and HOU.MAWB_HIA is not null
		--and CiaAER.SCAC is not null
		--and DI.NUMERO_PO_HIA is not null
		--and T4.DT_Conclusao	is not null
		--and T16.DT_Conclusao is not null
		--and DST.IATACODE is not null
		




















GO
