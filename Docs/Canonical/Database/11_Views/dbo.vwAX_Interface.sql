SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwAX_Interface]
AS
SELECT     HOU.Dt_emis_hem Dt_Criacao, HOU.Num_Proc_HEM AS num_proc, HOU.Cd_Export_HEM AS cd_cliente, LLP.ETD_Lem DATA, Num_proc_mem Master
			,LLP.ETD_Lem ETD, ETA_Lem ETA, ATD_Lem ATD, ATA_Lem ATA, Cd_Org_HEM cd_org, Cd_Dst_HEM cd_dst,JOB.Cd_Usuario cd_usuario
			,LLP.Cd_Tp_Carga Cd_Tp_Carga, Hou.HAWB_HEM HAWB, HOU.MAWB_HEM MAWB, HOU.Obs_HEM OBS
FROM         dbo.House_Exp_Mar HOU		WITH (nolock) 
				JOIN LLP_Exp_mar LLP	WITH (nolock)  ON llp.num_proc_lem = HOU.Num_Proc_HEM
                JOIN Job_Exp_Mar JOB	WITH (nolock)  ON job.Num_Proc_HEM=HOU.Num_Proc_HEM
                
UNION ALL


SELECT     Dt_emis_heo Dt_Criacao, HOU.Num_Proc_HEO AS num_proc, Cd_Export_HEO, ETD_LEO DATA, 'JOB' Master
			,LLP.ETD_Leo ETD, ETA_Leo ETA, ATD_Leo ATD, ATA_Leo ATA, Cd_Org_HEo cd_org, Cd_Dst_HEO cd_dst,LLP.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , Hou.HAWB_HEO HAWB, HOU.MAWB_HEO MAWB, HOU.Obs_HEO OBS
FROM         dbo.House_Exp_Out	HOU		WITH (nolock) 
				JOIN LLP_Exp_out LLP	WITH (nolock) ON llp.num_proc_leo = HOU.Num_Proc_HEO
				
UNION ALL

SELECT     Dt_emis_hea Dt_Criacao, HOU.Num_Proc_HEA AS num_proc, Cd_Export_HEA, ETD_LEA DATA, Num_proc_meA Master
			,LLP.ETD_Lea ETD,ETA_Lea ETA, ATD_Lea ATD, ATA_Lea ATA, Cd_Org_HEa cd_org, Cd_Dst_HEa cd_dst,JOB.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , Hou.HAWB_HEA HAWB, HOU.MAWB_HEA MAWB, HOU.Obs_HEA OBS
FROM         dbo.House_Exp_Aer	HOU		WITH (nolock) 
				JOIN LLP_Exp_aer LLP	WITH (nolock) ON llp.num_proc_lea = HOU.Num_Proc_HEA
				JOIN Job_Exp_Aer JOB	WITH (nolock) ON job.Num_Proc_HEA = HOU.Num_Proc_HEA
				
UNION ALL

SELECT     Dt_emis_him Dt_Criacao, HOU.Num_Proc_HIM AS num_proc, Cd_Consig_HIM, eta_LIM DATA, Num_proc_mIM Master
			,LLP.ETD_Lim ETD,ETA_Lim ETA, ATD_Lim ATD, ATA_Lim ATA, Cd_Org_Him cd_org, Cd_Dst_Him cd_dst,JOB.Cd_Usuario cd_usuario
			,LLP.Cd_Tp_Carga Cd_Tp_Carga , Hou.HAWB_HIM HAWB, HOU.MAWB_HIM MAWB, HOU.Obs_HIM OBS
FROM         dbo.House_Imp_Mar HOU		WITH (nolock) 
				JOIN LLP_Imp_MAr LLP	WITH (nolock) ON llp.num_proc_lim = HOU.Num_Proc_HIM
				JOIN Job_Imp_Mar JOB	WITH (nolock) ON job.Num_Proc_HIM = HOU.Num_Proc_HIM
UNION ALL

SELECT     Dt_emis_hia Dt_Criacao, HOU.Num_Proc_HIA AS num_proc, Cd_Consig_HIA, eta_lia DATA, Num_proc_mIA Master
			,LLP.ETD_LIA ETD,ETA_Lia ETA, ATD_Lia ATD, ATA_Lia ATA, Cd_Org_Hia cd_org, Cd_Dst_Hia cd_dst,JOB.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , Hou.HAWB_HIA HAWB, HOU.MAWB_HIA MAWB, HOU.Obs_HIA OBS
FROM         dbo.House_Imp_Aer HOU		WITH (nolock) 
				JOIN LLP_Imp_Aer LLP	WITH (nolock) ON llp.num_proc_lia = HOU.Num_Proc_HIA
				JOIN Job_Imp_Aer JOB	WITH (nolock) ON job.Num_Proc_HIA = HOU.Num_Proc_HIA
UNION ALL

SELECT     Dt_emis_hio Dt_Criacao, HOU.Num_Proc_HIO AS num_proc, Cd_Consig_HIO, eta_LIO DATA, 'JOB' Master
			,LLP.ETD_Lio ETD,ETA_Lio ETA, ATD_Lio ATD, ATA_Lio ATA, Cd_Org_Hio cd_org, Cd_Dst_Hio cd_dst,LLP.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , Hou.HAWB_HIO HAWB, HOU.MAWB_HIO MAWB, HOU.Obs_HIO OBS
FROM         dbo.House_Imp_Out HOU		WITH (nolock) 
				JOIN LLP_imp_out LLP	WITH (nolock) ON llp.num_proc_lio = HOU.Num_Proc_HIO
				
				
UNION ALL

SELECT    Dt_Emis_HBO Dt_Criacao, HOU.Num_Proc_HBO AS num_proc, cd_cliente_hbo, NULL DATA, 'JOB' Master
			,NULL ETD,NULL ETA, NULL ATD, NULL ATA, NULL cd_org, NULL cd_dst,LLP.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , NULL HAWB	,NULL MAWB,HOU.Descr_Serv_HBO OBS
FROM         dbo.House_BDP_OUT HOU WITH (nolock)
				JOIN LLP_BDP_OUT LLP WITH (nolock)  ON llp.Num_Proc_LBO = Num_Proc_HBO
				






GO
