SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Author:		Rafael Lindenberg
-- Create date:	20/05/2016
-- Revisão:		
-- Description: Abertura de JOB
-- =================================================

CREATE PROCEDURE [dbo].[spAlerta_PreAlertAerV2_Rel] --'I'

AS	
		select distinct
				 HOU.Num_Proc_HIA, 
				 CS.Apelido,
				 HOU.Dt_Emis_HIA Dt_Job, 
				 'rafael.lindenberg@bdpint.com' EMail,
				 'rafael.lindenberg@bdpint.com' ResponderPara
		from 
		House_Imp_Aer			HOU		with(nolock)
		Join LLP_Imp_Aer		LLP		with(nolock) on HOU.Num_Proc_HIA	=	LLP.Num_Proc_LIA
		join Job_Imp_Aer		JOB		with(nolock) on JOB.Num_Proc_HIA	=	HOU.Num_Proc_HIA
		join Usuario			US		with(nolock) on US.cd_usuario		=	JOB.cd_usuario
		Join Pessoa				CS		with(nolock) on HOU.cd_consig_hia	=	CS.cd_pes
		Join Pessoa				NTY		With(Nolock) on HOU.Cd_Import_HIA	=	NTY.Cd_Pes
		join pessoa				SHP		with(nolock) on SHP.cd_pes			=	HOU.cd_export_hia
		join Localidade			ORG		with(nolock) on ORG.cd_local		=	HOU.cd_org_HIA
		join Localidade			DST		with(nolock) on DST.cd_local		=	HOU.cd_dst_HIA
		join Localidade			FIM		with(nolock) on FIM.cd_local		=	LLP.cd_dstFinal_LIA	
	where 
		DST.Nome_Local = 'Viracopos'
		and Dt_Emis_HIA = GETDATE()
			order by
				Email,Dt_Job




GO
