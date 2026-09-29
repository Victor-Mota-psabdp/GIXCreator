SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMEMReferencia_Ins    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMEMReferencia_Ins 
(
@Origem	Char(3),
@Tipo		Char(2), 
@Referencia	Char(16)  OUTPUT 
)
 AS
	Declare @Mes 	Char(2) 
	Set @Mes =  Cast(month(GetDate()) as Char(2))
	If Len(@Mes) = 1 
		Set @Mes = '0' +  Cast(month(GetDate()) as Char(2))
	If @Tipo = 'EM' 
		Begin 
			Set @Referencia = IsNull((Select Max(Right(Num_Proc_MEM, 3))  From Master_Exp_Mar Where Left(Num_Proc_MEM, 11) = 'EM' + @Origem + Cast(Year(GetDate()) as Char(4)) + @Mes),0) + 1 			
			If Len(@Referencia) = 1 
				Set @Referencia  = '00' + @Referencia 
			If Len(@Referencia) = 2 
				Set @Referencia  = '0' + @Referencia 			
			
			Set @Referencia = 'EM' + @Origem + Cast(year(GetDate()) as Char(4)) +@Mes +  @Referencia
		End



GO
