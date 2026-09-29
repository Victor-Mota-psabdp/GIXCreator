SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwBDP_XML_OUT_ClienteALLJOBS]
AS
	SELECT	HOU.Dt_emis_hem Dt_Criacao, HOU.Num_Proc_HEM AS num_proc, HOU.Cd_Export_HEM AS cd_cliente, 
			HOU.Cd_Consig_HEM AS cd_fornecedor,LLP.ETD_Lem DATA, HOU.Num_proc_mem Master, LLP.ETA_Lem ETA, 
			LLP.ATD_Lem ATD,LLP.ATA_Lem ATA,HOU.Cd_Org_HEM Cd_local,LLP.ID_Status,HOU.Cd_Tp_Oper,
			JOB.Cd_Usuario Cd_Usuario,LLP.Cd_DstFinal_Lem Cd_DstFinal,LLP.Vlr_Invoice,LLP.Cd_Moeda_Invoice
			,HOU.Peso_Liquido_HEM Peso_Liquido
	FROM dbo.House_Exp_Mar HOU WITH (nolock) 
		JOIN LLP_Exp_mar LLP WITH (nolock)  ON llp.num_proc_lem = num_proc_hem
		JOIN Job_Exp_Mar JOB	WITH (nolock)  ON job.Num_Proc_HEM=HOU.Num_Proc_HEM
		
UNION ALL

	SELECT	HOU.Dt_emis_heo Dt_Criacao, HOU.Num_Proc_HEO AS num_proc,HOU.Cd_Export_HEO, 
			HOU.Cd_Consig_HEO, LLP.ETD_LEO DATA, 'JOB' Master,LLP.ETA_Leo ETA, 
			LLP.ATD_Leo ATD,LLP.ATA_Leo ATA,HOU.Cd_Org_HEO Cd_local,LLP.ID_Status,HOU.Cd_Tp_Oper,
			LLP.Cd_Usuario cd_usuario,LLP.Cd_DstFinal_Leo Cd_DstFinal,LLP.Vlr_Invoice,LLP.Cd_Moeda_Invoice
			,HOU.Peso_Real_HEO Peso_Liquido
	FROM dbo.House_Exp_Out HOU WITH (nolock) 
		JOIN LLP_Exp_out LLP WITH (nolock)  ON llp.num_proc_leo = num_proc_heo
		
UNION ALL

	SELECT	HOU.Dt_emis_hea Dt_Criacao, HOU.Num_Proc_HEA AS num_proc, HOU.Cd_Export_HEA,
			HOU.Cd_Consig_HEA,LLP.ETD_LEA DATA,HOU.Num_proc_meA Master,LLP.ETA_Lea ETA, 
			LLP.ATD_Lea ATD,LLP.ATA_Lea ATA,HOU.Cd_Org_HEA Cd_local,LLP.ID_Status,HOU.Cd_Tp_Oper,
			JOB.Cd_Usuario Cd_Usuario,LLP.Cd_DstFinal_Lea Cd_DstFinal,LLP.Vlr_Invoice,LLP.Cd_Moeda_Invoice
			,HOU.Peso_Real_HEA Peso_Liquido
	FROM dbo.House_Exp_Aer HOU WITH (nolock) 
		jOIN LLP_Exp_aer LLP ON llp.num_proc_lea = num_proc_hea
		JOIN Job_Exp_Aer JOB	WITH (nolock) ON job.Num_Proc_HEA = HOU.Num_Proc_HEA
						  
UNION ALL

	SELECT	HOU.Dt_emis_him Dt_Criacao, HOU.Num_Proc_HIM AS num_proc, HOU.Cd_Consig_HIM,
			HOU.Cd_Export_HIM, LLP.eta_LIM DATA, HOU.Num_proc_mIM Master,LLP.ETA_Lim ETA, 
			LLP.ATD_Lim ATD,LLP.ATA_Lim ATA,HOU.Cd_Dst_HIM Cd_local,LLP.ID_Status,HOU.Cd_Tp_Oper,
			JOB.Cd_Usuario Cd_Usuario,LLP.Cd_DstFinal_Lim Cd_DstFinal,LLP.Vlr_Invoice,LLP.Cd_Moeda_Invoice
			,HOU.Peso_Liquido_HIM Peso_Liquido
	FROM dbo.House_Imp_Mar HOU WITH (nolock) 
		JOIN LLP_Imp_MAr LLP WITH (nolock)  ON llp.num_proc_lim = num_proc_him
		JOIN Job_Imp_Mar JOB	WITH (nolock) ON job.Num_Proc_HIM = HOU.Num_Proc_HIM		
		
UNION ALL

	SELECT	HOU.Dt_emis_hia Dt_Criacao,HOU.Num_Proc_HIA AS num_proc, HOU.Cd_Consig_HIA,
			HOU.Cd_Export_HIA, LLP.eta_lia DATA, HOU.Num_proc_mIA Master,LLP.ETA_Lia ETA,
			LLP.ATD_Lia ATD,LLP.ATA_LIA ATA,HOU.Cd_Dst_HIA Cd_local,LLP.ID_Status,HOU.Cd_Tp_Oper,
			JOB.Cd_Usuario Cd_Usuario,LLP.Cd_DstFinal_LIA Cd_DstFinal,LLP.Vlr_Invoice,LLP.Cd_Moeda_Invoice
			,HOU.Peso_Real_HIA Peso_Liquido
	FROM dbo.House_Imp_Aer HOU WITH (nolock) 
		JOIN LLP_Imp_Aer LLP WITH (nolock)  ON llp.num_proc_lia = num_proc_hia
		JOIN Job_Imp_Aer JOB	WITH (nolock) ON job.Num_Proc_HIA = HOU.Num_Proc_HIA
		
UNION ALL

	SELECT	HOU.Dt_emis_hio Dt_Criacao, HOU.Num_Proc_HIO AS num_proc, HOU.Cd_Consig_HIO, 
			HOU.Cd_Export_HIO, LLP.eta_LIO DATA, 'JOB' Master,LLP.ETA_Lio ETA, 
			LLP.ATD_Lio ATD,LLP.ATA_Lio ATA,HOU.Cd_Dst_HIO Cd_local,LLP.ID_Status,HOU.Cd_Tp_Oper,
			LLP.Cd_Usuario cd_usuario,LLP.Cd_DstFinal_Lio Cd_DstFinal,LLP.Vlr_Invoice,LLP.Cd_Moeda_Invoice
			,HOU.Peso_Real_HIO Peso_Liquido
	FROM dbo.House_Imp_Out HOU WITH (nolock)
		JOIN LLP_imp_out LLP WITH (nolock)  ON llp.num_proc_lio = num_proc_hio





GO
