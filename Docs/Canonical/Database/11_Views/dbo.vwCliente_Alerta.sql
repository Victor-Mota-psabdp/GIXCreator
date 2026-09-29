SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCliente_Alerta]
AS
	SELECT HOU.Dt_emis_hem Dt_Criacao, HOU.Num_Proc_HEM AS num_proc, HOU.Cd_Export_HEM AS cd_cliente, 
	LLP.ETD_Lem DATA, HOU.Num_Proc_MEM Master,LLP.ETD_Lem ETD,LLP.ETA_Lem ETA, LLP.ATD_Lem ATD, LLP.ATA_Lem ATA, Cd_Org_HEM cd_org,
	Cd_Dst_HEM cd_dst,JOB.Cd_Usuario cd_usuario,LLP.Cd_Tp_Carga Cd_Tp_Carga,Mas.Cd_Consig_MEM AS cd_Cliente_Master, LLP.Cd_Transportadora
	,Hou.HAWB_HEM HAWB, HOU.MAWB_HEM MAWB,LLP.Cd_Terminal,Peso_Liquido_HEM Peso_Liquido,

	HOU.Cd_Consig_HEM	[Cd_Fornecedor],
	LLP.Cd_Armador_Lem		[Cd_Armador], 
	JOB.Cd_Agente

	FROM dbo.House_Exp_Mar HOU	WITH (nolock) 
	JOIN LLP_Exp_mar LLP	WITH (nolock)  ON llp.num_proc_lem = HOU.Num_Proc_HEM
	JOIN Job_Exp_Mar JOB	WITH (nolock)  ON job.Num_Proc_HEM=HOU.Num_Proc_HEM
	left Join Master_Exp_Mar MAS WITH (nolock)  ON MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
                
UNION ALL

	SELECT Dt_emis_heo Dt_Criacao, HOU.Num_Proc_HEO AS num_proc, Cd_Export_HEO AS cd_cliente, 
	ETD_LEO DATA, 'JOB' Master,LLP.ETD_Leo ETD,ETA_Leo ETA, ATD_Leo ATD, ATA_Leo ATA, Cd_Org_HEo cd_org, 
	Cd_Dst_HEO cd_dst,LLP.Cd_Usuario cd_usuario,0 Cd_Tp_Carga ,NULL AS cd_Cliente_Master, LLP.Cd_Transportadora
	,Hou.HAWB_HEO HAWB, HOU.MAWB_HEO MAWB,LLP.Cd_Terminal,HOU.Peso_Real_HEO Peso_Liquido,

	HOU.Cd_Consig_HEO	[Cd_Fornecedor],
	LLP.Cd_Carrier		[Cd_Armador],
	LLP.Cd_Agente 
	

	FROM dbo.House_Exp_Out	HOU	WITH (nolock) 
	JOIN LLP_Exp_out LLP	WITH (nolock) ON llp.num_proc_leo = HOU.Num_Proc_HEO				
				
UNION ALL

	SELECT Dt_emis_hea Dt_Criacao, HOU.Num_Proc_HEA AS num_proc, Cd_Export_HEA AS cd_cliente, 
	ETD_LEA DATA, HOU.Num_Proc_MEA Master,LLP.ETD_Lea ETD,ETA_Lea ETA, ATD_Lea ATD, ATA_Lea ATA, Cd_Org_HEa cd_org,
	Cd_Dst_HEa cd_dst,JOB.Cd_Usuario cd_usuario,0 Cd_Tp_Carga,Mas.Cd_Consig_MEA AS cd_Cliente_Master, LLP.Cd_Transportadora
	,Hou.HAWB_HEA HAWB, HOU.MAWB_HEA MAWB,LLP.Cd_Terminal,HOU.Peso_Real_HEA Peso_Liquido,

	HOU.Cd_Consig_HEA	[Cd_Fornecedor],
	LLP.Cd_CiaAerea_Lea		[Cd_Armador], 
	JOB.Cd_Agente 

	FROM dbo.House_Exp_Aer	HOU	WITH (nolock) 
	JOIN LLP_Exp_aer LLP WITH (nolock) ON llp.num_proc_lea = HOU.Num_Proc_HEA
	JOIN Job_Exp_Aer JOB WITH (nolock) ON job.Num_Proc_HEA = HOU.Num_Proc_HEA
	left Join Master_Exp_Aer MAS WITH (nolock)  ON MAS.Num_Proc_MEA = HOU.Num_Proc_MEA
				
