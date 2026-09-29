SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pParidade_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pParidade_Sel 
(
@Cd_Tp_Moeda	VarChar(3), 
@Cd_Tp_Par		VarChar(3), 
@Data 			Char(10)  =Null
)
 AS
	If @Data = Null 
		Set @Data = Convert(varchar(12), GetDate(), 103)
	Else
		Set @Data = Convert(varchar(12), @Data, 103)
	
		Select 
			Par.*, Pr.Nome_Tp_Par, Tm.Nome_Tp_Moeda
		From 
			Paridade as Par Join Tipo_Paridade as Pr on Par.Cd_Tp_Par = Pr.Cd_Tp_Par
			Join Tipo_Moeda as TM on Par.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		Where 
			Par.Dt_Par = @Data and 
			Par.Cd_Tp_Moeda = @Cd_Tp_moeda and 
			Par.Cd_Tp_Par = @Cd_Tp_Par



GO
