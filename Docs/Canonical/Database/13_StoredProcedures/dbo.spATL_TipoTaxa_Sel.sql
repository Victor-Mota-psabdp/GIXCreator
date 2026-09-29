SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_TipoTaxa_Sel]
(
	@Cd_Tp_Tx as varchar(3),
	@Nome_Tp_Tx as Varchar(50),
	@Tipo as char
)
as
if @Tipo = 'A'
Begin
	if @Cd_Tp_Tx = '' or @Cd_Tp_Tx is null
		Begin
			select Cd_Tp_Tx, Nome_Tp_Tx from Tipo_Taxa
			where Nome_Tp_Tx = @Nome_Tp_Tx 
		End
	else
		Begin
			select Cd_Tp_Tx, Nome_Tp_Tx from Tipo_Taxa
			where  Cd_Tp_Tx = @Cd_Tp_Tx 
		End
End
If @Tipo = 'B'
	Begin
		if @Cd_Tp_Tx = '' or @Cd_Tp_Tx is null
			Begin
				select Cd_Tp_Tx, Nome_Tp_Tx from Tipo_Taxa
				where Nome_Tp_Tx = @Nome_Tp_Tx and Desat_Tx = 'N'
			End
		else
			Begin
				select Cd_Tp_Tx, Nome_Tp_Tx from Tipo_Taxa
				where  Cd_Tp_Tx = @Cd_Tp_Tx and Desat_Tx = 'N'	
			End
	End
If @Tipo = 'T'
	Begin
		if @Cd_Tp_Tx = '' or @Cd_Tp_Tx is null
			Begin
				select Cd_Tp_Tx, Nome_Tp_Tx from Tipo_Taxa
				where  Desat_Tx = 'N'
			End
		else
			Begin
				select Cd_Tp_Tx, Nome_Tp_Tx from Tipo_Taxa
				where  Desat_Tx = 'N'	
			End
	End
GO
