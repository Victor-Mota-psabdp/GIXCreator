SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwfBusca_Alerta_Email_Doc_Automatico]

AS

SELECT 
	HOU.Num_Proc_HEM AS num_proc,
	Nr_Reserva as Nr_Reserva,
	LLP.Cd_Terminal as Cd_Terminal,
	ATD_Lem ATD,ATA_Lem ATA,LLP.ETD_Lem ETD,ETA_Lem ETA,
	HOU.Cd_Export_HEM as cd_export, 
	HOU.Cd_Consig_HEM as cd_Consig,
	HOU.Cd_Notify_HEM as cd_Notify,
	HOU.Navio_HEM as Navio,
	HOU.Cd_Org_HEM as Cd_Org,
	HOU.Cd_Dst_HEM as Cd_Dst,
	HOU.HAWB_HEM as HAWB,
	HOU.MAWB_HEM as MAWB,
	LLP.Courier_Number_Lem as Courier_Number,
	LLP.cd_courier as cd_courier,
	HOU.Obs_HEM as Obs,
	NG.Descr as Descr,	
	HOU.Viagem_HEM as Voo_Viagem,
	HOU.Cd_Tp_Oper as cd_tp_oper,
	HOU.Dt_emis_hem as Dt_Criacao, 
	HOU.Num_Proc_MEM as Master,
	JOB.Cd_Usuario as cd_usuario,
	LLP.Cd_Tp_Carga as Cd_Tp_Carga,
	Mas.Cd_Consig_MEM AS cd_Cliente_Master, 
	LLP.Cd_Transportadora,
	Qtd_Tot_Vol_HEM as Qtd_Tot_Vol,
	Peso_Liquido_HEM as Peso_Liquido,
	Peso_Bruto_HEM	as Peso_Bruto,
	0 as Peso_Cubado,
	Vol_Tot_HEM as Vol_Tot,
	HOU.TTime_D	as TransitTime
FROM 
	dbo.House_Exp_Mar	HOU WITH (nolock) 
	JOIN LLP_Exp_mar	LLP WITH (nolock)  ON llp.num_proc_lem = HOU.Num_Proc_HEM
	JOIN Job_Exp_Mar	JOB WITH (nolock)  ON job.Num_Proc_HEM=HOU.Num_Proc_HEM
	LEFT JOIN Master_Exp_Mar MAS WITH (nolock)  ON MAS.Num_Proc_MEM = HOU.Num_Proc_MEM
	LEFT JOIN Nature_Goods NG WITH (nolock)  ON HOU.Num_Proc_HEM = NG.Num_Proc
                
UNION ALL

SELECT 
	HOU.Num_Proc_HEO AS num_proc, 
	Nr_Reserva as Nr_Reserva,
	LLP.Cd_Terminal as Cd_Terminal,
	ATD_Leo ATD,ATA_Leo ATA, ETD_LEO ETD,ETA_Leo ETA,
	HOU.Cd_Export_HEO as cd_export,
	HOU.Cd_Consig_HEO as cd_Consig,
	HOU.Cd_Notify_HEO as cd_Notify,
	'' as Navio,
	HOU.Cd_Org_HEO as Cd_Org,
	HOU.Cd_Dst_HEO as Cd_Dst,
	HOU.HAWB_HEO as HAWB,
	HOU.MAWB_HEO as MAWB,
	LLP.Courier_Number_Leo as Courier_Number,
	LLP.cd_courier as cd_courier,
	HOU.Obs_HEO as Obs,
	NG.Descr as Descr,
	HOU.Voo_HEO as Voo_Viagem,
	HOU.Cd_Tp_Oper as cd_tp_oper,
	HOU.Dt_Emis_HEO as Dt_Criacao,
	'JOB' as Master,
	LLP.Cd_Usuario as cd_usuario,
	0 Cd_Tp_Carga,
	NULL AS cd_Cliente_Master, 
	LLP.Cd_Transportadora,
	Qtd_Tot_Vol_HEO as Qtd_Tot_Vol,
	Peso_Real_HEO as Peso_Liquido,
	Peso_Bruto_HEO	as Peso_Bruto,
	0 as Peso_Cubado,
	Vol_Tot_HEO as Vol_Tot,
	HOU.TTime_D	as TransitTime			
FROM 
	dbo.House_Exp_Out	HOU WITH (nolock) 
	JOIN LLP_Exp_out	LLP WITH (nolock) ON llp.num_proc_leo = HOU.Num_Proc_HEO
	LEFT JOIN Nature_Goods NG WITH (nolock)  ON HOU.Num_Proc_HEO = NG.Num_Proc
				
				
UNION ALL