UNION ALL

	SELECT Dt_emis_him Dt_Criacao, HOU.Num_Proc_HIM AS num_proc, Cd_Consig_HIM AS cd_cliente,
	eta_LIM DATA, HOU.Num_Proc_MIM Master,LLP.ETD_Lim ETD,ETA_Lim ETA, ATD_Lim ATD, ATA_Lim ATA, Cd_Org_Him cd_org,
	Cd_Dst_Him cd_dst,JOB.Cd_Usuario cd_usuario,LLP.Cd_Tp_Carga Cd_Tp_Carga,MAS.Cd_Export_MIM  AS cd_Cliente_Master, LLP.Cd_Transportadora
	,Hou.HAWB_HIM HAWB, HOU.MAWB_HIM MAWB,LLP.Cd_Terminal,HOU.Peso_Liquido_HIM Peso_Liquido,

	HOU.Cd_Export_HIM 	[Cd_Fornecedor],
	JOB.Cd_Armador[Cd_Armador], 
	JOB.Cd_Agente

	FROM dbo.House_Imp_Mar HOU	WITH (nolock) 
	JOIN LLP_Imp_MAr LLP WITH (nolock) ON llp.num_proc_lim = HOU.Num_Proc_HIM
	JOIN Job_Imp_Mar JOB WITH (nolock) ON job.Num_Proc_HIM = HOU.Num_Proc_HIM
	left Join Master_Imp_Mar MAS WITH (nolock)  ON MAS.Num_Proc_MIM = HOU.Num_Proc_MIM

UNION ALL

	SELECT Dt_emis_hia Dt_Criacao, HOU.Num_Proc_HIA AS num_proc, Cd_Consig_HIA AS cd_cliente,
	ETA_LIA DATA, HOU.Num_Proc_MIA Master,LLP.ETD_LIA ETD,ETA_Lia ETA, ATD_Lia ATD, ATA_Lia ATA, Cd_Org_Hia cd_org,
	Cd_Dst_Hia cd_dst,JOB.Cd_Usuario cd_usuario,0 Cd_Tp_Carga,MAS.Cd_Export_MIA AS cd_Cliente_Master, LLP.Cd_Transportadora
	,Hou.HAWB_HIA HAWB, HOU.MAWB_HIA MAWB,LLP.Cd_Terminal,HOU.Peso_Real_HIA Peso_Liquido,

	HOU.Cd_Export_HIA 	[Cd_Fornecedor],
	JOB.Cd_Cia_Aer		[Cd_Armador], 
	JOB.Cd_Agente
	FROM dbo.House_Imp_Aer HOU	WITH (nolock) 
	JOIN LLP_Imp_Aer LLP WITH (nolock) ON llp.num_proc_lia = HOU.Num_Proc_HIA
	JOIN Job_Imp_Aer JOB WITH (nolock) ON job.Num_Proc_HIA = HOU.Num_Proc_HIA
	left Join Master_Imp_Aer MAS WITH (nolock)  ON MAS.Num_Proc_Mia = HOU.Num_Proc_MIA

UNION ALL

	SELECT Dt_emis_hio Dt_Criacao, HOU.Num_Proc_HIO AS num_proc, Cd_Consig_HIO AS cd_cliente, 
	ETA_Lio DATA, 'JOB' Master,LLP.ETD_Lio ETD,ETA_Lio ETA, ATD_Lio ATD, ATA_Lio ATA, Cd_Org_Hio cd_org,
	Cd_Dst_Hio cd_dst,LLP.Cd_Usuario cd_usuario,0 Cd_Tp_Carga,NULL AS cd_Cliente_Master, LLP.Cd_Transportadora
	, Hou.HAWB_HIO HAWB, HOU.MAWB_HIO MAWB,LLP.Cd_Terminal,HOU.Peso_Real_HIO Peso_Liquido

	,HOU.Cd_Export_HIO 	[Cd_Fornecedor],
	LLP.Cd_Carrier		[Cd_Armador],
	LLP.Cd_Agente 

	FROM dbo.House_Imp_Out HOU	WITH (nolock) 
	JOIN LLP_imp_out LLP WITH (nolock) ON llp.num_proc_lio = HOU.Num_Proc_HIO
				
UNION ALL

	SELECT Dt_Emis_HBO Dt_Criacao, HOU.Num_Proc_HBO AS num_proc, cd_cliente_hbo,
	NULL DATA, 'JOB' Master
	,NULL ETD,NULL ETA, NULL ATD, NULL ATA, NULL cd_org, NULL cd_dst,LLP.Cd_Usuario cd_usuario
	,0 Cd_Tp_Carga ,NULL AS cd_Cliente_Master, NULL as Cd_Transportadora,
	NULL HAWB	,NULL MAWB,NULL AS Cd_Terminal,0 Peso_Liquido

	,NULL AS cd_fornecedor
	,NULL AS Cd_Armador
	,NULL AS Cd_Agente 

	FROM dbo.House_BDP_OUT HOU WITH (nolock)
	JOIN LLP_BDP_OUT LLP WITH (nolock)  ON llp.Num_Proc_LBO = Num_Proc_HBO
				









