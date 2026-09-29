SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spLocalidadeALL_Sel]

as
		select 'ALL' nome_local 
			union ALL
		select nome_local 
			from localidade 
		where 
			Desat_loc='N' 
GO
