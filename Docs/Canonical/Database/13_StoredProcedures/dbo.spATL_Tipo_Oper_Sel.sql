SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Tipo_Oper_Sel]--'4','','C'
(
	@Cd_Tp_Oper as Varchar(3),
	@Nome_Tp_Oper as Varchar(30),
	@Tipo as char
)
as
if @Tipo = 'A'
Begin
	if @Cd_Tp_Oper = '' or @Cd_Tp_Oper is null
		Begin
			select Cd_Tp_Oper,Nome_Tp_Oper from Tipo_Oper
			where Nome_Tp_Oper = @Nome_Tp_Oper 
		End
	else
		Begin
			select Cd_Tp_Oper,Nome_Tp_Oper from Tipo_Oper
			where  Cd_Tp_Oper = @Cd_Tp_Oper
		End
End
If @Tipo = 'B'
	Begin
		if @Cd_Tp_Oper = '' or @Cd_Tp_Oper is null
			Begin
				select Cd_Tp_Oper,Nome_Tp_Oper from Tipo_Oper
				where Nome_Tp_Oper = @Nome_Tp_Oper 
			End
		else
			Begin
				select Cd_Tp_Oper,Nome_Tp_Oper from Tipo_Oper
				where  Cd_Tp_Oper = @Cd_Tp_Oper 
			End
	End
If @Tipo = 'C'
	Begin	
		select 
			Cd_Tp_Oper,Nome_Tp_Oper 
		from 
			Tipo_Oper
		where 
			Cd_Tp_Oper = @Cd_Tp_Oper
	End

GO
