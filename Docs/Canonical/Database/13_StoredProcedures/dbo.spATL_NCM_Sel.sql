SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_NCM_Sel] 
(
	@Num_Proc VarChar(16)
)
AS
	Select 
		Id_NCM_Proc Item, 
		N.NCM Number, 
		N.Descricao_NCM [Description],
		(case when N.Alterado = 'N' then null
		else N.Alterado end) Alterado,
		N.Excecao
	from Proc_NCM P with (nolock)
    left join NCM  as N with (nolock) on P.Id_NCM = N.Id_NCM
    where P.Num_Proc= @Num_Proc



GO
