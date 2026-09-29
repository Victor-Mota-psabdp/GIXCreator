SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pTipoMoeda_Cod_Nome_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pTipoMoeda_Cod_Nome_Sel 
(
@Cd_Tp_Moeda	VarChar(3)='', 
@Moeda		VarChar(30)=''
)
 AS
	If @Cd_Tp_Moeda <> '' 
		Select 
			Cd_Tp_Moeda, 
			Nome_Tp_Moeda
		From 
			Tipo_Moeda
		Where
			Cd_Tp_Moeda = @Cd_Tp_Moeda
	Else 
		Begin 
			If @Moeda = '' 
				Select 
					Cd_Tp_Moeda, 
					Nome_Tp_Moeda
				From 
					Tipo_Moeda
				Order by 
					Nome_Tp_Moeda
			Else 
				Select 
					Cd_Tp_Moeda, 
					Nome_Tp_Moeda
				From 
					Tipo_Moeda
				Where
					Nome_Tp_Moeda = @Moeda 
				Order by 
					Nome_Tp_Moeda
		End



GO
