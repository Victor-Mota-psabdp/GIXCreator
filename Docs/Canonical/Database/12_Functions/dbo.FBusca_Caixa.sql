SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE  function [dbo].[FBusca_Caixa](
			@Num_Proc Varchar(16)
			
			
		)returns Datetime
AS 

BEGIN
	Declare @Valor Datetime
	if LEFT(@NUM_PROC,2)='IM'
		BEGIN
			set @valor=Isnull((
				select top 1 convert(datetime,dt_pgto_rcto_him,105) from caixa_hou_imp_mar CTA with(nolock)
				Where num_proc_him=@num_proc AND LEFT(CD_TP_tX,2)='XB'
				order by convert(datetime,dt_pgto_rcto_him,105) desc
				),0)
		END
	if LEFT(@NUM_PROC,2)='IO'
		BEGIN
			set @valor=Isnull((
				select top 1 convert(datetime,dt_pgto_rcto_hio,105) from caixa_hou_imp_out CTA with(nolock)
				Where num_proc_hio=@num_proc AND LEFT(CD_TP_tX,2)='XB'
				order by convert(datetime,dt_pgto_rcto_hio,105) desc				),0)
		
		END
	if LEFT(@NUM_PROC,2)='IA'
		BEGIN
			set @valor=Isnull((
				select top 1 convert(datetime,dt_pgto_rcto_hia,105) from caixa_hou_imp_aer CTA with(nolock)
				Where num_proc_hia=@num_proc AND LEFT(CD_TP_tX,2)='XB'
				order by convert(datetime,dt_pgto_rcto_hia,105) desc				
				),0)
		
		END
		return @valor
END








GO
