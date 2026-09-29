SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[spPessoaAll_Sel] 

AS

	select 'ALL' apelido 
union ALL 
	select 
		apelido 
	from pessoa PP	with(nolock) 
		where --desat_pes='N' and 
			apelido like '%'
order by apelido
GO
