SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmix_Retorno_Export_Item_Ins]

	@ID	bigint,
	@Campo Varchar(30),
	@Valor	Varchar(Max)

AS

Begin
	Declare @Id_Item int
	
	SEt @Id_Item = (select MAX(id_item) from ATL_INT.DBO.Emix_Retorno_Export_Item with(nolock) where Id=@ID)
	if @Id_Item is null
		Begin
			Set @Id_Item=1
		end
	else
		Begin
			Set @Id_Item=@Id_Item+1
		End
	Insert ATL_INT.DBO.Emix_Retorno_Export_Item(ID,ID_Item,Campo,Valor,Insert_Dt) 
	values (@ID,@Id_Item,@Campo,@Valor,GETDATE())
	



End
GO
