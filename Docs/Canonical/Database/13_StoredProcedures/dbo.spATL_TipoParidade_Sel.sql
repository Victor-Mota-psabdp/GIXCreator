SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TipoParidade_Sel]
(
	@Cd_Tp_Par as varchar(3),
	@Nome_Tp_Par as Varchar(30),
	@Tipo as char
)
as

If @Tipo ='A'
	Begin
		if @Cd_Tp_Par = '' or @Cd_Tp_Par is null
			Begin
				select Cd_Tp_Par, Nome_Tp_Par from Tipo_Paridade
				where Nome_Tp_Par = @Nome_Tp_Par 
			End
		else
			Begin	
				select Cd_Tp_Par, Nome_Tp_Par from Tipo_Paridade
				where  Cd_Tp_Par = @Cd_Tp_Par
			End
End 
If @Tipo ='B'
	Begin
		if @Cd_Tp_Par = '' or @Cd_Tp_Par is null
			Begin
				select Cd_Tp_Par, Nome_Tp_Par from Tipo_Paridade
				where Nome_Tp_Par = @Nome_Tp_Par  and [Status] = 1
			End
		else
			Begin	
				select Cd_Tp_Par, Nome_Tp_Par from Tipo_Paridade
				where  Cd_Tp_Par = @Cd_Tp_Par and [Status] = 1
			End
End
GO
