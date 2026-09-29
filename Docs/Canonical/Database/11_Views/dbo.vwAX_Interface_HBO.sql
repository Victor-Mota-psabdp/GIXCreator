SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAX_Interface_HBO]
AS
SELECT     HOU.Dt_emis_hem Dt_Criacao, HOU.Num_Proc_HEM AS num_proc, HOU.Cd_Export_HEM AS cd_cliente, LLP.ETD_Lem DATA, 
			HOU.Num_Proc_MEM [Master]
			,LLP.ETD_Lem ETD, ETA_Lem ETA, ATD_Lem ATD, ATA_Lem ATA, Cd_Org_HEM cd_org, Cd_Dst_HEM cd_dst,JOB.Cd_Usuario cd_usuario
			,LLP.Cd_Tp_Carga Cd_Tp_Carga, Hou.HAWB_HEM HAWB, HOU.MAWB_HEM MAWB, HOU.Obs_HEM OBS,
			LLP.Cd_Armador_Lem[Cd_Armador],HOU.Peso_Bruto_HEM[Peso_Bruto], HOU.Peso_Liquido_HEM[Peso_Liquido],
			 0 [Peso_cubado], JOB.Cd_Vendedor [cd_vendedor],HOU.Cd_Export_HEM [Cd_Export],
			 CASE WHEN HOU.Tp_Frete_HEM = 'P' THEN 'Prepaid' ELSE 'Collect' END [Tipo_Frete],Vol_Tot_HEM [Vol_Tot],
			 HOU.Viagem_HEM [Viagem],HOU.Navio_HEM [Navio],
			 MAS.Cd_Consig_MEM [cd_cliente_master]
FROM         dbo.House_Exp_Mar HOU		WITH (nolock) 
				JOIN LLP_Exp_mar LLP	WITH (nolock)  ON llp.num_proc_lem = HOU.Num_Proc_HEM
                JOIN Job_Exp_Mar JOB	WITH (nolock)  ON job.Num_Proc_HEM=HOU.Num_Proc_HEM
                LEft JOIN Master_exp_Mar MAS WITH (nolock) ON HOU.Num_Proc_MEM = MAS.Num_Proc_MEM
               
UNION ALL


SELECT     Dt_emis_heo Dt_Criacao, HOU.Num_Proc_HEO AS num_proc, Cd_Export_HEO, ETD_LEO DATA, 'JOB' [Master]
			,LLP.ETD_Leo ETD, ETA_Leo ETA, ATD_Leo ATD, ATA_Leo ATA, Cd_Org_HEo cd_org, Cd_Dst_HEO cd_dst,LLP.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , Hou.HAWB_HEO HAWB, HOU.MAWB_HEO MAWB, HOU.Obs_HEO OBS,
			LLP.Cd_Carrier[Cd_Armador], HOU.Peso_Bruto_HEO[Peso_Bruto], HOU.Peso_Real_HEO[Peso_Liquido],
			LLP.Peso_Cubado_Leo[Peso_cubado], LLP.Cd_Vendedor [cd_vendedor] ,HOU.Cd_Export_HEO [Cd_Export],
			CASE WHEN HOU.Tp_Frete_HEO = 'P' THEN 'Prepaid' ELSE 'Collect' END [Tipo_Frete],Vol_Tot_HEO [Vol_Tot],
			'' [Viagem],NULL [Navio],
			NULL [cd_cliente_master]
FROM         dbo.House_Exp_Out	HOU		WITH (nolock) 
				JOIN LLP_Exp_out LLP	WITH (nolock) ON llp.num_proc_leo = HOU.Num_Proc_HEO
				
UNION ALL

