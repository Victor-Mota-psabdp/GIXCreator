SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[spATL_TipoCourier_Sel]
(
	@ID_Tp_Courier int,
	@Nome_Tp_Courier as Varchar(50),
	@Tipo as char
)
as
if @Tipo = 'A'
	Begin
		if  @ID_Tp_Courier = '' or  @ID_Tp_Courier is null
		Begin
			select ID_Tp_Courier, Nome_Tp_Courier from Tipo_Courier with (nolock)
			where Nome_Tp_Courier = @Nome_Tp_Courier
		End
		else
		Begin			
			select ID_Tp_Courier, Nome_Tp_Courier from Tipo_Courier with (nolock)
			where ID_Tp_Courier = @ID_Tp_Courier
		End
	End
if @Tipo = 'B'
	Begin
	if  @ID_Tp_Courier = '' or  @ID_Tp_Courier is null
		Begin
			select ID_Tp_Courier, Nome_Tp_Courier from Tipo_Courier with (nolock)
			where Nome_Tp_Courier = @Nome_Tp_Courier and [Status] = 1
		End
		else
		Begin			
			select ID_Tp_Courier, Nome_Tp_Courier from Tipo_Courier with (nolock)
			where ID_Tp_Courier = @ID_Tp_Courier and [Status] = 1
		End
	End
if @Tipo = 'T'
	Begin
		select  ID_Tp_Courier,Nome_Tp_Courier from Tipo_Courier with (nolock)  where  [Status] = 1
	End
GO
