SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMIM_Referencia_Ins    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMIM_Referencia_Ins 
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
	If @Tipo = 'IM' 
		Begin 
			Set @Referencia = IsNull((Select Max(Right(Num_Proc_MIM, 3))  From Master_Imp_Mar Where Left(Num_Proc_MIM, 11) = 'IM' + @Origem + Cast(Year(GetDate()) as Char(4)) + @Mes),0) + 1 			
			If Len(@Referencia) = 1 
				Set @Referencia  = '00' + @Referencia 
			If Len(@Referencia) = 2 
				Set @Referencia  = '0' + @Referencia 			
			
			Set @Referencia = 'IM' + @Origem + Cast(year(GetDate()) as Char(4)) +@Mes +  @Referencia
		End



GO
