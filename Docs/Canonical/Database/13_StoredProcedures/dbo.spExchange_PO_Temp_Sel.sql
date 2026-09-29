SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Exchange_PO_Temp
CREATE Procedure [dbo].[spExchange_PO_Temp_Sel]--'2'
(
	@ID			BIGINT,
	@Tipo		char(1)
)

as

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select 
			ID,ID_House_Temp,Intl_Reference,Num_Proc,Dt_Ins,Dt_Envio,Dt_Retorno	
		from Exchange_PO_Temp H with(nolock)
		where
			--H.ID = @ID and 
			Dt_Envio is null
			and Num_Proc is not null
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			ID,ID_House_Temp,Intl_Reference,Num_Proc,Dt_Ins,Dt_Envio,Dt_Retorno	
		from Exchange_PO_Temp H with(nolock)
		where
			H.ID = @ID
			
	End

GO
