SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Alterado os status 17/05/2017- cadu
CREATE procedure [dbo].[spSolPgtoCtaCte_Sel]--'8000017'
(
	@ID bigint
)
as
	select 
		ID,
		Cd_Cred_Dev,
		Dt_Pgto_Rcto,
		Vlr_Doc,
		Dt_Vcto,
		Cd_Tp_Doc,
		SOL.Nome_Usuario[Solicitante],
		GR.Nome_Usuario [Gerente],
		DR.Nome_Usuario [Diretor],
		--(case 
		--	When [Status] = 1 and (GR.Cd_Usuario = ''or GR.Cd_Usuario is null)  then 'Created'
		--	when [Status] = 1 and (SP.Status_Aprovacao = 'E' or SP.Status_Aprovacao = 'D' )then 'Rejected'
		--	When [Status] = 1 and (GR.Cd_Usuario <> ''or GR.Cd_Usuario is not null) then 'Approved' else 'Canceled'End)
		--	[Status],
		
		(CASE WHEN SP.Status_Aprovacao IS NULL AND SP.Status = 1 THEN 'Created' 
				WHEN SP.Status_Aprovacao IS NULL AND SP.Status = 0 THEN 'Canceled' 
				WHEN SP.Status_Aprovacao = 'A' AND SP.Status = 1 THEN 'Approved'
				WHEN SP.Status_Aprovacao = 'A' AND SP.Status = 0 THEN 'Canceled' 
				WHEN (SP.Status_Aprovacao = 'D' Or SP.Status_Aprovacao = 'E')
				AND SP.Status = 1 or SP.Status = 0 THEN 'Rejected' END) AS [Status], 
			
		*
	from
		Sol_Pgto_Cta_Cte SP with(nolock)
		join Usuario SOL on SP.Cd_Solicitante = SOL.Cd_Usuario
		left join Usuario GR on SP.Cd_Gerente = GR.Cd_Usuario
		left join Usuario DR on SP.Cd_Diretor = DR.Cd_Usuario
	where 
		ID = @ID

GO
