SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCliente_House]
AS
SELECT     Dt_emis_hem Dt_Criacao, Num_Proc_HEM AS num_proc, Cd_Export_HEM AS cd_cliente, Num_proc_mem Master
FROM         dbo.House_Exp_Mar WITH (nolock) 
UNION ALL
SELECT     Dt_emis_heo Dt_Criacao, Num_Proc_HEO AS num_proc, Cd_Export_HEO,'JOB' Master
FROM         dbo.House_Exp_Out WITH (nolock) 
UNION ALL
SELECT     Dt_emis_hea Dt_Criacao, Num_Proc_HEA AS num_proc, Cd_Export_HEA,  Num_proc_meA Master
FROM         dbo.House_Exp_Aer WITH (nolock) 
UNION ALL
SELECT     Dt_emis_him Dt_Criacao, Num_Proc_HIM AS num_proc, Cd_Consig_HIM,  Num_proc_mIM Master
FROM         dbo.House_Imp_Mar WITH (nolock)
UNION ALL
SELECT     Dt_emis_hia Dt_Criacao, Num_Proc_HIA AS num_proc, Cd_Consig_HIA,  Num_proc_mIA Master
FROM         dbo.House_Imp_Aer WITH (nolock) 
UNION ALL
SELECT     Dt_emis_hio Dt_Criacao, Num_Proc_HIO AS num_proc, Cd_Consig_HIO, 'JOB' Master
FROM         dbo.House_Imp_Out WITH (nolock) 

GO
