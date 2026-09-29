SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spShipmentConfirmation_Verify]
AS
SET NOCOUNT ON;
	select 'Os JOBs abaixo estão relacionados para envio do alerta "SHIPMENT CONFIRMATION", mas estão SEM informação de ATD e/ou Courier:'
	select ''
	select 'JOB', 'ETD',' ATD',' Courier Number', 'Courier Name'
	union ALL
	select distinct 
		LLP.Num_Proc_LEM, convert(char(10),ETD_LEM,103), isnull(convert(char(10),LLP.ATD_LEM,103),'?'), convert(char(15),isnull(LLP.Courier_Number_Lem,'?')), isnull(COU.Nome_Raz_Soc,'?')
	from
		House_Exp_Mar HOU
		join LLP_Exp_Mar LLP on LLP.Num_Proc_LEM = HOU.Num_Proc_HEM
		left join Pessoa COU on LLP.Cd_Courier = COU.Cd_Pes
		join Pessoa_LLP PL on PL.cd_pes = HOU.cd_export_hem
		Join Pessoa GR on GR.Cd_Pes = PL.Cd_Pes_Grupo
		join Grupo GP on GP.Cd_Pes_Grupo = GR.Cd_Pes
		--join msdb.dbo.Alerta_Email AE on AE.Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
		join dbo.Alerta_Email AE on AE.Grupo COLLATE Latin1_General_CI_AI = GP.Grupo and AE.Nome_Alerta = 'SHIPMENT CONFIRMATION' 
		left join Alerta_Email_Historico AEH on AEH.Id_Alerta_Email = AE.ID and AEH.Num_Proc = HOU.Num_Proc_HEM
	where
		AEH.Num_Proc IS NULL and LLP.ETD_LEM Between getdate()-5 and getdate() and (ATD_LEM is null or LLP.Courier_Number_Lem is null)
	order by
		4,3





GO