SELECT 
	HOU.Num_Proc_HEA AS num_proc,
	'' as Nr_Reserva,
	LLP.Cd_Terminal as Cd_Terminal, 
	ATD_Lea ATD, ATA_Lea ATA,ETD_LEA ETD,ETA_Lea ETA,
	HOU.Cd_Export_HEA as cd_export,
	HOU.Cd_Consig_HEA as cd_Consig,
	HOU.Cd_Notify_HEA as cd_Notify, 
	'' as Navio,
	Cd_Org_HEA as Cd_Org,
	Cd_Dst_HEA as Cd_Dst,
	HOU.HAWB_HEA as HAWB,
	HOU.MAWB_HEA as MAWB,
	LLP.Courier_Number_Lea as Courier_Number, 
	LLP.cd_courier as cd_courier,
	HOU.Obs_HEA as Obs,
	NG.Descr as Descr,
	HOU.Voo_HEA as Voo_Viagem,
	HOU.Cd_Tp_Oper as cd_tp_oper,
	HOU.Dt_Emis_HEA Dt_Criacao,			
	HOU.Num_Proc_MEA Master,
	JOB.Cd_Usuario cd_usuario,
	0 Cd_Tp_Carga,
	Mas.Cd_Consig_MEA AS cd_Cliente_Master,
	LLP.Cd_Transportadora,
	Qtd_Tot_Vol_HEA as Qtd_Tot_Vol,
	Peso_Real_HEA as Peso_Liquido,
	Peso_Bruto_HEA	as Peso_Bruto,
	LLP.Peso_Cubado_Lea as Peso_Cubado,
	Vol_Tot_HEA as Vol_Tot,
	HOU.TTime_D	as TransitTime			
FROM 
	dbo.House_Exp_Aer	HOU	WITH (nolock) 
	JOIN LLP_Exp_aer LLP	WITH (nolock) ON llp.num_proc_lea = HOU.Num_Proc_HEA
	JOIN Job_Exp_Aer JOB	WITH (nolock) ON job.Num_Proc_HEA = HOU.Num_Proc_HEA
	LEFT JOIN Master_Exp_Aer MAS WITH (nolock) ON MAS.Num_Proc_MEA = HOU.Num_Proc_MEA
	LEFT JOIN Nature_Goods NG WITH (nolock)  ON HOU.Num_Proc_HEA = NG.Num_Proc
				
UNION ALL

SELECT 
	HOU.Num_Proc_HIM AS num_proc,
	Nr_Reserva as Nr_Reserva,
	LLP.Cd_Terminal as Cd_Terminal,
	ATD_Lim ATD, ATA_Lim ATA, ETD_Lim ETD,ETA_Lim ETA,
	HOU.Cd_Export_HIM as cd_export,
	HOU.Cd_Consig_HIM as cd_Consig,
	HOU.Cd_Import_HIM as cd_Notify, 
	HOU.Navio_HIM as Navio, 
	HOU.Cd_Org_HIM as Cd_Org,
	HOU.Cd_Dst_HIM as Cd_Dst,
	HOU.HAWB_HIM as HAWB,
	HOU.MAWB_HIM as MAWB,
	LLP.Courier_Number_Lim as Courier_Number,
	LLP.cd_courier as cd_courier,
	HOU.Obs_HIM as Obs,
	NG.Descr as Descr,
	HOU.Viagem_HIM as Voo_Viagem,
	HOU.Cd_Tp_Oper as cd_tp_oper,
	HOU.Dt_Emis_HIM as Dt_Criacao,
	HOU.Num_Proc_MIM as Master,
	JOB.Cd_Usuario as cd_usuario,
	LLP.Cd_Tp_Carga Cd_Tp_Carga,
	MAS.Cd_Export_MIM AS cd_Cliente_Master,
	LLP.Cd_Transportadora,
	Qtd_Tot_Vol_HIM as Qtd_Tot_Vol,
	Peso_Liquido_HIM as Peso_Liquido,
	Peso_Bruto_HIM	as Peso_Bruto,
	0 as Peso_Cubado,
	Vol_Tot_HIM as Vol_Tot,
	HOU.TTime_D	as TransitTime			
FROM
	dbo.House_Imp_Mar	HOU	WITH (nolock) 
	JOIN LLP_Imp_MAr	LLP	WITH (nolock) ON llp.num_proc_lim = HOU.Num_Proc_HIM
	JOIN Job_Imp_Mar	JOB	WITH (nolock) ON job.Num_Proc_HIM = HOU.Num_Proc_HIM
	LEFT JOIN Master_Imp_Mar MAS WITH (nolock)  ON MAS.Num_Proc_MIM = HOU.Num_Proc_MIM
	LEFT JOIN Nature_Goods NG WITH (nolock)  ON HOU.Num_Proc_HIM = NG.Num_Proc
	
