SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_PurchaseOrderJOB_Container_Sel]
(
	@ID_PurchaseOrderJOB	bigint,
	@ID_Line				bigint,
	@Tipo					char(1)
)
as

--sp_help ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Container

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],			
			J.ID_Line,
			J.numero,
			J.lacre,
			J.tipo,
			J.descr,
			J.tipo_ocupacao,
			J.descr_ocupacao
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Container J with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB with(nolock) on JOB.ID_purchaseOrderJOB = J.ID_purchaseOrderJOB
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],			
			J.ID_Line,
			J.numero,
			J.lacre,
			J.tipo,
			J.descr,
			J.tipo_ocupacao,
			J.descr_ocupacao
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Container J with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB with(nolock) on JOB.ID_purchaseOrderJOB = J.ID_purchaseOrderJOB	
		where 
			J.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],			
			J.ID_Line,
			J.numero,
			J.lacre,
			J.tipo,
			J.descr,
			J.tipo_ocupacao,
			J.descr_ocupacao
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB_Container J with(nolock)
			join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB JOB with(nolock) on JOB.ID_purchaseOrderJOB = J.ID_purchaseOrderJOB
		where 
			J.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB and J.ID_Line = @ID_Line
	End






GO
