SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spReportManagerInfShipment_Sel]
		@Num_Proc	Varchar(16)
AS

Select 
		dbo.fBusca_GMID(@Num_Proc)	Cod_Prod,	
		dbo.fBusca_PRODUTO(@Num_PRoc)	Produto,
		DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'IPI%') IPI,
		DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'Imposto de %') II,
		DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'%Siscomex%')  Siscomex,
		DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'PIS%') PIS,
		DBO.[fBusca_CustoProcessoTAB](@Num_Proc,'Cofins%') Cofins

GO