UNION ALL

SELECT 
	HOU.Num_Proc_HIA AS num_proc,
	'' as Nr_Reserva,
	LLP.Cd_Terminal as Cd_Terminal, 
	ATD_Lia ATD, ATA_Lia ATA,ETD_LIA ETD,ETA_Lia ETA,
	HOU.Cd_Export_HIA as cd_export,
	HOU.Cd_Consig_HIA as cd_Consig,
	HOU.Cd_Import_HIA as cd_Notify,
	'' as Navio,  
	HOU.Cd_Org_HIA as Cd_Org,
	HOU.Cd_Dst_HIA as Cd_Dst,
	HOU.HAWB_HIA as HAWB,
	HOU.MAWB_HIA as MAWB,
	LLP.Courier_Number_Lia as Courier_Number,
	LLP.cd_courier as cd_courier,
	HOU.Obs_HIA as Obs,
	NG.Descr as Descr,
	HOU.Voo_HIA as Voo_Viagem,
	HOU.Cd_Tp_Oper as cd_tp_oper,
	HOU.Dt_Emis_HIA as Dt_Criacao,	
	HOU.Num_Proc_MIA as Master,
	JOB.Cd_Usuario as cd_usuario,
	0 Cd_Tp_Carga,
	MAS.Cd_Export_MIA AS cd_Cliente_Master,
	LLP.Cd_Transportadora,
	Qtd_Tot_Vol_HIA as Qtd_Tot_Vol,
	Peso_Real_HIA as Peso_Liquido,
	Peso_Bruto_HIA	as Peso_Bruto,
	LLP.Peso_Cubado_LIA as Peso_Cubado,
	Vol_Tot_HIA as Vol_Tot,
	HOU.TTime_D	as TransitTime				
FROM
	dbo.House_Imp_Aer HOU	WITH (nolock) 
	JOIN LLP_Imp_Aer LLP	WITH (nolock) ON llp.num_proc_lia = HOU.Num_Proc_HIA
	JOIN Job_Imp_Aer JOB	WITH (nolock) ON job.Num_Proc_HIA = HOU.Num_Proc_HIA
	LEFT JOIN Master_Imp_Aer MAS WITH (nolock)  ON MAS.Num_Proc_Mia = HOU.Num_Proc_MIA
	LEFT JOIN Nature_Goods NG WITH (nolock)  ON HOU.Num_Proc_HIA = NG.Num_Proc
	
UNION ALL

SELECT 
	HOU.Num_Proc_HIO AS num_proc,
	'' as Nr_Reserva,
	LLP.Cd_Terminal as Cd_Terminal,
	ATD_Lio ATD, ATA_Lio ATA,ETD_Lio ETD,ETA_Lio ETA,
	HOU.Cd_Export_HIO as cd_export,
	HOU.Cd_Consig_HIO as cd_Consig,
	HOU.Cd_Import_HIO as cd_Notify,
	'' as Navio,
	HOU.Cd_Org_HIO as Cd_Org,
	HOU.Cd_Dst_HIO as Cd_Dst,
	HOU.HAWB_HIO as HAWB,
	HOU.MAWB_HIO as MAWB,
	LLP.Courier_Number_Lio as Courier_Number,
	LLP.cd_courier as cd_courier,
	HOU.Obs_HIO as Obs,
	NG.Descr as Descr, 
	HOU.Voo_HIO as Voo_Viagem,
	HOU.Cd_Tp_Oper as cd_tp_oper,
	HOU.Dt_Emis_HIO as Dt_Criacao,
	'JOB' as Master,
	LLP.Cd_Usuario as cd_usuario,
	0 Cd_Tp_Carga,
	NULL AS cd_Cliente_Master, 
	LLP.Cd_Transportadora,
	Qtd_Tot_Vol_HIO as Qtd_Tot_Vol,
	Peso_Real_HIO as Peso_Liquido,
	Peso_Bruto_HIO	as Peso_Bruto,
	0 as Peso_Cubado,
	Vol_Tot_HIO as Vol_Tot,
	HOU.TTime_D	as TransitTime				
FROM
	dbo.House_Imp_Out HOU	WITH (nolock) 
	JOIN LLP_imp_out LLP	WITH (nolock) ON llp.num_proc_lio = HOU.Num_Proc_HIO
	LEFT JOIN Nature_Goods NG WITH (nolock)  ON HOU.Num_Proc_HIO = NG.Num_Proc
				





GO