SELECT     Dt_emis_hea Dt_Criacao, HOU.Num_Proc_HEA AS num_proc, Cd_Export_HEA, ETD_LEA DATA, 
			HOU.Num_Proc_MEA [Master]
			,LLP.ETD_Lea ETD,ETA_Lea ETA, ATD_Lea ATD, ATA_Lea ATA, Cd_Org_HEa cd_org, Cd_Dst_HEa cd_dst,JOB.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , Hou.HAWB_HEA HAWB, HOU.MAWB_HEA MAWB, HOU.Obs_HEA OBS,
			HOU.Cd_Cia_Aer[Cd_Armador], HOU.Peso_Bruto_HEA [Peso_Bruto],HOU.Peso_Real_HEA [Peso_Liquido],
			LLP.Peso_Cubado_Lea [Peso_cubado],JOB.Cd_Vendedor [cd_vendedor] ,HOU.Cd_Export_HEA [Cd_Export],
			CASE WHEN HOU.Tp_Frete_HEA = 'P' THEN 'Prepaid' ELSE 'Collect' END [Tipo_Frete],Vol_Tot_HEA [Vol_Tot],
			HOU.Voo_HEA [Viagem],NULL [Navio],
			MAS.Cd_Consig_MEA [cd_cliente_master]
FROM         dbo.House_Exp_Aer	HOU		WITH (nolock) 
				JOIN LLP_Exp_aer LLP	WITH (nolock) ON llp.num_proc_lea = HOU.Num_Proc_HEA
				JOIN Job_Exp_Aer JOB	WITH (nolock) ON job.Num_Proc_HEA = HOU.Num_Proc_HEA
				LEFT JOIN Master_Exp_Aer MAS WITH (nolock) ON HOU.Num_Proc_MEA = MAS.Num_Proc_MEA
				
UNION ALL

SELECT     Dt_emis_him Dt_Criacao, HOU.Num_Proc_HIM AS num_proc, Cd_Consig_HIM, eta_LIM DATA, 
			HOU.Num_Proc_MIM [Master]
			,LLP.ETD_Lim ETD,ETA_Lim ETA, ATD_Lim ATD, ATA_Lim ATA, Cd_Org_Him cd_org, Cd_Dst_Him cd_dst,JOB.Cd_Usuario cd_usuario
			,LLP.Cd_Tp_Carga Cd_Tp_Carga , Hou.HAWB_HIM HAWB, HOU.MAWB_HIM MAWB, HOU.Obs_HIM OBS,
			 JOB.Cd_Armador[Cd_Armador],HOU.Peso_Bruto_HIM[Peso_Bruto], HOU.Peso_Liquido_HIM[Peso_Liquido],
			  0 [Peso_cubado], JOB.Cd_Vendedor [cd_vendedor] ,HOU.Cd_Export_Him[Cd_Export],
			  CASE WHEN HOU.Tp_Frete_HIM = 'P' THEN 'Prepaid' ELSE 'Collect' END [Tipo_Frete],Vol_Tot_HIM [Vol_Tot],
			  HOU.Viagem_HIM [Viagem],HOU.Navio_HIM [Navio],
			  MAS.Cd_Export_MIM [cd_cliente_master]
FROM         dbo.House_Imp_Mar HOU		WITH (nolock) 
				JOIN LLP_Imp_MAr LLP	WITH (nolock) ON llp.num_proc_lim = HOU.Num_Proc_HIM
				JOIN Job_Imp_Mar JOB	WITH (nolock) ON job.Num_Proc_HIM = HOU.Num_Proc_HIM
				LEft JOIN Master_Imp_Mar MAS WITH (nolock) ON HOU.Num_Proc_MIM = MAS.Num_Proc_MIM
UNION ALL

