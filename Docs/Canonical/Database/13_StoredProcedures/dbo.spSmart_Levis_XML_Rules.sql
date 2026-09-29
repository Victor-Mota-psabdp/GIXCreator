SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spSmart_Levis_XML_Rules 'IMLVS201410044BR'
--select * from levis_log_erro
--select * from Smart_Levis_XML
--select * from Exchange_Levis where Dt_Envio is NULL
CREATE procedure [dbo].[spSmart_Levis_XML_Rules]
	@Num_proc as varchar(16)
AS

	select 
		HOU.HAWB_HIM		[HAWB], 
		HOU.MAWB_HIM		[MAWB], 
		ARM.SCAC			[SCAC],
		DI.NUMERO_PO_HIM	[DI],
		T4.DT_Conclusao	[Custom Clearance],
		T16.DT_Conclusao	[Docs Received],
		DST.SCAC			[SCAC Port Of Entry]
	from House_Imp_Mar HOU
		Left Outer Join Job_Imp_Mar	JOB	on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
		Left Outer Join LLP_Imp_Mar	LLP	on HOU.Num_Proc_HIM	= LLP.Num_Proc_Lim
		Left Outer Join Armador	ARM	on JOB.Cd_Armador	= Arm.Cd_Armador
		Left Outer Join Localidade	DST	on DST.cd_local	= HOU.cd_dst_him
		Left Outer Join PO_HIM	DI	on HOU.Num_Proc_HIM	= DI.Num_Proc_him  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HIM = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T16	on HOU.Num_Proc_HIM = T16.Num_proc and T16.ID_Task = 16		
	where
		Hou.num_proc_him = @Num_proc
		
UNION ALL
	select 
		HOU.HAWB_HIA		[HAWB], 
		HOU.MAWB_HIA		[MAWB], 
		CiaAER.SCAC			[SCAC Carrier],
		DI.NUMERO_PO_HIA	[DI],
		T4.DT_Conclusao	[Custom Clearance],
		T16.DT_Conclusao	[Docs Received],
		DST.IATACODE		[IATACODE Port Of Entry]
	from House_Imp_Aer HOU	
		Left Outer Join Job_Imp_AER	JOB	on HOU.Num_Proc_HIa = JOB.Num_Proc_HIa
		Left Outer Join LLP_Imp_aer	LLP	on HOU.Num_Proc_HIa	= LLP.Num_Proc_Lia
		Left Outer Join Cia_Aerea	CiaAER	on JOB.Cd_Cia_Aer	= CiaAER.Cd_Cia_Aer
		Left Outer Join Localidade	DST	on DST.cd_local	= HOU.cd_dst_hia
		Left Outer Join PO_HIA	DI	on HOU.Num_Proc_HIA	= DI.Num_Proc_hia  and DI.id_dc = 5
		Left Outer Join Tarefas_processos	T4	on HOU.Num_Proc_HIA = T4.Num_proc and T4.ID_Task = 4
		Left Outer Join Tarefas_processos	T16	on HOU.Num_Proc_HIA = T16.Num_proc and T16.ID_Task = 16		
	where
		Hou.num_proc_hia = @Num_proc
		
	
--- Carrier (Armador  / Cia Aerea / Transportadora)





--The following ATL fields are mapped to the 856 that we are sending to Levi:
--Consignee Reference No.  (Note: If 10-digit ISD No. is NOT provided, NISD[Date in MMDDYY] e.g.NISD123114 is to be entered.)
--Carrier SCAC --- Carrier (Armador  / Cia Aerea / Transportadora)
--Port of Entry code --- Porto de Entrada
--CustomsEntryNumber --- Número da DI
--Master BL (or AW) No. --- Numero do MAWB/MBL
--House BL (or AW) No.--- Numero do MAWB/MBL
--DocsRcvdDate --- Data de Recebimento dos Docs.
--CustomsReleaseDate --- Data de Desembaraço
--ReasonCode  (Note: Only required if there are any delays as listed in Reason Code List)




























GO
