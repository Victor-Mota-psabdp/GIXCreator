SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Solicitacao_LI_Orgao_Anuente_Sel]--'','','B'
(	
	@Num_Solicitacao		Varchar(13),
	@Nome_Orgao_Anuente		varchar(60),
	@Tipo					char(1)
)
as

	--sp_help Orgao_Anuente
	Declare @ID_Orgao Int
	set @ID_Orgao = (Select ID_Orgao from Orgao_Anuente where Nome_Orgao_Anuente = @Nome_Orgao_Anuente)

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codgo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

--IF @Tipo = 'A' or @Tipo = 'B'
--	Begin
--		select 
--			SOA.Num_Solicitacao,
--			Nome_Orgao_Anuente
--		from 
--			Solicitacao_LI_Orgao_Anuente SOA with(nolock)			
--			Join Orgao_Anuente OA with(nolock) on SOA.ID_Orgao_Anuente=OA.ID_Orgao
--			JOIN Solicitacao_LI SLI with(nolock) on SOA.Num_Solicitacao=SLI.Num_Solicitacao		
--	End
	

IF @Tipo = 'C' or @Tipo = 'D'
	Begin
		select
			Nome_Orgao_Anuente [Orgão Anuente],
			(case when  Num_Solicitacao IS not NULL then 'X' else '' end)
			'Selec'
		from 
			Orgao_Anuente OA  with(nolock)			
			--left Join Solicitacao_LI_Orgao_Anuente SOA with(nolock) on SOA.ID_Orgao_Anuente=OA.ID_Orgao
			Left Join Solicitacao_LI_Orgao_Anuente on ID_Orgao_anuente=Id_Orgao and num_solicitacao=@Num_Solicitacao
		--Where
		--	SOA.Num_Solicitacao = 
			
	End
	

--IF @Tipo = 'N' or  @Tipo = 'O'
--	Begin
--		select 
--			SOA.Num_Solicitacao,
--			Nome_Orgao_Anuente
--		from 
--			Solicitacao_LI_Orgao_Anuente SOA with(nolock)			
--			Join Orgao_Anuente OA with(nolock) on SOA.ID_Orgao_Anuente=OA.ID_Orgao
--			JOIN Solicitacao_LI SLI with(nolock) on SOA.Num_Solicitacao=SLI.Num_Solicitacao
--		Where
--			OA.Nome_Orgao_Anuente = @Nome_Orgao_Anuente
--	End

GO