--ALTER VIEW [dbo].[vwCliente_Alerta]
--AS
--SELECT HOU.Dt_emis_hem Dt_Criacao, HOU.Num_Proc_HEM AS num_proc, HOU.Cd_Export_HEM AS cd_cliente, 
--LLP.ETD_Lem DATA, HOU.Num_Proc_MEM Master,LLP.ETD_Lem ETD,LLP.ETA_Lem ETA, LLP.ATD_Lem ATD, LLP.ATA_Lem ATA, Cd_Org_HEM cd_org,
--Cd_Dst_HEM cd_dst,JOB.Cd_Usuario cd_usuario,LLP.Cd_Tp_Carga Cd_Tp_Carga,Mas.Cd_Consig_MEM AS cd_Cliente_Master, LLP.Cd_Transportadora
--,Hou.HAWB_HEM HAWB, HOU.MAWB_HEM MAWB,LLP.Cd_Terminal,HOU.Cd_Consig_HEM AS cd_fornecedor
--,Peso_Liquido_HEM Peso_Liquido
--FROM dbo.House_Exp_Mar HOU	WITH (nolock) 
--JOIN LLP_Exp_mar LLP	WITH (nolock)  ON llp.num_proc_lem = HOU.Num_Proc_HEM
--JOIN Job_Exp_Mar JOB	WITH (nolock)  ON job.Num_Proc_HEM=HOU.Num_Proc_HEM
--left Join Master_Exp_Mar MAS WITH (nolock)  ON MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
                
--UNION ALL

--SELECT Dt_emis_heo Dt_Criacao, HOU.Num_Proc_HEO AS num_proc, Cd_Export_HEO AS cd_cliente, 
--ETD_LEO DATA, 'JOB' Master,LLP.ETD_Leo ETD,ETA_Leo ETA, ATD_Leo ATD, ATA_Leo ATA, Cd_Org_HEo cd_org, 
--Cd_Dst_HEO cd_dst,LLP.Cd_Usuario cd_usuario,0 Cd_Tp_Carga ,NULL AS cd_Cliente_Master, LLP.Cd_Transportadora
--,Hou.HAWB_HEO HAWB, HOU.MAWB_HEO MAWB,LLP.Cd_Terminal,HOU.Cd_Consig_HEO AS cd_fornecedor
--,HOU.Peso_Real_HEO Peso_Liquido
--FROM dbo.House_Exp_Out	HOU	WITH (nolock) 
--JOIN LLP_Exp_out LLP	WITH (nolock) ON llp.num_proc_leo = HOU.Num_Proc_HEO				
				
--UNION ALL

--SELECT Dt_emis_hea Dt_Criacao, HOU.Num_Proc_HEA AS num_proc, Cd_Export_HEA AS cd_cliente, 
--ETD_LEA DATA, HOU.Num_Proc_MEA Master,LLP.ETD_Lea ETD,ETA_Lea ETA, ATD_Lea ATD, ATA_Lea ATA, Cd_Org_HEa cd_org,
--Cd_Dst_HEa cd_dst,JOB.Cd_Usuario cd_usuario,0 Cd_Tp_Carga,Mas.Cd_Consig_MEA AS cd_Cliente_Master, LLP.Cd_Transportadora
--,Hou.HAWB_HEA HAWB, HOU.MAWB_HEA MAWB,LLP.Cd_Terminal,HOU.Cd_Consig_HEA AS cd_fornecedor
--,HOU.Peso_Real_HEA Peso_Liquido
--FROM dbo.House_Exp_Aer	HOU	WITH (nolock) 
--JOIN LLP_Exp_aer LLP WITH (nolock) ON llp.num_proc_lea = HOU.Num_Proc_HEA
--JOIN Job_Exp_Aer JOB WITH (nolock) ON job.Num_Proc_HEA = HOU.Num_Proc_HEA
--left Join Master_Exp_Aer MAS WITH (nolock)  ON MAS.Num_Proc_MEA = HOU.Num_Proc_MEA
				
--UNION ALL

