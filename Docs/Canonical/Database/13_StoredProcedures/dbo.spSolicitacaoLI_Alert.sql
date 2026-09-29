SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Author:		Claudio
-- Create date:	05/03/2010
-- Revisão:		
-- Description: Solicitações de LI
-- =================================================

CREATE PROCEDURE [dbo].[spSolicitacaoLI_Alert] --'I'

@Tipo_Email varchar(100)

AS	
	if @Tipo_Email = 'I'
		Begin
			select distinct
				 Num_Proc, S.Num_Solicitacao, convert(char(10),Dt_Solicitacao,103) Dt_Solicitacao, 
				 'willians.viola@bdpint.com,daniel.barbosa@bdpint.com,mnascimento@bdp.com.br,ecastro@bdp.com.br,sistemas@bdp.com.br,agarcia@bdp.com.br' EMail,
				 'willians.viola@bdpint.com,daniel.barbosa@bdpint.com;ecastro@bdp.com.br,agarcia@bdp.com.br' ResponderPara
			from 
				Atlantis.dbo.Solicitacao_LI S
				join Atlantis.dbo.Solicitacao_LI_Log L on L.Num_Solicitacao=S.Num_Solicitacao
			where
				L.Tipo_Oper = @Tipo_Email and L.Dt_Envio is null and S.Num_LI is null
			order by
				Email,Dt_Solicitacao
		End

	Else If @Tipo_Email = 'A'
		Begin
			select distinct
				 Cd_Usuario_Oper, U.Nome_Usuario, U.Email, 
				 'willians.viola@bdpint.com,daniel.barbosa@bdpint.com,mnascimento@bdp.com.br,ecastro@bdp.com.br,agarcia@bdp.com.br' ResponderPara
			from 
				Atlantis.dbo.Solicitacao_LI S
				join Atlantis.dbo.Solicitacao_LI_Log L on L.Num_Solicitacao=S.Num_Solicitacao
				join Usuario U on U.cd_usuario = S.cd_usuario_oper
			where
				L.Tipo_Oper = @Tipo_Email and L.Dt_Envio is null and S.Num_LI is null
		End
	Else
		Begin
			select distinct
				 Num_Proc, S.Num_Solicitacao, convert(char(10),Dt_Solicitacao,103) Dt_Solicitacao
			from 
				Atlantis.dbo.Solicitacao_LI S
				join Atlantis.dbo.Solicitacao_LI_Log L on L.Num_Solicitacao=S.Num_Solicitacao
				left join Usuario U on U.cd_usuario = S.cd_usuario_oper
			where
				Cd_Usuario_Oper = @Tipo_Email and L.Dt_Envio is null and S.Num_LI is null
			order by
				Dt_Solicitacao	
		End




GO