SELECT     Dt_emis_hia Dt_Criacao, HOU.Num_Proc_HIA AS num_proc, Cd_Consig_HIA, eta_lia DATA, 
			HOU.Num_Proc_MIA [Master]
			,LLP.ETD_LIA ETD,ETA_Lia ETA, ATD_Lia ATD, ATA_Lia ATA, Cd_Org_Hia cd_org, Cd_Dst_Hia cd_dst,JOB.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , Hou.HAWB_HIA HAWB, HOU.MAWB_HIA MAWB, HOU.Obs_HIA OBS,
			JOB.Cd_Cia_Aer[Cd_Armador],HOU.Peso_Bruto_HIA[Peso_Bruto], HOU.Peso_Real_HIA [Peso_Liquido],
			LLP.Peso_Cubado_LIA[Peso_cubado], JOB.Cd_Vendedor [cd_vendedor] ,HOU.Cd_Export_Hia[Cd_Export],
			(CASE WHEN HOU.Tp_Frete_HIA = 'P' THEN 'Prepaid' ELSE 'Collect' END) [Tipo_Frete],Vol_Tot_HIA [Vol_Tot],
			HOU.Voo_HIA [Viagem],NULL [Navio],
			MAS.Cd_Export_MIA [cd_cliente_master]
FROM         dbo.House_Imp_Aer HOU		WITH (nolock) 
				JOIN LLP_Imp_Aer LLP	WITH (nolock) ON llp.num_proc_lia = HOU.Num_Proc_HIA
				JOIN Job_Imp_Aer JOB	WITH (nolock) ON job.Num_Proc_HIA = HOU.Num_Proc_HIA
				LEFT JOIN Master_Imp_Aer MAS WITH (nolock) ON HOU.Num_Proc_MIA = MAS.Num_Proc_MIA
UNION ALL

SELECT     Dt_emis_hio Dt_Criacao, HOU.Num_Proc_HIO AS num_proc, Cd_Consig_HIO, eta_LIO DATA, 'JOB' [Master]
			,LLP.ETD_Lio ETD,ETA_Lio ETA, ATD_Lio ATD, ATA_Lio ATA, Cd_Org_Hio cd_org, Cd_Dst_Hio cd_dst,LLP.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , Hou.HAWB_HIO HAWB, HOU.MAWB_HIO MAWB, HOU.Obs_HIO OBS,
			LLP.Cd_Carrier[Cd_Armador],HOU.Peso_Bruto_HIO[Peso_Bruto], HOU.Peso_Real_HIO[Peso_Liquido], 
			LLP.Peso_Cubado_Lio[Peso_cubado], LLP.Cd_Vendedor [cd_vendedor] ,HOU.Cd_Export_Hio[Cd_Export],
			CASE WHEN HOU.Tp_Frete_HIO = 'P' THEN 'Prepaid' ELSE 'Collect' END [Tipo_Frete],Vol_Tot_HIO [Vol_Tot],
			'' [Viagem],NULL [Navio],
			NULL [cd_cliente_master]
FROM         dbo.House_Imp_Out HOU		WITH (nolock) 
				JOIN LLP_imp_out LLP	WITH (nolock) ON llp.num_proc_lio = HOU.Num_Proc_HIO
				
				
UNION ALL

SELECT    Dt_Emis_HBO Dt_Criacao, HOU.Num_Proc_HBO AS num_proc, cd_cliente_hbo, NULL DATA, 'JOB' [Master]
			,NULL ETD,NULL ETA, NULL ATD, NULL ATA, NULL cd_org, NULL cd_dst,LLP.Cd_Usuario cd_usuario
			,0 Cd_Tp_Carga , NULL HAWB	,NULL MAWB,HOU.Descr_Serv_HBO OBS,
			NULL [Cd_Armador],0 [Peso_Bruto], 0 [Peso_Liquido],
			0 [Peso_cubado],NULL [cd_vendedor] ,NULL[Cd_Export],
			NULL [Tipo_Frete],0 [Vol_Tot],
			'' [Viagem],NULL [Navio],
			NULL [cd_cliente_master]
FROM         dbo.House_BDP_OUT HOU WITH (nolock)
				JOIN LLP_BDP_OUT LLP WITH (nolock)  ON llp.Num_Proc_LBO = Num_Proc_HBO
				








GO