--SELECT Dt_emis_him Dt_Criacao, HOU.Num_Proc_HIM AS num_proc, Cd_Consig_HIM AS cd_cliente,
--eta_LIM DATA, HOU.Num_Proc_MIM Master,LLP.ETD_Lim ETD,ETA_Lim ETA, ATD_Lim ATD, ATA_Lim ATA, Cd_Org_Him cd_org,
--Cd_Dst_Him cd_dst,JOB.Cd_Usuario cd_usuario,LLP.Cd_Tp_Carga Cd_Tp_Carga,MAS.Cd_Export_MIM  AS cd_Cliente_Master, LLP.Cd_Transportadora
--,Hou.HAWB_HIM HAWB, HOU.MAWB_HIM MAWB,LLP.Cd_Terminal,HOU.Cd_Export_HIM AS cd_fornecedor
--,HOU.Peso_Liquido_HIM Peso_Liquido
--FROM dbo.House_Imp_Mar HOU	WITH (nolock) 
--JOIN LLP_Imp_MAr LLP WITH (nolock) ON llp.num_proc_lim = HOU.Num_Proc_HIM
--JOIN Job_Imp_Mar JOB WITH (nolock) ON job.Num_Proc_HIM = HOU.Num_Proc_HIM
--left Join Master_Imp_Mar MAS WITH (nolock)  ON MAS.Num_Proc_MIM = HOU.Num_Proc_MIM

--UNION ALL

--SELECT Dt_emis_hia Dt_Criacao, HOU.Num_Proc_HIA AS num_proc, Cd_Consig_HIA AS cd_cliente,
--ETA_LIA DATA, HOU.Num_Proc_MIA Master,LLP.ETD_LIA ETD,ETA_Lia ETA, ATD_Lia ATD, ATA_Lia ATA, Cd_Org_Hia cd_org,
--Cd_Dst_Hia cd_dst,JOB.Cd_Usuario cd_usuario,0 Cd_Tp_Carga,MAS.Cd_Export_MIA AS cd_Cliente_Master, LLP.Cd_Transportadora
--,Hou.HAWB_HIA HAWB, HOU.MAWB_HIA MAWB,LLP.Cd_Terminal,HOU.Cd_Export_HIA AS cd_fornecedor
--,HOU.Peso_Real_HIA Peso_Liquido
--FROM dbo.House_Imp_Aer HOU	WITH (nolock) 
--JOIN LLP_Imp_Aer LLP WITH (nolock) ON llp.num_proc_lia = HOU.Num_Proc_HIA
--JOIN Job_Imp_Aer JOB WITH (nolock) ON job.Num_Proc_HIA = HOU.Num_Proc_HIA
--left Join Master_Imp_Aer MAS WITH (nolock)  ON MAS.Num_Proc_Mia = HOU.Num_Proc_MIA

--UNION ALL

--SELECT Dt_emis_hio Dt_Criacao, HOU.Num_Proc_HIO AS num_proc, Cd_Consig_HIO AS cd_cliente, 
--ETA_Lio DATA, 'JOB' Master,LLP.ETD_Lio ETD,ETA_Lio ETA, ATD_Lio ATD, ATA_Lio ATA, Cd_Org_Hio cd_org,
--Cd_Dst_Hio cd_dst,LLP.Cd_Usuario cd_usuario,0 Cd_Tp_Carga,NULL AS cd_Cliente_Master, LLP.Cd_Transportadora
--, Hou.HAWB_HIO HAWB, HOU.MAWB_HIO MAWB,LLP.Cd_Terminal,HOU.Cd_Export_HIO AS cd_fornecedor
--,HOU.Peso_Real_HIO Peso_Liquido
--FROM dbo.House_Imp_Out HOU	WITH (nolock) 
--JOIN LLP_imp_out LLP WITH (nolock) ON llp.num_proc_lio = HOU.Num_Proc_HIO
				
--UNION ALL

--SELECT Dt_Emis_HBO Dt_Criacao, HOU.Num_Proc_HBO AS num_proc, cd_cliente_hbo,
--NULL DATA, 'JOB' Master
--,NULL ETD,NULL ETA, NULL ATD, NULL ATA, NULL cd_org, NULL cd_dst,LLP.Cd_Usuario cd_usuario
--,0 Cd_Tp_Carga ,
--NULL AS cd_Cliente_Master, NULL as Cd_Transportadora
--, NULL HAWB	,NULL MAWB,
--NULL AS Cd_Terminal,
--NULL AS cd_fornecedor
--,0 Peso_Liquido
--FROM dbo.House_BDP_OUT HOU WITH (nolock)
--JOIN LLP_BDP_OUT LLP WITH (nolock)  ON llp.Num_Proc_LBO = Num_Proc_HBO
				








--GO



GO
