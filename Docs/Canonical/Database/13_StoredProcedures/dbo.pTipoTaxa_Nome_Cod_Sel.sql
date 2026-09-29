SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pTipoTaxa_Nome_Cod_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pTipoTaxa_Nome_Cod_Sel
(
@Cd_Taxa		VarChar(3)='', 
@Taxa			VarChar(30)='', 
@Desat_Tx		Char(1)=''
)
 AS
	If @Cd_Taxa <> ''
		Select 
			Cd_Tp_Tx, Nome_Tp_Tx
		From 
			Tipo_Taxa
		Where 
			Cd_Tp_Tx = @Cd_Taxa
		Order by 
			Nome_Tp_Tx
	Else
		Begin 
			If @Taxa <> '' 
				Begin 
					If @Desat_Tx <> ''
						Select 
							Cd_Tp_Tx, Nome_Tp_Tx
						From 
							Tipo_Taxa
						Where 
							Nome_Tp_Tx = @Taxa and 
							Desat_Tx = @Desat_Tx
						Order by 
							Nome_Tp_Tx
					Else
						Select 
							Cd_Tp_Tx, Nome_Tp_Tx
						From 
							Tipo_Taxa
						Where
							Nome_Tp_Tx = @Taxa  
						Order by 
							Nome_Tp_Tx
				
				End 
			Else
				Begin 
					If @Desat_Tx <> ''
						Select 
							Cd_Tp_Tx, Nome_Tp_Tx
						From 
							Tipo_Taxa
						Where 
							Desat_Tx = @Desat_Tx
						Order by 
							Nome_Tp_Tx
					Else
						Select 
							Cd_Tp_Tx, Nome_Tp_Tx
						From 
							Tipo_Taxa
						Order by 
							Nome_Tp_Tx
				End 
		End



GO
