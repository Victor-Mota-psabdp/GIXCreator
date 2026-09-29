SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_MANaoConciliado_Alert]
	@ALL varchar(3)

AS

Begin

SET NOCOUNT ON;

	select 
		dt_pgto_rcto_mov	[Data],
		num_lcto_mov		[Numero do MA],
		num_cta_cte			[Cta.Cte],
		Dc_mov				[DC],
		vlr_doc_mov			[Valor],
		historico			[Histórico]
	from 
		atlantis.dbo.mvto_Cta_cte
	where
		concil_mov='N' and convert(Datetime,dt_pgto_rcto_mov,105)>='01-01-2009'
		and convert(Datetime,dt_pgto_rcto_mov,105) <=getdate()-2
	order by 
		convert(Datetime,dt_pgto_rcto_mov,105) desc

End
GO
