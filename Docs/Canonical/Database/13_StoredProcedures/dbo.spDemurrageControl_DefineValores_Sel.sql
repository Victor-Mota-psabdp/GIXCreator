SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    Procedure [dbo].[spDemurrageControl_DefineValores_Sel]
	@nome_tp_cont varChar(100)

as
	select
		taxa,
		dias 
	from 
		Taxa_Demurrage TD With(nolock) 
	join tipo_container TC With(nolock) on tc.cd_tp_cont = TD.cd_tp_cont 
	where 
		nome_tp_cont = @nome_tp_cont
	order by
		periodo

GO
