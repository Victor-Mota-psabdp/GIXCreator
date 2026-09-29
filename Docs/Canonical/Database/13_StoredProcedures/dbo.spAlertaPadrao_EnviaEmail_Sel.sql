SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spAlertaPadrao_EnviaEmail_Sel]

AS
	select distinct
		APH.ID, APH.JOB, APH.DocAnexos, AP.Nome_Alerta, APH.Conteudo, cast(APH.Dt_Ins as decimal(20,5)) Compara,
		U.Email ResponderPara,  APH.Emails
--		'sistemas@bdp.com.br;claudio.alves' Emails
	from
		Alerta_Padrao_Historico  APH with (nolock)
		join Alerta_Padrao AP with (nolock) on AP.ID = APH.ID and AP.Ativo = '1'
		join Usuario U with (nolock) on U.cd_usuario = AP.cd_usuario and U.ck_ativo = '1'
	where
		APH.dt_envio is NULL
		

GO
