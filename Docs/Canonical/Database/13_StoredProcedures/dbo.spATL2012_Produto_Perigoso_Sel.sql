SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from produto_cliente where cd_proc_cliente = '00363310'
--select * from produto_perigoso where cd_proc_cliente = '00363310'


CREATE Procedure [dbo].[spATL2012_Produto_Perigoso_Sel]--'6'

		@cd_prod int		

AS

	select * from produto_perigoso
	where cd_prod = @cd_prod
GO
