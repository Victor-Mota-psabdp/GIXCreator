SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[vwClienteALLJOBS_BO_Sel]
AS
SELECT     Dt_emis_hem Dt_Criacao, Num_Proc_HEM AS num_proc, Cd_Export_HEM AS cd_cliente, Cd_Consig_HEM AS cd_fornecedor, ETD_LEM DATA, 
                      Num_proc_mem Master, ETA_Lem ETA, ATD_Lem ATD, ATA_Lem ATA, Cd_Org_HEM Cd_local, ID_Status,Cd_Tp_Oper
FROM         dbo.House_Exp_Mar WITH (nolock) JOIN
                      LLP_Exp_mar LLP WITH (nolock) ON llp.num_proc_lem = num_proc_hem
UNION ALL
SELECT     Dt_emis_heo Dt_Criacao, Num_Proc_HEO AS num_proc, Cd_Export_HEO, Cd_Consig_HEO, ETD_LEO DATA, 'JOB' Master, ETA_Leo ETA, ATD_Leo ATD, ATA_Leo ATA, 
                      Cd_Org_HEO Cd_local, ID_Status,Cd_Tp_Oper
FROM         dbo.House_Exp_Out WITH (nolock) JOIN
                      LLP_Exp_out LLP WITH (nolock) ON llp.num_proc_leo = num_proc_heo
UNION ALL
SELECT     Dt_emis_hea Dt_Criacao, Num_Proc_HEA AS num_proc, Cd_Export_HEA, Cd_Consig_HEA, ETD_LEA DATA, Num_proc_meA Master, ETA_Lea ETA, ATD_Lea ATD, 
                      ATA_Lea ATA, Cd_Org_HEA Cd_local, ID_Status,Cd_Tp_Oper
FROM         dbo.House_Exp_Aer WITH (nolock) JOIN
                      LLP_Exp_aer LLP ON llp.num_proc_lea = num_proc_hea
UNION ALL
SELECT     Dt_emis_him Dt_Criacao, Num_Proc_HIM AS num_proc, Cd_Consig_HIM, Cd_Export_HIM, eta_LIM DATA, Num_proc_mIM Master, ETA_Lim ETA, ATD_Lim ATD, 
                      ATA_Lim ATA, Cd_Dst_HIM Cd_local, ID_Status,Cd_Tp_Oper
FROM         dbo.House_Imp_Mar WITH (nolock) JOIN
                      LLP_Imp_MAr LLP WITH (nolock) ON llp.num_proc_lim = num_proc_him
UNION ALL
SELECT     Dt_emis_hia Dt_Criacao, Num_Proc_HIA AS num_proc, Cd_Consig_HIA, Cd_Export_HIA, eta_lia DATA, Num_proc_mIA Master, ETA_Lia ETA, ATD_Lia ATD, 
                      ATA_LIA ATA, Cd_Dst_HIA Cd_local, ID_Status,Cd_Tp_Oper
FROM         dbo.House_Imp_Aer WITH (nolock) JOIN
                      LLP_Imp_Aer LLP WITH (nolock) ON llp.num_proc_lia = num_proc_hia
UNION ALL
SELECT     Dt_emis_hio Dt_Criacao, Num_Proc_HIO AS num_proc, Cd_Consig_HIO, Cd_Export_HIO, eta_LIO DATA, 'JOB' Master, ETA_Lio ETA, ATD_Lio ATD, ATA_Lio ATA, 
                      Cd_Dst_HIO Cd_local, ID_Status,Cd_Tp_Oper
FROM         dbo.House_Imp_Out WITH (nolock) JOIN
                      LLP_imp_out LLP WITH (nolock) ON llp.num_proc_lio = num_proc_hio





GO
